FROM catatnight/postfix

# installing mail client just for convenience
# You can send email locally by
# echo "test mail!" | mail -s "test" bot@localhost
RUN apt -y update \
 && DEBIAN_FRONTEND=noninteractive apt -y install mailutils

RUN useradd netteam \
 && useradd osteam \ 
 && useradd appteam \ 
 && useradd sqlteam \
 && useradd bot
