#This is the docker build script used in local-exec provisioner block of appinfra/aws_ecr_repository.tf to bootstrap the initial image for ECS Service

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com
docker build --tag $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$APP_NAME:latest .
docker push $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$APP_NAME:latest
