# Counter-Strike: Global Offensive Dedicated Server

CS:GO Dedicated Server containing MetaMod and SourceMod, running in a Docker container.

## How to get up and running

> Note that the port always has to be given, otherwise it won't be accessible from outside. For further information refer to the [Docker user guide](https://docs.docker.com/v1.8/userguide/dockerlinks/).

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

### Environment variables

#### Available variables

Variable | Value | Default
-------- | ----- | -------
maxplayers | `[# of players]` | -
tickrate | `[# ticks per second]` | `128`

#### Example

##### Change maximum number of players

```
docker run -it \
    -e maxplayers=4 \
    -p 27015:27015/udp \
    christianharke/csgoserver
```

### Console commands (Cvars)

#### Predefined defaults

Variable | Value | Default
-------- | ----- | -------
log | <code>[on&#124;off]</code> | `on`

Additionally, you can add commands to be executed directly after start.

> For more details refer to this [inofficial but rather complete list of CS:GO Console Commands](http://www.tobyscs.com/csgo-console-commands/)

#### Examples

##### Set first map after startup

```
docker run -it \
    -p 27015:27015/udp \
    christianharke/csgoserver \
    +map de_dust2
```

##### Set game mode to Deathmatch

```
docker run -it \
    -p 27015:27015/udp \
    christianharke/csgoserver \
    +game_mode 2 \
    +game_type 1
```

> Available modes/types:
> ```
Mode                   game_mode    game_type
Classic Casual             0            0
Classic Competitive        0            1
Arms Race                  1            0
Demolition                 1            1
Deathmatch                 2            1
```
