#!/bin/bash

function STATUS {
        SERVER1=`ping -c 3 0.0.0.0 | grep received`
        SERVER2=`ping -c 3 0.0.0.0 | grep received`
        SERVER3=`ping -c 3 0.0.0.0 | grep received`
        SERVER4=`ping -c 3 0.0.0.0 | grep received`
        RESPOSTA="STG - $SERVER1\n
PROXMOX - $SERVER2\n
MIKROTIK - $SERVER3\n
RASPBERRY - $SERVER4\n
Fim do comando."
}
STATUS
echo -e $RESPOSTA > .status_hw
