# Usa immagine Python
FROM python:3.11-slim

# Evita richieste interattive durante apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Installa dipendenze di sistema e TA-Lib
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    tar \
    gcc \
    make && \
    wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar -xvzf ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib && ./configure --prefix=/usr && make && make install && \
    cd .. && rm -rf ta-lib ta-lib-0.4.0-src.tar.gz && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Imposta cartella di lavoro
WORKDIR /app

# Copia i file del progetto
COPY . .

# Installa dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

# Comando per avviare il bot
CMD ["python", "bot_xauusd.py"]
