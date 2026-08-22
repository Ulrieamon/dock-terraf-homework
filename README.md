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

```
#ls
bin  boot  dataview  dev  etc  home  lib  lib64  media	mnt  opt  proc	root  run  sbin  srv  sys  tmp	usr  var
```

# cd dataview/
green_tripdata_2025-11.parquet	taxi_zone_lookup.csv```

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

**copy a token in jupyter log, you can see in this command :**

`docker compose logs -f jupyter`


### 4. build a Docker image

`docker build -t taxi-city .`

### 5. Run a docker image taxi-city
```
docker run -it --rm \
  --name taxi-city \
  -p 8888:8888 \
  -v "$(pwd)/datasource:/dataview" \
  taxi-city
```
### 6. on Jupyter

`[] : import pandas as pd `

`[]: pip install sqlalchemy`

`[]: pip install psycopg2-binary `

`[]: df = pd.read_parquet("green_tripdata_2025-11.parquet")
     zone=pd.read_csv("taxi_zone_lookup.csv") `

`[]: from sqlalchemy import create_engine
    engine = create_engine("postgresql://postgres:postgres@db:5432/ny_taxi") `

`[]: df.dtypes `

`[]: zone.dtypes`

`[] :  df.to_sql(
    "green_tripdata",
    engine,
    if_exists="replace",
    index=False)

zone.to_sql(
    "taxi_zone_lookup",
    engine,
    if_exists="replace",
    index=False
)

### create a docker-compose files

`# touch docker-compose.yml`

In yml files put the docker compose script
I will put a container taxi-city in the same network with postgresql. I add a Jupyter in the same docker-compose.yml
```
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: ny_taxi
    ports:
      - "5433:5432"
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

  jupyter:
    container_name: taxi-city
    build: .
    ports:
      - "8888:8888"
    volumes:
      - ./datasource:/dataview

volumes:
  vol-pgdata:
    name: vol-pgdata

  vol-pgadmin_data:
    name: vol-pgadmin_data
```
after 

`#docker compose up -d`

now the 2 docker a running in back

### Launch PgAdmin in web browser
`
http://localhost:8080`

**access to PgAdmin:** 
```
user mail : pgadmin@pgadmin.com
password: pgadmin
```

**access to server:** 
```
server: db
port :5432
user: postgres
password: postgres
```

# Question 3. Counting short trips
```
select 
count(*) "number"
from public.green_tripdata
where lpep_pickup_datetime>='2025-11-01' and lpep_pickup_datetime<'2025-12-01'
and trip_distance <= '1'
```
**Result  =  8,007**

# Question 4. Longest trip for each day
```
select 
lpep_pickup_datetime::date as pick_up_day ,
Max(trip_distance) as distance
from public.green_tripdata
where trip_distance < 100
group BY lpep_pickup_datetime::date
order by distance desc
limit 1
```

**Result = 2025-11-14**


# Question 5. Biggest pickup zone
```
select 
zl."Zone",
SUM(gt.total_amount) total_amount
from public.green_tripdata gt
left join public.taxi_zone_lookup as zl on zl."LocationID"=gt."PULocationID"
where lpep_pickup_datetime::date >= '2025-11-18' 
and lpep_pickup_datetime::date < '2025-11-19'
group by zl."Zone"
order by total_amount desc
```

**Result = East Harlem North**

# Question 6.
```
select 
zd."Zone",
MAX(gt.tip_amount) tip_amount
from public.green_tripdata gt
left join public.taxi_zone_lookup zp on gt."PULocationID"=zp."LocationID"
left join public.taxi_zone_lookup zd on gt."DOLocationID"=zd."LocationID"
where zp."Zone" = 'East Harlem North'
and lpep_pickup_datetime>='2025-11-01' 
and lpep_pickup_datetime<'2025-12-01'
group by zd."Zone"
order by tip_amount desc
```

**Result = Yorkville West**


# Question 7. Terraform


Anwser :

```
 terraform init
 terraform apply -auto-approve
 terraform destroy**
```

I use terraform for AWS CLI on linux. at first :

**I update a package and install a requise**

`sudo apt-get update && sudo apt-get install -y gnupg software-properties-common wget`

**Download and install the Hashicorp GPG key**

`wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg`

**Add a official hashicorp repo for Ubuntu**

`echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`


**Update and install Terraform**

`sudo apt-get update && sudo apt-get install -y terraform`

**show the version of Terraform**
```
#terraform --version

Terraform v1.15.9
on linux_amd64
```

**Download a AWS CLI**

`sudo apt install -y unzip curl`

`curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`

**unzip and execute installation**

```
unzip awscliv2.zip

sudo ./aws/install
```

**Show the version of AWS**
```
# aws --version
aws-cli/2.36.28 Python/3.14.6 Linux/7.0.0-29-generic exe/x86_64.ubuntu.26
```
**Configure your AWS**

`aws configure`

after this command, put your access key in AWS

AWS Access Key ID : ***************
AWS Secret Access Key : ****************************
Default region name [None]: us-east-3
Default output format [None]:


Modify a variable "bucket _name"in  variables.tf :

```
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "data-engineering-terraf-redempteur-20082026"
}
```

after I upload on my S3 Bucket 

`
/terraf-homwk# aws s3 cp ~/datasource/green_tripdata_2025-11.parquet s3://data-engineering-terraf-redempteur-20082026/
`

**Destroy Terraform**

`terraform destroy`
