# KubeArchInspect Demonstration

For the last part of this workshop, we will demonstrate how the `KubeArchInspect` tool can be used to check your existing kubernetes workloads for `arm64` compatibility.

You can get the project from the [official GitHub page](https://github.com/ArmDeveloperEcosystem/kubearchinspect) located at [ArmDeveloperEcosystem/kubearchinspect](https://github.com/ArmDeveloperEcosystem/kubearchinspect)

## Inspect our Kubernetes deployment

It should already be downloaded and set up for you in our terminal environment. Try it:

```bash,run
./kubearchinspect images
```

Our kubernetes cluster is fairly simple, but you should see output that shows you which container images already have `arm64` options.

> [!IMPORTANT]
> You will note that our custom images respond with 🚫. That is because they are on a private Azure Container Registry.
> This does not mean that the images are or are not compatible with `arm64`. We happen to know that they both are, but the tool is unable to confirm that due to not having permission.

This tool is designed to save you time by automatically checking image compatibility, so you don’t have to manually inspect each image or its documentation. Images listed with a 🆙 you know will have to be updated to a later version in order to be compatible. For any that are ❌ or 🚫, there may still be support. Some containers don't use multi-architectural images, but have separate image URLs for different platforms. This may be the case for your deployments.

Remember, even if you have services that are not `arm64` compatible, you can still migrate other kubernetes deployments that are to `arm64` based nodes. This can save you money while maintaining or increasing availability and performance.

## The End

To complete this workshop and clean up all your resources, click the **Next** button below.
