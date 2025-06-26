from tasks import add, broker_url

print(f"Using broker URL: {broker_url}", flush=True)

add.delay(9,10)