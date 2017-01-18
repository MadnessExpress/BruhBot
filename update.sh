#!/bin/bash

if [ "$1" = "restart" ]; then
	echo "#########Restarting############"
	echo "###############################"
  ./bot.rb
elif [ "$1" = "update" ]; then
	git pull
	./bot.rb
else
	echo "Nothing happened."
fi
