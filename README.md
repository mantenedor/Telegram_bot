# oto
Operadoder de Texto Ordenado

# Getupdates
https://api.telegram.org/bot_TOKEN_/getupdates


# sendMessage
 curl -X POST "https://api.telegram.org/bot_TOKEN_/sendMessage" -d "chat_id=_CHATID_text=Mensagem"
 
# Serviço
 
    Run this command

    sudo nano /etc/systemd/system/YOUR_SERVICE_NAME.service

    Paste in the command below. Press ctrl + x then y to save and exit

    Description=GIVE_YOUR_SERVICE_A_DESCRIPTION

    Wants=network.target
    After=syslog.target network-online.target

    [Service]
    Type=simple
    ExecStart=YOUR_COMMAND_HERE
    Restart=on-failure
    RestartSec=10
    KillMode=process

    [Install]
    WantedBy=multi-user.target

    Reload services

    sudo systemctl daemon-reload

    Enable the service

    sudo systemctl enable YOUR_SERVICE_NAME

    Start the service

    sudo systemctl start YOUR_SERVICE_NAME

    Check the status of your service

    systemctl status YOUR_SERVICE_NAME

    Reboot your device and the program/script should be running. If it crashes it will attempt to restart

