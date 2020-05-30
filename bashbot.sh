#!/bin/bash
#logfile='/home/bashbot/irclogs/zenoc/#lobby'

# Config is in ./config.sh :) 

run=true # Don't change: for while loop :)
time=$(date +%H:%M:%S) # Format for time
# Clients
sendtoirc="/home/bashbot/sendtoirc.sh"
#config="/home/bashbot/config.sh"
#. /home/bashbot/config.sh
#. ./config.sh
source config.sh
log(){
echo "$time [LOG] $1"
}

send(){
$sendtoirc "$1"
log "Sending to $channel $1"
#echo "Ignore me" >> /home/bashbot/irclogs/zenoc/\#lobby
echo "Ignore" >> $logfile
}

trapcmds(){ # What to run when an exit is caught
echo "Caught signal, terminating..."
if [ -f "$lckfile" ]; then
	rm -f $lckfile # important if you have lckfile enabled
fi
exit
}

trap trapcmds EXIT # When there is an exit signal, run the trapcmds function


if [ "$1" == "" ]; then
	echo -e "\e[31mYou must specify an option! Use --option-list for an option list.\e[00m"
fi
if [ "$1" == "--option-list" ]; then
	echo "Option list:
	start - start bot
	build - build bot (must be done every time system reboots)
	--option-list - list options"
fi


if [ "$1" == "build" ]; then
echo "Requirements:
Irssi
Screen
It is recommended you put this on a seperate account named bashbot, because it creates files.
Type ./bashbot.sh confirmbuild to continue."
exit
fi
if [ "$1" == "confirmbuild" ]; then
	screen -dmS $irssiScreenName
	echo -ne "*-----\r"
	sleep 1
	screen -S $irssiScreenName -X stuff "irssi\n"
	echo -ne "**----\r"
	sleep 1
	screen -S $irssiScreenName -X stuff "/log start $logfile\n"
	echo -ne "***---\r"
	sleep 1
	screen -S $irssiScreenName -X stuff "/log open -targets $channel $logfile\n"
	echo -ne "****--\r"
	sleep 1
	screen -S $irssiScreenName -X stuff "/connect $server\n"
	echo -ne "*****-\r"
	sleep 1
	screen -S $irssiScreenName -X stuff "/join $channel\n"
	echo -ne "******\r"
	sleep 1
	echo -ne "Finished. Type ./bashbot.sh start to run\r"
	exit
fi
if [ "$1" == "start" ]; then

echo -e "\e[32mWelcome to BashBot by SlimeDiamond\e[00m"
echo -e "\e[32m$time [BashBot] Starting...\e[00m"
if [ -f "$lckfile" ]; then
	echo -e "\e[31m$time [ERROR] lckfile $lckfile exists, exiting...\e[00m"
	echo -e "This means BashBot may already be running."
	exit
fi
echo "Current date (condenced) : $time"
echo -e "Current date: $(date)"

if [ "$makelckfile" = "true" ]; then
	log "Creating lckfile: $lckfile"
	touch $lckfile
	log "Created lckfile sucsesfully"
	log "Please note: Do not use kill -9 on this unless it is completely nececary. If you experience errors when starting, try rm -f $lckfile"
fi

#echo "Creating lckfile: $lckfile"
#touch $lckfile
while [ "$run" = 'true' ]
do
	sendMSG=$( cat "$logfile" |tail -1 | grep -o "\!test$" )
	if [ "$sendMSG" = '!test' ]
	then
		send "/msg $channel Works!"
		#screen -S $irssiScreenName -X stuff "it is working\n"
		#echo "Ignore this" >> /home/bashbot/irclogs/zenoc/\#lobby
		
fi
	sleep 0.1
	helpCommand=$(cat "$logfile" | tail -1 | grep -o "\!help$")
	if [ "$helpCommand" = '!help' ]; then
	send "/msg $channel Commands: !help !test " # Needs space else bot will execute command itself, idk why!	
	#screen -S $irssiScreenName -X stuff "Commands: \!help \!test\n"
		#echo "Ignore this" >> $logfile
	fi
	sleep 0.1
done
fi
