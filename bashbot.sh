#!/bin/bash
#logfile='/home/bashbot/irclogs/zenoc/#lobby'

# Config - change this to your liking :)

irssiScreenName='irssi'
run=true
time=$(date +%H:%M:%S)
#log=$(echo -e "$date [LOG] $1")
#log=$(echo -e "$(date +%H:%M:%s) [LOG] $1")
sendtoirc="/home/bashbot/sendtoirc.sh"
channel="#lobby"
server="oris.zenoc.net"
lckfile="/home/bashbot/bashbot.lck"
logfile="/home/bashbot/$server/$channel
makelckfile="true"
log(){
echo "$time [LOG] $1"
}

send(){
$sendtoirc "$1"
log "Sending to $channel $1"
#echo "Ignore me" >> /home/bashbot/irclogs/zenoc/\#lobby
echo "Ignore" >> $logfile
}

trapcmds(){
echo "Caught signal, terminating..."
rm -f $lckfile
exit
}

trap trapcmds EXIT


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
Type ./bashbot.sh build confirm to continue."
exit
fi
if [ "$1" == "build confirm" ]; then
	screen -dmS irssi
	screen -S irssi -X stuff "irssi"
	screen -S irssi -X stuff "/connect $server"
	screen -S irssi -X stuff "/join $channel"
	echo "Finished. Type ./bashbot.sh start to run"
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
	evalCommand=$(cat "$logfile" | tail -1 | grep -o "\!eval$ ")
	if [ "$evalCommand" = '!eval' ]; then

		output=$($*)
		#screen -S $irssiScreenName -X stuff "Input: $* Output: $output"
		screen -S $irssiScreenName -X stuff "$output"

	fi
done
fi
