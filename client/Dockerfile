
# syntax=docker/dockerfile:1
ARG URL

# Build: 1st stage
FROM python:3.10-slim
EXPOSE 8501
ENV TORCHCHAT_BASE_URL $URL

# Install dependencies
RUN apt-get update && \
    apt-get install -y python3-pip python3-venv git

RUN python -m venv torch_env && \
    . torch_env/bin/activate && \
    # Clone and patch pytorch/torchchat
    git clone --recursive https://github.com/pytorch/torchchat.git && \
    cd torchchat && \
    git checkout 925b7bd73f110dd1fb378ef80d17f0c6a47031a6 && \
    pip install -r requirements.txt && \
    pip3 install openai==1.45.0 && \
    pip3 install httpx==0.27.2 && \
    find . -name browser.py -exec sed -i'e' '1s/^/import platform\nimport os\n/' {} + && \
    find . -name browser.py -exec sed -i'e' 's|"http://127\.0\.0\.1:5000/v1"|os.environ.get("TORCHCHAT_BASE_URL", "http://127.0.0.1:5000/v1")|' {} + && \
    find . -name browser.py -exec perl -i -p0e 's|status\.update\((?:.\|\n)*?start\)|env_node = os.environ.get("NODE_NAME")\n            env_pod  = os.environ.get("POD_NAME")\n            env_platform = platform.processor()\n            status.update(\n                label="Done, averaged {:.2f} tokens\/second running on {} \/ {} \/ {}".format(\n                    tokcount \/ (time.time() - start), env_node, env_pod, env_platform|' {} +

CMD ["bash", "-c", ". torch_env/bin/activate && cd torchchat && streamlit run browser/browser.py --server.port=8501 --server.address=0.0.0.0"]
