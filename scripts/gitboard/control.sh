#!/bin/bash

export DISPLAY=:0
DESKTOPFILE=~/Desktop/gitboard.desktop
WEBBROWSER="Firefox"
WEBSITENAME="GitBoard.io"
WEBSITEREGEX="$WEBSITENAME.*$WEBBROWSER"
NOWEBSITENAME="Server Not Found"
NOWEBSITEREGEX="$NOWEBSITENAME.*$WEBBROWSER"
OPER=$1
PARAM=$2

declare -A OPERMAP=( \
	[refresh]=_refreshcb \
	[zoom]=_zoomcb \
	[restart]=_restartcb \
)

declare -A ZOOMMAP=( \
	[-]="minus" \
	[+]="plus" \
)

function _isParamInMap
{
	local -n MAP=$1
	local PARAM=$2

	echo ${!MAP[@]} | grep -o $PARAM &> /dev/null
	return $?
}

function _runOnWindow
{
	local WEBSITE=$1
	local ACTION=$2
	
	echo "Running: DISPLAY=$DISPLAY xdotool search --onlyvisible \
--name $WEBSITE windowactivate key $ACTION"
	WINDOW=$(xdotool search --onlyvisible --name "$WEBSITE")
	if [ -z "$WINDOW" ]; then
		_refreshemptysite
	fi
	WINDOW=$(xdotool search --onlyvisible --name "$WEBSITE")
	if [ -n "$WINDOW" ]; then
		xdotool windowactivate "$WINDOW"
		xdotool key "$ACTION"
		return $?
	fi
	return 1
}

function _refreshemptysite
{
	local PARAM=$1
	local ACTION="Ctrl+F5"

	_runOnWindow "$NOWEBSITEREGEX" "$ACTION"
	return $?
}

function _refreshcb
{
	local PARAM=$1
	local ACTION="Ctrl+F5"

	_runOnWindow "$WEBSITEREGEX" "$ACTION"
	return $?
}

function _zoomcb
{
	local PARAM=$1
	local ACTION="Ctrl+"

	_isParamInMap ZOOMMAP $PARAM
	if [ $? -ne 0 ]; then echo "[$FUNCNAME] Param '$PARAM' not supported"; exit 3; fi
	_runOnWindow "$WEBSITEREGEX" "$ACTION${ZOOMMAP[$PARAM]}"
	return $?
}

function _restartcb
{
	local PARAM=$1
	local ACTION="Ctrl+F4"

	_runOnWindow "$WEBSITEREGEX" "$ACTION"
	echo "Running: DISPLAY=$DISPLAY gio launch $DESKTOPFILE"
	sleep 1
	gio launch $DESKTOPFILE
	return $?
}


# main
_isParamInMap OPERMAP $OPER
if [ $? -ne 0 ]; then echo "Operation '$OPER' not supported"; exit 2; fi

${OPERMAP[$OPER]} $PARAM
exit $?

