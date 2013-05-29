#!/bin/bash
#192.168.1.1 #IP PC1
#192.168.1.2 #IP PC2
#192.168.1.3 #IP PC3
#192.168.1.4 #IP PC4
#192.168.1.5 #IP PC5
#192.168.1.6 #IP PC6
#192.168.1.7 #IP PC7
IpArray=( 192.168.1.1 192.168.1.2 192.168.1.3 192.168.1.4 192.168.1.5 192.168.1.6 192.168.1.7 )

ip_range=192.168.1. #Subnet
#Parameter for Range Check, Range scan will be skipped if start IP > endIP
startIP=101 #Start rangescan with this IP(Host part)
endIP=100 #End rangescan with this IP(Host part)

_shutdown () {
case $1 in
    1) echo "NO SHUTDOWN: At least one pc is running" ;;
    2) echo "SHUTDOWN: No specified pc is running" ; shutdown -p now ;;
esac
}

for i in "${IpArray[@]}"
do
  echo $i
	if [ `ping -c 1 -i 1 $i | grep -wc 100.0%` -eq 0 ] #If one host could be pinged the shutdown will be skipped
		then _shutdown 1; 
	fi
done
 
# Range check
while [ $startIP -le $endIP ]
do
    ping -c 1 -i 1 $ip_range$startIP #send ping
    if [ `ping -c 1 -i 1 $ip_range$startIP | grep -wc 100.0%` -eq 0 ] #If one host could be pinged the shutdown will be skipped
		then _shutdown 1
	fi
 	startIP=$(( $startIP+1 )) #next IP
done
 
_shutdown 2 # No pc could be pinged, shutdown will be executed
