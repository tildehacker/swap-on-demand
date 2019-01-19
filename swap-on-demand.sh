#!/usr/bin/env bash

function _print_usage() {
	echo "Usage:"
	echo -e "\t${0} on|off"
}

if [ "${#}" -ne 1 ]
then
	_print_usage
	exit 1
else
	if [ "${1}" == "on" ] \
		|| [ "${1}" == "off" ]
	then
		_subcmd="${1}"
	else
		_print_usage
		exit 1
	fi
fi

if [ -f "/swapfile" ]
then
	sudo swapoff /swapfile 2> /dev/null
	sudo rm --force /swapfile
fi

if [ "${_subcmd}" == "off" ]
then
	exit 0
fi

dd if=/dev/zero 2>/dev/null \
	| pv -s 4G \
	| sudo dd of=/swapfile \
			bs=40M \
			count=100 \
			iflag=fullblock \
			2>/dev/null

sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
