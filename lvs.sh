#!/bin/bash

VIP=192.168.99.253

RIP1=192.168.99.33

RIP2=192.168.99.22

/etc/rc.d/init.d/functions
case "$1" in

start)

        echo "start LVS"
        
        # set the Virtual IP Address
        
        /sbin/ifconfig eth0:0 $VIP broadcast $VIP netmask 255.255.255.255 up
        
        /sbin/route add -host $VIP dev eth0:0
        
        /sbin/ipvsadm -C
        
        /sbin/ipvsadm -A -t $VIP:80 -s rr
        
        /sbin/ipvsadm -a -t $VIP:80 -r $RIP1:80 -g 
        
        /sbin/ipvsadm -a -t $VIP:80 -r $RIP2:80 -g 
        /sbin/ipvsadm -L -n
        
        ;;
stop)
        echo "stop LVS"
        /sbin/ifconfig eth0:0 down
        /sbin/route del -host $VIP dev eth0:0
        /sbin/ipvsadm -C
        ;;
*)
        echo "Usage: $0 {start¦stop}"
        exit 1
esac
exit 0
