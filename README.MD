# A simple Node.js example

Just a simple Node.js "hello world" example with a Dockerfile and Kubernetes deployment configuration.

This example project accompanies the blog post [The quick guide to creating a production Kubernetes cluster](https://www.codecapers.com.au/kub-cluster-quick-2/).

# Project layout

```
nodejs-example
│   Dockerfile          -> Script file for building our Docker image.
│   package.json        -> Project metadata and dependencies.
├───src
│       index.js        -> Example Express web server.
├───scripts             -> Shell scripts for build, publish and deployment.
│   │   build-image.sh  -> Builds the Docker image.
│   │   push-image.sh   -> Published the Docker image.
│   │   deploy.sh       -> Deploys the Node.js application to Kubernetes.
│   │   delete.sh       -> Deletes the Node.js application from Kubernetes.
│   └───kubernetes
│           deploy.yaml -> Kubernetes configuration to deploy the Node.js app.    
└───.github
    └───workflows/
            deploy.yaml -> GitHub Actions workflow for deployment to Kubernetes.
```

# Setup

You need [Node.js](https://nodejs.org/en/) and [Docker Desktop](https://www.docker.com/products/docker-desktop) installed.

Clone the example repo:

```bash
git clone https://github.com/ashleydavis/nodejs-example.git
```

Then change to the directory and install dependencies:

```bash
cd nodejs-example
npm install
```

# Directly run it

The example Node.js application is just "Hello world", you run it directly under Node.js like this:

```bash
npm start
```

## Use the shell scripts to build, publish and deploy to Kubernetes

Before running each script, please ensure it is flagged as executable, eg:

```bash
chmod +x ./scripts/build-image.sh
```

Set environment variables to connect to your container registry:

```bash
export CONTAINER_REGISTRY=<your-container-registry>
export REGISTRY_UN=<username-for-your-registry>
export REGISTRY_PW=<password-for-your-registry>
export VERSION=1
```

Build the Docker image:

```bash
./scripts/build-image.sh
```

Publish the Docker image to your container registry:

```bash
./scripts/push-image.sh
```

To deploy to Kubernetes you need [Kubectl configured to connect to your cluster](https://www.codecapers.com.au/kub-cluster-quick-2/).

The Kubernetes configuration is templated. To see it expanded, run it through Figit:

```bash
npx figit ./scripts/kubernetes/deploy.yaml --output yaml
```

To deploy the Node.js application, pipe the output from Figit to `kubectl apply`:

```bash
npx figit ./scripts/kubernetes/deploy.yaml --output yaml | kubectl apply -f -
```

Or just run the deploy shell script:

```bash
./scripts/deploy.sh
```

## Check your deployment 

Check the status of the pod and deployment:

```bash
kubectl get pods
kubectl get deployments
```

To find the IP address allocated to the web server, invoke:

```bash
kubectl get services
```

Pull out the EXTERNAL-IP address for the nodejs-example service and put that into your web browser. You should see the hello world message in the browser.

To check console logging for the Node.js app:

```bash
kubectl logs <pod-name>
```

Be sure the actual name of the pod for `<pod-name>` that was in the output from `kubectl get pods`.

## Destroy the deployment

Run `deploy.yaml` through Figit and pipe the result to `kubectl delete`:

```bash
npx figit ./scripts/kubernetes/deploy.yaml --output yaml | kubectl delete -f -
```

Or use the shell script:

```bash
./scripts/delete.sh
```

## Setup for automated deployment

The GitHub Actions `deploy.yaml` workflow automatically builds, publishes and deploys the Node.js application to Kubernetes when code is pushed to this repository.

To get this working in your own code repostiory you must add GitHub Secrets for the following environment variables:
- `CONTAINER_REGISTRY`
- `REGISTRY_UN`
- `REGISTRY_PW`

Just don't set `VERSION` because that is automatically derived from the current commit hash.

You also need a GitHub Secret to configure Kubectl's connection to your Kubernetes cluster. Add `KUBE_CONFIG` to be the base64 encoded version of your local Kubernetes configuration.

You can encoded your local configuration like this:

```bash
cat ~/.kube/config | base64
```

## Using this repo as a template

You can use this example as a template to start your own Node.js application.

Choose a name for your project, for example `my-application`.

Clone the example repo name giving it the new name:

```bash
git clone https://github.com/ashleydavis/nodejs-example.git my-application
```

Delete the Git repo:

```bash
cd my-application
rm -rf .git
```

Initialise a new Git repo here and commit the template code:

```bash
git init
git add .
git commit -m "First commit from template"
```

Search and replace `nodejs-example` with your own unique name, eg `my-application`.

Then commit your customized project:

```bash
git add .
git commit -m "Customized template"
```

Happy coding on your new Node.js project!
