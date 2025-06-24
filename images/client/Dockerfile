
# syntax=docker/dockerfile:1

# Build: 1st stage
FROM --platform=${BUILDPLATFORM} python:3.10-slim AS builder

# Install dependencies and update packages to fix vulnerabilities
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone and patch torchchat
RUN git clone  https://github.com/pytorch/torchchat.git && \
    cd torchchat && \
    git checkout 925b7bd73f110dd1fb378ef80d17f0c6a47031a6

# Modify browser.py to use environment variable for base URL
RUN sed -i'e' '1s/^/import os\n/' torchchat/browser/browser.py && \
    sed -i'e' 's|127\.0\.0\.1:5000|"+os.environ.get("TORCHCHAT_BASE_URL", "127.0.0.1:5000")+"|' torchchat/browser/browser.py

# Release: 2nd stage
FROM python:3.10-slim
EXPOSE 8501

# Install dependencies and update packages to fix vulnerabilities
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y python3-pip python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install python dependencies
RUN python -m venv torch_env && \
    . torch_env/bin/activate && \
    pip install streamlit && \
    pip install openai==1.45.0 && \
    pip install httpx==0.27.2 

COPY --from=builder /torchchat/browser/browser.py browser.py

CMD ["bash", "-c", ". torch_env/bin/activate && streamlit run browser.py --server.port=8501 --server.address=0.0.0.0"]
