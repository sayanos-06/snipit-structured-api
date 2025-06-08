FROM rasa/duckling:latest AS duckling

FROM python:3.10-slim

# Install Flask, requests, supervisor
RUN apt-get update && apt-get install -y supervisor && \
    pip install flask requests

# Copy Duckling binary from rasa/duckling image
COPY --from=duckling /duckling /duckling

# Copy Flask app
WORKDIR /app
COPY . /app

# Add supervisord configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose Flask + Duckling ports
EXPOSE 5000

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]