#!/opt/local/bin/bash

# Script to backup FreeBSD Testing VM
# FreeBSDVM9
# FreeBSDVM10

/opt/local/bin/tarsnap -v -c \
	-f "$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)-VMs" \
	 /Users/takizo/Documents/BSDVirtualMachines
