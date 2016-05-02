#!/bin/sh


if [ -z $1 ]; then
	echo "Please give an IPBus address to test"
	exit
fi

addr=$((0x64000000 + ($1 << 2)))

ITERATION=0
ERRORS=0

while [ $ITERATION -lt 500 ]; do
	VALUE=`awk -F - '{print(("0x"$1) % 0xffff)}' /proc/sys/kernel/random/uuid`
	#echo "writing $VALUE"
	mpoke $addr $VALUE
	READBACK=`mpeek $addr`
        #echo "read back $READBACK"
	if [ $VALUE -ne $(( $READBACK )) ]; then
		echo "ERROR: wrote $VALUE, got $READBACK, which is $(( $READBACK ))"
		let ERRORS=ERRORS+1
#		exit
	fi
	let ITERATION=ITERATION+1
done

echo "Total errors: $ERRORS"
