FROM openjdk:8-jre-slim

RUN apt-get update \
  && apt-get install -y \
    curl \
    apt-transport-https \
    gnupg \
  && echo 'deb     http://lsc-project.org/debian lsc main' >> /etc/apt/sources.list.d/lsc-project.list \
  && echo 'deb-src http://lsc-project.org/debian lsc main' >> /etc/apt/sources.list.d/lsc-project.list \
  && curl -sL http://ltb-project.org/wiki/lib/RPM-GPG-KEY-LTB-project | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=non-empty apt-key add - \
  && apt-get update && apt-get install -y \
    lsc \
  && apt-get remove --purge -y \
    gnupg \
    apt-transport-https

RUN mkdir /home/lsc && chown -R lsc.lsc /home/lsc

USER lsc

WORKDIR /home/lsc
