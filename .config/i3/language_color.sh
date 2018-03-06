#!/bin/bash

lang=$(xkblayout-state print %n |  cut -c1-2)
if [ "$lang" == "En" ] 
	then
	echo -e "\033[1;36m$lang"
elif [ "$lang" == "He" ] 
	then
	echo "#00ff00"
fi
