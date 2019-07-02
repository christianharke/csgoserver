FROM christianharke/steamcmd:latest
LABEL maintainer="Christian Harke <ch.harke@gmail.com>"

# Server settings
ENV appdir=/home/${user}/csgoserver \
    appid=740

# Install application
RUN ./steamcmd.sh \
    +login anonymous \
    +force_install_dir ${appdir} \
    +app_update ${appid} validate \
    +quit

# Set working directory
WORKDIR ${appdir}

COPY cfg/*.cfg ./csgo/cfg/

RUN { \
        cd csgo; \

        # Install metamod & sourcemod
        # - http://www.metamodsource.net/
        # - http://www.sourcemod.net/
        wget https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git970-linux.tar.gz; \
        tar -xvzf mmsource-1.10.7-git970-linux.tar.gz; \
        wget https://sm.alliedmods.net/smdrop/1.9/sourcemod-1.9.0-git6281-linux.tar.gz; \
        tar -xvzf sourcemod-1.9.0-git6281-linux.tar.gz; \

        # Prevent some error notifications
        touch cfg/gamemode_casual_server.cfg; \
        cp gamerulescvars.txt.example gamerulescvars.txt; \
        sed -i 's/Rank/\/\/Rank/g' botprofile.db; \
    }

ENV maxplayers=${maxplayers} \
    tickrate=${tickrate:-128}

# Expose ports
# - 27015/udp: CSGO
# - 27015/tcp: rcon
# - 27020: Source-TV
EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27020

# https://developer.valvesoftware.com/wiki/Command_Line_Options#Source_Dedicated_Server
ENTRYPOINT ./srcds_run -autoupdate -console -game csgo -maxplayers_override ${maxplayers} -tickrate ${tickrate} -usercon
