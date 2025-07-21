import requests
from dotenv import load_dotenv
from pathlib import Path
import os
import json

load_dotenv()

API_KEY = os.getenv("LASTFM_API_KEY")
USERNAME = os.getenv("LASTFM_USERNAME")
BASE_URL = "http://ws.audioscrobbler.com/2.0/"

# period is either "7day" or "overall"
def fetch_top_albums(period):
    params = {
        "method": "user.getTopAlbums",
        "user": USERNAME,
        "api_key": API_KEY,
        "format": "json",
        "period": "7day" if period == "7day" else "overall",
        "limit": 10 
    }
    response = requests.get(BASE_URL, params=params)
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception("API request failed with code ", response.status_code)

# period is either "7day" or "overall"
def fetch_top_artists(period):
    params = {
        "method": "user.getTopArtists",
        "user": USERNAME,
        "api_key": API_KEY,
        "format": "json",
        "period": "7day" if period == "7day" else "overall",
        "limit": 10
    }
    response = requests.get(BASE_URL, params=params)
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception("API request failed with code ", response.status_code)
    
def save_to_file(data, filename):
    reports_dir = Path(__file__).parent / "reports"
    reports_dir.mkdir(exist_ok=True)
    filepath = reports_dir / filename
    with filepath.open("w+") as f:
        json.dump(data, f, indent=2)

if __name__ == "__main__":
    print("Fetching weekly albums")
    top_album_week = fetch_top_albums("7day")
    save_to_file(top_album_week, "weekly_albums.json")
    
    print("Fetching all-time albums")
    top_album_week = fetch_top_albums("overall")
    save_to_file(top_album_week, "all_albums.json")
    
    print("Fetching weekly artists")
    top_album_week = fetch_top_artists("7day")
    save_to_file(top_album_week, "weekly_artists.json")
    
    print("Fetching all-time artists")
    top_album_week = fetch_top_artists("overall")
    save_to_file(top_album_week, "all_artists.json")
