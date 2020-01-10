#!/bin/bash

# ------------------------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------------------------

#ENVIRONMENT="wemos-d1mini-relayshield"
ENVIRONMENT="ak_D1mini"
READELF="xtensa-lx106-elf-readelf"
NUMBER=48
RD_OPTA="-s"
RD_OPTA="-a"
# ------------------------------------------------------------------------------
# END CONFIGURATION - DO NOT EDIT FURTHER
# ------------------------------------------------------------------------------

# remove default trace file
rm -rf $FILE

function help {
    echo
    echo "Syntax: $0 [-e <environment>] [-n <number>]"
    echo
}

cmd="sort"

# get environment from command line
while [[ $# -gt 1 ]]; do

    key="$1"

    case "$key" in
        "-e" )
            ENVIRONMENT="$2"
            shift
        ;;
        
        "-n" )
            NUMBER="$2"
            shift
        ;;
     
	"-s" ) 
	    RD_OPT="-S"
	    cmd="sec"
            NUMBER="$2"
            shift
	;;

        "-h" )
	    RD_OPT=$2
	    shift
	    cmd="opt"
	;;
    esac

    shift # past argument or value

done

# check environment folder
if [ $ENVIRONMENT == "" ]; then
    echo "No environment defined"
    help
    exit 1
fi
ELF=.pioenvs/$ENVIRONMENT/firmware.elf
if [ ! -f $ELF ]; then
    echo "Could not find ELF file for the selected environment: $ELF"
    exit 2
fi

case "$cmd" in 
    "sort" )
	echo "================ SORT ====================="
	$READELF -s $ELF | head -3 | tail -1
	$READELF -s $ELF | sort -r -k3 -n  | head -$NUMBER
    ;;

    "sec" )
	echo "================ Sec ====================="
	$READELF -S $ELF | head -n $NUMBER | tail -n +3 
#	$READELF -S $ELF | sort -r -k6 -n  | head -$NUMBER
    ;;

    "opt" )
	$READELF $RD_OPT $ELF 
    ;;
esac

