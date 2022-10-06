#
# Deploys the Node.js application to Kubernetes.
#

npx figit ./scripts/kubernetes/deploy.yaml --output yaml | kubectl apply -f -