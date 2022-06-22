FROM catatnight/postfix

# installing mail client just for convenience
# You can send email locally by
# echo "test mail!" | mail -s "test" bot@localhost
ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y update  \
 && apt -y install sudo curl language-pack-ja-base language-pack-ja mailutils \
 && echo 'export LANG=ja_JP.UTF-8' >> ~/.bashrc && echo 'export LANGUAGE="ja_JP:ja"' >> ~/.bashrc

RUN useradd netteam -p pass -m \
 && useradd osteam -p pass -m \ 
 && useradd appteam -p pass -m \ 
 && useradd sqlteam -p pass -m \
 && useradd bot -p pass -m
