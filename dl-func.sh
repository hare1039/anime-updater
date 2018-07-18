source $SCRIPTPATH/config.sh;

slack-send()
{
    local title="${1##*/}";
    local filename="${@:2}";
	if [ "$filename" = "" ]; then
		return;
    fi
	for pattern in ${IGNORE_MSG_PATTERN[*]}; do
		if ${PYTHON3} -c "import re; R = re.search('$pattern', '$filename'); E = 1 if R is None else 0; exit(E);"; then
			# match => break;
			return;
		fi;
	done
    local url=$(${PYTHON3} -c "from urllib.parse import quote; print(quote(\"${1:8}\"))")
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
    find . -name '*(*).mp4' -delete
    find . -name '*(*).mkv' -delete
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
    local result=$(${PYTHON3} ${GDRIVEDL_PY}                          \
			      -d $PWD                                 \
			      -s ${GDRIVEDL_PY_SELENIUM_HOST}         \
			      -t 'test "$(ls | grep "(1).mp4\|(1).mkv")" = ""' \
			      $* || gdrivedl-cleanup 2>/dev/null);
    if grep -q -v -E 'ERROR|WARNING' <<< "$result"; then
	local rawname=$(grep -v -E 'ERROR|WARNING' <<< "$result");
	local filename;
	while read -r line; do
	    filename="$filename \n${line##*/}";
	done <<< "$rawname";
	echo $filename;
	slack-send $PWD $filename;
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
#	line "$title dl failed. Please renew the url. <<$*>>"
	echo "$title dl failed. Please renew the url. <<$*>>" > $line_buf_file;
	echo "$title download failed. Please renew the url. <<$*>>";
    fi
    if grep -q -v -E 'ERROR|WARNING' <<< "$mega_result"; then
	local rawname=$(grep -v -E 'ERROR|WARNING' <<< "$mega_result");
	local filename;
	while read -r line; do
	    filename="$filename \n${line##*/}";
	done <<< "$rawname";
#	line "$title have updated.,$filename have been downloaded.";
	slack-send "$PWD" "$filename"
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
