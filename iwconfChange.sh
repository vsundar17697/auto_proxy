#!/bin/bash
if iwconfig|grep -c pennstate
then                                                         
        pkill vpnc
        vpnc psu.conf
fi