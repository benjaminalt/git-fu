export SCRIPT=`realpath $0`
export SCRIPTPATH=`dirname $SCRIPT`

function blacklisted()
{
    blacklist=$SCRIPTPATH/blacklist.txt
    dirname="$(basename $1)"
    if cat $blacklist | grep -w $dirname > /dev/null; then
        return 0
    fi
    return 1
}