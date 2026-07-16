#!/usr/bin/env python3
"""
Code Analyzer Module for the Code Fixer and Generator Agents

Supports analysis of multiple languages:
- Swift
- Python
- JavaScript
- HTML
- CMake
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

    def scan_repository(self) -> List[Dict]:
        """Scan entire repository for issues."""
        all_issues = []

        for root, dirs, files in os.walk(self.repo_path):
            # Skip hidden and build directories
            dirs[:] = [d for d in dirs if not d.startswith('.')]

            for file in files:
                file_path = os.path.join(root, file)

                if file.endswith('.swift'):
                    all_issues.extend(self.analyze_swift(file_path))
                elif file.endswith('.py'):
                    all_issues.extend(self.analyze_python(file_path))
                elif file.endswith('.js'):
                    all_issues.extend(self.analyze_javascript(file_path))

        return all_issues

    def generate_report(self) -> str:
        """Generate a report of found issues."""
        issues = self.scan_repository()

        if not issues:
            return "No issues found!"

        report = "# Code Analysis Report\n\n"
        report += f"## Summary\n- Total issues found: {len(issues)}\n\n"

        # Group by severity
        by_severity = {}
        for issue in issues:
            severity = issue['severity']
            if severity not in by_severity:
                by_severity[severity] = []
            by_severity[severity].append(issue)

        for severity in ['error', 'warning', 'info']:
            if severity in by_severity:
                report += f"### {severity.upper()} ({len(by_severity[severity])})\n"
                for issue in by_severity[severity]:
                    report += f"- **{issue['file']}**: {issue['message']}\n"
                report += "\n"

        return report


if __name__ == "__main__":
    analyzer = CodeAnalyzer()
    print(analyzer.generate_report())
