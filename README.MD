# BashBot
IRC Bot using bash
## Usage
- ~~./bashbot.sh build - Build the bot, tells instructions - Must be run every time the machine starts up.~~ As of version 1.19 beta, this is no longer nececary and is run when the bot starts up
- ./bashbot.sh --option-list - List options
- ./bashbot.sh start - Start the bot

WARNING: If you use Irssi as your main IRC client and you're using the same user account, this may lead to unintended bahavior, such as nickname changes. It is recommended you give the bot its own account.
Make sure to configure the config.sh before building.
## Requirements
- Irssi
- Screen
- Linux

## Examples
![Screenshot](https://i.imgur.com/cTV4ZRW.png)
![Another screenshot](https://i.imgur.com/tQQktA5.png)

## Adding commands yourself!

Copy the following code and paste it in ./bashbot.sh inside the while loop (line 125) (put it under the 'do')

```
commandNameCommand=$(cat "$logfile" | tail -1 | grep -o "\!yourcommandhere$")
	if [ "$commandNameCommand" = '!yourcommandagain' ]; then
	send "/msg $channel Thing you want to send"
	fi
	sleep 0.1
```
Pretty straight forward to do

In the future, I will make adding commands a lot easier :)

## Feature requests & Bugs

[Issue tracker](https://github.com/MrSlimeDiamond/BashBot/issues/)
