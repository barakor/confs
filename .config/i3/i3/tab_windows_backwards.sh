#!/bin/bash

id=`python2 ~/.config/i3/id_list_backwards.py`
i3-msg [id="$id"] focus > /dev/null
