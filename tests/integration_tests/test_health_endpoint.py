import unittest
from fastapi.testclient import TestClient
from unittest.mock import patch, MagicMock

# Mock the database and other dependencies before importing main
@patch('main.engine')
@patch('main.register_toolkits')
@patch('main.register_marketplace_toolkits')
class TestHealthEndpoint(unittest.TestCase):
    """Test the health endpoint for Railway deployment"""
    
    def test_health_endpoint_returns_healthy_status(self, mock_register_marketplace, mock_register_toolkits, mock_engine):
        """Test that /health endpoint returns 200 OK with healthy status"""
        # Mock the database session
        mock_session = MagicMock()
        mock_session.query.return_value.filter.return_value.first.return_value = None
        
        with patch('main.sessionmaker') as mock_sessionmaker:
            mock_sessionmaker.return_value.return_value = mock_session
            
            # Import main after mocking to prevent database connection errors
            from main import app
            
            client = TestClient(app)
            response = client.get("/health")
            
            # Assert response
            assert response.status_code == 200
            assert response.json() == {"status": "healthy"}
    
    def test_health_endpoint_accessible_without_auth(self, mock_register_marketplace, mock_register_toolkits, mock_engine):
        """Test that /health endpoint is accessible without authentication"""
        mock_session = MagicMock()
        mock_session.query.return_value.filter.return_value.first.return_value = None
        
        with patch('main.sessionmaker') as mock_sessionmaker:
            mock_sessionmaker.return_value.return_value = mock_session
            
            from main import app
            
            client = TestClient(app)
            # Make request without any authentication headers
            response = client.get("/health")
            
            # Should still return 200 OK
            assert response.status_code == 200
            assert "status" in response.json()

if __name__ == "__main__":
    unittest.main()
