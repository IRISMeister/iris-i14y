# The simplest demo of IRIS Interoperab
IRIS Data platform, postgresql, sftpサーバ用のコンテナを使用した、IRIS DPの相互運用性(Interoperability)の例です。アダプタの使用例に主眼をおいています。

## 起動方法
```bash
$ docker-compose up -d
```
## 停止方法
```bash
$ docker-compose down
```
## ユースケース
### ユースケース1

入力元: order.txt  
IRIS DPでの処理:  
FTP経由でのフォルダ(in_order)の監視及びファイルの取込  
CSVの行をRDB上のレコードに編成  
Postgresに対してINSERT実行  
出力先: orderテーブル  
単独メッセージ処理とバッチによる処理の2種類があります。

### ユースケース2
process.txtについて、1)と同様の処理()を実行します。  
監視対象はin_processフォルダ  
出力先はprocessテーブル  
異なるReccordMapを定義・使用することで、同類の処理を容易に複製可能であることを示す例です。

### ユースケース3
入力元: reportテーブル  
IRIS DPでの処理:  
Postgresに対してSELECTを定期的に実行  
RDB上のレコードをCSVに編成  
FTP経由でファイルを出力  
出力先: out_reportフォルダのcsvファイル  
単独メッセージ処理とバッチによる処理の2種類があります。

## ビジネスホスト一覧
|ビジネスホスト名|カスタム|クラス|アダプタ|I/O|処理概要|
|:--|:--|:--|:--|:--|:--|
|FTPOrderInfo|No|EnsLib.RecordMap.Service.FTPService|FTP|I|aaa|
|FTPOrderInfoBatch|No|EnsLib.RecordMap.Service.BatchFTPService|FTP|I|aaa|
|FTPProcess|No|EnsLib.RecordMap.Service.FTPService|FTP|I|aaa|
|FTPProcessBatch|No|EnsLib.RecordMap.Service.BatchFTPService|FTP|I|aaa|
|FTPSource1PathThrough|No|EnsLib.FTP.PassthroughService|FTP|I|aaa|
|SQLReport|Yes|Demo.Service.SQL|SQL|I|aaa|
|SQLReportBatch|Yes|Demo.Service.SQL2CSV|SQL|I|複数の入力レコードをまとめて処理する例|
|FileTransfer|No|EnsLib.MsgRouter.RoutingEngine||I/O|aaa|
|FileTransferCallBack|Yes|Demo.Process.FileTransferCallBack||I/O|aaa|
|FTPReport|No|EnsLib.RecordMap.Operation.BatchFTPOperation|FTP|O|aaa|
|FTPTarget1PathThrough|No|EnsLib.FTP.PassthroughOperation|FTP|O|aaa|
|FTPTarget2PathThrough|No|EnsLib.FTP.PassthroughOperation|FTP|O|同上|
|Postgres1|Yes|Demo.Operation.SQL|SQL|O|aaa|

## FTP Inboud処理について
FTP Inboundアダプタは下記の入力を受け付けます。  

```bash
$ cd upload/demo
$ cp order.txt in_order/
$ cp process.txt in_process/
$ cp source1_1.txt in_source1/
$ cp source1_2.txt in_source1/
$ cp report.txt in_report/
```

## SQL Inboud処理について
### SQLReportBatchは下記の入力を受け付けます。このレコードの発生がトリガとなり、データ(reportテーブル)の取得処理が発動します。取得処理完了時に該当reportTriggerレコードは削除されます。
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
```
```SQL
SQL> INSERT INTO reportTrigger VALUES (1);
```
### SQLReportは下記の入力を受け付けます。これらのレコードの発生がトリガとなり、データ(reportテーブル)の取得処理が発動します。取得処理完了時に該当reportレコードは削除されます。
```SQL
SQL> INSERT INTO report VALUES (1,1,10,20);
SQL> INSERT INTO report VALUES (1,2,11,21);
SQL> INSERT INTO report VALUES (1,3,12,22);
```

## その他
下記のコマンドで、プロダクションの状態を完全にリセットし、メッセージやログを削除した上で、再起動することができます。
```bash
docker-compose exec iris iris session iris -U demo init
```