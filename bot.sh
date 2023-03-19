#!/bin/bash

CONF="/opt/tinybot/bot.conf"
TOKEN=`grep "TOKEN" $CONF | cut -d= -f2`
JSON=`grep "JSON" $CONF | cut -d= -f2`
TRUSTFILE=`grep "TRUSTFILE" $CONF | cut -d= -f2`
SECURITYID=`grep "SECURITYID" $CONF | cut -d= -f2`
WORKDIR=`grep "WORKDIR" $CONF | cut -d= -f2`

API="https://api.telegram.org"
URL="$API/bot$TOKEN"
RESPOSTA="Saldações!"

function GET {

        FUNCTION="getupdates"

        MSG=`curl $URL/$FUNCTION | jq .result[1]`
        UPDATEID=`echo $MSG | jq .update_id`
        FROMID=`echo "$MSG" | jq .message.from.id`
        CHATID=`echo "$MSG" | jq .message.chat.id`
        GROUP=`echo "$MSG" | jq -r .message.chat.type`
        TYPE=`echo $MSG | jq .message.entities[0].type`
        TXT=`echo $MSG | jq .message.text`
        MSGID=`echo "$MSG" | jq .message.message_id`
        USERNAME=`echo $MSG | jq .message.chat.username`

        curl "$URL/getupdates?offset=$UPDATEID"

        if [ "$GROUP" = "supergroup" ];then
                CHATID=`echo "$CHATID" | tr '-' '@'`
                TXT=`echo $MSG | jq -r .message.text | cut -d'@' -f1`
                TXT="\"$TXT\""
        else
                CHATID=$FROMID
        fi
}

function CHAT {
        CHATID=`echo "$CHATID" | tr '@' '-'`
        echo "$CHATID"
        FUNCTION="sendMessage"
        curl -X POST "$URL/$FUNCTION" -d "chat_id=$CHATID&text=$RESPOSTA"
}

function COMAND {
                cd "$WORKDIR"
                if [[ "$TXT" = '"/sleep"' ]];then
                        RESPOSTA="Eu nunca durmo."
                        CHAT
                fi
                
                #if [[ "$TXT" = '"/start_all"' ]];then
                #        RESPOSTA="Ligando todos os servidores..."
                #        CHAT
                #        ./start_all.sh
                #        RESPOSTA=`cat .status_hw`
                #        sleep 60
                #        CHAT
                #fi
                #if [[ "$TXT" = '"/start_stg"' ]];then
                #        RESPOSTA="Ligando storage...."
                #        CHAT
                #        ./start_stg.sh
                #        RESPOSTA=`cat .status_hw`
                #        sleep 60
                #        CHAT
                #fi
                #if [[ "$TXT" = '"/start_hw1"' ]];then
                #        RESPOSTA="Ligando servidor hw1..."
                #        CHAT
                #        ./start_hw1.sh
                #       RESPOSTA=`cat .status_hw`
                #        sleep 60
                #        CHAT
                #fi
                if [[ "$TXT" = '"/status_hw"' ]];then
                        RESPOSTA="Isso pode demorar um pouco. Seja paciente. Verificando conectividade com os equipamentos..."
                        CHAT
                        ./status_hw.sh
                        RESPOSTA=`cat .status_hw`
                        sleep 60
                        CHAT
                fi

}

function SEQUENCE {

        GET

        TRUSTID=`grep -x "$CHATID" "$TRUSTFILE"`
        
        if [ "$TRUSTID" != "$CHATID" ]; then
                if [ "$UPDATEID" != null ];then
                        SECURITY      
                fi
        else
                if [[ "$TYPE" = '"bot_command"' ]];then
                        #BUSCA
                        COMAND
                else
                        BUSCA
                fi
        fi
                        echo "$CHATID"
                        echo "$TRUSTID"

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
                curl -X POST "$URL/sendMessage" -d "chat_id=$SECURITYID&text=$RESPOSTA"
}

function RUN {

        while true; do
                SEQUENCE
                sleep 3
        done

}

RUN
