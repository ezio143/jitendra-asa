# Running the APP using Docker

# build docker image (run from root dir)
```
docker build -t fastapi-asa:latest .
```

# run app using docker
```
docker run -d -p 8000:8000 --name fastapi-asa fastapi-asa:latest
```