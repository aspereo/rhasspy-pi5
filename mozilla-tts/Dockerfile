FROM arm64v8/python:3.9-slim

RUN apt-get update && apt-get install -y \
    git build-essential espeak-ng python3-dev libsndfile1 ffmpeg \
    && git clone https://github.com/mozilla/TTS.git /app \
    && cd /app && pip install -e .

WORKDIR /app
EXPOSE 5002
CMD ["tts-server"]
