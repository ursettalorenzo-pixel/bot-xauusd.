import requests
import time
import pandas as pd
import talib
import matplotlib.pyplot as plt
from io import BytesIO
from telegram import Bot

# -------------------------
# CONFIGURAZIONE
# -------------------------
TELEGRAM_TOKEN = "8305780391:AAGx3hRQWhGGRJ7McfQZYHapd_VnvlHe67s"
CHAT_ID = "-1002308325794"
API_KEY = "IW5NTOZE3FGHVJDG"
SYMBOLS = ["XAUUSD", "SP500", "NASDAQ"]
TIMEFRAMES = ["1d", "1h", "30m", "15m", "5m"]

bot = Bot(token=TELEGRAM_TOKEN)

# -------------------------
# FUNZIONI
# -------------------------
def get_data(symbol, interval):
    url = f"https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol={symbol}&interval={interval}&apikey={API_KEY}&outputsize=full"
    response = requests.get(url).json()
    key = [k for k in response.keys() if "Time Series" in k][0]
    df = pd.DataFrame(response[key]).T
    df = df.astype(float)
    df = df.sort_index()
    return df

def calculate_indicators(df):
    df['EMA20'] = talib.EMA(df['close'], timeperiod=20)
    df['EMA50'] = talib.EMA(df['close'], timeperiod=50)
    df['RSI'] = talib.RSI(df['close'], timeperiod=14)
    macd, macdsignal, _ = talib.MACD(df['close'], fastperiod=12, slowperiod=26, signalperiod=9)
    df['MACD'] = macd
    df['MACD_signal'] = macdsignal
    df['ATR'] = talib.ATR(df['high'], df['low'], df['close'], timeperiod=14)
    upper, middle, lower = talib.BBANDS(df['close'], timeperiod=20, nbdevup=2, nbdevdn=2, matype=0)
    df['BB_upper'] = upper
    df['BB_middle'] = middle
    df['BB_lower'] = lower
    return df

def support_resistance(df):
    support = df['low'].min()
    resistance = df['high'].max()
    pivot = (df['high'].iloc[-1] + df['low'].iloc[-1] + df['close'].iloc[-1]) / 3
    return support, resistance, pivot

def generate_signal(df):
    last = df.iloc[-1]
    signal = "HOLD"
    support, resistance, pivot = support_resistance(df)

    # Segnale combinato avanzato
    if last['EMA20'] > last['EMA50'] and last['RSI'] < 70 and last['MACD'] > last['MACD_signal']:
        signal = "BUY"
    elif last['EMA20'] < last['EMA50'] and last['RSI'] > 30 and last['MACD'] < last['MACD_signal']:
        signal = "SELL"

    # Bollinger + support/resistance
    if last['close'] <= support or last['close'] <= last['BB_lower']:
        signal = "SELL"
    elif last['close'] >= resistance or last['close'] >= last['BB_upper']:
        signal = "BUY"

    return signal, support, resistance, pivot

def plot_chart(df, symbol, tf):
    plt.figure(figsize=(10,5))
    plt.plot(df.index[-100:], df['close'].iloc[-100:], label='Close', color='blue')
    plt.plot(df.index[-100:], df['EMA20'].iloc[-100:], label='EMA20', color='orange')
    plt.plot(df.index[-100:], df['EMA50'].iloc[-100:], label='EMA50', color='green')
    plt.plot(df.index[-100:], df['BB_upper'].iloc[-100:], label='BB_upper', linestyle='--', color='red')
    plt.plot(df.index[-100:], df['BB_lower'].iloc[-100:], label='BB_lower', linestyle='--', color='red')
    plt.title(f"{symbol} - {tf}")
    plt.xlabel("Tempo")
    plt.ylabel("Prezzo")
    plt.legend()
    plt.tight_layout()
    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    plt.close()
    return buffer

def send_alert(message, chart_buffer=None):
    if chart_buffer:
        bot.send_photo(chat_id=CHAT_ID, photo=chart_buffer, caption=message)
    else:
        bot.send_message(chat_id=CHAT_ID, text=message)

# -------------------------
# MAIN
# -------------------------
def main():
    last_signals = {sym+"_"+tf: None for sym in SYMBOLS for tf in TIMEFRAMES}

    while True:
        for symbol in SYMBOLS:
            for tf in TIMEFRAMES:
                try:
                    df = get_data(symbol, tf)
                    df = calculate_indicators(df)
                    signal, support, resistance, pivot = generate_signal(df)
                    key = symbol+"_"+tf

                    if last_signals[key] != signal:
                        message = (f"SIMBOLO: {symbol}\nTIMEFRAME: {tf}\nSegnale: {signal}\n"
                                   f"Massimo: {df['high'].max():.2f}\nMinimo: {df['low'].min():.2f}\n"
                                   f"Supporto: {support:.2f}\nResistenza: {resistance:.2f}\nPivot: {pivot:.2f}")
                        chart = plot_chart(df, symbol, tf)
                        send_alert(message, chart)
                        last_signals[key] = signal
                except Exception as e:
                    print(f"Errore con {symbol} {tf}: {e}")
        time.sleep(60)

if _name_ == "_main_":
    main()
