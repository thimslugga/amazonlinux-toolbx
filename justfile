#!/usr/bin/env just --justfile

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

project_root      := justfile_directory()
project_name      := env_var('PROJECT_NAME')
#timestamp        := `date +%s`
#commit           := `git show -s --format=%h`

# just --set release 2023 <command>
release           := env_var('DEFAULT_RELEASE')

# just --set aws_region us-east-1 <command>
aws_region        := env_var('DEFAULT_AWS_REGION')

# public.ecr.aws/registry_alias/repository_name:image_tag
registry              := env_var('OCI_REGISTRY')
registry_alias        := env_var('OCI_REGISTRY_ALIAS')
repo_name             := env_var('OCI_REPOSITORY_NAME')
uri                   := env_var('OCI_URI')
image_name            := env_var('OCI_NAME')
cointainer_name       := "amazonlinux-" + release + "-toolbx"

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

# Evaluate and return all just variables
evaluate:
    @just --evaluate

# List available recipes
help:
    @just --justfile {{justfile()}} --list

# Just format
format:
    just --justfile {{justfile()}} --fmt

# Return system information
system-info:
    @echo "os: {{os()}}"
    @echo "family: {{os_family()}}"
    @echo "architecture: {{arch()}}"
    @echo "home directory: {{ home_directory() }}"

# Build image and create container
make: build create

# Build image
build:
  #!/usr/bin/env bash
  podman build -t amazonlinux-toolbox:{{ release }} -f $(pwd)/{{ release }}/Containerfile $(pwd)/{{ release }}/.

# Remove image using podman
rmi:
  podman rmi {{ image_name }}:{{ release }}

# Toolbox remove image
toolbox-rmi:
  toolbox rmi {{ image_name }}:{{ release }}

# Toolbox create container
create:
  toolbox create -c amazonlinux-{{ release }}-toolbx -i {{ image_name }}:{{ release }}

# Toolbox enter container
enter:
  toolbox enter amazonlinux-{{ release }}-toolbx

# Stop container
stop:
  podman stop amazonlinux-{{ release }}-toolbx

# Remove container
rm:
  podman rm amazonlinux-{{ release }}-toolbx

# Toolbox remove container
toolbox-rm:
  toolbox rm amazonlinux-{{ release }}-toolbx

# Stop and cleanup container as well as image
cleanup: stop rm toolbox-rmi

# Push the image to the registry
push:
  aws ecr-public get-login-password --region {{ aws_region }} | podman login --username AWS --password-stdin public.ecr.aws/l6o8q4o8
  podman tag thimslugga/amazonlinux-toolbox:{{ release }} {{ uri }}:{{ release }}
  podman push {{ uri }}/{{ image_name }}:{{ release }}

################################################################################
## Aliases
################################################################################

alias m := make
alias b := build
alias c := create
alias e := enter
alias p := push
alias cu := cleanup