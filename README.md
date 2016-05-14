# Counter-Strike: Global Offensive Dedicated Server

CS:GO Dedicated Server containing MetaMod and SourceMod, running in a Docker container.

## How to get up and running

> Note that the port always have to be given, otherwise it won't be accessible from outside. For further information refer to the [Docker user guide](https://docs.docker.com/v1.8/userguide/dockerlinks/).

### Minimal setup

```
docker run -it \
    -p 27015:27015/udp \
    christianharke/csgoserver
```

### With RCON enabled

```
docker run -it \
    -p 27015:27015/udp \
    -p 27015:27015 \
    christianharke/csgoserver \
    +rcon_password [RCON password]
```

> Note that if the gameserver's port (UDP => `27015/udp` here) is changed, the RCON port (TCP => `27015` here) changes as well.

### With Source-TV enabled

```
docker run -it \
    -p 27015:27015/udp \
    -p 27020:27020 \
    christianharke/csgoserver \
    +tv_enable 1
```

> For further information refer to the [Source-TV section of the Valve Wiki](https://developer.valvesoftware.com/wiki/SourceTV)

## Configuration

### Environment Variables

Add environment variables to the run command, e. g.:

```
docker run -it \
    -e hostname="My Awesome Gameserver" \
    -p 27015:27015/udp \
    christianharke/csgoserver
```

Variable | Value | Default | Description
-------- | ----- | ------- | -----------
log | <code>[on&#124;off]</code> | `on` |
hostname | `[hostname]` | `CS:GO Server` |
port | `[# UDP port game]` | `27015` |
sourcetvport | `[# UDP port game]` | `27020` |
tickrate | `[# rate of getting player position]` | `128` |
game_type | <code>[0&#124;1]</code> | `0` | see below table
game_mode | <code>[0&#124;1]</code> | `0` | see below table
mapgroup | `[mapgroup]` | `mg_active` | Change the map group
maxplayers | `[# players]` | - | Change the maximum number of players allowed on this server
limitteams | `[#]` | `1` | Maximum number of allowed disbalance
autoteambalance | <code>[0&#124;1]</code> | `1` | Automatically balance team by players strength

```
Mode                   game_mode    game_type
Classic Casual             0            0
Classic Competitive        0            1
Arms Race                  1            0
Demolition                 1            1
Deathmatch                 2            1
```

### Console Commands (Cvars)

Additionally, you can add commands to be executed directly after start, e. g.:

```
docker run -it \
    -p 27015:27015/udp \
    christianharke/csgoserver \
    +map de_dust2
```

> For details, please refer to the official documentation: [Valve Console Command List](https://developer.valvesoftware.com/wiki/Console_commands).
