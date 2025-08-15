# Usa un'immagine Python ufficiale
FROM python:3.11-slim

# Evita domande interattive durante apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Installa pacchetti di sistema necessari
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    git \
    ta-lib \
    && rm -rf /var/lib/apt/lists/*

# Imposta la cartella di lavoro
WORKDIR /app

# Copia i file del progetto
COPY . .

# Installa le dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

# Avvia il bot
CMD ["python", "bot_xauusd.py"]
