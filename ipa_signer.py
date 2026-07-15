#!/usr/bin/env python3
"""
IPA Signer with Entitlement Modification
A lightweight tool to sign iOS IPA files and modify entitlements.
"""

import os
import sys
import shutil
import zipfile
import subprocess
import plistlib
import argparse
from pathlib import Path
from typing import Dict, Optional


class IPASigner:
    def __init__(self, ipa_path: str, certificate: str, password: Optional[str] = None):
        """
        Initialize IPA Signer.
        
        Args:
            ipa_path: Path to the IPA file
            certificate: Path to the signing certificate/identity
            password: Optional password for the certificate
        """
        self.ipa_path = Path(ipa_path)
        self.certificate = certificate
        self.password = password
        self.work_dir = Path(f".ipa_work_{os.getpid()}")
        self.app_dir = None
        
        if not self.ipa_path.exists():
            raise FileNotFoundError(f"IPA file not found: {ipa_path}")
    
    def extract(self) -> None:
        """Extract IPA to working directory."""
        if self.work_dir.exists():
            shutil.rmtree(self.work_dir)
        self.work_dir.mkdir()
        
        with zipfile.ZipFile(self.ipa_path, 'r') as zip_ref:
            zip_ref.extractall(self.work_dir)
        
        # Find the .app directory
        payload_dir = self.work_dir / "Payload"
        if payload_dir.exists():
            app_dirs = list(payload_dir.glob("*.app"))
            if app_dirs:
                self.app_dir = app_dirs[0]
                print(f"[+] Extracted IPA to {self.work_dir}")
            else:
                raise FileNotFoundError("No .app bundle found in IPA")
        else:
            raise FileNotFoundError("Payload directory not found in IPA")
    
    def modify_entitlements(self, entitlements: Dict) -> None:
        """
        Modify entitlements in the app bundle.
        
        Args:
            entitlements: Dictionary of entitlements to add/modify
        """
        if not self.app_dir:
            raise RuntimeError("App directory not set. Call extract() first.")
        
        entitlements_path = self.app_dir / "Entitlements.plist"
        
        # Read existing entitlements or create new
        if entitlements_path.exists():
            with open(entitlements_path, 'rb') as f:
                current_entitlements = plistlib.load(f)
        else:
            current_entitlements = {}
        
        # Update with new entitlements
        current_entitlements.update(entitlements)
        
        # Write back
        with open(entitlements_path, 'wb') as f:
            plistlib.dump(current_entitlements, f)
        
        print(f"[+] Modified entitlements: {list(entitlements.keys())}")
    
    def get_entitlements(self) -> Dict:
        """Retrieve current entitlements from the app."""
        if not self.app_dir:
            raise RuntimeError("App directory not set. Call extract() first.")
        
        entitlements_path = self.app_dir / "Entitlements.plist"
        
        if entitlements_path.exists():
            with open(entitlements_path, 'rb') as f:
                return plistlib.load(f)
        return {}
    
    def sign(self) -> None:
        """Sign the app bundle with the specified certificate."""
        if not self.app_dir:
            raise RuntimeError("App directory not set. Call extract() first.")
        
        # Build codesign command
        cmd = ['codesign', '-f', '-s', self.certificate]
        
        if self.password:
            cmd.extend(['--keychain-password', self.password])
        
        # Sign the app
        cmd.append(str(self.app_dir))
        
        try:
            subprocess.run(cmd, check=True, capture_output=True)
            print(f"[+] Signed app bundle with certificate: {self.certificate}")
        except subprocess.CalledProcessError as e:
            raise RuntimeError(f"Signing failed: {e.stderr.decode()}")
    
    def verify_signature(self) -> bool:
        """Verify the app bundle signature."""
        if not self.app_dir:
            raise RuntimeError("App directory not set. Call extract() first.")
        
        try:
            result = subprocess.run(
                ['codesign', '-v', str(self.app_dir)],
                capture_output=True,
                check=True
            )
            print("[+] Signature verified successfully")
            return True
        except subprocess.CalledProcessError:
            print("[-] Signature verification failed")
            return False
    
    def repackage(self, output_path: Optional[str] = None) -> Path:
        """
        Repackage the modified app into an IPA file.
        
        Args:
            output_path: Optional custom output path
            
        Returns:
            Path to the new IPA file
        """
        if output_path is None:
            output_path = f"signed_{self.ipa_path.name}"
        
        output_path = Path(output_path)
        
        # Create the new IPA
        with zipfile.ZipFile(output_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for root, dirs, files in os.walk(self.work_dir):
                for file in files:
                    file_path = Path(root) / file
                    arcname = file_path.relative_to(self.work_dir)
                    zipf.write(file_path, arcname)
        
        print(f"[+] Repackaged IPA: {output_path}")
        return output_path
    
    def cleanup(self) -> None:
        """Clean up working directory."""
        if self.work_dir.exists():
            shutil.rmtree(self.work_dir)
            print(f"[+] Cleaned up working directory")
    
    def process(self, entitlements: Optional[Dict] = None, 
                output_path: Optional[str] = None) -> Path:
        """
        Complete workflow: extract, modify, sign, and repackage.
        
        Args:
            entitlements: Optional entitlements to add/modify
            output_path: Optional custom output path
            
        Returns:
            Path to the signed IPA
        """
        try:
            self.extract()
            
            if entitlements:
                self.modify_entitlements(entitlements)
            
            self.sign()
            self.verify_signature()
            result = self.repackage(output_path)
            
            return result
        finally:
            self.cleanup()


def main():
    parser = argparse.ArgumentParser(
        description='IPA Signer with Entitlement Modification'
    )
    parser.add_argument('ipa', help='Path to the IPA file')
    parser.add_argument('-c', '--certificate', required=True, help='Signing certificate/identity')
    parser.add_argument('-p', '--password', help='Certificate password (optional)')
    parser.add_argument('-e', '--entitlements', help='Entitlements JSON file to merge')
    parser.add_argument('-o', '--output', help='Output IPA path')
    parser.add_argument('--list-entitlements', action='store_true', help='List current entitlements')
    
    args = parser.parse_args()
    
    try:
        signer = IPASigner(args.ipa, args.certificate, args.password)
        
        if args.list_entitlements:
            signer.extract()
            entitlements = signer.get_entitlements()
            print("\n[*] Current Entitlements:")
            for key, value in entitlements.items():
                print(f"  {key}: {value}")
            signer.cleanup()
        else:
            # Parse entitlements if provided
            entitlements_dict = None
            if args.entitlements:
                import json
                with open(args.entitlements, 'r') as f:
                    entitlements_dict = json.load(f)
            
            output_ipa = signer.process(entitlements_dict, args.output)
            print(f"\n[✓] Successfully signed IPA: {output_ipa}")
    
    except Exception as e:
        print(f"[!] Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
