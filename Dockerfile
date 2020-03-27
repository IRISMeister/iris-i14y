FROM store/intersystems/iris-community:2020.1.0.209.0

USER root

# Japanese language pack (optional)
RUN apt -y update \
 && DEBIAN_FRONTEND=noninteractive apt -y install language-pack-ja-base language-pack-ja ibus-mozc 

# odbc/jdbc related 
RUN DEBIAN_FRONTEND=noninteractive apt -y install unixodbc odbc-postgresql openjdk-8-jre \
 && apt clean

COPY odbc .

# register psql data source. Doing some tricks to make it work
RUN odbcinst -i -s -l -f odbc.ini \
 && mv $ISC_PACKAGE_INSTALLDIR/mgr/irisodbc.ini $ISC_PACKAGE_INSTALLDIR/mgr/irisodbc.ini.org \
 && cp odbc.ini $ISC_PACKAGE_INSTALLDIR/mgr/irisodbc.ini \
 && cd $ISC_PACKAGE_INSTALLDIR/bin \
 && mv odbcgateway.so odbcgateway.so.org \
 && cp odbcgatewayur64.so odbcgateway.so\
 && mv liblber-2.4.so.2 liblber-2.4.so.2.org \
 && mv libldap-2.4.so.2 libldap-2.4.so.2.org \
 && ln -s /usr/lib/x86_64-linux-gnu/liblber-2.4.so.2 liblber-2.4.so.2 \
 && ln -s /usr/lib/x86_64-linux-gnu/libldap-2.4.so.2 libldap-2.4.so.2 

USER irisowner
# download postgresql jdbc driver
RUN wget https://jdbc.postgresql.org/download/postgresql-42.2.11.jar \
 && echo 'export LANG=ja_JP.UTF-8' >> ~/.bashrc && echo 'export LANGUAGE="ja_JP:ja"' >> ~/.bashrc

ENV SRCDIR=src
COPY project/ $SRCDIR/

#; making archive path 777 because depending on how you start your production(via SMP or command line), it uses different O/S user (irisuser/irisowner).
RUN mkdir /var/tmp/arc ; chmod 777 /var/tmp/arc \
 && iris start $ISC_PACKAGE_INSTANCENAME quietly \ 
 && printf 'Do ##class(Config.NLS.Locales).Install("jpuw") Do ##class(Security.Users).UnExpireUserPasswords("*") h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'Set tSC=$system.OBJ.Load("'$HOME/$SRCDIR'/MyInstallerPackage/Installer.cls","ck") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && printf 'Set tSC=##class(MyInstallerPackage.Installer).setup() Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly

RUN iris start $ISC_PACKAGE_INSTANCENAME nostu quietly \
 && printf "kill ^%%SYS(\"JOURNAL\") kill ^SYS(\"NODE\") h\n" | iris session $ISC_PACKAGE_INSTANCENAME -B | cat \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly bypass \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/* \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log

ARG COMMIT_ID="unknown"
RUN echo $COMMIT_ID > $HOME/commit.txt