# Login shell profile (sourced for login shells only)
# This should be minimal and non-interactive

# MOTD environment variables (used by motd-server/client)
export MOTD_CACHE_DIR=~/.motd
export MOTD_CACHE_MAX_FILES=200
export MOTD_GIPHY_API_KEY_FILE=~/.giphy-api
export MOTD_GIPHY_TAGS="the simpsons:g,futurama:g,bob's burgers:g,brooklyn 99:g,rupaul:r,30 rock:g,american dad:r,key peele:r,snl:r,golden girls:g,rick and morty:r,cat fails:g,maya rudolph:g,kristen wiig:g"
export MOTD_DOWNLOAD_INTERVAL=86400
export MOTD_CLEANUP_INTERVAL=1800

# Remote Docker daemon, if you use one:
# export DOCKER_HOST=tcp://<host>:2375
