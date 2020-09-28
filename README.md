# parameterized-cac-jenkins

This repo is an example of using Configuration-as-Code with Jenkins as well as
the following:

- Triggering downstream Jenkins job with parameters
- Copying dynamic variables between jobs

## Running locally on Docker

Configuration-as-Code is mounted onto the Docker container. Reloading the

### Environment variables

Environment variables are kept in `.env` and used to populate an example. Any
environment variable can be used in this way throughout the configuration.

```
docker build -t jenkins -f docker/Dockerfile .
docker run -d --rm --name jenkins -p 8080:8080 -p 50000:50000 --env-file .env -v "$(pwd)"/jac:/usr/share/jac jenkins
```

To cleanup:

```
docker stop jenkins
```

TODO: How to connect to a Kubernetes cluster from a Docker container

## Running in Minikube

### Getting Helm chart

```
helm repo add jenkinsci https://charts.jenkins.io
```

## Build the values

```
yq m minikube-values.yaml plugins.yaml > /tmp/minikube.yaml
```

### Stand up the service

```
minikube start
kubectl create ns jenkins
helm install -f /tmp/minikube.yaml -n jenkins jenkins jenkinsci/jenkins
```

### Get Jenkins endpoint

```
MINIKUBE_IP=$(minikube ip)
NODEPORT=$(kubectl -n jenkins get svc jenkins | tail -n 1 | awk -F ':' '{print $2}' | awk -F '/' '{print $1}')
JENKINS_URL="http://$MINIKUBE_IP:$NODEPORT"
echo "Go here for Jenkins: $JENKINS_URL"
```

### Got to Jenkins and Run Job

Build this $JENKINS_URL/job/kubernetes-jobs/job/job1/

To cleanup:

```
minikube delete
```

## Running in EKS

Need to follow this guide to be ALB setup correctly:
https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html

```
eksctl create cluster jenkins
eksctl create nodegroup --cluster jenkins
kubectl create ns jenkins
kubectl -n jenkins create secret generic test --from-literal=test=abcd1234
kubectl -n jenkins apply -f kubernetes/sa.yml
kubectl -n jenkins apply -f kubernetes/jenkins.yml
kubectl -n jenkins apply -f kubernetes/service.yml
kubectl -n jenkins apply -f kubernetes/ingress.yml
```

Verify the status of Jenkins with:

```
kubectl get all -n jenkins
kubectl logs jenkins-0 -n jenkins
```

### Get Jenkins endpoint

Create ingress and point to that for Jenkins

```
kubectl get ingress/jenkins-ingress -n jenkins
```

### Got to Jenkins and Run Job

Build this $JENKINS_URL/job/kubernetes-jobs/job/job1/
