trace_file=$SCRIPTPATH/rate.txt;
line_buf_file=${HOME}/Documents/git_projects/line-buff/message.txt;
instance_sub()
{
    local rate=$(cat ${trace_file});
    if [ $rate -eq "0" ]; then
	echo "Too meny mega instences. Skip.";
	exit 0;
    fi
    # ok, instence - 1
    let "rate = $rate - 1";
    echo $rate > ${trace_file};
}
instance_plus()
{
    local rate=$(cat ${trace_file});
    # instence + 1
    let "rate = $rate + 1";
    echo $rate > ${trace_file};
}

source ${HOME}/.bash_profile
export LC_ALL=zh_TW.UTF-8
instance_sub;
trap instance_plus EXIT;
ERROR_CODE=254;
cd ${HOME};

slack-send()
{
    local title=${1##*/};
    local filename=$2
    local msg=$(cat <<EOF
      {
        "attachments": [
          {
            "color": "#36a64f",
            "pretext": "<https://hare1039.nctu.me/sysvol${1:8}|$title> have updated", 
            "title": "Downloaded $title:",
            "title_link": "https://hare1039.nctu.me/sysvol${1:8}",
            "text": "$filename"
          }
        ]
      }
EOF
)
    slack-send-raw $msg;
}

gdrivedl_from()
{
    local title=${PWD##*/};
    if [[ "${PWD}" == "${HOME}" ]]; then
	return $err;
    fi
    echo "downloading: $title";
    local result=$(python3 ~/Documents/git_projects/gdrivedl/dl.py \
			   -d $PWD                                 \
			   -s http://192.168.1.120:4445/wd/hub     \
			   $*)
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

megadl_from()
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
	slack-send $PWD $filename
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
