#!/bin/bash

# Example usage:
#
# - Mode: Casual
# - Port: 27015
# - Map: de_dust2
# - RCON password: myAwesomePassword
# - Max number of players: 10 (5on5)
#
# > ./casual.sh 27015 de_dust2 myAwesomePassword 10

PORT=${1:-27015}
DEFAULTMAP=${2}
RCON_PW=${3}
MAX_PLAYERS=${4:-16}

docker run -it \
    -e maxplayers=${MAX_PLAYERS} \
    -p ${PORT}:27015/udp \
    -p ${PORT}:27015 \
    christianharke/csgoserver \
        +map ${DEFAULTMAP} \
        +rcon_password ${RCON_PW} \
        +game_mode 0 \
        +game_type 0
