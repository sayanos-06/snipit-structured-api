FROM python:3.10-slim

# Duckling dependencies
RUN apt-get update && \
    apt-get install -y libpcre3 libpcre3-dev curl git supervisor && \
    curl -sSL https://get.haskellstack.org/ | sh

# Install Python dependencies
RUN pip install flask requests

# Install Duckling from source
RUN git clone https://github.com/facebook/duckling.git /duckling
WORKDIR /duckling
RUN stack setup && stack build

# Add Flask API
WORKDIR /app
COPY . /app

# Add supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 5000

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]