from celery import Celery
import os
import time
import signal


# Use environment variable for broker URL, default to localhost for development
broker_url = os.getenv('CELERY_BROKER_URL', 'redis://localhost:6379/0')
WAIT_SECONDS = int(os.getenv('WAIT_SECONDS', 50))  # Default to 50 seconds if not set

app = Celery('tasks', broker=broker_url)

def process_signal(signum, frame):
    print(f"Received signal {signum}. Exiting gracefully...", flush=True)
    if signum == signal.SIGINT:
        print("SIGINT received. Closing...", flush=True)
    elif signum == signal.SIGTERM:
        print(f"SIGTERM received. Cleaning up and wait {WAIT_SECONDS} seconds...", flush=True)
        time.sleep(WAIT_SECONDS)  # Simulate cleanup delay

signal.signal(signal.SIGINT, process_signal)
signal.signal(signal.SIGTERM, process_signal)
signal.signal(signal.SIGQUIT, process_signal)  # Optional: handle SIGQUIT

@app.task
def add(x, y):
    i = 0
    print(f"Starting task with x={x}, y={y}", flush=True)
    kill= time.time() + WAIT_SECONDS  # Default to 50 seconds if not set
    while True:
        if(time.time() > kill):
            print("Delay passed. Exiting now.", flush=True)
            break
        time.sleep(1)
        print(f"Doing something in a loop {i}: {x} + {y}", flush=True)
        i+=1
    return x + y