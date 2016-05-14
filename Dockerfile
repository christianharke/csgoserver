FROM christianharke/steamcmd:latest
MAINTAINER Christian Harke <ch.harke@gmail.com>

# Server settings
ENV installdir=/home/${user}/csgoserver \
    appdir=${installdir}/csgo \
    appid=740 \
    log=${log:-on} \
    hostname=${hostname:-"CS:GO Server"} \
    port=${port:-27015} \
    sourcetvport=${sourcetvport:-27020} \
    tickrate=${tickrate:-128} \
    game_type=${game_type:-0} \
    game_mode=${game_mode:-0} \
    mapgroup=${mapgroup:-mg_active} \
    maxplayers=${maxplayers:-} \
    limitteams=${limitteams:-1} \
    autoteambalance=${autoteambalance:-0}

# Install application
RUN ./steamcmd.sh \
    +login anonymous \
    +force_install_dir ${installdir} \
    +app_update ${appid} validate \
    +quit

# Set working directory
WORKDIR ${appdir}

# Install metamod & sourcemod
# - http://www.metamodsource.net/
# - http://www.sourcemod.net/
RUN wget http://mirror.pointysoftware.net/alliedmodders/mmsource-1.10.6-linux.tar.gz && \
    tar -xvzf mmsource-1.10.6-linux.tar.gz && \
    wget http://mirror.pointysoftware.net/alliedmodders/sourcemod-1.7.2-linux.tar.gz && \
    tar -xvzf sourcemod-1.7.2-linux.tar.gz

# autoexec.cfg - executed once at startup
RUN echo hostname "${hostname}" >> cfg/autoexec.cfg && \
    echo log ${log} >> cfg/autoexec.cfg && \
    echo exec banned_user.cfg >> cfg/autoexec.cfg && \
    echo exec banned_ip.cfg >> cfg/autoexec.cfg && \
    echo game_mode ${game_mode} >> cfg/autoexec.cfg && \
    echo game_type ${game_type} >> cfg/autoexec.cfg && \
    echo mapgroup ${mapgroup} >> cfg/autoexec.cfg &&

# server.cfg - executed at every map change
RUN echo mp_autoteambalance ${autoteambalance} >> cfg/server.cfg && \
    echo mp_limitteams ${limitteams} >> cfg/server.cfg && \
    echo writeid >> cfg/server.cfg && \
    echo writeip >> cfg/server.cfg

# Prevent some error notifications
RUN touch cfg/gamemode_casual_server.cfg && \
    cp gamerulescvars.txt.example gamerulescvars.txt && \
    sed -i 's/Rank/\/\/Rank/g' botprofile.db

# https://developer.valvesoftware.com/wiki/Command_Line_Options#Source_Dedicated_Server
ENTRYPOINT ["../srcds_run", "-autoupdate", "-console", "-game", "csgo", "-maxplayers_override", "${maxplayers}", "-port", "${port}", "-sourcetvport", "${sourcetvport}", "-tickrate", "${tickrate}", "-usercon"]
