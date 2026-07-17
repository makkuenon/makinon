"""
Configuration for SideSigner Hub server
"""

import os
from pathlib import Path

# Base directories
BASE_DIR = Path(__file__).parent
DATA_DIR = BASE_DIR / 'data'
UPLOADS_DIR = DATA_DIR / 'uploads'
LIBRARY_DIR = DATA_DIR / 'library'
SIGNED_DIR = DATA_DIR / 'signed'

# Flask configuration
FLASK_ENV = os.getenv('FLASK_ENV', 'development')
DEBUG = FLASK_ENV == 'development'
SECRET_KEY = os.getenv('SECRET_KEY', 'dev-key-change-in-production')

# Server configuration
HOST = os.getenv('HOST', '0.0.0.0')
PORT = int(os.getenv('PORT', 5000))
MAX_UPLOAD_SIZE = 500 * 1024 * 1024  # 500MB

# CORS configuration
CORS_ORIGINS = os.getenv('CORS_ORIGINS', '*').split(',')

# Signing configuration
SIGNING_TIMEOUT = 300  # 5 minutes
KEEP_SIGNED_IPAS = True
SIGNED_IPA_RETENTION_DAYS = 7
