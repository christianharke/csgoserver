#!/bin/bash

DEFAULTMAP=${1}
RCON_PW=${2}

docker run \
    -it \
    -p 27015:27015/udp \
    -p 27015:27015 \
    -p 27020:27020 \
    christianharke/csgoserver \
    +map ${DEFAULTMAP} \
    +rcon_password ${RCON_PW}
