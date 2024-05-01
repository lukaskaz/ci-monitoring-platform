#!/bin/bash

# Enable and disable HDMI output on the Raspberry Pi

function _status()
{
        status=$(ddcutil getvcp d6|tr -s ' '|sed -r "s/^.*\(sl=(.*)\).*$/\1/g")
        if [ -z $status ]; then
                echo "Cannot check status"
        elif [ $status = 0x01 ]; then
                echo "Display is on"
                return 1
        elif [ $status = 0x05 ]; then
                echo "Display is off"
                return 0
        fi
        return 2
}

case $1 in
        off)
                _status &> /dev/null
                if [ $? -eq 1 ]; then ddcutil setvcp d6 0x05; fi
        ;;
        on)
                _status &> /dev/null
                if [ $? -eq 0 ]; then ddcutil setvcp d6 0x01; fi
        ;;
        status)
                _$1
        ;;
        *)
                echo "Usage: $0 on|off|status" >&2
                exit 2
        ;;
esac

exit 0
