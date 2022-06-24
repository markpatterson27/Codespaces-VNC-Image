# Codespaces VNC Image

Custom Codespaces Docker images configured for in-browser GUI app development. The images use [openbox](http://openbox.org/wiki/Main_Page) and [x11vnc](https://github.com/LibVNC/x11vnc) for a lightweight VNC desktop and [noVNC](https://novnc.com/info.html) for a browser based VNC viewer hosted inside the Codespace.

## Using

Add the following to `.devcontainer/devcontainer.json` settings file.

```json
{
    "image": "ghcr.io/markpatterson27/codespaces-vnc-image:universal",
    "forwardPorts": [6080],
    "portsAttributes": {
        "6080": {
            "label": "noVNC Viewer",
            "onAutoForward": "openBrowser"
        }
    }
}
```

When the Codespace starts the noVNC Viewer port will be automatically forwarded. Switch to the `ports` tab to get the reverse proxy URL or click the 'Open in Broswer' icon.

![screenshot showing port forwarded through reverse proxy](https://user-images.githubusercontent.com/35724907/173828402-e76f0b3e-3e11-4f96-9d19-2024f9a3944e.png)

## Tags

| Tag | Description |
| --- | --- |
| `universal` | This image is built on top of the dev-container [GitHub Codespaces](https://github.com/microsoft/vscode-dev-containers/tree/main/containers/codespaces-linux). This is the same image used by default for Codespaces. |

## References

Docker image settings are largely based on https://github.com/gitpod-io/workspace-images/tree/master/full-vnc

## Alternatives

There is a [VNC option for devcontainers](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/desktop-lite.md) which can be used with Codespaces.
