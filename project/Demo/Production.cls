Class Demo.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="SQLReport" Category="custom,sql2sql" ClassName="Demo.Service.SQLReport" PoolSize="1" Enabled="false" Foreground="false" Comment="SQLレコードを行ごとに転送する処理" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query">select * from report order by orderid</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">orderid</Setting>
    <Setting Target="Adapter" Name="DeleteQuery">delete from report where orderid=?</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
  </Item>
  <Item Name="SQLReportBatch" Category="custom,sql2ftp" ClassName="Demo.Service.SQLReportBatch" PoolSize="1" Enabled="true" Foreground="false" Comment="SQLレコードを１回の取得毎(複数レコードの可能性あり)にファイルにまとめる処理" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query">select * from reportTrigger order by seq</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">seq</Setting>
    <Setting Target="Adapter" Name="DeleteQuery">delete from reportTrigger where seq=?</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
  </Item>
  <Item Name="SQLReportBatchODBC" Category="custom,sql2ftp" ClassName="Demo.Service.SQLReportBatch" PoolSize="1" Enabled="false" Foreground="false" Comment="SQLレコードを１回の取得毎(複数レコードの可能性あり)にファイルにまとめる処理" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresql</Setting>
    <Setting Target="Adapter" Name="Query">select * from reportTrigger order by seq</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">seq</Setting>
    <Setting Target="Adapter" Name="DeleteQuery">delete from reportTrigger where seq=?</Setting>
  </Item>
  <Item Name="Postgres1" Category="custom,sql2sql,ftp2sql" ClassName="Demo.Operation.SQL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Host" Name="SkipHeader">1</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
  </Item>
  <Item Name="FTPTarget1PathThrough" Category="ftp2ftp" ClassName="EnsLib.FTP.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="FTPPort"></Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/out_target1</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">FileGroup</Setting>
  </Item>
  <Item Name="FTPTarget2PathThrough" Category="ftp2ftp" ClassName="EnsLib.FTP.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="FTPPort"></Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/out_target2</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">FileGroup</Setting>
  </Item>
  <Item Name="FileTransfer" Category="ftp2ftp" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">Demo.Rule.FileTransfer</Setting>
    <Setting Target="Host" Name="ForceSyncSend">0</Setting>
    <Setting Target="Host" Name="ResponseFrom">+FTPTarget1,FTPTarget2</Setting>
    <Setting Target="Host" Name="ResponseTargetConfigNames">FileTransferCallBack</Setting>
  </Item>
  <Item Name="FTPSource1PathThrough" Category="ftp2ftp" ClassName="EnsLib.FTP.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/upload/demo/in_source1</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/var/tmp/arc</Setting>
    <Setting Target="Host" Name="TargetConfigNames">FileTransfer</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
  </Item>
  <Item Name="FileTransferCallBack" Category="custom,ftp2ftp" ClassName="Demo.Process.FileTransferCallBack" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
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
  </Item>
  <Item Name="FTPReport" Category="sql2ftp" ClassName="EnsLib.RecordMap.Operation.BatchFTPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FTPServer">sftp</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FilePath">/upload/demo/out_report</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="RecordMap">Report</Setting>
    <Setting Target="Host" Name="Filename">Report-%Q</Setting>
  </Item>
  <Item Name="SQLEntireTable" Category="custom" ClassName="Demo.Service.SQLEntireTable" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query">select * from report2 order by orderid</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
  </Item>
  <Item Name="SQLEntireTableBulk" Category="custom" ClassName="Demo.Service.SQLEntireTableBulk" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresqljdbc</Setting>
    <Setting Target="Adapter" Name="Query">select 1</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
  </Item>
  <Item Name="EnsLib.JavaGateway.Service" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
