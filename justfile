#!/usr/bin/env just --justfile
# vim: set ft=make :

# Usage: just --set release 2023 <command>

# justfile requires - https://github.com/casey/just
#
# - https://github.com/casey/just/discussions
# - https://github.com/casey/just#settings
# - https://just.systems/man/en/
# - https://cheatography.com/linux-china/cheat-sheets/justfile Cheatsheet
# - https://docs.rs/regex/1.5.4/regex/#syntax Regexps

## Settings

#export PATH := justfile_directory() + "/env/bin:" + env_var("PATH")

#set default-recipe := default
#set default-recipe := help
#set default-recipe := _list
# Load environment variables from `.env` file.
set dotenv-load := true
set export := false
#set positional-arguments := true
#set allow-unknown-flags := false
#set allow-unknown-variables := false
#set allow-unknown-recipes := false
#set allow-duplicate-variables := false
#set allow-duplicate-recipes := false
#set ignore-errors := false
set shell := ["bash", "-c"]
#set shell := ["bash", "-euo", "pipefail", "-c"]

## Variables

timestamp := `date +%s`
#project_name := env_var('PROJECT_NAME')
#project_version := env_var('PROJECT_VERSION')
#semver := env_var('PROJECT_VERSION')
#commit := `git show -s --format=%h`
#project_version := semver + "+" + commit
#work_dir := "build"

release := "2023"
region := "us-east-1"
registry := "public.ecr.aws/l6o8q4o8/thimslugga"

## Recipes

# Default recipe (equivalent to 'all' in Makefile)

#default:
#  @just --summary

#@default:
#	 @just --list --justfile {{ justfile() }}

# Lists the tasks and variables in the justfile
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

help:
	@just --list

# Return system information (e.g. os, architecture, etc)
alias sysinfo := system-info
system-info:
	@echo "architecture: {{arch()}}"
	@echo "os: {{os()}}"
	@echo "os family: {{os_family()}}"

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
