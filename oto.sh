#!/bin/bash

API="https://api.telegram.org"
TOKEN=$TOKEN #Definir variável de ambinete
URL="$API/bot$TOKEN"
#BASE="/mnt/data/oto/data"
JSON="/mnt/data/oto/data/oto.json"
RESPOSTA="Saldações!"

function GET {

        FUNCTION="getupdates"

        MSG=`curl $URL/$FUNCTION | jq .result[1]`
        UPDATEID=`echo $MSG | jq .update_id`
        FROMID=`echo $MSG | jq .message.from.id`
        TYPE=`echo $MSG | jq .message.entities[0].type`
        TXT=`echo $MSG | jq .message.text`
        MSGID=`echo "$MSG" | jq .message.message_id`
        USERNAME=`echo $MSG | jq .message.chat.username`
        TRUSTID=`grep -x "$FROMID" /opt/oto/.trust`

        curl "$URL/getupdates?offset=$UPDATEID"
}

function CHAT {

        FUNCTION="sendMessage"
        curl -X POST "$URL/$FUNCTION" -d "chat_id=$FROMID&text=$RESPOSTA"
}

function COMAND {

                echo "CHAT"

                if [[ "$TXT" = '"/sleep"' ]];then
                        RESPOSTA="Eu nunca durmo."
                        CHAT
                fi

}

function SEQUENCE {

        GET

        if [ "$TRUSTID" != "$FROMID" ]; then
                if [ "$UPDATEID" != null ];then
                        SECURITY
                fi
        else
                if [[ "$TYPE" = '"bot_command"' ]];then
                        echo "COMAND"
                        BUSCA
                        #COMAND
                else
                        BUSCA
                fi
        fi

}

function BUSCA {

        BASE=`cat "$JSON"`
        TERMO=`echo "$TXT" | tr -d '"' | tr -d '\/'`
        RESPOSTA=`echo "$BASE" | jq ."$TERMO"`

        if [ "$RESPOSTA" = null ];then
                RESPOSTA="Não computa."
        fi

        echo "$TERMO"
        CHAT
}

function SECURITY {

                RESPOSTA="Tentativa de comunicação desconhecida: $MSG"
                #echo $RESPOSTA >> /opt/oto/security.log
                FROMID="757541494"
                curl -X POST "$URL/sendMessage" -d "chat_id=$FROMID&text=$RESPOSTA"
}

function RUN {

        while true; do
                SEQUENCE
                sleep 3
        done

}

RUN
