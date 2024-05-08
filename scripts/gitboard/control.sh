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
	[zoomkbd]=_zoomkbdcb \
	[zoommouse]=_zoommousecb \
	[restart]=_restartcb \
)

declare -A ZOOMKBDMAP=( \
	[-]="minus" \
	[+]="plus" \
	[reset]="0" \
)

declare -A ZOOMMOUSEMAP=( \
	[-]="click 5" \
	[+]="click 4" \
)

function _isParamInMap
{
	local -n MAP=$1
	local PARAM=$2

	echo ${!MAP[@]} | grep -wo $PARAM &> /dev/null
	return $?
}

function _runOnWindow
{
	local WEBSITE=$1
	local ACTION=$2
	
	echo "Running: DISPLAY=$DISPLAY xdotool search --onlyvisible \
--name $WEBSITE windowactivate $ACTION"
	WINDOW=$(xdotool search --onlyvisible --name "$WEBSITE")
	if [ -z "$WINDOW" ]; then
		local REFRESH="key Ctrl+F5"
		WINDOW=$(xdotool search --onlyvisible --name "$NOWEBSITEREGEX")
		if [ -z "$WINDOW" ]; then return 2; fi 
		xdotool windowactivate "$WINDOW"
		xdotool $REFRESH
	fi
	WINDOW=$(xdotool search --onlyvisible --name "$WEBSITE")
	if [ -n "$WINDOW" ]; then
		xdotool windowactivate "$WINDOW"
		xdotool $ACTION
		return $?
	fi
	return 1
}

function _refreshcb
{
	local PARAM=$1
	local ACTION="key Ctrl+F5"

	_runOnWindow "$WEBSITEREGEX" "$ACTION"
	return $?
}

function _zoomkbdcb
{
	local PARAM=$1
	local ACTION="key Ctrl+%s"

	_isParamInMap ZOOMKBDMAP $PARAM
	if [ $? -ne 0 ]; then echo "[$FUNCNAME] Param '$PARAM' not supported"; exit 3; fi
	ACTION=$(printf "$ACTION" "${ZOOMKBDMAP[$PARAM]}")
	_runOnWindow "$WEBSITEREGEX" "$ACTION"
	return $?
}

function _zoommousecb
{
	local PARAM=$1
	local ACTION="keydown ctrl %s keyup ctrl"

	_isParamInMap ZOOMMOUSEMAP $PARAM
	if [ $? -ne 0 ]; then echo "[$FUNCNAME] Param '$PARAM' not supported"; exit 3; fi
	ACTION=$(printf "$ACTION" "${ZOOMMOUSEMAP[$PARAM]}")
	_runOnWindow "$WEBSITEREGEX" "$ACTION"
	return $?
}

function _restartcb
{
	local PARAM=$1
	local ACTION="key Ctrl+F4"

	_runOnWindow "$WEBSITEREGEX" "$ACTION"
	echo "Running: DISPLAY=$DISPLAY gio launch $DESKTOPFILE"
	sleep 1
	gio launch $DESKTOPFILE
	return $?
}

function _help
{
	echo "Available commands for ./$(basename $0)"
	echo "${!OPERMAP[@]}"

}

# main
_isParamInMap OPERMAP $OPER
if [ $? -ne 0 ]; then _help; exit 99; fi

${OPERMAP[$OPER]} $PARAM
exit $?

