# BashBot Config

irssiScreenName='irssi' # Name of irssi screen
channel="#yourchannel" # IRC Channel
server="irc.example.com" # IRC server
lckfile="/home/bashbot/bashbot.lck" # Lock file
logfile="~/irclogs/$server/$channel" # Where irssi logs are, it's recommended you don't change this setting (:
logfile_send="~/irclogs/$server/\\$channel" # Channel with a backslash infront of it
makelckfile="true" # Prevent BashBot from being run more than once
