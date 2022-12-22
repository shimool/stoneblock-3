# syntax=docker/dockerfile:1

FROM openjdk:17-jdk-buster

LABEL version="1.5.0"

RUN apt-get update && apt-get install -y curl dos2unix && \
 addgroup minecraft && \
 adduser --home /data --ingroup minecraft --disabled-password minecraft

COPY launch.sh /launch.sh
RUN dos2unix /launch.sh
RUN chmod +x /launch.sh

COPY serverinstall_100_2308 /serverinstall_100_2308
COPY stoneblock-3.png /stoneblock-3.png
RUN chmod +x /serverinstall_100_2308

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

CMD ["/launch.sh"]

ENV MOTD "A Minecraft (FTB Presents Stoneblock 3 1.5.0) Server Powered by Docker"
ENV LEVEL world
ENV LEVELTYPE ""
ENV JVM_OPTS "-Xms2048m -Xmx6144m"
