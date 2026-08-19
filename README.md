# dock-terraf-homework
hdocker and Terraform SQL HomeWork

# Question 1 . Understanding Docker images

the version of pip in the image is :
`25.3`

# Question 2 . Understanding Docker networking and docker-compose

in the Docker-compose, all containers use the same service :
hostname : db
port: 5433

the answer is : `db:5433`

# Prepare the Data

### 1. I create a directory **~/Data-engineering/01-docker-terraform/docker-homework$** in my homework to download the files:

```
# mkdir datasource

# wget https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet

# wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```
create a volume between my path **/datasource** and my container python:3.13.11-slim path /dataview

`# docker run -it --entrypoint=bash -v $(pwd)/datasource:/dataview python:3.13.11-slim`

in container 

`#ls
bin  boot  dataview  dev  etc  home  lib  lib64  media	mnt  opt  proc	root  run  sbin  srv  sys  tmp	usr  var`

`# cd dataview/
green_tripdata_2025-11.parquet	taxi_zone_lookup.csv`

`# cd ..`

### 2. Install pandas and pyarrow for data processing 
```
# pip upgrade

# pip install pandas pyarrow

# pip install jupyter notebook

```

### 3. Create a Dockerfile

I create a Dockerfile to create a docker image and import a dependencies

`/docker-homework$# touch Dockerfile`

`/docker-homework$# vim Dockerfile`

in Dockerfile :

```
FROM python:3.13.11-slim

RUN pip install pandas pyarrow jupyter

WORKDIR /dataview

# jupyter accessibility of container
EXPOSE 8888
# run on container
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

```

### 4. build a Docker image

`docker build -t taxi-city .`

### 5. Run a docker image taxi-city
```
docker run -it --rm \
  --name taxi-city \
  -p 8888:8888 \
  -v /datasource:/dataview \
  taxi-city
```
# Question 3 . Counting short trips


