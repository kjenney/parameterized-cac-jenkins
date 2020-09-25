# parameterized-cac-jenkins

This repo is an example of using Configuration-as-Code with Docker as well as
the following:

- Triggering downstream Jenkins job with parameters
- Copying dynamic variables between jobs
- Configuring Kubernetes cloud

## Running locally on Docker

### Environment variables

Environment variables are kept in `.env` and used to populate an example. Any
environment variable can be used in this way throughout the configuration.

```
docker build -t jenkins .
docker run -d --rm --name jenkins -p 8080:8080 -p 50000:50000 --env-file .env jenkins
```

To cleanup:

```
docker stop jenkins
```

## Running in Minikube

### Stand up the service

### Environment variables

Environment variables are defined in secrets and then referred to in the deployment config.

Example: `kubectl -n jenkins create secret generic test --from-literal=test=abcd1234`

```
minikube start
kubectl create ns jenkins
kubectl -n jenkins create secret generic test --from-literal=test=abcd1234
kubectl -n jenkins apply -f kubernetes/jenkins-admin-rbac.yaml
kubectl -n jenkins apply -f kubernetes/jenkins-service.yaml
kubectl -n jenkins apply -f kubernetes/jenkins-deployment.yaml
```

### Get Jenkins endpoint

```
MINIKUBE_IP=$(minikube ip)
NODEPORT=$(kubectl -n jenkins get svc | tail -n 1 | awk -F ':' '{print $2}' | awk -F '/' '{print $1}')
echo "Go here for Jenkins: http://$MINIKUBE_IP:$NODEPORT"
```
