## Description
This repository holds what you need to build a Docker container containing a Mumble server (Murmur) with :

- a customizable configuration file
- a pre-configured system DBus conenction so you can poll it from other Docker containers
- SSL certification support

**For (obvious) reasons, I do not provide the pre-made image. You have to put your own SSL certificates in there :)**

## Prerequisites

You will need Git (obviously) and [Docker](https://www.docker.com/ "Docker homepage") on your system to use this.

## Build
Create a suitable directory on your server to store the Dockerfile and do the build process. It could be:
`mkdir -p /home/jean-michel-dockerfile/docker-builds/murmur`

Now go there and git pull my respository:
`git clone https://github.com/RabidFX/murmur-dbus.git`

After pulling, customize the build :

- Replace the **placeholder.example.com.crt** and **placeholder.example.com.key** by your own SSL files. If you don't want SSL, remove them.
- Edit the **Dockerfile** and change the SSL filenames to match yours. If you don't want SSL, comment-out the lines referencing them.
- Edit the **mumur.ini** configuration script with values of your choice. Keep in mind to adjust the SSL section according to your files, or absence thereof. 

To ensure DBus capabilities for your Mumble instance, you need to enrich your host's DBus configuration with the provided file:
`mv murmur.conf /etc/dbus-1/system.d/murmur.conf`

The only thing remaining is to build your custom image:
`docker build .`
This command will build your image. The last line written to the standard output will have this form:
`Successfully built e60d820ad77c`
You need to save this ID somewhere. It's your image ID, and you will need it in the rest of this instructions. (Here, mine was *e60d820ad77c*.)

## Launch
You just need to launch the built image as a new container with the proper parameters (change the image ID to match the one you got):
`docker run -d -v /var/run/dbus:/var/run/dbus -p 64738:64738 -p 64738:64738/udp e60d820ad77c`

## Getting SuperUser access
Once you have launched the container, you can get the SuperUser password (and start configuring your server) with the following command:
`docker logs $(docker ps | grep e60d820ad77c | awk '{print $1}') 2>&1 | grep Password`
Once again, you need to change the image ID in the command, and substitute *e60d820ad77c* for your own.
