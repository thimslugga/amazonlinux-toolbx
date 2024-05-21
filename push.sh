#!/usr/bin/env bash

AWS_REGION="${AWS_REGION:-us-east-1}"
#AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}"
#AWS_ECR_REPO="${AWS_ECR_REPO:-public.ecr.aws/l6o8q4o8}"

case "${1}" in
login)
  set +o history
  #podman login
  aws --region "${AWS_REGION}" ecr-public get-login-password |
    podman login --username AWS --password-stdin public.ecr.aws/l6o8q4o8
  set -o history
  ;;
build)
  podman build \
    -t thimslugga/amazonlinux-toolbx:2023 .
  podman tag thimslugga/amazonlinux-toolbx:2023 \
    public.ecr.aws/l6o8q4o8/thimslugga/amazonlinux-toolbx:2023
  ;;
push)
  # push image to ECR
  podman push public.ecr.aws/l6o8q4o8/thimslugga/amazonlinux-toolbox:2
  ;;
*)
  echo "Usage: $0 {login|build|push}"
  exit 1
  ;;
esac
