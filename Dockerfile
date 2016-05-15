FROM christianharke/steamcmd:latest
MAINTAINER Christian Harke <ch.harke@gmail.com>

# Server settings
ENV appdir=/home/${user}/csgoserver \
    appid=740 \
    tickrate=${tickrate:-128} \
    maxplayers=${maxplayers:-16}

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
        wget http://mirror.pointysoftware.net/alliedmodders/mmsource-1.10.6-linux.tar.gz; \
        tar -xvzf mmsource-1.10.6-linux.tar.gz; \
        wget http://mirror.pointysoftware.net/alliedmodders/sourcemod-1.7.2-linux.tar.gz; \
        tar -xvzf sourcemod-1.7.2-linux.tar.gz; \

        # Prevent some error notifications
        touch cfg/gamemode_casual_server.cfg; \
        cp gamerulescvars.txt.example gamerulescvars.txt; \
        sed -i 's/Rank/\/\/Rank/g' botprofile.db; \
    }

# https://developer.valvesoftware.com/wiki/Command_Line_Options#Source_Dedicated_Server
ENTRYPOINT ["./srcds_run", "-autoupdate", "-console", "-game csgo", "-maxplayers_override ${maxplayers}", "-tickrate ${tickrate}", "-usercon"]
