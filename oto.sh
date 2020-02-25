#!/bin/bash

CONF="/opt/oto/oto.conf"
TOKEN=`grep "TOKEN" $CONF | cut -d= -f2`
URL="https://api.telegram.org/bot$TOKEN"
SCRIPT=`grep "SCRIPT" $CONF | cut -d= -f2`

function GET {
        echo 'GET'
        MSG=`curl $URL/getupdates | jq .result[1]`
        FROMID=`echo $MSG | jq .message.from.id`
        TYPE=`echo $MSG | jq .message.entities[0].type`
        TXT=`echo $MSG | jq .message.text`
        MSGID=`echo "$MSG" | jq .message.message_id`
        UPDATEID=`echo $MSG | jq .update_id`

        CHATID=`echo "$MSG" | tail -n1 | cut -d: -f5 | cut -d, -f1`

        echo $FROMID
        echo $TYPE
        echo $TXT

        echo "$MSG" > /tmp/.msg
        curl "$URL/getupdates?offset=$UPDATEID"
}


function CHAT {
        echo "CHAT"
        GET
        if [[ "$TYPE" = '"hashtag"' ]];then
                CLI
                curl -X POST "$URL/sendMessage" -d "chat_id=$FROMID&text=$RESPOSTA"
        else
                if [[ "$TXT" != null ]];then
                        FUNC
                        curl -X POST "$URL/sendMessage" -d "chat_id=$FROMID&text=$RESPOSTA"
                fi
        fi
}

function CLI {
        echo "CLI"
        CMD=`echo $TXT | sed 's/^"#//' | sed 's/"$//'`
        RESPOSTA=`$CMD`
}

function FUNC {
        echo "FUNC"
        RESPOSTA="`echo "$TXT"` não computa."
        if [[ "$TXT" = '"Olá"' ]];then
                RESPOSTA="Saldações!"
        fi
        if [[ `echo "$TXT" | cut -b 2-6` = 'cofre' ]];then
                DELIMITADOR=`echo "$TXT" | cut -d' ' -f2`
                SERVICO=`echo "$TXT" | cut -d' ' -f3`
                SECRET=`echo $TXT | cut -d' ' -f4 | tr -d '"'`
                SERVICO=`echo "$SERVICO" | md5sum | tr -d [0-9] | cut -b 1-3`
                SECRET=`echo "obase=16; $SECRET" | bc`
                RESPOSTA="$SERVICO$DELIMITADOR$SECRET"
        fi


}

function RUN {
        while true; do
                CHAT;
                TIME=`echo $RANDOM % 10 + 1 | bc`
                sleep $TIME
        done
}

RUN
