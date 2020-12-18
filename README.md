# Mac OS 9 Docker Image

A docker image which uses QEMU to run Mac OS 9.

## Why?!@

Run a bridge file server (eg, FTP <-> AFP) to move files from your modern your classic macs.

Build a CI/CD Pipeline for your new Classic Mac app or game.

Horizontally scale your OS9's Personal Web Server on a k8 cluster.

A CodeWarrior OS9 VDI in the cloud.

Why not? <--

## Usage

### Prepare OS 9 Image

Build an OS9 image locally. If you're on a Mac you can grab a pre-compiled QEMU and follow the instructions to create a base OS9 install here https://www.emaculation.com/doku.php/ppc-osx-on-qemu-for-osx

Be sure to follow the guide and name the OS9 image `MacOS9.2.img`

You can find a Mac OS 9 CD in your desk drawer or on the Macintosh Garden https://macintoshgarden.org/apps/mac-os-922-universal

### Build this docker image

This image is not published, but you can build it easily:

```bash
# Grab the code
git clone https://github.com/erichelgeson/mac-os9-docker.git
cd mac-os9-docker

# Build the and tag the image
docker build -t mac-os9 .
```

### Start the container

Note:
 - Map a folder where your `MacOS9.2.img` is located to `/drives`
 - Map the ports you'd wish to forward.
    - If you want VNC remote management be sure to forward `5900`.

```bash
docker run --volume /path/to/image/:/drives -p 5900:5900 -p 548:548 mac-os9
```

### Connecting via VNC

VNC is used to connect to QEMU on port 5900. Use your favorite VNC client to connect.

Note - mouse tracking is somewhat off - consider doing all the OS 9 configuration on your local machine.

### Settings

A few settings can be customized by passing in env vars to the docker command.

```bash
   -e OS9_MEM=128 # Default 512
   -e OS9_DISK=MyDisk.img # MacOS9.2.img
   -e OS9_CDROM=Some.iso  # Mount an ISO in OS9
   -e OS9_CDROM_BOOT=d # Boot off the cdrom `d`
```

#### Example

Run OS9 with 1gb of RAM and an alternative disk image name.

```bash
docker run -e OS9_MEM=1024 -e OS9_DISK=MyDisk.img mac-os9:latest
```

## Performance

Some random performance numbers.

Rumpus 2.0 FTP Server - 10MB/sec

## Networking

Note that there are two layers of networking here. 
 - First we need to forward ports from the docker host to QMEU.
 - Additionally forward ports from QEMU to the MacOS9 machine.

Classic Mac via AFP -> Docker Host -> Container -> QEMU -> Mac OS 9

It may be possible to use a bridge interface for this. PR's welcome.

The ports for AFP(548), FTP(21), and Passive FTP(3000-3009) are mapped by default. See `start.sh` for customizations.

## Enhancements 

 - Easier to map other/more ports via env.
 - Conditionally map a CD-ROM and/or other drives.

## Additional links

https://wiki.qemu.org/Documentation/Platforms/PowerPC
