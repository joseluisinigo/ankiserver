FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONPATH="/app/anki-bundled:$PYTHONPATH"

# 1. Install required tools and dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip git curl unzip build-essential \
    protobuf-compiler python3-pyaudio portaudio19-dev && \
    apt-get clean

# 2. Set working directory
WORKDIR /app

# 3. Copy only the essential server files
COPY ankisyncd /app/ankisyncd
COPY ankisyncd.conf /app/
COPY ankisyncctl.py /app/

# 4. Install server dependencies
RUN pip3 install --no-cache-dir flask werkzeug webob

EXPOSE 27701

CMD ["sh", "-c", "cd /app/anki-bundled && pip3 install -r requirements.txt && cd /app && python3 -m ankisyncd"]
