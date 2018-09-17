# bash script

echo 'This script will guide you set up your auto anime updater'
echo 'If you need to operate anime updater, please use "./anime-updater.sh"'
echo 'Make sure you are in the ./anime-updater-builder folder'
ANIME_UPDATER_DIR=$(bash -c 'cd ../; echo $PWD')


if ! [ -x "$(command -v docker-compose)" ]; then
    echo 'Error: docker-compose is not installed.' >&2
    exit 1
fi

DL_DIR=${HOME}/anime-updater
read -p "What directory downloaded files should go to? [default=${DL_DIR}] " INPUT;
if ! [[ "$INPUT" == "" ]]; then
    DL_DIR=${INPUT};
fi

HTTP_PORT="2015"
read -p "Which port http server should listen to? [default=${HTTP_PORT}] " INPUT
if ! [[ "$INPUT" == "" ]]; then
    HTTP_PORT=${INPUT}
fi
echo "---"
tee ./anime-updater/Caddyfile <<EOF
:80 {
    gzip
    root /mnt
    browse
    proxy /AnimeUpdate http://slack:8027
    log stdout
    errors stdout
}
EOF
echo "---"
echo "Here is your ./anime-updater/Caddyfile look like"
echo "Please change it now if necessary"
echo "P.S. No need to modify the :80 part. Script will redirect port ${HTTP_PORT} using docker"
echo ""
read -p "Script paused. [Enter] to continue. " INPUT


read -p "Expose VNC port in selenium? [default=5900, 0 for not open] " INPUT

if [[ "$INPUT" == "" ]]; then
    SELENIUM_PORTS_LINE1='    ports:'
    SELENIUM_PORTS_LINE2='      - "5900:5900"'
    echo "VNC Password is 'secret'"
elif [[ "$INPUT" == "0" ]]; then
    SELENIUM_PORTS_LINE1=""
    SELENIUM_PORTS_LINE2=""
else
    SELENIUM_PORTS_LINE1='    ports:'
    SELENIUM_PORTS_LINE2="      - '$INPUT:5900'"
    echo "VNC Password is 'secret'"
fi

echo "---"
tee docker-compose.yml <<EOF
version: "2"
services:
  anime-updater:
    build: ./anime-updater
    ports:
      - "${HTTP_PORT}:80"
    volumes:
      - "${ANIME_UPDATER_DIR}:/anime-updater"
      - "${DL_DIR}:/mnt"
    container_name: anime-updater
  db:
    image: mongo
    container_name: anime-updater-db

  selenium:
    image: selenium/standalone-firefox-debug:3.14.0-europium
    volumes:
      - "${DL_DIR}:/mnt"
      - "/dev/shm:/dev/shm"
    container_name: anime-updater-selenium
${SELENIUM_PORTS_LINE1}
${SELENIUM_PORTS_LINE2}

  slack:
    image: hare1039/anime-updater-bot
    volumes:
      - "${ANIME_UPDATER_DIR}/bot-server:/bot-server"
    container_name: anime-updater-slack-server
EOF
echo "---"

echo "Here is your ./docker-compose.yml look like"
echo "Please change it now if necessary"
echo ""
PUBLIC_HOST="http://$(curl ipinfo.io/ip 2>/dev/null):${HTTP_PORT}";
read -p "Script paused. [Enter] to continue. " INPUT


echo "You finish the basic setup. Now configure slack notification part"
read -p "Please set your URL base. [default=${PUBLIC_HOST}] " INPUT
if ! [[ "$INPUT" == "" ]]; then
    PUBLIC_HOST=$INPUT;
fi

echo "Goto https://api.slack.com/slack-apps#creating_apps to create new an APP"
read -p "client id = " CLIENT_ID;
read -p "client secret = " CLIENT_SECRET;
read -p "Verification Token = " TOKEN;

echo "Goto 'OAuth & Permission' on left side panel, and add Redirect URL"
echo "Redirect URL [default=${PUBLIC_HOST}/AnimeUpdate/auth/redirect] "

tee ${ANIME_UPDATER_DIR}/bot-server/info.json <<EOF
{
    "client-id":     "$CLIENT_ID",
    "client-secret": "$CLIENT_SECRET",
    "token":         "$TOKEN",
    "redirect-url":  "${PUBLIC_HOST}/AnimeUpdate/auth/redirect",
    "mongodb-host":  "db:27017"
}
EOF

echo "Here is your ANIME_UPDATER/bot-server/info.json look like"
echo "Please change it now if necessary"
echo ""
read -p "Script paused. [Enter] to continue. " INPUT


echo "Goto incoming webhooks on left side panel, and then activate webhook"
echo "Then get a webhook url for all notification";
read -p "Slack webhook url = " WEBHOOK_URL


echo "---"
tee ${ANIME_UPDATER_DIR}/config.sh <<EOF
slack-send-raw()
{
    curl -X POST                             \
         -H 'Content-type: application/json' \
         --data "\$*"                         \
         ${WEBHOOK_URL}
}

pinkie-send()
{
    curl -X POST        \
     -F "title=\$1"       \
     -F "data=\$2"        \
     http://slack/AnimeUpdate/eat-my-update;
}

export trace_file=\$SCRIPTPATH/rate.txt;
export line_buf_file=/dev/null
export LC_ALL=zh_TW.UTF-8;
export ERROR_CODE=254;
export TIMEOUT="timeout --signal SIGINT 6h";

# message part
export BASE_URL='${PUBLIC_HOST}';
export IGNORE_MSG=('\n');
export IGNORE_MSG_PATTERN=('.*伊莉.*txt.*'); # prevent any message that match these pattern to be post to slack

# gdrivedl setup
export GDRIVEDL_PY="/gdrivedl/dl.py";
export PYTHON3='python3';
export GDRIVEDL_PY_SELENIUM_HOST='http://selenium:4444/wd/hub';

EOF
echo "---"
echo "Here is your ANIME_UPDATER/config.sh look like"
echo "Please change it now if necessary"
echo ""
read -p "Script paused. [Enter] to continue. " INPUT

echo "Next, add correct permission on 'Scope', which is also on 'OAuth & Permission' page"
echo "Add: chat:write:bot, im:read, bot, commands"
echo "Finally, generate a slack button at https://api.slack.com/docs/slack-button"
echo "The adding button is close to middle of the page"
read -p "Paste your button link here: " HTML_BUTTON

tee ${ANIME_UPDATER_DIR}/bot-server/web/add_to_slack.html <<EOF
<!DOCTYPE html>
<html>
    <head>
      <title>add_to_slack_button</title>
    </head>
    <body>
      ${HTML_BUTTON}
    </body>
</html>
EOF

echo 3 > ${ANIME_UPDATER_DIR}/rate.txt;

echo "Wait 2-3 minutes and goto ${PUBLIC_HOST}/AnimeUpdate/auth/add_to_slack.html"
echo "docker-compose building & logging start. [Ctrl-C] to leave logging"

docker-compose up --build -d

docker-compose logs -f
