#!/bin/bash

export DISPLAY=:0
WEBBROWSER="Firefox"
WEBSITENAME="GitBoard.io"
WEBSITEREGEX="$WEBSITENAME.*$WEBBROWSER"
PARAM=$1

declare -A ZOOM=( \
[-]="minus" \
[+]="plus" \
)

echo ${!ZOOM[@]} | grep -o $PARAM
if [ $? -ne 0 ]; then echo "Given parameter '$PARAM' not intended for zooming"; exit 2; fi

ACTION="Ctrl+${ZOOM[$PARAM]}"
echo "Running: DISPLAY=$DISPLAY xdotool search --onlyvisible \
--name $WEBSITEREGEX windowactivate key $ACTION"

WINDOW=$(xdotool search --onlyvisible --name "$WEBSITEREGEX")
if [ -n "$WINDOW" ]; then
	xdotool windowactivate "$WINDOW"
	xdotool key "$ACTION"
	exit $?
fi

exit 1

