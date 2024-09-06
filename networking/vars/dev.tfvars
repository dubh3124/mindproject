region = "us-west-2"
project_alias = "nlp"
environment = "dev"
vpc_cidr = "10.10.0.0/16"
public_subnet_configs = [
  {
    name = "public-subnet-a"
    cidr = "10.10.0.0/24"
    az = "us-west-2a"
  },
  {
    name = "public-subnet-b"
    cidr = "10.10.16.0/24"
    az = "us-west-2b"
  }
]

private_subnet_configs = [
  {
    name = "private-subnet-a"
    cidr = "10.10.32.0/24"
    az = "us-west-2a"
  },
  {
    name = "private-subnet-b"
    cidr = "10.10.48.0/24"
    az = "us-west-2b"
  }
]