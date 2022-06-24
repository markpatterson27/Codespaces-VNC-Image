# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.209.5/containers/codespaces-linux/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/universal:2-focal

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

USER codespace

# This is a bit of a hack. At the moment we have no means of starting background
# tasks from a Dockerfile. This workaround checks, on each bashrc eval, if the X
# server is running on screen 0, and if not starts Xvfb, x11vnc and novnc.
RUN echo "export DISPLAY=:0" >> ~/.bashrc \
    && echo "[ ! -e /tmp/.X0-lock ] && (/usr/bin/start-vnc-session.sh &> /tmp/display-\${DISPLAY}.log)" >> ~/.bashrc
