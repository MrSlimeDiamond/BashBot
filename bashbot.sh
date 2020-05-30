#!/bin/bash
#logfile='/home/bashbot/irclogs/zenoc/#lobby'

# Config is in ./config.sh :) 

version="1.20 beta" # Don't touch me
run=true # Don't change: for while loop :)
time=$(date +%H:%M:%S) # Format for time
# Clients
#sendtoirc="/home/bashbot/sendtoirc.sh"
sendtoirc="./sendtoirc.sh"
#config="/home/bashbot/config.sh"
#. /home/bashbot/config.sh
#. ./config.sh
source ./config.sh

# Get the directory the file is in, this script is stolen from stackoverflow (:
# Currently useless

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do 
  TARGET="$(readlink "$SOURCE")"
  if [[ $TARGET == /* ]]; then
    echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
    SOURCE="$DIR/$TARGET" 
  fi
done
echo "SOURCE is '$SOURCE'"
RDIR="$( dirname "$SOURCE" )"
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
if [ "$DIR" != "$RDIR" ]; then
  echo "DIR '$RDIR' resolves to '$DIR'"
fi
echo "DIR is '$DIR'"

logerror(){
echo -e "\e[31m$time [ERROR] $1\e[00m"
}

logwarn(){
echo -e "\e[33m$time [WARN] $1\e[00m"
}

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
#echo "Caught signal, terminating..."
if [ -f "$lckfile" ]; then
	rm -f $lckfile # important if you have lckfile enabled
fi
stopbot
exit
}

trap trapcmds EXIT # When there is an exit signal, run the trapcmds function


if [ "$1" == "" ]; then
	echo -e "\e[31mYou must specify an option! Use --option-list for an option list.\e[00m"
fi
if [ "$1" == "--option-list" ]; then
	echo "Option list:
	start - start bot
	build - build bot - Automatically done when you start the bot in version 1.19 beta 
	--option-list - list options"
fi


if [ "$1" == "build" ]; then
echo "
Note: As of version 1.19 beta, doing start will automatically build


Requirements:
Irssi
Screen
It is recommended you put this on a seperate account named bashbot.
Type ./bashbot.sh confirmbuild to continue."
exit
fi
#if [ "$1" == "confirmbuild" ]; then
	buildbot(){
	screen -dmS $irssiScreenName
	#echo -ne "*-----\r"
	echo -ne "Starting irssi screen... name: $irssiScreenName\r"
	sleep 1
	screen -S $irssiScreenName -X stuff "irssi\n"
	echo -ne "Starting irssi...\r"
	sleep 1
	echo -ne "Setting up user...\r"
	screen -S $irssiScreenName -X stuff "/set nick $nick\n"
	#echo -ne "Setting up user..."
	screen -S $irssiScreenName -X stuff "/set real_name $realname\n"
	sleep 1
	screen -S $irssiScreenName -X stuff "/set user_name $username\n"
	sleep 1
	screen -S $irssiScreenName -X stuff "/connect $server\n"
	echo -ne "Connecting to $server\r"
	sleep 10
        screen -S $irssiScreenName -X stuff "/join $channel\n"
        echo -ne "joining $channel\r"
	sleep 1
	#screen -S $irssiScreenName -X stuff "/log start $logfile\n"
	screen -S $irssiScreenName -X stuff "/log open -targets $channel $logfile\n"
	echo -ne "Setting up logging (part 1)\r"
	sleep 1
	#screen -S $irssiScreenName -X stuff "/log open -targets $channel $logfile\n"
	screen -S $irssiScreenName -X stuff "/log start $logfile\n"
	echo -ne "Setting up logging (part 2)\r"
	# Silly me did irssi commands the wrong way around :I
	#echo -ne "******\r"
	sleep 1
	#screen -S $irssiScreenName -X stuff "/connect $server\n"
	#echo -ne "******\r"
	echo -ne "Finished\r"
	#sleep 1
	#screen -S $irssiScreenName -X stuff "/join $channel\n"
	#echo -ne "******\r"
	#sleep 1
	}

#fi
if [ "$1" = "confirmbuild" ]; then buildbot; fi


	stopbot(){
	screen -S $irssiScreenName -X stuff "/quit $quitmessage\n"
	sleep 1
	screen -S $irssiScreenName -X stuff "exit\n"
	}
if [ "$1" = "start" ]; then

echo -e "\e[32mWelcome to BashBot by SlimeDiamond version $version\e[00m"
echo -e "\e[32m$time [BashBot] Starting build process...\e[00m"
buildbot
echo "Note: Using build connects the bot to irc, start will make it respond to commands. Use the stop command to take the bot offline"
if [ -f "$lckfile" ]; then
#	echo -e "\e[31m$time [ERROR] lckfile $lckfile exists, exiting...\e[00m"
	logerror "lckfile $lckfile exists, exiting..."
	echo -e "This means BashBot may already be running."
	exit
fi
echo "Current date (timestamp): $time"
echo -e "Current date: $(date)"

if [ "$makelckfile" = "true" ]; then
	log "Creating lckfile: $lckfile"
	touch $lckfile
	log "Created lckfile sucsesfully"
	#log "Please note: Do not use kill -9 on this unless it is completely nececary. If you experience errors when starting, try rm -f $lckfile"
	logwarn "Using kill -9 may cause errors when starting. If you have trouble starting, try removing $lckfile"
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
