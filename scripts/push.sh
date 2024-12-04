#!/bin/bash
# vi: sw=2 ts=4
# shellcheck disable=SC1101
set -e

export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock

# Set release version
RELEASE="${RELASE:-2023}"
AWS_REGION="${AWS_REGION:-us-east-1}"
#AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}"

# [account].dkr.ecr.[region].amazonaws.com/[repository_name]
REGISTRY="${REGISTRY:-public.ecr.aws}"
REPO="${REPO:-l6o8q4o8}"

function die() {
  echo "$@" >&2
  exit 1
}

function enable_user_linger() {
  local username="${1:-$USER}"
  loginctl enable-linger "${username}"
}

function enable_user_podman() {
  systemctl --user daemon-reload
  systemctl --user enable --now podman.socket
}

function make_container_dirs() {
  # /etc/containers/systemd and /usr/share/containers/systemd
  mkdir -p "${HOME}/.config/systemd/user"
  mkdir -p "${HOME}/.config/containers/systemd"
}

function quadlet_user_dryrun() {
  /usr/libexec/podman/quadlet --user --dryrun
}

function build() {
  # work around non-working pkexec
  local fake_pkexec
  fake_pkexec="$(mktemp)"
  cat >"$fake_pkexec" <<-'EOF'
	#!/bin/sh
	exec su -c "\$*"
	EOF

  buildah copy --chmod 755 "$build_cntr" "$fake_pkexec" /usr/bin/pkexec
}

case "${1}" in
login)
  set +o history
  aws --region "${AWS_REGION}" ecr-public get-login-password | podman login --username AWS --password-stdin "${REGISTRY}"/"${REPO}"
  #podman login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
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
  #podman push $TOOLBOX_IMAGE
  ;;
*)
  echo "Usage: $0 {login|build|push}"
  exit 1
  ;;
esac
