# Usa una versione ufficiale di Python leggera
FROM python:3.11-slim

# Imposta la cartella di lavoro dentro il container
WORKDIR /app

# Copia tutti i file della cartella corrente nel container
COPY . .

# Aggiorna apt e installa build-essential e lib needed per TA-Lib
RUN apt-get update && \
    apt-get install -y build-essential wget && \
    rm -rf /var/lib/apt/lists/*

# Installa le dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

# Comando per avviare il bot
CMD ["python", "bot_xauusd.py"]
