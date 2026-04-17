import asyncio
import uuid
from datetime import datetime
from typing import List

from fastapi import APIRouter
from app.schemas.tts import (
    TTSRequest,
    TTSResponse,
    AudioItem,
    FavoriteRequest,
    FavoriteResponse,
)

router = APIRouter()

# In-memory mock database
mock_audio_db: List[dict] = [
    {
        "id": "mock-001",
        "text": "Welcome to the Text to Speech application. This is a sample audio.",
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        "voice": "female_1",
        "language": "en-US",
        "speed": 1.0,
        "created_at": "2026-04-15T10:30:00Z",
        "is_favorite": True,
    },
    {
        "id": "mock-002",
        "text": "The quick brown fox jumps over the lazy dog near the riverbank.",
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        "voice": "male_1",
        "language": "en-US",
        "speed": 1.0,
        "created_at": "2026-04-14T14:15:00Z",
        "is_favorite": False,
    },
    {
        "id": "mock-003",
        "text": "Artificial intelligence is transforming the way we interact with technology.",
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
        "voice": "female_2",
        "language": "en-GB",
        "speed": 0.8,
        "created_at": "2026-04-13T09:00:00Z",
        "is_favorite": False,
    },
    {
        "id": "mock-004",
        "text": "Buenos dias, esta es una prueba de texto a voz en espanol.",
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
        "voice": "male_2",
        "language": "es-ES",
        "speed": 1.2,
        "created_at": "2026-04-12T16:45:00Z",
        "is_favorite": True,
    },
    {
        "id": "mock-005",
        "text": "Learning new languages opens doors to different cultures and perspectives.",
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3",
        "voice": "female_1",
        "language": "en-US",
        "speed": 1.0,
        "created_at": "2026-04-11T11:20:00Z",
        "is_favorite": False,
    },
]


@router.post("/tts/generate", response_model=TTSResponse)
async def generate_tts(request: TTSRequest):
    """Simulate TTS generation with a 2-second delay."""
    await asyncio.sleep(2)

    audio_id = str(uuid.uuid4())[:8]
    now = datetime.utcnow().isoformat() + "Z"

    new_audio = {
        "id": audio_id,
        "text": request.text,
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        "voice": request.voice,
        "language": request.language,
        "speed": request.speed,
        "created_at": now,
        "is_favorite": False,
    }

    mock_audio_db.insert(0, new_audio)

    return TTSResponse(**new_audio)


@router.get("/audio", response_model=List[AudioItem])
async def get_audio_list():
    """Return the list of all generated audio items."""
    return [AudioItem(**item) for item in mock_audio_db]


@router.post("/audio/favorite", response_model=FavoriteResponse)
async def toggle_favorite(request: FavoriteRequest):
    """Toggle the favorite status of an audio item."""
    for item in mock_audio_db:
        if item["id"] == request.audio_id:
            item["is_favorite"] = not item["is_favorite"]
            return FavoriteResponse(
                success=True,
                audio_id=request.audio_id,
                is_favorite=item["is_favorite"],
            )

    return FavoriteResponse(
        success=False,
        audio_id=request.audio_id,
        is_favorite=False,
    )
