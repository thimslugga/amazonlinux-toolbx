#!/bin/bash
# shellcheck disable=SC1101


# Set release version
RELEASE="${RELASE:-2023}"
AWS_REGION="${AWS_REGION:-us-east-1}"
#AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}"

# [account].dkr.ecr.[region].amazonaws.com/[repository_name]
REGISTRY="${REGISTRY:-public.ecr.aws}"
REPO="${REPO:-l6o8q4o8}"

case "${1}" in
login)
  set +o history
  aws --region "${AWS_REGION}" ecr-public get-login-password \
    | podman login --username AWS --password-stdin "${REGISTRY}"/"${REPO}"
  set -o history
  ;;
build)
  podman build -t thimslugga/amazonlinux-toolbx:"${RELEASE}" .
  ;;
tag)
  podman tag thimslugga/amazonlinux-toolbx:"${RELEASE}" "${REGISTRY}"/thimslugga/amazonlinux-toolbx:"${RELEASE}"
  ;;
push-ecr)
  # push image to ECR
  podman push "${REGISTRY}"/thimslugga/amazonlinux-toolbx:"${RELEASE}"
  ;;
*)
  echo "Usage: $0 {login|build|push}"
  exit 1
  ;;
esac
