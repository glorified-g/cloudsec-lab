import os

from flask import Flask, jsonify, render_template

app = Flask(__name__)

VERSION = "1.0.1"
ENVIRONMENT = os.getenv("APP_ENV", "local")


@app.route("/")
def index():
    return render_template(
        "index.html",
        environment=ENVIRONMENT,
        version=VERSION,
    )


@app.route("/health")
def health():
    return jsonify(status="healthy")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
