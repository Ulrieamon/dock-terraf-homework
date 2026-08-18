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

I create a directory **~/Data-engineering/01-docker-terraform/docker-homework$** in my homework to download the files:

```
# mkdir datasource

# wget https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet

# wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```
create a volume between my path **/datasource** and my container python:3.13.11-slim path /dataview

`# docker run -it --entrypoint=bash -v $(pwd)/datasource:/dataview python:3.13.11-slim`

in container 
`
#ls
bin  boot  dataview  dev  etc  home  lib  lib64  media	mnt  opt  proc	root  run  sbin  srv  sys  tmp	usr  var`

`# cd dataview/
green_tripdata_2025-11.parquet	taxi_zone_lookup.csv
`

`# cd ..`

### Install pandas and pyarrow for data processing 
```
# pip upgrade

# pip install pandas pyarrow

# pip install jupyter notebook

```

### Create a Dockerfile

I create a Dockerfile to create a docker image and import a dependancies

# touch Dockerfile

# vim Dockerfile

in DOckerfile :
```
FROM python:3.13.11-slim

RUN pip install pandas pyarrow jupyter

WORKDIR /app/datadock
```

# Question 3 . Counting short trips


