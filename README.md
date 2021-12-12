# Codespaces VNC Image

Custom Codespaces Docker images configured for in-browser GUI app development.

## Using

Add the following to `.devcontainer/devcontainer.json` settings file.

```json
{
  "image": "ghcr.io/markpatterson27/codespaces-vnc-image:universal",
  "forwardPorts": [6080]
}
```

## Tags

| Tag | Description |
| --- | --- |
| `universal` | This image is built on top of the dev-container [GitHub Codespaces](https://github.com/microsoft/vscode-dev-containers/tree/main/containers/codespaces-linux). This is the same image used by default for Codespaces. |
| `python` | This image is built on top of the python dev-container [Python 3](https://github.com/microsoft/vscode-dev-containers/tree/main/containers/python-3). |

## References

Docker image settings are largely based on https://github.com/gitpod-io/workspace-images/tree/master/full-vnc
