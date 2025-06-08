FROM rasa/duckling:latest

# Install Python + Flask + Requests
RUN apt-get update && apt-get install -y python3 python3-pip supervisor && \
    pip3 install flask requests

# Set working directory
WORKDIR /app

# Copy Flask API
COPY app.py /app/app.py
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 5000

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]