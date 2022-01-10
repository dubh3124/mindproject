region = "us-east-1"
project_alias = "nlp"
environment = "dev"
vpc_cidr = "10.10.0.0/16"
public_subnet_configs = [
  {
    name = "public-subnet-a"
    cidr = "10.10.0.0/24"
    az = "us-east-1d"
  },
  {
    name = "public-subnet-b"
    cidr = "10.10.16.0/24"
    az = "us-east-1e"
  }
]

private_subnet_configs = [
  {
    name = "private-subnet-a"
    cidr = "10.10.32.0/24"
    az = "us-east-1d"
  },
  {
    name = "private-subnet-b"
    cidr = "10.10.48.0/24"
    az = "us-east-1e"
  }
]