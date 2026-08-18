from app import VERSION, app


def test_health():
    response = app.test_client().get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "healthy"}


def test_home_shows_version():
    response = app.test_client().get("/")
    assert response.status_code == 200
    assert VERSION.encode() in response.data
