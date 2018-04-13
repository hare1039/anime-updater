
SCRIPT=$(readlink -f "$0");
export SCRIPTPATH=$(dirname "$SCRIPT");

source $SCRIPTPATH/dl-func.sh;

list=$(cat $SCRIPTPATH/list.json)

for row in $(echo "${list}" | jq -r '.[] | @base64'); do
    _jq() {
     	echo ${row} | base64 --decode | jq -r ${1}
    }

    for url in $(_jq '.url[]'); do
	cd "$(_jq '.file_path')";
	if [[ "$url" = *"mega"* ]]; then
	    megadl_from $url;
	elif [[ "$url" = *"google.com"* ]]; then
	    gdrivedl_from $url;
        fi
    done
done
