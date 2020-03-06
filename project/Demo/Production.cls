Class Demo.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="SQL" Category="sql2sql" ClassName="Demo.Service.SQL" PoolSize="1" Enabled="false" Foreground="false" Comment="SQLレコードを行ごとに転送するだけの処理" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresql</Setting>
    <Setting Target="Adapter" Name="Query">select * from jisseki order by orderid</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">orderid</Setting>
    <Setting Target="Adapter" Name="DeleteQuery">delete from jisseki where orderid=?</Setting>
  </Item>
  <Item Name="SQL2CSV" Category="sql2csv" ClassName="Demo.Service.SQL2CSV" PoolSize="1" Enabled="true" Foreground="false" Comment="SQLレコードを１回の取得毎(複数レコードの可能性あり)にファイルにまとめる処理" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresql</Setting>
    <Setting Target="Adapter" Name="Query">select * from jissekiTrigger order by seq</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">seq</Setting>
    <Setting Target="Adapter" Name="DeleteQuery">delete from jissekiTrigger where seq=?</Setting>
  </Item>
  <Item Name="Postgres1" Category="sql2sql" ClassName="Demo.Operation.SQL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">postgresql</Setting>
  </Item>
  <Item Name="FTPTarget1" Category="ftp" ClassName="EnsLib.FTP.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="FTPPort"></Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Adapter" Name="FilePath">/C:/enstest/demo/out</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">FileGroup</Setting>
  </Item>
  <Item Name="FTPTarget2" Category="ftp" ClassName="EnsLib.FTP.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="FTPPort"></Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Adapter" Name="FilePath">/C:/enstest/demo/out2</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="AlertGroups">FileGroup</Setting>
  </Item>
  <Item Name="FileTransfer" Category="ftp" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">Demo.Rule.FileTransfer</Setting>
    <Setting Target="Host" Name="ForceSyncSend">0</Setting>
    <Setting Target="Host" Name="ResponseFrom">+FTPTarget1,FTPTarget2</Setting>
    <Setting Target="Host" Name="ResponseTargetConfigNames">FileTransferCallBack</Setting>
  </Item>
  <Item Name="FTPSource1" Category="ftp" ClassName="EnsLib.FTP.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/C:/enstest/demo/in</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\enstest\Demo\arc</Setting>
    <Setting Target="Host" Name="TargetConfigNames">FileTransfer</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
  </Item>
  <Item Name="FileTransferCallBack" Category="ftp" ClassName="Demo.Process.FileTransferCallBack" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="EnsLib.RecordMap.Service.FTPService" Category="" ClassName="EnsLib.RecordMap.Service.FTPService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RecordMap">Order</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Postgres1</Setting>
    <Setting Target="Adapter" Name="FilePath">/C:/enstest/demo/in-2sql</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\enstest\Demo\arc</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="HeaderCount">1</Setting>
  </Item>
  <Item Name="EnsLib.RecordMap.Service.BatchFTPService" Category="" ClassName="EnsLib.RecordMap.Service.BatchFTPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RecordMap">Order</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Postgres1</Setting>
    <Setting Target="Adapter" Name="FilePath">/C:/enstest/demo/in-2sql</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\enstest\Demo\arc</Setting>
    <Setting Target="Adapter" Name="Credentials">ftp</Setting>
    <Setting Target="Adapter" Name="FTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="BatchClass">User.Order.Batch</Setting>
    <Setting Target="Host" Name="BatchHandling">Whole</Setting>
  </Item>
</Production>
}

}
