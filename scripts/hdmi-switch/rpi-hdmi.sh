#!/bin/sh

# Enable and disable HDMI output on the Raspberry Pi

is_off ()
{
	vcgencmd display_power | grep "display_power=0" >/dev/null
}

case $1 in
	off)
        	ddcutil setvcp d6 5	
		#vcgencmd display_power 0
	;;
	on)
		ddcutil setvcp d6 1
		#vcgencmd display_power 1
	;;
	status)
		ddcutil getvcp d6	
	;;
	*)
		echo "Usage: $0 on|off|status" >&2
		exit 2
	;;
esac

exit 0
