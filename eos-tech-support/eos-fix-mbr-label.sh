#!/bin/bash -e

if [[ $# -ne 1 ]] ; then
    echo "Usage: $0 DEVICE"
    exit 1
fi

root_disk=$1
sfdisk -d ${root_disk} > partitions.txt

# Check this is a MBR partiton table
label_type=$(sed -n -e 's/^label: [ ]*\(.*\)$/\1/p' partitions.txt)
if [[ ${label_type} != "dos" ]] ; then
    echo "Error: This is not a MBR partition table"
    echo
    cat partitions.txt
    exit 2
fi

# Check that the partition starting at 144585 is a bootable Linux partition
type83_bootable=$(sed -n -e 's/^.*start=[ ]*144585,.*\(type=83, bootable\).*$/\1/p' partitions.txt)
if [[ ${type83_bootable} != "type=83, bootable" ]] ; then
    echo "Error: The partition starting at 144585 is not a bootable Linux partition"
    echo
    cat partitions.txt
    exit 3
fi

# Change the starting of the bootable Linux partition from 144585 to 131072
sed -i -e 's/\(start=[ ]*\)144585\(.*\), size=[ ]*[^,]*/\1131072\2/' partitions.txt
sfdisk --force --no-reread ${root_disk} < partitions.txt
rm partitions.txt
