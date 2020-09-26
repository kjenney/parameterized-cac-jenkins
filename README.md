# parameterized-cac-jenkins

This repo is an example of using Configuration-as-Code with Docker as well as
the following:

- Triggering downstream Jenkins job with parameters
- Copying dynamic variables between jobs
- Running jobs on Kubernetes pods

Configuration-as-Code is baked into the Docker image so any changes must be reflected by a
Docker push.

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

### Environment variables

Environment variables are defined in secrets and then referred to in the deployment config.

Example: `kubectl -n jenkins create secret generic test --from-literal=test=abcd1234`

### Stand up the service

```
minikube start
kubectl create ns jenkins
kubectl -n jenkins create secret generic test --from-literal=test=abcd1234
kubectl -n jenkins apply -f kubernetes/sa.yml
kubectl -n jenkins apply -f kubernetes/jenkins.yml
kubectl -n jenkins apply -f kubernetes/service.yml
```

Verify the status of Jenkins with:

```
kubectl get all -n jenkins
kubectl logs jenkins-0 -n jenkins
```

### Get Jenkins endpoint

```
MINIKUBE_IP=$(minikube ip)
NODEPORT=$(kubectl -n jenkins get svc | tail -n 1 | awk -F ':' '{print $2}' | awk -F '/' '{print $1}')
JENKINS_URL="http://$MINIKUBE_IP:$NODEPORT"
echo "Go here for Jenkins: $JENKINS_URL"
```

### Got to Jenkins and Run Job

Build this $JENKINS_URL/job/kubernetes-jobs/job/job1/
