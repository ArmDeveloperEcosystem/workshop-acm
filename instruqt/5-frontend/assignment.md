python -m venv torch_env && \
    . torch_env/bin/activate && \
    # Clone pytorch/torchchat
    git clone --recursive https://github.com/pytorch/torchchat.git && \
    cd torchchat 
    
    
    pip3 install openai==1.45.0
pip3 install httpx==0.27.2

find . -name browser.py -exec sed -i -e "s/127\.0\.0\.1:5000/$IPADDRESS:80/" {} +