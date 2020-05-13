FROM cm2network/steamcmd:root

ENV STEAMAPPID 740
ENV STEAMAPPDIR /home/steam/csgo-dedicated

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.20.1-1.1 \
		ca-certificates=20190110 \
	&& mkdir -p ${STEAMAPPDIR}/csgo \
	&& cd ${STEAMAPPDIR} \
	&& wget https://raw.githubusercontent.com/CM2Walki/CSGO/master/etc/entry.sh \
	&& chmod 755 ${STEAMAPPDIR}/entry.sh \
	&& cd ${STEAMAPPDIR}/csgo \
	&& { \
			echo '@ShutdownOnFailedCommand 1'; \
			echo '@NoPromptForPassword 1'; \
			echo 'login anonymous'; \
			echo 'force_install_dir ${STEAMAPPDIR}'; \
			echo 'app_update ${STEAMAPPID}'; \
			echo 'quit'; \
		} > ${STEAMAPPDIR}/csgo_update.txt \
	&& wget -qO- https://raw.githubusercontent.com/CM2Walki/CSGO/master/etc/cfg.tar.gz | tar xvzf - \
	&& sed -i -E "s/hostname\s+\".+\"/hostname \"| SEKA-GAMING |\"/" cfg/server.cfg \
	&& wget -qO- https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar xvzf - \
	&& wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6454-linux.tar.gz | tar xvzf - \
	&& wget -qO tmp.zip https://github.com/splewis/csgo-practice-mode/releases/download/1.3.3/practicemode_1.3.3.zip | unzip tmp.zip \
	&& wget -qO tmp.zip https://ci.splewis.net/job/csgo-retakes/lastSuccessfulBuild/artifact/builds/retakes-release/retakes-165.zip | unzip tmp.zip \
	&& wget -qO tmp.zip https://github.com/allowyoba/csgo/raw/master/cfg.zip | unzip tmp.zip \
	&& chown -R steam:steam ${STEAMAPPDIR} \
	&& apt-get remove --purge -y \
		wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

ENV SRCDS_FPSMAX=300 \
	SRCDS_TICKRATE=128 \
	SRCDS_PORT=27015 \
	SRCDS_TV_PORT=27020 \
	SRCDS_CLIENT_PORT=27005 \
	SRCDS_MAXPLAYERS=12 \
	SRCDS_TOKEN=temp \
	SRCDS_RCONPW="temp" \
	SRCDS_PW="temp" \
	SRCDS_STARTMAP="de_dust2" \
	SRCDS_REGION=3 \
	SRCDS_MAPGROUP="mg_active" \
	SRCDS_GAMETYPE=0 \
	SRCDS_GAMEMODE=0

USER steam

WORKDIR $STEAMAPPDIR

VOLUME $STEAMAPPDIR

ENTRYPOINT ${STEAMAPPDIR}/entry.sh

# Expose ports
EXPOSE ${SRCDS_PORT}/tcp ${SRCDS_PORT}/udp ${SRCDS_TV_PORT}/udp
