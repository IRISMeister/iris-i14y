FROM store/intersystems/iris-community:2020.1.0.202.0

USER root
RUN apt -y update \
 && DEBIAN_FRONTEND=noninteractive apt -y install unixodbc odbc-postgresql \
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

ENV SRCDIR=src
COPY project/ $SRCDIR/

#; making archive path 777 because depending on how you start your production(via SMP or command line), it uses different O/S user (irisuser/irisowner).
RUN mkdir /var/tmp/arc ; chmod 777 /var/tmp/arc \
 && iris start $ISC_PACKAGE_INSTANCENAME quietly \ 
 && printf 'Do ##class(Config.NLS.Locales).Install("jpuw") Do ##class(Security.Users).UnExpireUserPasswords("*") h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'Set tSC=$system.OBJ.Load("'$HOME/$SRCDIR'/MyInstallerPackage/Installer.cls","ck") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && printf 'Set tSC=##class(MyInstallerPackage.Installer).setup() Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly
