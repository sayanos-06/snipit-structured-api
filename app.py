from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

DUCKLING_URL = "https://duckling-snipit-api.onrender.com/parse"

@app.route("/parse", methods=["POST"])
def parse():
    try:
        if not request.is_json:
            actual_type = request.headers.get("Content-Type", "missing")
            return jsonify({
                "error": "Expected application/json Content-Type",
                "received": actual_type
            }), 415

        data = request.get_json()
        
        payload = {
            "text": data["text"],
            "locale": data.get("locale", "en_US"),
            "tz": data.get("tz", "Asia/Kolkata"),
            "dims": data.get("dims", ["time", "email", "url", "phone-number"])
        }
        res = requests.post(DUCKLING_URL, data = payload)
        try:
            duckling_json = res.json()
            return jsonify(duckling_json)
        except Exception:
            print("❗ RAW Duckling Response:", res.text)  # Log for debugging
            return jsonify({
                "error": "Duckling returned non-JSON response",
                "raw": res.text
            }), 500
    except Exception as e:
        return jsonify({"error": str(e)}), 500