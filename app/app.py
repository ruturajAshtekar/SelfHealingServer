from flask import Flask, jsonify
import random
import time
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

# Track app start time
start_time = time.time()

# Prometheus metric
REQUEST_COUNT = Counter(
    "app_requests_total",
    "Total HTTP requests",
    ["endpoint"]
)

@app.route("/")
def index():
    REQUEST_COUNT.labels(endpoint="/").inc()

    #  Simulate CPU load
    start = time.time()
    while time.time() - start < 0.1:
        pass

    #  Random failure simulation
    if random.random() < 0.2:
        return "Service temporarily unavailable", 503

    return "Hello from the Self-Healing Server demo!"

@app.route("/health")
def health():
    REQUEST_COUNT.labels(endpoint="/health").inc()

    # 20% chance to simulate failure
    if random.random() < 0.2:
        return jsonify({
            "status": "unhealthy",
            "reason": "Simulated random failure"
        }), 500

    uptime = time.time() - start_time
    return jsonify({
        "status": "healthy",
        "uptime_seconds": round(uptime, 2)
    }), 200

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {
        "Content-Type": CONTENT_TYPE_LATEST
    }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
