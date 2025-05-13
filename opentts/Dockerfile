FROM python:3.9-slim

# 1) System dependencies
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

# 2) Clone OpenTTS repo
RUN git clone https://github.com/synesthesiam/opentts.git /app

WORKDIR /app

# 3) Pin Jinja2 and Werkzeug to compatible versions, then install Python deps
RUN pip install --upgrade pip setuptools wheel \
 && pip install "jinja2<3.1" "werkzeug<3.0" \                              # Pin Werkzeug below v3.0 to restore url_decode :contentReference[oaicite:0]{index=0}
 && pip install -r requirements.txt

# 4) Expose port & default command
EXPOSE 5500
CMD ["python3", "app.py", \
     "--marytts-url", "http://marytts:59125"]


