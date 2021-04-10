#!/bin/sh
# @k-a-s-c-h on GitHub
# @0815 on ubnt forums
# file is located at https://github.com/k-a-s-c-h/unifi/blob/main/on_boot.d/10-wireguard_failover.sh

while sleep 240
do
	
wan1=primary
wan2=none
ulte=backup

if [ $wan1  = primary ] && [ $ulte = backup ]; then
	if [ `cat /var/log/messages | grep wanFailover | grep "using table" | tail -n1 | awk '{print $17}' | awk '{print substr($0,0,length($0)-1)}'` = up ]; then
		if [ -f /tmp/failover_up ]; then
			wg-quick down wg0
			sleep 5
			wg-quick up wg0
			rm /tmp/failover_up
		fi
	else
		if [ ! -f /tmp/failover_up ]; then
			touch /tmp/failover_up
		fi
	fi
fi

if [ $wan1 = primary ] && [ $wan2 = backup ]; then
	if [ `cat /var/log/messages | grep wanFailover | grep "using table" | tail -n1 | awk '{print $17}' | awk '{print substr($0,0,length($0)-1)}'` = up ]; then
		if [ -f /tmp/failover_up ]; then
			wg-quick down wg0
			sleep 5
			wg-quick up wg0
			rm /tmp/failover_up
		fi
	else
		if [ ! -f /tmp/failover_up ]; then
			touch /tmp/failover_up
		fi
	fi
fi

if [ $wan2 = primary ] && [ $ulte = backup ]; then
	if [ `cat /var/log/messages | grep wanFailover | grep "using table" | tail -n1 | awk '{print $13}' | awk '{print substr($0,0,length($0)-1)}'` = up ]; then
		if [ -f /tmp/failover_up ]; then
			wg-quick down wg0
			sleep 5
			wg-quick up wg0
			rm /tmp/failover_up
		fi
	else
		if [ ! -f /tmp/failover_up ]; then
			touch /tmp/failover_up
		fi
	fi
fi

if [ $wan2 = primary ] && [ $wan1 = backup ]; then
	if [ `cat /var/log/messages | grep wanFailover | grep "using table" | tail -n1 | awk '{print $13}' | awk '{print substr($0,0,length($0)-1)}'` = up ]; then
		if [ -f /tmp/failover_up ]; then
			wg-quick down wg0
			sleep 5
			wg-quick up wg0
			rm /tmp/failover_up
		fi
	else
		if [ ! -f /tmp/failover_up ]; then
			touch /tmp/failover_up
		fi
	fi
fi
done