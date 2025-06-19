# Deploy backend workload into AKS

Now that we have all the pieces in place, it's time to deploy and run our application itself using kuberneters.

## File Explanation
===

In the [Editor](tab-1) tab, let's look through the various `yaml` files we will be using today:

[button label="Editor"](tab-1)

### Services

`llmserver-service.yaml` and `client-service.yaml` create our services in kubernetes. These set up load balancers with an external facing IP address that will direct traffic to our applications, regardless of what nodes those deployments are running on.

`llmserver-service` allows us to connect to our backend server, with a public IP address for our testing purposes. In a real world situation, we would only need a public IP on our `client-service`. However, for ease of testing, both services create a public IP address.

These two services are nearly identical, but target different applications.

### Deployments

There are two deployment files, one for our server (`llmserver-deployment.yaml`) and one for our client (`client-deployment.yaml`)

Once again these two deployments are similar. The `yaml` files define the resource requirements and which image we want to deploy from our ACR. However, besides targeting different container images, they are different in a couple key ways.

Each has a `nodeSelector` targeting a different platform. We optimized our LLM server for `arm64`, so we want our application to only run on arm based compute. However, we built our frontend client to run on either `amd64` or `arm64`. Because it is cross platform, it can run on all of our nodes and our `client-service` will automatically direct traffic completely invisibly to the end user.

For example purposes today, we have chosen our client to be only run `amd64`. This is to demonstrate that in a truly multi-architectural kubernetes system, what matters is the applications and their relationship to each other. As long as containers are built for any platform, they will not only work but talk to other aspects of the deployment regardless of their architecture. If we wanted frontend client to run on either `amd64` or `arm64` workloads, all we have to do is remove the `nodeSelector` from the yaml file. This is a great example of how you can implement new architecture into your existing workloads without having to take existing services down. Then gradually change the available of your nodes as you optimize for cost and scale.

In each file, we will need to update the image URL to our ACR we pushed to in the previous section.

In the `client-deployment.yaml` file, we will also need to set the environment variable to the `llmserver-service` IP address.

## Update `llmserver-deployment.yaml`

While in the [Editor](tab-1) tab, open the `llmserver-deployment.yaml` file.

[button label="Editor"](tab-1)

On line 21, change this:

```yaml
        image: <your deployed ACR name>.azurecr.io/acmworkshopllm:latest
```

to

```yaml
        image: workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]].azurecr.io/acmworkshopllm:latest
```

> [!NOTE]
> Note the name of your deployed Azure Container Registry, if it is not the default `workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]` then edit the above line.

Make sure the file is saved. Once you have done so, we are ready to deploy.

## Deploy backend server

In your [Terminal tab](tab-0), write the following command to load your AKS credentials into your local kubernetes:

[button label="Terminal"](tab-0)

```bash,run
az aks get-credentials --resource-group workshop-demo-rg-[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]-aks --name workshop-aks-demo-cluster --overwrite-existing 
```

> [!NOTE]
> Once again noting that if your resource group is not the default name of `workshop-demo-rg-[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]-aks`, then you will have to edit the above line to use the actual name of your deployed resource group and AKS cluster.

Deploy the service using `kubectl`

```bash,run
kubectl apply -f llmserver-service.yaml
```

Now that our service is running, let's deploy our backend server:

```bash,run
kubectl apply -f llmserver-deployment.yaml
```

> [!NOTE]
> Ensure you only deploying `llmserver-service` and `llmserver`, not the client ones! We will do that later.

### Test backend server
===

Let's check on our deployment by looking at our pods:

```bash,run
kubectl get pods
```

You should see two pods running the same server application. Your load balancer will automatically assign a response from one upon getting a request.

It may take a minute for the container to become running. In the mean time you can check if your service is ready with:

```bash,run
kubectl get svc
```

You should see the llmserver-service we deployed, along with an external facing IP address.

> [!IMPORTANT]
> If you still see a `pending` value for the external IP address, wait a moment and try again.

Once an external IP addressed is assigned, let's save that value to a variable:

```bash,run
export SERVER_IP=$(kubectl get services llmserver-service --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

Try it out by sending a ping using curl:

```bash,run
curl http://$SERVER_IP/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama3.1",
    "stream": "true",
    "max_tokens": 200,
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Hello!"
      }
    ]
  }'
```

You should get a series of json messages as a response.

> [!IMPORTANT]
> If you don't get a response, do another `kubectl get pods` and ensure at least one deployment is in a `running` state.

## Update `client-deployment.yaml`

Now we are ready to deploy our frontend client.

On line 21, change this:

```yaml
        image: <your deployed ACR name>.azurecr.io/acmworkshopclient:latest
```

to

```yaml
        image: workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]].azurecr.io/acmworkshopclient:latest
```

> [!NOTE]
> Just like all the times before, make sure you use the correct name for your Azure Container Registry. If it is not the default `workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]` then edit the above line.

Next we will need to set the `TORCHCHAT_BASE_URL` environment variable.

We will need to use the `Cluster IP` or the `External IP` of our `llmserver-service`

You can get that by running this:

```bash,run
kubectl get svc
```

Or get it from the variable `SERVER_IP` we set during server testing:

```bash,run
echo $SERVER_IP
```

Either way, the IP address goes into line 27

```yaml
            value: <server.url:port>
```

Since we set our load balancer to route traffic from port 80, all we need is the IP address.

Ensure the file is saved before deploying!

## Deploy frontend server

Back in your [Terminal tab](tab-0), let's deploy our `client-service`.

[button label="Terminal"](tab-0)

```bash,run
kubectl apply -f client-service.yaml
```

Once that is running, deploy the client:

```bash,run
kubectl apply -f client-deployment.yaml
```

All our services and deployments should now be live in our AKS.

### Ensure deployments were successful
===

We can ensure deployment was successful by looking at our pods:

```bash,run
kubectl get pods
```

You should see two pods for the server and two for the client. It may take a minute for the container to become running.

Then ensure that the client has a ready external IP address:

```bash,run
kubectl get svc
```

> [!IMPORTANT]
> If you still see a `pending` value for the external IP address, wait a moment and try again.

## Access the Streamlit frontend in your browser

To confirm the external IP address of our `client-service`, you can run the following command:

```bash,run
kubectl get services client-service --output jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

Open a new browser tab and go to `http://<EXTERNAL IP ADDRESS OF YOUR CLIENT-SERVICE>`

You should see a simple LLM based application, and be able to ask the bot any question you desire.

When you are ready to move on, click the **Next** button below.
