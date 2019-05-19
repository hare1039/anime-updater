source $SCRIPTPATH/config.sh;

slack-send()
{
    local title="${PWD##*/}";
    local filename="${@:2}";

    if [ "$filename" = "" ] ; then
        return;
    fi
    for msg in ${IGNORE_MSG[*]}; do
        if [ "$filename" = "$msg" ] ; then
            return;
        fi
    done
    for pattern in ${IGNORE_MSG_PATTERN[*]}; do
        if ${PYTHON3} -c "import re; R = re.search('$pattern', '$filename'); E = 1 if R is None else 0; exit(E);"; then
            # match => break;
            return;
        fi;
    done
    local url=$(${PYTHON3} -c "from urllib.parse import quote; print(quote(\"${1#$RM_LOCALFS_PREFIX}\"))")
    local msg=$(cat <<EOF
      {
        "attachments": [
          {
            "color": "#36a64f",
            "pretext": "<${BASE_URL}${url}|$title> have updated",
            "title": "Downloaded $title:",
            "title_link": "${BASE_URL}${url}",
            "text": "$filename"
          }
        ]
      }
EOF
)

    slack-send-raw $msg;
    local pinkiemsg=$(cat <<EOF
      [
        {
          "color": "#36a64f",
          "pretext": "<${BASE_URL}${url}|$title> have updated",
          "title": "Downloaded $title:",
          "title_link": "${BASE_URL}${url}",
          "text": "$filename"
        }
      ]
EOF
)
    pinkie-send "$title" "$pinkiemsg";
}

gdrivedl-cleanup()
{
    find . -name '*([0-9]).mp4' -delete
    find . -name '*([0-9]).mkv' -delete
    find . -name '*.part' -delete
    find . -size 0 -not -name '*.txt' -delete
}

gdrivedl-from()
{
    local title=${PWD##*/};
    if [[ "${PWD}" == "${HOME}" ]]; then
        return $err;
    fi
    echo "downloading: $title";
    local result=$(${PYTHON3} ${GDRIVEDL_PY}                       \
                  -d $PWD                                          \
                  -s ${GDRIVEDL_PY_SELENIUM_HOST}                  \
                  -t 'test "$(ls | grep "(1).mp4\|(1).mkv")" = ""' \
                  $* || gdrivedl-cleanup 2>/dev/null);
    if grep -q -v -E 'ERROR|WARNING' <<< "$result"; then
        local rawname=$(grep -v -E 'ERROR|WARNING' <<< "$result");
        local filename_cat='';
        while read -r line; do
            local filename=${line##*/};
            filename_cat="$filename_cat\n$filename";
        done <<< "$rawname";
        slack-send "$PWD" "$filename_cat"
        echo "$title have updated";
        err=0;
    fi
    cd ${HOME};
    return $err;
}

megadl-from()
{
    local title=${PWD##*/};
    local err=$ERROR_CODE;
    if [[ "${PWD}" == "${HOME}" ]]; then
        return $err;
    fi
    echo "downloading: $title";
    local mega_result=$(megadl --no-progress --print-names $* 2>&1);
    if grep -q 'ENOENT' <<< "$mega_result" ; then
        #   line "$title dl failed. Please renew the url. <<$*>>"
        echo "$title dl failed. Please renew the url. <<$*>>" >> $line_buf_file;
        echo "$title download failed. Please renew the url. <<$*>>";
    fi
    if grep -q -v -E 'ERROR|WARNING' <<< "$mega_result"; then
        local rawname=$(grep -v -E 'ERROR|WARNING' <<< "$mega_result");
        local filename_cat='';
        local folder='';
        while read -r line; do
            local filename=${line##*/};
            filename_cat="$filename_cat\n$filename";
            folder=${line%"$filename"}
        done <<< "$rawname";
        #   line "$title have updated.,$filename have been downloaded.";
        slack-send "$folder" "$filename_cat"
        echo "$title have updated";
        err=0;
    fi

    if grep -q "509" <<< "$mega_result"; then
        echo "509!";
    fi
    find . -type f -size 0 -delete;
    cd ${HOME};
    return $err;
}

youtube-dl-from()
{
    local title=${PWD##*/};
    local err=$ERROR_CODE;
    if [[ "${PWD}" == "${HOME}" ]]; then
        return $err;
    fi
    echo "downloading: $title";

    local result=$(${YOUTUBE_DL} --download-archive ytdl.cache \
                                 --no-post-overwrites \
                                 --no-progress \
                                 --no-warnings "$*" 2>&1);

    local filename_cat='';
    while read -r line; do
        if grep -q "ffmpeg" <<< "$line"; then
            local filename=$(echo $line | awk 'split($0, a, "\"") {$6 = a[2]} {print $6}');
            filename_cat="$filename_cat\n$filename";
        fi
    done <<< "${result}"

    slack-send "$PWD" "$filename_cat"
    echo "$title have updated";
    err=0;

    cd ${HOME};
    return $err;
}
