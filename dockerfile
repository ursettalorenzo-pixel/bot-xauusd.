# Usa un'immagine Python ufficiale
FROM python:3.11-slim

# Imposta la cartella di lavoro
WORKDIR /app

# Copia i file del progetto
COPY . .

# Aggiorna pip e installa le dipendenze
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Comando per avviare il bot
CMD ["python", "bot_xauusd.py"]
