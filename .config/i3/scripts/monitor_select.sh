#!/bin/bash

# check for arg input
if ! [ -z "$1" ] ; then
        monitor_mode=$1

# if we don't have a file, start at zero
elif [ ! -f "/tmp/monitor_mode.dat" ] ; then
        monitor_mode="INTERNAL"

# otherwise read the value from the file
else 
        echo "WUT2" >> /tmp/monitor_mode.dat
        current_mode=`cat /tmp/monitor_mode.dat`

        if [[ $current_mode = "ALL" ]]; then
                monitor_mode="EXTERNAL"
        elif [[ $current_mode = "EXTERNAL" ]]; then
                monitor_mode="INTERNAL"
        elif [[ $current_mode = "INTERNAL" ]]; then
                monitor_mode="CLONES"
        else
                monitor_mode="ALL"
        fi
fi

if [ $monitor_mode = "ALL" ]; then
        echo "ALL"
        bash ~/.screenlayout/extended.sh
elif [ $monitor_mode = "EXTERNAL" ]; then
        echo "EXTERNAL"
        bash ~/.screenlayout/external_only.sh
elif [ $monitor_mode = "INTERNAL" ]; then
        echo "INTERNAL"
        bash ~/.screenlayout/internal_only.sh
elif [ $monitor_mode = "CLONES" ]; then
        echo "CLONES"
        bash ~/.screenlayout/clones.sh
fi
echo "${monitor_mode}" > /tmp/monitor_mode.dat
