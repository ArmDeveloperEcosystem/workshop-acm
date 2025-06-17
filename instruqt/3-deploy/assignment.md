# Deploy workload into AKS

Now that we have all the pieces in place, it's time to deploy and run our application itself using kuberneters.

## Update yaml deployment file
===

In the [Editor](tab-1) tab, let's look through the various yaml files we will be using today:

[button label="Editor"](tab-1)

### hello-service.yaml

This is creates a service in kubernetes with an external facing IP address, that will direct traffic to our "hello" application we will deploy across various nodes.

### deployment yaml

There are three deployment files:

- `arm64-deployment.yaml`
- `amd64-deployment.yaml`
- `multi-arch-deployment.yaml`

All three of these files are very similar. They deploy our application from the image we imported into ACR. However, they are different in one key way.

`multi-arch-deployment.yaml` deploys the application to run on whatever node is available. However `arm64-deployment.yaml` and `amd64-deployment.yaml` implement an additional two lines of yaml called a `nodeSelector`, that only allows our application to run on either `arm64` or `amd64` based nodes respectively.

In each file, we will need to update it to point to our ACR we were using in the previous steps.

Change line 21 of all three files from:

```yaml
        image: <your deployed ACR name>.azurecr.io/multi-arch:latest
```

to

```yaml
        image: workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]].azurecr.io/multi-arch:latest
```

> [!NOTE]
> Note the name of your deployed Azure Container Registry, if it is not the default `workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]` then edit the above line.

Once the files are saved, we are ready to deploy our application on our AKS cluster.

## Deploy initial AKS workload
===

In your [Terminal tab](tab-0), write the following command to load your AKS credentials into your local kubernetes:

[button label="Terminal"](tab-0)

```bash,run
az aks get-credentials --resource-group workshop-demo-rg-[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]-aks --name workshop-aks-demo-cluster --overwrite-existing 
```

> [!NOTE]
> Once again if your resource group is not the default name of `workshop-demo-rg-[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]-aks`, then you will have to edit the above line to use the actual name of your deployed resource group and AKS cluster.

Deploy the service using `kubectl`

```bash,run
kubectl apply -f hello-service.yaml
```

Now that our service is running, let's deploy our application. At first, let's deploy only the version that runs on arm64 based devices:

```bash,run
kubectl apply -f arm64-deployment.yaml
```

You can check your deploy service with:

```bash,run
kubectl get svc
```

You should see the hello-service we deployed, along with an external facing IP address.

> [!IMPORTANT]
> If you still see a `pending` value for the external IP address, wait a moment and try again.

Once an external IP addressed is assigned, let's save that value to a variable:

```bash,run
export IPADDRESS=$(kubectl get services hello-service --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

Then send a ping using curl:

```bash,run
curl -w '\n' $IPADDRESS
```

You should get a reply from that service that confirms the Go application is running, and which architecture the application is running on.

## Deploy multi-architectural workloads
===

Now it's time to deploy the amd64 version of the application:

```bash,run
kubectl apply -f amd64-deployment.yaml
```

You can now see you have pods for both the arm64 and amd64 deployments.

```bash,run
kubectl get pods
```

Note that these are running the same application, and your load balancer will automatically assign a response from one upon request.

You can test this by sending more pings to the service:

```bash,run
curl -w '\n' $IPADDRESS
```

> [!NOTE]
> Remember you can run `kubectl get svc` to get the external IP address of your service.

Do this a couple of times, and you should see two different kinds of responses. Showing the Go application is running sometimes on amd64 and other times on arm64 based nodes.

Let's add a third deployment without the architecture restrictions:

```bash,run
kubectl apply -f multi-arch-deployment.yaml
```

Since our docker image has both an amd64 and arm64 version, it is compatible with all our nodes.

You can now see you have three pods for both the arm64, amd64 and multi architectural deployments.

```bash,run
kubectl get pods
```

Let's run a little script to ping the service repeatedly. Insert the external IP address of your service into this line of code and run it:

```bash,run
for i in $(seq 1 20); do curl -w '\n' $IPADDRESS; done
```

You will now get a variety of messages back. Some will be from the application deployments that we assigned to run on amd or arm. Others will be on the multi architectural deployment that could be running on both amd and arm based compute.

The load balance will automatically direct traffic to your various pods that is completely invisible to your end user.

This is a great example of how you can implement new architecture into your existing workloads without having to take existing services down. Then gradually change the available of your nodes as you optimize for cost and scale.

To complete this workshop and clean up these resources, click the **Next** button below.










az acr import --name workshopacroq00yn9bkmyl --source docker.io/avinzarlez979/acmworkshopllm:latest --image acmworkshopllm:latest

az aks get-credentials --resource-group workshop-demo-rg-nice-elephant-aks --name workshop-aks-demo-cluster --overwrite-existing 


python -m venv torch_env
. torch_env/bin/activate
git clone --recursive https://github.com/pytorch/torchchat.git
cd torchchat
git checkout 925b7bd73f110dd1fb378ef80d17f0c6a47031a6
find . -name browser.py -exec sed -i -e "s/127\.0\.0\.1:5000/$IPADDRESS:80/" {} +
pip3 install openai==1.45.0
pip3 install httpx==0.27.2






In this section, you will learn how to configure and run the chatbot server as a backend service and create a Streamlit-based frontend. This setup enables communication with the chatbot through a web interface accessible in your browser.

## Activate the Virtual Environment to install dependencies
===
First, connect back to your Arm instance
```bash,run
ssh -i "[[ Instruqt-Var key="PEM_KEY" hostname="cloud-container" ]]" -L 0.0.0.0:8501:localhost:8501 ubuntu@[[ Instruqt-Var key="EXTERNAL_IP" hostname="cloud-container" ]]
```

Then, re-activate the Python virtual environment you have used in the previous section
```bash,run
source torch_env/bin/activate
```

### Install Additional Tools
Install the additional packages:

```bash,run
pip3 install openai==1.45.0
pip3 install httpx==0.27.2
```
**Choose the next step based on which model you're using**
## Running LLM Inference Backend Server (Llama 3.1)
===
Change to the **Terminal 2** tab on the top, or click here [button label="Terminal 2"](tab-1), and connect back to the instance and activate the virtual environment
```bash,run
ssh -i "[[ Instruqt-Var key="PEM_KEY" hostname="cloud-container" ]]" ubuntu@[[ Instruqt-Var key="EXTERNAL_IP" hostname="cloud-container" ]]
```

```bash,run
source torch_env/bin/activate
```

```bash,run
cd torchchat
LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libtcmalloc.so.4 TORCHINDUCTOR_CPP_WRAPPER=1 TORCHINDUCTOR_FREEZING=1 OMP_NUM_THREADS=16 python3 torchchat.py server llama3.1 --dso-path exportedModels/llama3.1.so
```

The output while the backend server starts looks like this:

```output
Using device=cpu
Loading model...
Time to load model: 0.13 seconds
-----------------------------------------------------------
 * Serving Flask app 'server'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://127.0.0.1:5000
Press CTRL+C to quit
```

## Running LLM Inference Backend Server (Mistral)
===
Change to the **Terminal 2** tab on the top, or click here [button label="Terminal 2"](tab-1), and connect back to the instance and activate the virtual environment
```bash,run
ssh -i "[[ Instruqt-Var key="PEM_KEY" hostname="cloud-container" ]]" ubuntu@[[ Instruqt-Var key="EXTERNAL_IP" hostname="cloud-container" ]]
```

```bash,run
source torch_env/bin/activate
```

```bash,run
cd torchchat
LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libtcmalloc.so.4 TORCHINDUCTOR_CPP_WRAPPER=1 TORCHINDUCTOR_FREEZING=1 OMP_NUM_THREADS=16 python3 torchchat.py server mistral --dso-path exportedModels/mistral.so
```

The output while the backend server starts looks like this:

```output
Using device=cpu
Loading model...
Time to load model: 0.13 seconds
-----------------------------------------------------------
 * Serving Flask app 'server'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://127.0.0.1:5000
Press CTRL+C to quit
```

## Running Streamlit frontend server
===
Switch back to the **Terminal 1** tab, or click here [button label="Terminal 1"](tab-0)

```bash,run
cd torchchat
streamlit run browser/browser.py
```

The output while the streamlit frontend server starts looks like this:

```output
Collecting usage statistics. To deactivate, set browser.gatherUsageStats to false.

  You can now view your Streamlit app in your browser.

  Local URL: http://localhost:8501
  Network URL: http://10.0.2.29:8501
  External URL: http://3.86.224.131:8501
```

## Accessing the Streamlit frontend in the browser
===
To view the frontend, either select the **Application** tab at the top of this window, click here [button label="Application"](tab-2), or click the external URL link in the termal to open in a new browser tab.

Or open the External URL in a new browser tab: [ http://[[ Instruqt-Var key="EXTERNAL_IP" hostname="cloud-container" ]]:8501](http://[[ Instruqt-Var key="EXTERNAL_IP" hostname="cloud-container" ]]:8501)