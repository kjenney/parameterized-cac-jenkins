# parameterized-iac-jenkins

This repo is an example of using Configuration-as-Code with Docker as well as
Triggering downstream Jenkins job with parameters

```
docker build -t jenkinsp .
docker run -d --rm --name jenkins -p 8080:8080 -p 50000:50000 --env-file .env jenkinsp
```

To cleanup:

```
docker stop jenkins
```
