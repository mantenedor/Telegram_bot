# Telgram_bot
Utilise o telgaram para aacionar comandos simples em equipamentos remotamente.

Crie um bot no Telegram, substitua a variável "$TOKEN" pelo token do seu bot e acesso a url abaixo em seu navegador ou com o comando "curl":
# Getupdates
https://api.telegram.org/bot$TOKEN/getupdates

Você pode fazer um teste de envio com o cando baixo, substituindo as variáveis pelo token do seu bot e a mensagem que deseja enviar, erspectivamente:
# sendMessage
```
curl -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" -d "chat_id=$CHATID&text=Mensagem"
```
Saiba mais em: https://core.telegram.org/bots/api

Agora você já pode descpbrir os "IDs" das mesnsagens qeu recebe.

Inclua os id dos remetentes autorizados em um arquivo de texto, separados por linha.
Invorme o caminho absoluto deste arquivo assim como as demais variáveis no arquivo "bot.conf"
A variável "$SECURITYID" corresponde ao destinatário das mensagens de segurança, caso alguém não autorizado tente se comunicar com o bot.

# Aplicação

Crie os scripts que serão invocados como comandos e invoque-os dentro da função "COMAND" e/ou crie novas funções:
```
...
function COMAND {
                cd "$WORKDIR"
                
                # Pingando hosts a partir de uma lista

                if [[ "$TXT" = '"/status_hw"' ]];then
                        RESPOSTA="Isso pode demorar um pouco. Seja paciente. Verificando conectividade com os equipamentos..."
                        CHAT
                        ./status_hw.sh
                        RESPOSTA=`cat .status_hw`
                        sleep 60
                        CHAT
                fi

}
...
```
O "/status_hw" corersponde ao comando cadastrado no bot do Telegram:

![image](https://user-images.githubusercontent.com/5191875/226203433-c5d62855-3003-40ab-8abf-321f48adbcbc.png)

Você também pode incluir o seu bot num grupo, autorizando o id do grupo, subistituindo o sinal negativo(-) por um arroba(@) no seu arquivo de ids confiáveis e tera cesso a lista de comando para todos no grupo:
![image](https://user-images.githubusercontent.com/5191875/226203713-9b17af77-362a-4435-a85a-36e94b83a8cd.png)

# Serviço

Configure seu bot como serviço.

Ajuste o caminho absoluto do arquivo "bot.service" de acordo com sua instalação

Crie um link simbólico em "/etc/systemd/system/" para o seu arquivo de serviço:
```
ln -s /opt/bot/bot.service -t /etc/systemd/system/
```
Habilite o serviço:
```
systemctl enable bot.service
```
Inicie o serviço:
```
systemctl start bot.service
```
