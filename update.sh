#!/bin/bash

screenname="BruhBot"

git pull https://github.com/FormalHellhound/BruhBot.git

screen -d -m -S $screenname ./BruhBot.rb
