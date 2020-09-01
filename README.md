# parameterized-cac-jenkins

This repo is an example of using Configuration-as-Code with Docker as well as
the following:

- Triggering downstream Jenkins job with parameters
- Copying dynamic variables between jobs

## Environment variables

Environment variables are kept in `.env` and used to populate an example. Any
environment variable can be used in this way throughout the configuration.

```
docker build -t jenkinsp .
docker run -d --rm --name jenkins -p 8080:8080 -p 50000:50000 --env-file .env jenkinsp
```

To cleanup:

```
docker stop jenkins
```
