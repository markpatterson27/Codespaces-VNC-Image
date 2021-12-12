# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.209.3/containers/python-3/.devcontainer/base.Dockerfile

# [Choice] Python version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.10, 3.9, 3.8, 3.7, 3.6, 3-bullseye, 3.10-bullseye, 3.9-bullseye, 3.8-bullseye, 3.7-bullseye, 3.6-bullseye, 3-buster, 3.10-buster, 3.9-buster, 3.8-buster, 3.7-buster, 3.6-buster
ARG VARIANT="3.10-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

USER root

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install xvfb x11vnc openbox \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV WINDOW_MANAGER="openbox"

# Change the default number of virtual desktops from 4 to 1 (footgun)
RUN sed -ri "s/<number>4<\/number>/<number>1<\/number>/" /etc/xdg/openbox/rc.xml

# Install novnc
# RUN git clone --depth 1 https://github.com/novnc/noVNC.git /opt/novnc \
#     && git clone --depth 1 https://github.com/novnc/websockify /opt/novnc/utils/websockify
RUN mkdir -p /opt/novnc \
    && curl -sSL https://github.com/novnc/noVNC/archive/v1.3.0.tar.gz -o /tmp/novnc-install.tar.gz \
    && tar -zxf /tmp/novnc-install.tar.gz --strip-components=1 -C /opt/novnc \
    && rm -f /tmp/novnc-install.tar.gz \
    && mkdir -p /opt/novnc/utils/websockify \
    && curl -sSL https://github.com/novnc/websockify/archive/v0.10.0.tar.gz -o /tmp/websockify-install.tar.gz \
    && tar -zxf /tmp/websockify-install.tar.gz --strip-components=1 -C /opt/novnc/utils/websockify \
    && rm -f /tmp/websockify-install.tar.gz \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends python3-minimal python3-numpy \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
COPY novnc-index.html /opt/novnc/index.html

# Add VNC startup script
COPY start-vnc-session.sh /usr/bin/
RUN chmod +x /usr/bin/start-vnc-session.sh

USER vscode

# This is a bit of a hack. At the moment we have no means of starting background
# tasks from a Dockerfile. This workaround checks, on each bashrc eval, if the X
# server is running on screen 0, and if not starts Xvfb, x11vnc and novnc.
RUN echo "export DISPLAY=:0" >> ~/.bashrc \
    && echo "[ ! -e /tmp/.X0-lock ] && (/usr/bin/start-vnc-session.sh &> /tmp/display-\${DISPLAY}.log)" >> ~/.bashrc
