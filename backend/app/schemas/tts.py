from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class TTSRequest(BaseModel):
    text: str
    voice: str = "male_1"
    language: str = "en-US"
    speed: float = 1.0


class TTSResponse(BaseModel):
    audio_url: str
    id: str
    text: str
    voice: str
    language: str
    speed: float
    created_at: str
    is_favorite: bool = False


class AudioItem(BaseModel):
    id: str
    text: str
    audio_url: str
    voice: str
    language: str
    speed: float
    created_at: str
    is_favorite: bool = False


class FavoriteRequest(BaseModel):
    audio_id: str


class FavoriteResponse(BaseModel):
    success: bool
    audio_id: str
    is_favorite: bool
