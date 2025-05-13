FROM arm64v8/python:3.9-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential git curl ffmpeg espeak-ng libsndfile1 \
    && apt-get clean

# Clone and install OpenTTS
RUN git clone https://github.com/synesthesiam/opentts.git /opentts \
    && cd /opentts \
    && pip install -r requirements.txt \
    && pip install .

# Expose default port
EXPOSE 5500

# Set default command
CMD ["opentts", "--host", "0.0.0.0"]
