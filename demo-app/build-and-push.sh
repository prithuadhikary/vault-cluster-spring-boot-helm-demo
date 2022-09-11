#!/bin/bash

ECR_REPO=117826729006.dkr.ecr.us-east-1.amazonaws.com
AWS_REGION=us-east-1

docker build -t "$ECR_REPO/demo-app:1.0" .

docker login --username AWS -p $(aws ecr get-login-password --region $AWS_REGION) $ECR_REPO

docker push "$ECR_REPO/demo-app:1.0"