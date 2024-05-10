#!/bin/bash

DISPLAY=:0
PARAMS="-display $DISPLAY -usepw"

x11vnc $PARAMS
exit $?

