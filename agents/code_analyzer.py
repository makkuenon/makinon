#!/usr/bin/env python3
"""
Code Analyzer Module for the Code Fixer and Generator Agents

Supports analysis of multiple languages:
- Swift
- Python
- JavaScript
- HTML
"""

import os
import re
from typing import List, Dict, Tuple


class CodeAnalyzer:
    """Analyzes code for issues and patterns."""

    def __init__(self, repo_path: str = "."):
        self.repo_path = repo_path
        self.issues = []
        self.patterns = {}

    def analyze_swift(self, file_path: str) -> List[Dict]:
        """Analyze Swift files for common issues."""
        issues = []
        try:
            with open(file_path, 'r') as f:
                content = f.read()
                lines = content.split('\n')

            # Check for forced unwrapping
            if re.search(r'!\s*[\n;]', content):
                issues.append({
                    'file': file_path,
                    'type': 'forced_unwrap',
                    'severity': 'warning',
                    'message': 'Forced unwrapping detected'
                })

            # Check for unused variables
            if re.search(r'let\s+_\s*=', content):
                issues.append({
                    'file': file_path,
                    'type': 'unused_var',
                    'severity': 'info',
                    'message': 'Unused variable found'
                })

            # Check for missing error handling
            if 'try!' in content:
                issues.append({
                    'file': file_path,
                    'type': 'unsafe_try',
                    'severity': 'warning',
                    'message': 'try! detected - consider proper error handling'
                })

        except Exception as e:
            print(f"Error analyzing {file_path}: {e}")

        return issues

    def analyze_python(self, file_path: str) -> List[Dict]:
        """Analyze Python files for common issues."""
        issues = []
        try:
            with open(file_path, 'r') as f:
                content = f.read()

            # Check for bare except
            if re.search(r'except\s*:', content):
                issues.append({
                    'file': file_path,
                    'type': 'bare_except',
                    'severity': 'warning',
                    'message': 'Bare except clause detected'
                })

            # Check for print statements
            if re.search(r'^\s*print\(', content, re.MULTILINE):
                issues.append({
                    'file': file_path,
                    'type': 'print_statement',
                    'severity': 'info',
                    'message': 'Print statement found - consider using logging'
                })

        except Exception as e:
            print(f"Error analyzing {file_path}: {e}")

        return issues

    def analyze_javascript(self, file_path: str) -> List[Dict]:
        """Analyze JavaScript files for common issues."""
        issues = []
        try:
            with open(file_path, 'r') as f:
                content = f.read()

            # Check for var usage
            if re.search(r'\bvar\s+', content):
                issues.append({
                    'file': file_path,
                    'type': 'var_usage',
                    'severity': 'warning',
                    'message': 'var keyword detected - use const or let instead'
                })

            # Check for console.log
            if 'console.log' in content:
                issues.append({
                    'file': file_path,
                    'type': 'console_log',
                    'severity': 'info',
                    'message': 'console.log found - consider removing or using logger'
                })

        except Exception as e:
            print(f"Error analyzing {file_path}: {e}")

        return issues
