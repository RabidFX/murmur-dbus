FROM debian:latest
MAINTAINER Silver QUETTIER <silver.quettier@gmail.com>

ENV version=1.2.13

# Install required packages
RUN apt-get -qq update && apt-get -qq install -y bzip2 && rm -rf /var/lib/apt/lists/*

# Copy SSL certificates (comment these lines if not used)
COPY placeholder.example.com.key /etc/placeholder.example.com.key
COPY placeholder.example.com.crt /etc/placeholder.example.com.crt

# Copy all configuration files and sets modes
COPY murmur.ini /etc/murmur.ini
COPY startMurmur.sh /etc/startMurmur.sh

# Sets modes, permissions...
RUN useradd -m murmur && chmod u+x /etc/startMurmur.sh 

# Retrieve latest pre-compiled Murmur
ADD https://github.com/mumble-voip/mumble/releases/download/${version}/murmur-static_x86-${version}.tar.bz2 /opt/

# Install Murmur
RUN bunzip2 /opt/murmur-static_x86-${version}.tar.bz2 
RUN tar -x -C /opt -f /opt/murmur-static_x86-${version}.tar && mv /opt/murmur-static_x86-${version} /opt/murmur

# Forward appropriate ports
EXPOSE 64738/tcp 64738/udp

# Run murmur
ENTRYPOINT ["/etc/startMurmur.sh"]
