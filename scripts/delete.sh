#
# Destroys the Node.js application in Kubernetes.
#

npx figit ./scripts/kubernetes/deploy.yaml --output yaml | kubectl delete -f -