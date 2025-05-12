FROM arm64v8/python:3.9-slim

RUN apt-get update && apt-get install -y \
    build-essential git curl ffmpeg espeak-ng \
    && pip install opentts

EXPOSE 5500

CMD ["opentts", "--host", "0.0.0.0"]
