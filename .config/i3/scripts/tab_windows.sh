#!/bin/bash

id=`python ~/.config/i3/scripts/id_list.py $1`
i3-msg [id="$id"] focus > /dev/null
