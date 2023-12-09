#!/bin/sh

status=$(playerctl metadata --player=spotify_player --format '{{lc(status)}}')
if [[ $status == "playing" ]]; then
	info=$(playerctl metadata --player=spotify_player --format '{{artist}} - {{title}}')
	text=$info
elif [[ $status == "paused" ]]; then
	text=" "
elif [[ $class == "stopped" ]]; then
	text=" "
fi

echo -e "{\"text\":\""$text"\", \"status\":\""$status"\"}"
