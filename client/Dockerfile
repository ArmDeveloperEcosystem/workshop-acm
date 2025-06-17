
# syntax=docker/dockerfile:1
ARG URL

# Build: 1st stage
FROM --platform=${BUILDPLATFORM} python:3.10-slim AS builder

# Install dependencies
RUN apt-get update && \
    apt-get install -y git

RUN git clone  https://github.com/pytorch/torchchat.git && \
    cd torchchat && \
    git checkout 925b7bd73f110dd1fb378ef80d17f0c6a47031a6 && \
    sed -i'e' '1s/^/import os\n/' browser/browser.py && \
    sed -i'e' 's|127\.0\.0\.1:5000|"+os.environ.get("TORCHCHAT_BASE_URL", "127.0.0.1:5000")+"|' browser/browser.py

# Release: 2nd stage
FROM --platform=${BUILDPLATFORM} python:3.10-slim
EXPOSE 8501
ARG URL
ENV TORCHCHAT_BASE_URL=$URL

# Install dependencies
RUN apt-get update && \
    apt-get install -y python3-pip python3-venv git

RUN python -m venv torch_env && \
    . torch_env/bin/activate && \
    pip install streamlit && \
    pip install openai==1.45.0 && \
    pip install httpx==0.27.2 

COPY --from=builder /torchchat/browser/browser.py browser.py

CMD ["bash", "-c", ". torch_env/bin/activate && streamlit run browser.py --server.port=8501 --server.address=0.0.0.0"]
