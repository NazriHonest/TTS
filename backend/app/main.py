from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routes.tts import router as tts_router

app = FastAPI(
    title="Mock TTS API",
    description="Simulated Text-to-Speech backend for development and testing",
    version="1.0.0",
)

# Allow all origins for development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(tts_router, prefix="/api")


@app.get("/")
async def root():
    return {
        "message": "Mock TTS API is running",
        "docs": "/docs",
        "version": "1.0.0",
    }
