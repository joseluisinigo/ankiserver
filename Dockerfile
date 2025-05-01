FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONPATH="/app/anki-bundled:$PYTHONPATH"

# Install required system tools and dependencies
RUN apt-get update && apt-get install -y \\
    python3 python3-pip git curl unzip build-essential \\
    protobuf-compiler python3-pyaudio portaudio19-dev && \\
    apt-get clean

# Set working directory inside the container
WORKDIR /app

# Copy only the necessary server files
COPY ankisyncd /app/ankisyncd
COPY ankisyncd.conf /app/
COPY ankisyncctl.py /app/

# Install Python dependencies for the sync server
RUN pip3 install --no-cache-dir flask werkzeug webob

# Expose the default sync server port
EXPOSE 27701

# Entry point command: install anki-bundled dependencies and start the server
CMD ["sh", "-c", "cd /app/anki-bundled && pip3 install -r requirements.txt && cd /app && python3 -m ankisyncd"]
