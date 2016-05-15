#!/bin/bash

# Example usage:
#
# - Mode: Competitive
# - Port: 27016
# - Map: de_dust2
# - RCON password: myAwesomeRCONPassword
# - Server password: "" (no password)
# - Max number of players: 4 (2on2)
#
# > ./competitive.sh 27016 de_dust2 myAwesomeRCONPassword "" 4

PORT=${1:-27015}
DEFAULTMAP=${2}
RCON_PW=${3}
SV_PW=${4}
MAX_PLAYERS=${5:-10}

docker run -it \
    -e maxplayers=${MAX_PLAYERS} \
    -p ${PORT}:27015/udp \
    -p ${PORT}:27015 \
    christianharke/csgoserver \
        +map ${DEFAULTMAP} \
        +rcon_password ${RCON_PW} \
        +sv_password ${SV_PW} \
        +game_mode 0 \
        +game_type 1
