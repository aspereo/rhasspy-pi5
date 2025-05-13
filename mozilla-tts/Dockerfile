FROM python:3.9-slim

# Install system packages
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    espeak-ng \
    python3-dev \
    libsndfile1 \
    ffmpeg \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone Mozilla TTS (Coqui-TTS)
RUN git clone https://github.com/coqui-ai/TTS.git /app

WORKDIR /app

# Fix TensorFlow version for ARM64
RUN pip install --upgrade pip setuptools wheel \
    && pip install numpy Cython \
    && pip install tensorflow==2.11.0 \
    && sed -i 's/tensorflow==2.3.1/# tensorflow pinned for x86/' requirements.txt

# Install the package
RUN pip install -e .

# Optionally, download pretrained model(s)
# RUN python3 TTS/bin/download_models.py --model_name "tts_models/en/ljspeech/tacotron2-DDC"

CMD ["/bin/bash"]