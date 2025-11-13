"""
Google OAuth 2.0 Authentication Controller for ISHE Group Platform
Implements secure Google Sign-In for seamless integration with Google ecosystem
"""

from fastapi import APIRouter, Depends, Query, HTTPException, status
from fastapi.responses import RedirectResponse
from fastapi_jwt_auth import AuthJWT
from fastapi_sqlalchemy import db
import requests
import json
from datetime import datetime, timedelta
from urllib.parse import urlencode

import superagi
from superagi.config.config import get_config
from superagi.models.user import User
from superagi.models.organisation import Organisation
from superagi.helper.auth import create_access_token

router = APIRouter()

# Google OAuth endpoints
GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth"
GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token"
GOOGLE_USERINFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo"

# Required Google OAuth scopes for full ecosystem integration
GOOGLE_SCOPES = [
    "openid",
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/userinfo.profile",
    "https://www.googleapis.com/auth/calendar",
    "https://www.googleapis.com/auth/drive.file",
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/gmail.send",
    "https://www.googleapis.com/auth/cloud-platform.read-only",
]


@router.get('/login')
def google_login():
    """
    Initiates Google OAuth 2.0 authentication flow
    Redirects user to Google's secure login page
    """
    google_client_id = get_config("GOOGLE_CLIENT_ID")
    
    if not google_client_id:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Google OAuth not configured. Please set GOOGLE_CLIENT_ID in environment."
        )
    
    frontend_url = get_config("FRONTEND_URL", "http://localhost:3000")
    redirect_uri = f"{frontend_url}/api/google/oauth-callback"
    
    # Build Google OAuth authorization URL
    params = {
        'client_id': google_client_id,
        'redirect_uri': redirect_uri,
        'response_type': 'code',
        'scope': ' '.join(GOOGLE_SCOPES),
        'access_type': 'offline',
        'prompt': 'consent',  # Force consent screen to ensure refresh token
        'state': 'ishe_group_auth'
    }
    
    auth_url = f"{GOOGLE_AUTH_URL}?{urlencode(params)}"
    return RedirectResponse(url=auth_url)


@router.get('/oauth-callback')
async def google_auth_callback(code: str = Query(...), state: str = Query(None), Authorize: AuthJWT = Depends()):
    """
    Handles Google OAuth callback
    Exchanges authorization code for access token and creates/authenticates user
    """
    
    if state != 'ishe_group_auth':
        raise HTTPException(status_code=400, detail="Invalid state parameter")
    
    google_client_id = get_config("GOOGLE_CLIENT_ID")
    google_client_secret = get_config("GOOGLE_CLIENT_SECRET")
    frontend_url = get_config("FRONTEND_URL", "http://localhost:3000")
    redirect_uri = f"{frontend_url}/api/google/oauth-callback"
    
    if not google_client_id or not google_client_secret:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Google OAuth credentials not configured"
        )
    
    # Exchange authorization code for tokens
    token_params = {
        'client_id': google_client_id,
        'client_secret': google_client_secret,
        'code': code,
        'redirect_uri': redirect_uri,
        'grant_type': 'authorization_code'
    }
    
    try:
        token_response = requests.post(GOOGLE_TOKEN_URL, data=token_params)
        token_response.raise_for_status()
        tokens = token_response.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=400, detail=f"Failed to obtain access token: {str(e)}")
    
    # Get user information from Google
    headers = {'Authorization': f"Bearer {tokens['access_token']}"}
    
    try:
        userinfo_response = requests.get(GOOGLE_USERINFO_URL, headers=headers)
        userinfo_response.raise_for_status()
        user_data = userinfo_response.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=400, detail=f"Failed to get user info: {str(e)}")
    
    # Extract user information
    user_email = user_data.get('email')
    user_name = user_data.get('name', user_email.split('@')[0])
    user_picture = user_data.get('picture')
    
    if not user_email:
        raise HTTPException(status_code=400, detail="Email not provided by Google")
    
    # Check if user exists, create if not
    db_user = db.session.query(User).filter(User.email == user_email).first()
    
    if db_user is None:
        # Create new organization for new user
        organisation = Organisation(name=f"{user_name}'s Organization")
        db.session.add(organisation)
        db.session.commit()
        
        # Create new user
        db_user = User(
            name=user_name,
            email=user_email,
            organisation_id=organisation.id,
            password='',  # Google OAuth users don't need password
            login_source='GOOGLE'
        )
        db.session.add(db_user)
        db.session.commit()
        
        first_time_login = True
    else:
        first_time_login = False
    
    # Store Google tokens for API access (optional, for future use)
    # You can save tokens to database here if needed for API calls
    
    # Create JWT token for application
    jwt_token = create_access_token(user_email, Authorize)
    
    # Redirect back to frontend with token
    redirect_url = f"{frontend_url}?access_token={jwt_token}&first_time_login={first_time_login}&provider=google"
    return RedirectResponse(url=redirect_url)


@router.post('/refresh-token')
async def refresh_google_token(refresh_token: str):
    """
    Refreshes Google OAuth access token using refresh token
    """
    google_client_id = get_config("GOOGLE_CLIENT_ID")
    google_client_secret = get_config("GOOGLE_CLIENT_SECRET")
    
    params = {
        'client_id': google_client_id,
        'client_secret': google_client_secret,
        'refresh_token': refresh_token,
        'grant_type': 'refresh_token'
    }
    
    try:
        response = requests.post(GOOGLE_TOKEN_URL, data=params)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=400, detail=f"Failed to refresh token: {str(e)}")


@router.get('/get_client_id')
def get_google_client_id():
    """
    Returns Google Client ID for frontend OAuth initialization
    """
    google_client_id = get_config("GOOGLE_CLIENT_ID", "")
    if google_client_id:
        google_client_id = google_client_id.strip()
    return {"google_client_id": google_client_id}
