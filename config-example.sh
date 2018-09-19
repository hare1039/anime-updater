# this file is to setup varibles

# setup send message function
# - slack-send-raw
# - pinkie-send

source ${HOME}/.bash_profile;

# or you can write the function here.
# e.g.
#slack-send-raw()
#{
#    curl -X POST                             \
#         -H 'Content-type: application/json' \
#         --data "$*"                         \
#         https://hooks.slack.com/services/X1/X2/XX3;
#}
#
#pinkie-send()
#{
#    curl -X POST        \
#    -F "title=$1"    \
#    -F "data=$2"     \
#    https://YOUR_URL_OF_RECEIVING_UPDATE/eat-my-update;
#}

export trace_file=$SCRIPTPATH/rate.txt;
export line_buf_file=${HOME}/Documents/git_projects/line-buff/message.txt; # this file is for error handling
export LC_ALL=zh_TW.UTF-8;
export ERROR_CODE=254;
export TIMEOUT="timeout --signal SIGINT 6h";

# message part
export BASE_URL='https://hare1039.nctu.me/sysvol';
export IGNORE_MSG=('\n');
# prevent any message that match these pattern to be post to slack
export IGNORE_MSG_PATTERN=('.*伊莉.*txt.*');
# Remove prefix that should not belong to url.
# e.g. Downloaded '/mnt/NAS/video/magic/01.mp4'
# but my url should look like http://server.com/video/magic/01.mp4
# => RM_LOCALFS_PREFIX that should remove is '/mnt/NAS'
export RM_LOCALFS_PREFIX='/mnt/NAS'

# gdrivedl setup
export GDRIVEDL_PY="${HOME}/Documents/git_projects/gdrivedl/dl.py";
export PYTHON3='python3';
export GDRIVEDL_PY_SELENIUM_HOST='http://192.168.1.120:4444/wd/hub';
