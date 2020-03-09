# The simplest demo of IRIS Interoperability

|ビジネスホスト名|カスタム|クラス|使用アダプタ|In/Out|処理概要|
|:--|:--|:--|:--|:--|:--|
|FTPOrderInfo|No|EnsLib.RecordMap.Service.FTPService|FTP|In|aaa|
|FTPOrderInfoBatch|No|EnsLib.RecordMap.Service.BatchFTPService|FTP|In|aaa|

FTP Inboundアダプタは下記の入力を受け付けます。  

```bash
$ cd upload/demo
$ cp order.txt in_order/
$ cp process.txt in_process/
$ cp source1_1.txt in_source1/
$ cp source1_2.txt in_source1/
$ cp report.txt in_report/
```

SQL Inboundアダプタは下記の入力を受け付けます。  
```bash
$ docker-compose exec iris isql postgresql
+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL> insert into reportTrigger values (1);
```



reset everything and restart production
docker-compose exec iris iris session iris -U demo init
