# anki-sync-server (Dockerized)

This project provides a Dockerized version of [`anki-sync-server`](https://github.com/tsudoko/anki-sync-server), a lightweight Anki synchronization server compatible with older clients (AnkiDroid, AnkiMobile, Anki desktop). This version is maintained and containerized by [Riskoo](https://github.com/joseluisinigo).

## 📦 Features

- Sync server compatible with Anki clients as old as 2.0.27.
- Uses official `anki-bundled` submodule to provide Anki functionality.
- Completely self-hosted and persistent via Docker volumes.
- Easy deployment and isolated dependencies.

## 🚀 Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/tsudoko/anki-sync-server.git
cd anki-sync-server
git submodule update --init --recursive
```

### 2. Build and start the container

```bash
docker compose up -d --build
```

This will:

- Build the Docker image based on Ubuntu 22.04
- Install required packages and dependencies
- Mount the Anki Python libraries from `anki-bundled`
- Start the sync server at port `27701`

### 3. Create a new user

```bash
docker exec -it anki-sync-server python3 ankisyncctl.py adduser <username>
```

You’ll be prompted to enter a password. This is the same user/pass you’ll use in your Anki client sync configuration.

## 🛠️ File Structure

```
.
├── ankisyncd/               # Core server logic (Python)
├── ankisyncd.conf           # Configuration file (can be customized)
├── ankisyncctl.py           # CLI to manage users
├── anki-bundled/            # Anki Python libraries (as submodule)
├── docker-compose.yml       # Compose service definition
└── Dockerfile               # Docker build instructions
```

## 🧱 Docker Details

### Dockerfile (key points)

- Uses `ubuntu:22.04`
- Installs Python 3, PortAudio, Protobuf, Flask, Werkzeug, and WebOb
- Mounts `anki-bundled` as a volume to ensure persistence and separation
- Installs `anki-bundled/requirements.txt` at runtime for flexibility
- Starts the server via:  
  ```sh
  CMD ["sh", "-c", "cd /app/anki-bundled && pip3 install -r requirements.txt && cd /app && python3 -m ankisyncd"]
  ```

### docker-compose.yml

```yaml
version: '3'

services:
  anki-sync-server:
    build: .
    container_name: anki-sync-server
    ports:
      - "27701:27701"
    volumes:
      - ./data:/app/data
      - ./anki-bundled:/app/anki-bundled
      - ./ankisyncd.conf:/app/ankisyncd.conf
    restart: unless-stopped
```

## 💡 Notes

- `anki-bundled` must be initialized using `git submodule update --init --recursive`
- Only the server-side version of Anki is needed. Clients can run any legacy version that supports the sync protocol.

## 👤 Author

Maintained and Dockerized by **Riskoo**  
🔗 [github.com/joseluisinigo](https://github.com/joseluisinigo)  
📧 info@joseluisinigo.work  
🌐 [joseluisinigo.work](https://joseluisinigo.work)

