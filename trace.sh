
SCRIPT=$(readlink -f "$0");
SCRIPTPATH=$(dirname "$SCRIPT");

source $SCRIPTPATH/dl-func.sh;

list=$(cat $SCRIPTPATH/list.json)

for row in $(echo "${list}" | jq -r '.[] | @base64'); do
    _jq() {
     	echo ${row} | base64 --decode | jq -r ${1}
    }

    #echo $(_jq '.title')

    #echo $(_jq '.file_path');
    #cd $(_jq '.file_path');
    for url in $(_jq '.megaurl[]'); do
	cd "$(_jq '.file_path')";
	#echo "megaurl: $url"
	megadl_from $url;
    done
    for url in $(_jq '.gdurl[]'); do
	cd "$(_jq '.file_path')";
	#echo "gdurl: $url"
	gdrivedl_from $url;
    done
done
