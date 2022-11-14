#!/usr/bin/env bash

aws ecr-public get-login-password --region us-east-1 | podman login --username AWS --password-stdin public.ecr.aws/l6o8q4o8
#podman build -t thimslugga/amazonlinux-toolbox:2 .
podman tag thimslugga/amazonlinux-toolbox:2 public.ecr.aws/l6o8q4o8/thimslugga/amazonlinux-toolbox:2
podman push public.ecr.aws/l6o8q4o8/thimslugga/amazonlinux-toolbox:2
