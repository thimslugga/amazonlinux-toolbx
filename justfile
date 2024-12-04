#!/usr/bin/env just --justfile

################################################################################
# justfile
# https://github.com/casey/just
# just --set release 2023 <command>
# just --set aws_region us-east-1 <command>
################################################################################

################################################################################
## Settings
################################################################################

set unstable := false
set allow-duplicate-recipes := false
set allow-duplicate-variables := false
#set positional-arguments := true
set export := false
set dotenv-required := false
set dotenv-load := true
#set dotenv-path := env_var('PWD')
set dotenv-filename := ".env"

################################################################################
## Variables
################################################################################

project_root            := justfile_directory()
project_name            := env_var('PROJECT_NAME')
#timestamp        := `date +%s`
#commit           := `git show -s --format=%h`

release                   := env_var('RELEASE')
cointainer_name           := "amazonlinux-" + release + "-toolbx"

# public.ecr.aws/registry_alias/repository_name:image_tag
aws_region                := env_var('DEFAULT_AWS_REGION')
oci_name                  := env_var('OCI_NAME')
oci_registry              := env_var('OCI_REGISTRY')
oci_registry_alias        := env_var('OCI_REGISTRY_ALIAS')
oci_repo_name             := env_var('OCI_REPOSITORY_NAME')
oci_uri                   := env_var('OCI_URI')

################################################################################
## Recipes
################################################################################

# Default recipe (equivalent to 'all' in Makefile).
# If no default recipe, first recipe will become default.

# Lists the tasks and variables in the justfile.
@_list:
    just --justfile {{justfile()}} --list --unsorted
    echo ""
    echo "Available variables:"
    just --evaluate | sed 's/^/    /'
    echo ""
    echo "Override variables using 'just key=value ...' (also ALL_UPPERCASE ones)"

[doc('Evaluate and return all just variables')]
evaluate:
    @just --evaluate

[doc('List available recipes')]
help:
    @just --justfile {{justfile()}} --list

[doc('Just format')]
format:
    just --justfile {{justfile()}} --fmt

[doc('Return system information')]
system-info:
    @echo "os: {{os()}}"
    @echo "family: {{os_family()}}"
    @echo "architecture: {{arch()}}"
    @echo "home directory: {{ home_directory() }}"

[doc('List files in current directory')]
ls:
    #!/usr/bin/env python3
    import os
    print(*os.listdir())

################################################################################
# Podman
################################################################################

[doc('Build image and create container using podman')]
make: build create

[doc('Build image using podman')]
build:
  #!/usr/bin/env bash
  podman build -t amazonlinux-toolbox:{{ release }} -f $(pwd)/{{ release }}/Containerfile $(pwd)/{{ release }}/.

[doc('Remove image using podman')]
rmi:
  podman rmi {{ oci_name }}:{{ release }}

[doc('Remove container image using toolbx')]
toolbox-rmi:
  toolbox rmi {{ oci_name }}:{{ release }}

[doc('Create container using toolbx')]
create:
  toolbox create -c {{ container_name }} -i {{ oci_name }}:{{ release }}

create-local:
  toolbox create -c {{ container_name }} -i localhost/{{ oci_name }}:{{ release }}

[doc('Enter container using toolbx')]
enter:
  toolbox enter {{ container_name }}

[doc('Stop container using podman')]
stop:
  podman stop {{ container_name }}

[doc('Remove container using podman')]
rm:
  podman rm {{ container_name }}

[doc('Remove container using toolbx')]
toolbox-rm:
  toolbox rm {{ container_name}}

[doc('Stop and cleanup container as well as image')]
cleanup: stop rm toolbox-rmi

[doc('Push the image to the registry')]
push:
  aws ecr-public get-login-password --region {{ aws_region }} | podman login --username AWS --password-stdin {{ oci_registry }}/{{ oci_registry_alias }}
  podman tag {{ oci_repository_name }}/{{ oci_name }}:{{ release }} {{ oci_uri }}:{{ release }}
  podman push {{ oci_uri }}/{{ oci_name }}:{{ release }}

################################################################################
## Aliases
################################################################################

#alias m := make
#alias b := build
#alias c := create
#alias e := enter
#alias p := push
#alias cu := cleanup