Class Demo.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="AlertNotificationManager">Ens.Alerting.NotificationManager</Setting>
  <Setting Target="Adapter" Name="AlertNotificationOperation">AlertDefault</Setting>
  <Setting Target="Adapter" Name="AlertNotificationRecipients">bot@localhost</Setting>
  <Item Name="SQLReport" Category="custom,sql2sql" ClassName="Demo.Service.SQLReport" PoolSize="1" Enabled="true" Foreground="false" Comment="SQLレコードを行ごとに転送する処理" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query">select * from report3 order by orderid</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">orderid</Setting>
    <Setting Target="Adapter" Name="DeleteQuery">delete from report3 where orderid=?</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="TargetConfigName">ReportRouter</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">SQL</Setting>
  </Item>
  <Item Name="SQLReportBatch" Category="custom,sql2ftp" ClassName="Demo.Service.SQLReportBatch" PoolSize="1" Enabled="true" Foreground="false" Comment="SQLレコードを１回の取得毎(複数レコードの可能性あり)にファイルにまとめる処理" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query">select * from reportTrigger order by seq</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">seq</Setting>
    <Setting Target="Adapter" Name="DeleteQuery">delete from reportTrigger where seq=?</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">SQL</Setting>
  </Item>
  <Item Name="SQLReportBatchODBC" Category="custom,sql2ftp" ClassName="Demo.Service.SQLReportBatch" PoolSize="1" Enabled="false" Foreground="false" Comment="SQLレコードを１回の取得毎(複数レコードの可能性あり)にファイルにまとめる処理" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresql</Setting>
    <Setting Target="Adapter" Name="Query">select * from reportTrigger order by seq</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">seq</Setting>
    <Setting Target="Adapter" Name="DeleteQuery">delete from reportTrigger where seq=?</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">SQL</Setting>
  </Item>
  <Item Name="Postgres1" Category="custom,sql2sql,ftp2sql" ClassName="Demo.Operation.SQL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Host" Name="SkipHeader">1</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">SQL</Setting>
  </Item>
  <Item Name="FTPTarget1PassThrough" Category="ftp2ftp" ClassName="EnsLib.FTP.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="FTPPort"></Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/out_target1</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FTPTarget2PassThrough" Category="ftp2ftp" ClassName="EnsLib.FTP.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="FTPPort"></Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/out_target2</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FileTransferRouter" Category="ftp2ftp" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">Demo.Rule.FileTransferRouter</Setting>
    <Setting Target="Host" Name="ForceSyncSend">0</Setting>
    <Setting Target="Host" Name="ResponseFrom">+FTPTarget1PassThrough,FTPTarget2PassThrough</Setting>
    <Setting Target="Host" Name="ResponseTargetConfigNames">FileTransferRouterCallBack</Setting>
  </Item>
  <Item Name="FTPSource1PassThrough" Category="ftp2ftp" ClassName="EnsLib.FTP.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/upload/demo/in_source1</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/var/tmp/arc</Setting>
    <Setting Target="Host" Name="TargetConfigNames">FileTransferRouter</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FTPSource2PassThrough" Category="ftp2ftp" ClassName="EnsLib.FTP.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/upload/demo/in_source2</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/var/tmp/arc</Setting>
    <Setting Target="Host" Name="TargetConfigNames">FileTransferRouter</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">ftp</Setting>
    <Setting Target="Adapter" Name="Protocol">FTP</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FileTransferRouterCallBack" Category="custom,ftp2ftp" ClassName="Demo.Process.FileTransferRouterCallBack" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="FTPOrderInfo" Category="ftp2sql" ClassName="EnsLib.RecordMap.Service.FTPService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RecordMap">Order</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Postgres1</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/in_order</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/var/tmp/arc</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">ftp</Setting>
    <Setting Target="Adapter" Name="Protocol">FTP</Setting>
    <Setting Target="Host" Name="HeaderCount">1</Setting>
    <Setting Target="Adapter" Name="Charset">utf-8</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FTPOrderInfoBatch" Category="ftp2sql" ClassName="EnsLib.RecordMap.Service.BatchFTPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RecordMap">Order</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Postgres1</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/in_order</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/var/tmp/arc</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">ftp</Setting>
    <Setting Target="Adapter" Name="Protocol">FTP</Setting>
    <Setting Target="Host" Name="BatchClass">User.Order.Batch</Setting>
    <Setting Target="Host" Name="BatchHandling">Whole</Setting>
    <Setting Target="Adapter" Name="Charset">utf-8</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FTPProcess" Category="ftp2sql" ClassName="EnsLib.RecordMap.Service.FTPService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RecordMap">Process</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Postgres1</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/in_process</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/var/tmp/arc</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="HeaderCount">1</Setting>
    <Setting Target="Adapter" Name="Charset">@UTF8</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FTPProcessBatch" Category="ftp2sql" ClassName="EnsLib.RecordMap.Service.BatchFTPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RecordMap">Process</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Postgres1</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/in_process</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/var/tmp/arc</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="BatchClass">User.Process.Batch</Setting>
    <Setting Target="Host" Name="BatchHandling">Whole</Setting>
    <Setting Target="Adapter" Name="Charset">@UTF8</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FTPReportBatch" Category="sql2ftp" ClassName="EnsLib.RecordMap.Operation.BatchFTPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/out_report</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="RecordMap">Report</Setting>
    <Setting Target="Host" Name="Filename">Report-%Q</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FTPReport1" Category="sql2ftp" ClassName="EnsLib.RecordMap.Operation.FTPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/out_report1</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="RecordMap">ReportExtra</Setting>
    <Setting Target="Host" Name="Filename">Report-%Q</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FTPReport2" Category="sql2ftp" ClassName="EnsLib.RecordMap.Operation.FTPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/out_report2</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="RecordMap">ReportExtra</Setting>
    <Setting Target="Host" Name="Filename">Report-%Q</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="FTPReport3" Category="sql2ftp" ClassName="EnsLib.RecordMap.Operation.FTPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/out_report3</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="RecordMap">ReportExtra</Setting>
    <Setting Target="Host" Name="Filename">Report-%Q</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="SQLEntireTable" Category="custom" ClassName="Demo.Service.SQLEntireTable" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query">select * from report2 order by orderid</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">SQL</Setting>
  </Item>
  <Item Name="SQLEntireTableBulk" Category="custom" ClassName="Demo.Service.SQLEntireTableBulk" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query">select 1</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">SQL</Setting>
  </Item>
  <Item Name="EnsLib.JavaGateway.Service" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">LOCAL</Setting>
  </Item>
  <Item Name="FILEOrderInfo" Category="local2local" ClassName="EnsLib.RecordMap.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RecordMap">Order</Setting>
    <Setting Target="Adapter" Name="FilePath">/home/irisowner/upload/local/in_order/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Host" Name="TargetConfigNames">FILEOrderInfoOut</Setting>
    <Setting Target="Host" Name="HeaderCount">1</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">LOCAL</Setting>
  </Item>
  <Item Name="FILEOrderInfoOut" Category="local2local" ClassName="EnsLib.RecordMap.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/home/irisowner/upload/local/out_order/</Setting>
    <Setting Target="Host" Name="RecordMap">Order</Setting>
    <Setting Target="Adapter" Name="Charset">Binary</Setting>
    <Setting Target="Host" Name="Filename">%f</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">LOCAL</Setting>
  </Item>
  <Item Name="ReportRouter" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">Demo.Rule.ReportRouter</Setting>
    <Setting Target="Host" Name="ResponseTargetConfigNames">ReportRouterCallBack</Setting>
    <Setting Target="Host" Name="ResponseFrom">+FTPReport1,FTPReport2,FTPReport3</Setting>
  </Item>
  <Item Name="ReportRouterCallBack" Category="" ClassName="Demo.Process.ReportRouterCallBack" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">Postgres1</Setting>
  </Item>
  <Item Name="SQLReport_update" Category="custom,sql2sql" ClassName="Demo.Service.SQLReport" PoolSize="1" Enabled="true" Foreground="false" Comment="SQLレコードを行ごとに転送する処理" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query">select * from report4 where done=false order by orderid;</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">orderid</Setting>
    <Setting Target="Adapter" Name="DeleteQuery">update report4 Set done=true where orderid=?</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="TargetConfigName">ReportRouter</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">SQL</Setting>
  </Item>
  <Item Name="SQLReport_lastkey" Category="custom,sql2sql" ClassName="Demo.Service.SQLReport" PoolSize="1" Enabled="true" Foreground="false" Comment="SQLレコードを行ごとに転送する処理" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query"><![CDATA[select * from report5 where seq>? order by seq]]></Setting>
    <Setting Target="Adapter" Name="KeyFieldName">seq</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="TargetConfigName">ReportRouter</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[&%LastKey]]></Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">SQL</Setting>
  </Item>
  <Item Name="AccessLocalDB" Category="custom" ClassName="Demo.Service.AccessLocalDB" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="FTPCustom" Category="custom" ClassName="Demo.Operation.FTPCustom" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">ftp</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/out_custom</Setting>
    <Setting Target="Adapter" Name="Charset">utf-8</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="XMLPerson" Category="xmlvdoc" ClassName="EnsLib.EDI.XML.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="DocSchemaCategory">person</Setting>
    <Setting Target="Adapter" Name="FilePath">/home/irisowner/upload/xmlvdoc/in_person</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.xml</Setting>
    <Setting Target="Adapter" Name="Charset">UTF-8</Setting>
    <Setting Target="Host" Name="TargetConfigNames">XMLVDocRouter</Setting>
    <Setting Target="Host" Name="Validation">1</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">LOCAL</Setting>
  </Item>
  <Item Name="XMLOrder" Category="xmlvdoc" ClassName="EnsLib.EDI.XML.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="Person=personの意味は...ルートノード&lt;Person&gt;をxml schema category &apos;person&apos;にマッピングするの意" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="DocSchemaCategory">order</Setting>
    <Setting Target="Adapter" Name="FilePath">/home/irisowner/upload/xmlvdoc/in_order</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.xml</Setting>
    <Setting Target="Adapter" Name="Charset">UTF-8</Setting>
    <Setting Target="Host" Name="TargetConfigNames">XMLVDocRouter</Setting>
    <Setting Target="Host" Name="Validation">1</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">LOCAL</Setting>
  </Item>
  <Item Name="XMLNoSchema" Category="xmlvdoc" ClassName="EnsLib.EDI.XML.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="DocSchemaCategory"></Setting>
    <Setting Target="Adapter" Name="FilePath">/home/irisowner/upload/xmlvdoc/in_noschema</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.xml</Setting>
    <Setting Target="Adapter" Name="Charset">UTF-8</Setting>
    <Setting Target="Host" Name="TargetConfigNames">XMLVDocNoSchemaRouter</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">LOCAL</Setting>
  </Item>
  <Item Name="XMLVDocRouter" Category="xmlvdoc" ClassName="EnsLib.MsgRouter.VDocRoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation">dm</Setting>
    <Setting Target="Host" Name="BusinessRuleName">Demo.Rule.VDocRoutingEngineRoutingRule</Setting>
    <Setting Target="Host" Name="ResponseTargetConfigNames"></Setting>
  </Item>
  <Item Name="XMLVDocNoSchemaRouter" Category="xmlvdoc" ClassName="EnsLib.MsgRouter.VDocRoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation">m</Setting>
    <Setting Target="Host" Name="BusinessRuleName">Demo.Rule.VDocRoutingEngineRoutingRuleNoSchema</Setting>
    <Setting Target="Host" Name="ResponseTargetConfigNames"></Setting>
    <Setting Target="Host" Name="RuleLogging">r</Setting>
  </Item>
  <Item Name="XMLOut" Category="xmlvdoc" ClassName="EnsLib.EDI.XML.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/home/irisowner/upload/xmlvdoc/out/</Setting>
    <Setting Target="Adapter" Name="Charset">!UTF-8</Setting>
    <Setting Target="Host" Name="Filename">%f_%Q</Setting>
    <Setting Target="Host" Name="Format">n</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">LOCAL</Setting>
  </Item>
  <Item Name="XMLIgnored" Category="xmlvdoc" ClassName="EnsLib.EDI.XML.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/home/irisowner/upload/xmlvdoc/ignored/</Setting>
    <Setting Target="Adapter" Name="Charset">!UTF-8</Setting>
    <Setting Target="Host" Name="Filename">%f_%Q</Setting>
    <Setting Target="Host" Name="Format">n</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">LOCAL</Setting>
  </Item>
  <Item Name="SendMail" Category="mail,custom" ClassName="Demo.Operation.SendMail" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SMTPPort">25</Setting>
    <Setting Target="Adapter" Name="SMTPServer">smtp</Setting>
    <Setting Target="Adapter" Name="Credentials">smtp</Setting>
    <Setting Target="Adapter" Name="From">iris</Setting>
    <Setting Target="Adapter" Name="Recipient">root@localhost</Setting>
  </Item>
  <Item Name="SendMailExt" Category="mail,custom" ClassName="Demo.Operation.SendMail" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">mail-yahoo</Setting>
    <Setting Target="Adapter" Name="SMTPPort">465</Setting>
    <Setting Target="Adapter" Name="SMTPServer">smtp.mail.yahoo.co.jp</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="From">iris</Setting>
    <Setting Target="Adapter" Name="Recipient">root@localhost</Setting>
  </Item>
  <Item Name="RESTPassThrough" Category="" ClassName="EnsLib.REST.GenericService" PoolSize="0" Enabled="false" Foreground="false" Comment="Doesn&apos;t work" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">FileTransferRouter</Setting>
    <Setting Target="Host" Name="PersistInProcData">0</Setting>
    <Setting Target="Host" Name="KeepCSPPartition">0</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">NET</Setting>
  </Item>
  <Item Name="EnsLib.EMail.AlertOperation" Category="alert,mail" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SMTPPort">25</Setting>
    <Setting Target="Adapter" Name="SMTPServer">smtp</Setting>
    <Setting Target="Adapter" Name="Credentials">smtp</Setting>
    <Setting Target="Adapter" Name="From">iris</Setting>
    <Setting Target="Host" Name="IncludeDetails">1</Setting>
    <Setting Target="Host" Name="IncludeNodeinSubject">1</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="alert" ClassName="Ens.Alerting.AlertManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="CreateManagedAlertRule">Demo.Rule.ManagedAlert</Setting>
    <Setting Target="Host" Name="AlertGroups"></Setting>
  </Item>
  <Item Name="Ens.Alerting.NotificationManager" Category="alert" ClassName="Ens.Alerting.NotificationManager" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="NotificationTransform">Demo.DTL.NotifyManager</Setting>
  </Item>
  <Item Name="AlertDefault" Category="alert,custom" ClassName="Demo.Operation.AlertDefault" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Alert" Category="alert,custom" ClassName="Demo.Operation.Alert" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Direct" Category="custom" ClassName="Demo.Service.Direct" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Rest" Category="custom" ClassName="Demo.Operation.Rest" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="URL">/csp/demo/rest/repo</Setting>
    <Setting Target="Adapter" Name="Credentials">rest</Setting>
  </Item>
  <Item Name="SimpleSendMail" Category="custom" ClassName="Demo.Process.SimpleSendMail" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="SQLMultipleTables" Category="custom" ClassName="Demo.Service.SQLMultipleTables" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query">select 1</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Host" Name="AlertGroups">SQL</Setting>
  </Item>
  <Item Name="dc.demo.imap.python.IMAPPyTestService" Category="mail,custom" ClassName="dc.demo.imap.python.IMAPPyTestService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="POP3Port">993</Setting>
    <Setting Target="Adapter" Name="POP3Server">imap.mail.yahoo.co.jp</Setting>
    <Setting Target="Adapter" Name="Credentials">mail-yahoo</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Mailbox">INBOX</Setting>
    <Setting Target="Adapter" Name="CallInterval">30</Setting>
    <Setting Target="Adapter" Name="MatchSubject">[IMAP test]</Setting>
  </Item>
</Production>
}

/// Override this in your Production class to do setup before the Production starts
ClassMethod OnStart(pTimeStarted As %String) As %Status
{
  // Secretを使用しているため、コンテナ環境でしか機能しない。
  // fileに実際のファイル名(my_secret.txt)を絶対パスで指定すれば非コンテナ環境でも使用可能。
  Set tSC=$$$OK
  Try {
    Set file="/run/secrets/my_secret"
    Set stream = ##class(%Stream.FileCharacter).%New()
    Set sc = stream.LinkToFile(file)
    Set json = {}.%FromJSON(stream)
    Set tSC=##class(Ens.Config.Credentials).SetCredential(json.CredName,json.UserName,json.Password,1)
	}
	Catch e {
		Set tSC=e.AsStatus()
	}
  //必須ではないので常に成功させる
	Return $$$OK
}

}
