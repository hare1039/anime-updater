
SCRIPT=$(readlink -f "$0");
export SCRIPTPATH=$(dirname "$SCRIPT");

source $SCRIPTPATH/config.sh;

instance_sub()
{
    local rate=$(cat ${trace_file});
    if (( "$rate" <= 0 )); then
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

instance_sub;
trap instance_plus EXIT;

INT-handler () {
    echo "Cleaning up"
    exit
}
trap INT-handler INT

SRC_DL_FUNC="source $SCRIPTPATH/dl-func.sh";
list=$(cat $SCRIPTPATH/list.json);
> ${line_buf_file} #clear error buffer

for row in $(echo "${list}" | jq -r '.[] | @base64'); do
    _jq() {
        echo ${row} | base64 --decode | jq -r ${1}
    }
    cd ${HOME};
    for url in $(_jq '.url[]'); do
        cd "$(_jq '.file_path')";
        if [[ "$url" = *"mega"* ]]; then
            $TIMEOUT bash -c "$SRC_DL_FUNC; megadl-from $url";
        elif [[ "$url" = *"google.com"* ]]; then
            $TIMEOUT bash -c "$SRC_DL_FUNC; gdrivedl-from $url";
        elif [[ "$url" = *"youtube.com"* ]]; then
            $TIMEOUT bash -c "$SRC_DL_FUNC; youtube-dl-from $url";
        fi
        cd ${HOME};
    done
done
