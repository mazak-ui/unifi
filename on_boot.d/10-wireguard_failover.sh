#!/bin/sh
# @k-a-s-c-h on GitHub
# @0815 on ubnt forums
# file is located at https://github.com/k-a-s-c-h/unifi/blob/main/on_boot.d/10-wireguard_failover.sh
# table 201 WAN Primary
# table 202 WAN Failover
# table 203 U-LTE Failover
#
# curl -LJo /mnt/data/on_boot.d/10-wireguard_failover.sh https://raw.githubusercontent.com/k-a-s-c-h/unifi/main/on_boot.d/10-wireguard_failover.sh
# chmod +x /mnt/data/on_boot.d/10-wireguard_failover.sh


while sleep 240
do

if [ `lsmod | awk '{print $1}' | grep wireguard | wc -l` = 1 ]; then

using_table=`cat /var/log/messages | grep wanFailover | grep "using table" | tail -n1 | awk '{print $11}'`

	if [ $using_table = 201 ]; then
		[ ! -z "$failover" ] || failover=0
		if [ $failover = 1 ]; then
			wg-quick down wg0
			sleep 2
			wg-quick up wg0
			unset failover
		fi
	else
		if [ $using_table = 202 ] || [ $using_table = 203 ]; then
			failover=1
		fi
	fi
fi

done