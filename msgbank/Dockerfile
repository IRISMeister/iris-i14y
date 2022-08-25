FROM containers.intersystems.com/intersystems/iris-community:2022.1.0.209.0

USER root

# Japanese language pack (optional)
RUN apt -y update \
 && DEBIAN_FRONTEND=noninteractive apt -y install language-pack-ja-base language-pack-ja ibus-mozc \
 && apt clean

USER irisowner

ENV SRCDIR=src
COPY src/ $SRCDIR/

# making archive path 777 because depending on how you start your production(via SMP or command line), it uses different O/S user (irisuser/irisowner).
RUN mkdir /var/tmp/arc ; chmod 777 /var/tmp/arc \
 && iris start $ISC_PACKAGE_INSTANCENAME quietly \ 
 && printf 'Do ##class(Config.NLS.Locales).Install("jpuw") Do ##class(Security.Users).UnExpireUserPasswords("*") h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'Set tSC=$system.OBJ.Load("'$HOME/$SRCDIR'/MyInstallerPackage/Installer.cls","ck") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && printf 'Set tSC=##class(MyInstallerPackage.Installer).setup() Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly

# clean up
RUN iris start $ISC_PACKAGE_INSTANCENAME nostu quietly \
 && printf "kill ^%%SYS(\"JOURNAL\") kill ^SYS(\"NODE\") h\n" | iris session $ISC_PACKAGE_INSTANCENAME -B | cat \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly bypass \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/* \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log \
 && touch $ISC_PACKAGE_INSTALLDIR/mgr/messages.log

ARG COMMIT_ID="unknown"
RUN echo $COMMIT_ID > $HOME/commit.txt