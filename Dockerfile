FROM jetbrains/teamcity-agent:latest
MAINTAINER Jan Rudolph (rudolph@biochem.mpg.de)

# base on https://github.com/mono/docker/5.0.0.100/Dockerfile
ENV MONO_VERSION 5.0.0.100

RUN apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

RUN echo "deb http://download.mono-project.com/repo/debian jessie/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official.list \
  && apt-get update \
  && apt-get install -y binutils mono-devel ca-certificates-mono fsharp mono-vbnc nuget referenceassemblies-pcl \
  && rm -rf /var/lib/apt/lists/* /tmp/*

# msbuild failed due to /etc/localtime not working.
# solution from https://stackoverflow.com/questions/40234847/docker-timezone-in-ubuntu-16-04-image
# and https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes/
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
