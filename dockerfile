# Usa Python ufficiale
FROM python:3.11-slim

# Imposta la cartella di lavoro
WORKDIR /app

# Aggiorna pacchetti e installa librerie necessarie per TA-Lib
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Scarica e installa TA-Lib
RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz \
    && tar -xvzf ta-lib-0.4.0-src.tar.gz \
    && cd ta-lib/ \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && cd .. \
    && rm -rf ta-lib ta-lib-0.4.0-src.tar.gz

# Copia i file del progetto
COPY . .

# Installa le dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

# Comando per avviare il bot
CMD ["python", "bot_xauusd.py"]
