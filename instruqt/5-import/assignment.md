# Import into Azure Container Registry

Now we need to import an image of our Go application into our newly created Azure Container Registry.

## Overview of our Go application
===

Switch to the [Editor](tab-1) tab to take a look the application we will run today:

[button label="Editor"](tab-1)

We have a `Dockerfile`, that defines how our application image will be created. The application itself is incredibly simple, responding to pings with some basic diagnostic information. This will allow us to see which node our application is deployed on.

## Import image into ACR
===

To save some time, I have already created our docker image and uploaded it to a private repository.

In your [Terminal tab](tab-0), write the following command to prepare the current working directory for use with Terraform:

[button label="Terminal"](tab-0)

```bash,run
az acr import --name armacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]] --source docker.io/avinzarlez979/multi-arch:latest --image multi-arch:latest
```

This will import the public image of this Go application available at `docker.io/avinzarlez979/multi-arch:latest` into your newly created ACR.

> [!NOTE]
> If you did not set your `random_id` to `[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]` during deployment, then you will have to edit the above line to use the actual name of your deployed Azure Container Registry.
