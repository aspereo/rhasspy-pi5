FROM python:3.9-slim

# 1. System deps for TTS back-ends
RUN apt-get update \
    && apt-get install -y \
       git \
       build-essential \
       espeak-ng \
       python3-dev \
       libsndfile1 \
       ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Clone OpenTTS source
RUN git clone https://github.com/synesthesiam/opentts.git /app

WORKDIR /app

# 3. Install Python requirements
RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt

# 4. Expose HTTP port and launch server
EXPOSE 5500
CMD ["python3", "app.py"]
