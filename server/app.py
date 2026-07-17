"""
SideSigner Hub - IPA App Library Server
Backend for managing IPA signing operations
"""

from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import json
import os
from datetime import datetime
from pathlib import Path
import uuid
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

# Configuration
DATA_DIR = Path(__file__).parent / 'data'
UPLOADS_DIR = DATA_DIR / 'uploads'
LIBRARY_DIR = DATA_DIR / 'library'
CERTS_FILE = DATA_DIR / 'certs.json'
APPS_FILE = DATA_DIR / 'apps.json'

# Create directories if they don't exist
for directory in [DATA_DIR, UPLOADS_DIR, LIBRARY_DIR]:
    directory.mkdir(parents=True, exist_ok=True)


# ==================== Data Management ====================

def load_json(filepath, default=None):
    """Load JSON file with fallback to default."""
    try:
        with open(filepath, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return default or []


def save_json(filepath, data):
    """Save data to JSON file."""
    filepath.parent.mkdir(parents=True, exist_ok=True)
    with open(filepath, 'w') as f:
        json.dump(data, f, indent=2)


def ensure_default_data():
    """Initialize default certs and apps if they don't exist."""
    
    # Default certificates
    if not CERTS_FILE.exists():
        default_certs = [
            {
                "id": "cert_1",
                "name": "Personal Certificate",
                "type": "Apple ID",
                "expires": "2025-01-01"
            },
            {
                "id": "cert_2",
                "name": "Developer Certificate",
                "type": "Developer",
                "expires": "2026-01-01"
            }
        ]
        save_json(CERTS_FILE, default_certs)
        logger.info("Created default certificates")
    
    # Default apps
    if not APPS_FILE.exists():
        default_apps = [
            {"id": "app_1", "name": "Twitter", "bundleId": "com.twitter.ios", "version": "9.0"},
            {"id": "app_2", "name": "Instagram", "bundleId": "com.instagram.ios", "version": "253.0"},
            {"id": "app_3", "name": "Discord", "bundleId": "com.hammerandchisel.discord", "version": "185.0"},
            {"id": "app_4", "name": "Telegram", "bundleId": "ph.telegra.Telegraph", "version": "9.8"},
            {"id": "app_5", "name": "Reddit", "bundleId": "com.reddit.official", "version": "2023.47"},
        ]
        save_json(APPS_FILE, default_apps)
        logger.info("Created default app library")


# ==================== API Routes ====================

@app.route('/api/certs', methods=['GET'])
def get_certs():
    """Get available signing certificates."""
    certs = load_json(CERTS_FILE, [])
    logger.info(f"Retrieved {len(certs)} certificates")
    return jsonify(certs)


@app.route('/api/apps', methods=['GET'])
def get_apps():
    """Get available IPAs from library with optional search."""
    query = request.args.get('search', '').lower()
    apps = load_json(APPS_FILE, [])
    
    if query:
        apps = [app for app in apps if query in app['name'].lower() or query in app.get('bundleId', '').lower()]
        logger.info(f"Search for '{query}' returned {len(apps)} results")
    
    return jsonify(apps)


@app.route('/api/sign', methods=['POST'])
def sign_ipa():
    """
    Sign an IPA file.
    
    Accepts either:
    - 'ipa' file upload (multipart/form-data)
    - 'ipaId' from library (form data)
    
    Also accepts: certId, mode, flags
    """
    try:
        cert_id = request.form.get('certId')
        mode = request.form.get('mode', 'free')
        ipa_id = request.form.get('ipaId')
        flags = request.form.get('flags', '{}')
        
        if not cert_id:
            return jsonify({'error': 'Missing certId'}), 400
        
        # Determine IPA source
        ipa_filename = None
        
        if 'ipa' in request.files:
            # Upload from file
            file = request.files['ipa']
            if file.filename == '':
                return jsonify({'error': 'No file selected'}), 400
            
            ipa_filename = f"{uuid.uuid4()}_{file.filename}"
            filepath = UPLOADS_DIR / ipa_filename
            file.save(filepath)
            logger.info(f"Uploaded IPA: {ipa_filename}")
            
        elif ipa_id:
            # Use from library
            apps = load_json(APPS_FILE, [])
            app = next((a for a in apps if a['id'] == ipa_id), None)
            if not app:
                return jsonify({'error': 'IPA not found in library'}), 404
            
            ipa_filename = f"lib_{app['bundleId']}.ipa"
            logger.info(f"Using library IPA: {app['name']}")
        else:
            return jsonify({'error': 'Must provide either IPA file or ipaId'}), 400
        
        # Verify certificate exists
        certs = load_json(CERTS_FILE, [])
        cert = next((c for c in certs if c['id'] == cert_id), None)
        if not cert:
            return jsonify({'error': 'Certificate not found'}), 404
        
        # Generate signed IPA filename and URLs
        signed_ipa_id = str(uuid.uuid4())
        signed_filename = f"{signed_ipa_id}_signed.ipa"
        
        # In production, actual signing would happen here
        logger.info(f"Signing IPA with mode={mode}, cert={cert['name']}, flags={flags}")
        
        # Generate OTA manifest (Over-The-Air installation)
        ota_id = str(uuid.uuid4())
        ota_url = f"itms-services://?action=download-manifest&url=https://your-domain.com/ota/{ota_id}/manifest.plist"
        
        signed_ipa_url = f"https://your-domain.com/download/{signed_ipa_id}"
        
        return jsonify({
            'success': True,
            'signedIpaId': signed_ipa_id,
            'signedIpaUrl': signed_ipa_url,
            'otaUrl': ota_url,
            'mode': mode,
            'certificate': cert['name'],
            'timestamp': datetime.now().isoformat()
        })
        
    except Exception as e:
        logger.error(f"Error signing IPA: {str(e)}")
        return jsonify({'error': str(e)}), 500


@app.route('/api/signing-history', methods=['GET'])
def get_signing_history():
    """Get recent signing history."""
    # In production, this would query a database
    return jsonify({
        'total': 0,
        'history': []
    })


@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint."""
    return jsonify({'status': 'ok', 'timestamp': datetime.now().isoformat()})


@app.route('/')
def serve_frontend():
    """Serve the frontend HTML."""
    frontend_dir = Path(__file__).parent.parent
    return send_from_directory(frontend_dir, 'README.md')


# ==================== Error Handlers ====================

@app.errorhandler(400)
def bad_request(error):
    return jsonify({'error': 'Bad request'}), 400


@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Not found'}), 404


@app.errorhandler(500)
def internal_error(error):
    logger.error(f"Internal server error: {str(error)}")
    return jsonify({'error': 'Internal server error'}), 500


# ==================== Initialization ====================

if __name__ == '__main__':
    ensure_default_data()
    logger.info("Starting SideSigner Hub server...")
    app.run(debug=True, host='0.0.0.0', port=5000)
