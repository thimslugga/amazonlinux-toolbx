# justfile

# just --set release 2023 <command>
release := "2023"
region := "us-east-1"
registry := "public.ecr.aws/l6o8q4o8/thimslugga"

default:
  @just --summary

help:
  @just --list

alias m := make
make: build create

alias b := build
build:
  #!/usr/bin/env bash
  podman build -t amazonlinux-toolbox:{{release}} \
    -f $(pwd)/{{release}}/Containerfile $(pwd)/{{release}}/.

alias rmi := remove-image
remove-image:
  podman rmi amazonlinux-toolbox:{{release}}
  #toolbox rmi amazonlinux-toolbox:{{release}}

alias c := create
create:
  toolbox create \
    -c amznlinux-{{release}}-toolbx \
    -i amazonlinux-toolbox:{{release}}

alias e := enter
enter:
  toolbox enter amznlinux-{{release}}-toolbx

alias cu := cleanup
cleanup:
  podman stop amznlinux-{{release}}-toolbx
  toolbox rm amznlinux-{{release}}-toolbx
  toolbox rmi amazonlinux-toolbox:{{release}}

alias p := push
push:
  aws ecr-public get-login-password --region {{region}} | podman login --username AWS --password-stdin public.ecr.aws/l6o8q4o8
  podman tag thimslugga/amazonlinux-toolbox:{{release}}
  {{registry}}/amazonlinux-toolbox:{{release}}
  podman push public.ecr.aws/l6o8q4o8/thimslugga/amazonlinux-toolbox:{{release}}
