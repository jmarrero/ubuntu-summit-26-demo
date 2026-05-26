# Ubuntu Summit 26 Demo

A demonstration of running containerized workloads on Ubuntu bootc using Quadlet.

## Overview

This demo consists of two container images:

1. **httpd container** - A simple Apache httpd server based on Ubuntu 26.04 serving a static webpage
2. **bootc host image** - An Ubuntu bootable container image that runs the httpd container as a systemd service using Quadlet

## Project Structure

- `Containerfile` - Builds the httpd application container
- `host/Containerfile` - Builds the bootc host image
- `host/usr/share/containers/systemd/httpd.container` - Quadlet unit file for the httpd service
- `index.html` - Static webpage served by httpd
- `.github/workflows/build.yml` - CI workflow that builds and pushes images to ghcr.io

## Building

Build the httpd container:

```
podman build -t ubuntu-summit-26-demo-httpd:latest .
```

Build the host image:

```
podman build -t ubuntu-summit-26-demo-host:latest ./host
```

## Running

Run the httpd container standalone:

```
podman run -p 8080:80 ubuntu-summit-26-demo-httpd:latest
```

Then visit http://localhost:8080

## Snap Support

The host image replaces the ostree symlinks (`/home`, `/root`, `/opt`, `/mnt`, `/srv`) with real directories backed by systemd bind mount units so that `snap-confine` can work on composefs. A `snap.mount` unit also bind-mounts `/var/lib/snapd/snap` onto `/snap`.

### Fixing home directory permissions after first boot

If the system was originally provisioned (e.g. via cloud-init) before switching to this image, the home directory may be owned by `root`. Fix it after the first boot:

```
sudo chown -R <user>:<user> /home/<user>
```

For example:

```
sudo chown -R ubuntu:ubuntu /home/ubuntu
```

This is only needed once. Fresh deployments with this image will have correct ownership from the start.
