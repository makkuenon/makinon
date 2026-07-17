# SideSigner Hub - Backend Server

Backend server for the IPA app library signing system.

## Features

- **Certificate Management**: Store and manage signing certificates
- **App Library**: Browse and search available IPAs
- **IPA Signing**: Sign IPAs from uploads or library
- **OTA Installation**: Generate Over-The-Air installation manifests
- **REST API**: Complete REST API for frontend integration

## API Endpoints

### GET `/api/certs`
Retrieve available signing certificates.

**Response:**
```json
[
  {
    "id": "cert_1",
    "name": "Personal Certificate",
    "type": "Apple ID",
    "expires": "2025-01-01"
  }
]
```

### GET `/api/apps?search=query`
Search available IPAs in the library.

**Query Parameters:**
- `search` (optional): Search term for app name or bundle ID

**Response:**
```json
[
  {
    "id": "app_1",
    "name": "Twitter",
    "bundleId": "com.twitter.ios",
    "version": "9.0"
  }
]
```

### POST `/api/sign`
Sign an IPA file.

**Form Data:**
- `ipa` (file): IPA file to sign (optional if using ipaId)
- `ipaId` (string): Library IPA ID (optional if uploading file)
- `certId` (string): Certificate ID to use
- `mode` (string): Signing mode - 'free', 'dev', or 'enterprise'
- `flags` (JSON string): Optional signing flags

**Response:**
```json
{
  "success": true,
  "signedIpaId": "uuid",
  "signedIpaUrl": "https://domain.com/download/uuid",
  "otaUrl": "itms-services://...",
  "mode": "free",
  "certificate": "Personal Certificate",
  "timestamp": "2024-01-01T12:00:00"
}
```

### GET `/health`
Health check endpoint.

## Installation

1. **Install dependencies:**
   ```bash
   cd server
   pip install -r requirements.txt
   ```

2. **Run the server:**
   ```bash
   python app.py
   ```

   The server will start at `http://localhost:5000`

3. **Or use a production WSGI server:**
   ```bash
   pip install gunicorn
   gunicorn -w 4 -b 0.0.0.0:5000 app:app
   ```

## Environment Variables

- `FLASK_ENV`: Set to 'production' for production deployments
- `SECRET_KEY`: Flask secret key (required for production)
- `HOST`: Server host (default: 0.0.0.0)
- `PORT`: Server port (default: 5000)
- `CORS_ORIGINS`: Comma-separated list of allowed CORS origins

## Directory Structure

```
server/
├── app.py              # Main Flask application
├── config.py           # Configuration
├── requirements.txt    # Python dependencies
├── data/
│   ├── certs.json      # Signing certificates
│   ├── apps.json       # IPA library
│   ├── uploads/        # Uploaded IPAs
│   ├── library/        # Library IPAs
│   └── signed/         # Signed IPAs
└── README.md           # This file
```

## Development

### Adding Custom Certificates

Edit `server/data/certs.json` or use the API to add certificates:

```json
{
  "id": "cert_custom",
  "name": "My Certificate",
  "type": "Developer",
  "expires": "2025-12-31"
}
```

### Adding Apps to Library

Edit `server/data/apps.json`:

```json
{
  "id": "app_custom",
  "name": "My App",
  "bundleId": "com.example.myapp",
  "version": "1.0.0"
}
```

## Production Deployment

1. Set `FLASK_ENV=production`
2. Generate a strong `SECRET_KEY`
3. Use a WSGI server like Gunicorn or uWSGI
4. Place behind a reverse proxy (Nginx/Apache)
5. Enable HTTPS
6. Configure proper CORS origins
7. Set up database for persistent signing history

## Security Notes

- Always use HTTPS in production
- Validate and sanitize all inputs
- Store certificates securely
- Implement authentication/authorization
- Monitor file uploads for malware
- Regular backups of certificate data
- Implement rate limiting
