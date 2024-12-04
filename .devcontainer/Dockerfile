# Amazon Linux 2023 devcontainer

ARG VARIANT=2023

#FROM public.ecr.aws/amazonlinux/amazonlinux:${VARIANT}
FROM amazonlinux:${VARIANT}

#ARG INSTALL_ZSH="true"
#ARG UPGRADE_PACKAGES="false"

#ENV DOCKER_BUILDKIT=1

#ENV TZ=Etc/UTC LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Install needed packages and setup non-root user.
# Use a separate RUN statement to add your own dependencies.
# A user of "automatic" attempts to reuse an user ID if one already exists.
ARG USERNAME=vscode
ARG GROUPNAME=$USERNAME
ARG UID=1000
ARG GID=$UID

COPY extra-packages /

RUN dnf upgrade -y --refresh --releasever=latest && \
    dnf install -y --allowerasing $(<extra-packages) && \
    dnf groupinstall -y "Development Tools"; \
    groupadd -g "${GID}" "${GROUPNAME}" && \
    useradd -l -u "${UID}" -g "${GROUPNAME}" -md /home/"${USERNAME}" -s /bin/bash "${USERNAME}" && \
    usermod -aG wheel "${USERNAME}"; \
    touch /etc/sudoers.d/"${USERNAME}" && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/"${USERNAME}" && \
    chmod 0440 /etc/sudoers.d/"${USERNAME}"; \
    rm -rf /var/cache/dnf/* && dnf clean all;
    #mkdir -p /home/vscode/.ssh; \
    #chmod 0700 /home/vscode/.ssh; \

#RUN groupadd -g "${USER_GID}" "${GROUPNAME}" \
#    && useradd -l -u "${USER_UID}" -g "${GROUPNAME}" -md /home/"${USERNAME}" -s /bin/bash "${USERNAME}" \
#    && usermod -aG wheel "${USERNAME}"; \
#    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/"${USERNAME}" \
#    && chmod 0440 /etc/sudoers.d/"${USERNAME}";

#VOLUME [ "/var/lib/docker" ]

#ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]

#CMD [ "sleep", "infinity" ]