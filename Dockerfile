FROM debian:latest
MAINTAINER help@eth0.bid

ARG STEAM_LOGIN
ARG STEAM_PASS
ARG STEAM_GUARD

#killing floor server preferences
ENV KF_LOGIN=admin \
	KF_PASS=Malkuth793 \
	KF_MAIL=help@eth0.bid
	KF_GAMELEN=2 \
	KF_DIFFICULTY=2.0 \
	KF_SERVER_NAME=KillingForce
	KF_CONFIG=/kf/server/System/killingfloor-server.ini \
	TERM=xterm

WORKDIR /
RUN apt-get update && \
	apt-get install -y lib32gcc1 curl lib32stdc++6 && \
	rm -rf /var/lib/apt/lists/* && \
	mkdir -p /kf/server

WORKDIR /kf
COPY setup.sh kf.ini /kf/
RUN curl -O https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
	tar -xf steamcmd_linux.tar.gz && \
	rm -f steamcmd_linux.tar.gz && \
	chmod +x setup.sh steamcmd.sh

#i split this command in case of login failure, to just redo this one
RUN ./steamcmd.sh +login ${STEAM_LOGIN} ${STEAM_PASS} ${STEAN_GUARD} +force_install_dir /kf/server +app_update 215360 validate +quit

WORKDIR /kf/server/System
RUN cp -v /kf/kf.ini /kf/server/System/Default.ini && \
	curl -O http://www.goodmods.com/Killing-Floor/KFAntiBlocker_1.1/MutKFAntiBlocker.u && \
	curl -O http://www.goodmods.com/Killing-Floor/KFAntiBlocker_1.1/MutKFAntiBlocker.ucl && \
	curl -O http://www.goodmods.com/Killing-Floor/KFMapVoteV2/KFMapVoteV2.int && \
	curl -O http://www.goodmods.com/Killing-Floor/KFMapVoteV2/KFMapVoteV2.u && \
	

EXPOSE 7707/udp \
	7708/udp \
	7717/udp \
	28852 \
	28852/udp \
	8075 \
	20560/udp

ENTRYPOINT ["/kf/setup.sh"]
