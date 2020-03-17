# InterSystems IRIS インターオペラビリティ機能の紹介
InterSystems IRIS, postgresql, SFTPサーバ,FTPサーバ用のコンテナを使用した、InterSystems IRISの相互運用性(Interoperability)の例です。アダプタの使用方法にフォーカスしています。  
Ubuntu 18.04 LTS 上にて動作確認済み。

## 起動前提条件
下記のイメージ実行が成功する環境であること。
```bash
$ sudo docker run hello-world
```
See https://docs.docker.com/install/linux/docker-ce/ubuntu/


## 起動方法
git clone直後の初回起動時は、DockerイメージのPull,ビルドが発生するため、若干(2,3分程度)の時間を要します。
```bash
$ git clone https://github.com/IRISMeister/iris-i14y.git
$ cd iris-i14y
$ docker-compose up -d
$ docker-compose ps
        Name                      Command                       State                                   Ports
--------------------------------------------------------------------------------------------------------------------------------------
iris-i14y_ftp_1        /bin/sh -c /run.sh -l pure ...   Up                      0.0.0.0:2121->21/tcp, 0.0.0.0:30000->30000/tcp,
                                                                                0.0.0.0:30001->30001/tcp, 0.0.0.0:30002->30002/tcp,
                                                                                0.0.0.0:30003->30003/tcp, 0.0.0.0:30004->30004/tcp,
                                                                                0.0.0.0:30005->30005/tcp, 0.0.0.0:30006->30006/tcp,
                                                                                0.0.0.0:30007->30007/tcp, 0.0.0.0:30008->30008/tcp,
                                                                                0.0.0.0:30009->30009/tcp
iris-i14y_iris_1       /iris-main                       Up (health: starting)   0.0.0.0:51773->51773/tcp, 0.0.0.0:52773->52773/tcp
iris-i14y_postgres_1   docker-entrypoint.sh postgres    Up                      0.0.0.0:5432->5432/tcp
iris-i14y_sftp_1       /entrypoint foo:pass:1000:1000   Up                      0.0.0.0:2222->22/tcp
$
```

なお、既存のプロダクションレディなネームスペース環境(以下の実行例ではDEMO)に、IRISの要素だけをインポートしたい場合、第１引数(ファイルパス)をgit cloneを実施した場所に読み替えた上で、下記のコマンドを実行してください。この場合、postgres,sftpコンテナへの接続、odbcドライバのインストールや設定は別途マニュアル操作で実施する必要があります。
```ObjectScript
Windows
DEMO>d $SYSTEM.OBJ.LoadDir("c:\temp\iris-i14y\project\","ck",.e,1)
Linux
DEMO>d $SYSTEM.OBJ.LoadDir("/var/tmp/iris-i14y/project/","ck",.e,1)
```

以下、コンテナを起動したホストのIPをlinuxとします。  

## 管理ポータルへのアクセス
http://linux:52773/csp/sys/%25CSP.Portal.Home.zen  
ユーザ名:SuperUser  
パスワード:SYS

## 停止/再開/削除方法
```bash
$ docker-compose stop
$ docker-compose start
$ docker-compose down -v
```
## ユースケース
|#|入力元|処理|出力先|備考|
|:--|:--|:--|:--|:--|
|1|in_order/order.txt|FTP経由でのフォルダ監視及びファイルの取得。CSVの行をRDB上のレコードに編成。Postgresに対してINSERT実行|orderinfoレコード|単独メッセージ処理とバッチによる処理の2種類があります。|
|2|in_process/process.txt|1と同様の処理を異なる入力ファイル、出力先テーブルに対して実行。|processレコード|異なるReccordMapを定義・使用することで、同類の処理を容易に複製可能であることを示す例です。|
|3|reportTriggerテーブル| Postgresに対してSELECTを定期的に実行。RDB上のレコードをCSVに編成。FTP経由でファイルを出力。|out_report/*|バッチによる処理を行います。|
|4|in_source1/*.txt| FTP経由でのフォルダ監視及びファイルの取得。FileTransferのRule定義にしたがって、送信先を決定。FTP経由でファイルを出力。|out_target1/*|受信ファイルをパススルーで送信する例です。ファイル内容は任意です。|
|5|reportテーブル| Postgresに対してSELECTを定期的に実行。Postgresに対してINSERT実行。|reportTargetレコード|レコードの複製処理を行います。この仕組みは、CSV出力のように複数メッセージをまとめる必要がある処理には向いていません。|
|6|report2テーブル| Postgresに対してSELECTを定期的に実行。|なし|3,5のケースと異なり、毎回全レコードを取得する例です。単独メッセージ処理とバッチによる処理の2種類があります。|

## ビジネスホスト一覧
BS:ビジネスサービス,BP:ビジネスプロセス,BO:ビジネスオペレーション  
カスタムとは、カスタムコーディングを伴うもの

|ビジネスホスト名|BH|カスタム|クラス|アダプタ|I/O|処理概要|ユースケース|
|:--|:--|:--|:--|:--|:--|:--|:--|
|FTPOrderInfo|BS|No|EnsLib.RecordMap.Service.FTPService|FTP|I|in_orderフォルダ監視、ファイル取得、Orderメッセージ作成|1|
|FTPOrderInfoBatch|BS|No|EnsLib.RecordMap.Service.BatchFTPService|FTP|I|in_orderフォルダ監視、ファイル取得、バッチ用Orderメッセージ作成|1|
|FTPProcess|BS|No|EnsLib.RecordMap.Service.FTPService|FTP|I|in_processフォルダ監視、ファイル取得、Processメッセージ作成|2|
|FTPProcessBatch|BS|No|EnsLib.RecordMap.Service.BatchFTPService|FTP|I|in_processフォルダ監視、ファイル取得、バッチ用Processメッセージ作成|2|
|FTPSource1PathThrough|BS|No|EnsLib.FTP.PassthroughService|FTP|I|in_source1フォルダ監視、ファイル取得、パススルー用メッセージ作成|4|
|SQLReport|BS|Yes|Demo.Service.SQL|SQL|I|reportレコード監視、reportレコード取得、Reportメッセージ作成|5|
|SQLReportBatch|BS|Yes|Demo.Service.SQL2CSV|SQL|I|reportTriggerレコード監視、reportレコード取得、バッチ用Reportメッセージ作成|3|
|FileTransfer|BP|No|EnsLib.MsgRouter.RoutingEngine||I/O|Rule適用,オペレーションへの送信|4|
|FileTransferCallBack|BP|Yes|Demo.Process.FileTransferCallBack||I/O|(オプション)オペレーションからの戻り値のテスト|4|
|FTPReport|BO|No|EnsLib.RecordMap.Operation.BatchFTPOperation|FTP|O|Reportファイルの作成、FTP出力|3|
|FTPTarget1PathThrough|BO|No|EnsLib.FTP.PassthroughOperation|FTP|O|受信ファイルから送信用ファイルを複製、FTP出力|4|
|FTPTarget2PathThrough|BO|No|EnsLib.FTP.PassthroughOperation|FTP|O|同上|4|
|Postgres1|BO|Yes|Demo.Operation.SQL|SQL|O|受信メッセージに従ったINSERT文の組み立て,PostgresへのレコードのINSERT|1,2,5|
|SQLEntireTable|BS|Yes|Demo.Service.SQLEntireTable|SQL|I|report2レコード監視、reportレコード取得|6|
|SQLEntireTableBulk|BS|Yes|Demo.Service.SQLEntireTableBulk|SQL|I|仮想レコード監視(select 1)、report2レコード取得|6|

下記URLにて閲覧可能です。  
プロダクション画面  
http://linux:52773/csp/demo/EnsPortal.ProductionConfig.zen?$NAMESPACE=DEMO&$NAMESPACE=DEMO  
インターフェースマップ  
http://linux:52773/csp/demo/EnsPortal.InterfaceMaps.zen?$NAMESPACE=DEMO&$NAMESPACE=DEMO

## RecordMap一覧

下記のRecordMapを定義・使用しています。  
|RecordMap名|生成クラス|生成バッチクラス|ユースケース|使用しているビジネスホスト名|
|:--|:--|:--|:--|:--|
|User.Order|User.Order.Record|User.Order.Batch|1|FTPOrderInfo,FTPOrderInfoBatch,Postgres1|
|User.Process|User.Process.Record|User.Process.Batch|2|FTPProcess,FTPProcessBatch,Postgres1|
|User.Report|User.Report.Record|User.Report.Batch|3,5,6|SQLReport,SQLReportBatch,Postgres1|

下記URLにて閲覧可能です。  
http://linux:52773/csp/demo/EnsPortal.RecordMapper.cls?MAP=User.Order&SHOWSAMPLE=1

## FTP Inboud処理について
FTP Inboundアダプタは下記の入力を受け付けます。  

```bash
$ pwd
/home/user1/git/iris-i14y
$ cd upload/demo
$ cp order.txt in_order/
$ cp process.txt in_process/
$ cp source1_1.txt in_source1/
$ cp source1_2.txt in_source1/
```
cp order.txt in_order/ を実行することで、ユースケース1が動作します。その結果、postgresql上にorderinfoレコードがINSERTされます。ファイルや対象フォルダなどが異なるだけで、ユースケース2も同様です。
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
SQL>
```
```SQL
SQL> select * from orderinfo;
+------------+------------+------------+
| orderid    | data1      | data2      |
+------------+------------+------------+
| 1          | 100        | 200        |
| 2          | 101        | 201        |
| 3          | 102        | 202        |
+------------+------------+------------+
SQLRowCount returns 3
3 rows fetched
SQL> [リターン押下で終了]
$ 
```

下記の設定を変更することで、受信元のサーバをSFTPからFTPに変更することが出来ます。
FTPサーバ:SFTP->FTP
接続の設定/Protocol:SFTP->FTP

## FTP Outboud処理について
下記の設定を変更することで、送信先のサーバをSFTPからFTPに変更することが出来ます。
FTPサーバ:SFTP->FTP
接続の設定/Protocol:SFTP->FTP

## SQL Inboud処理について
### バッチ処理
SQLReportBatchは下記の入力を受け付けます。このレコードの発生がトリガとなり、データ(reportレコード)の取得処理が発動します。取得処理完了時に該当reportTriggerレコードは削除されます。
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
SQL>
```
```SQL
SQL> INSERT INTO reportTrigger VALUES (1);
```
これでユースケース3が動作します。その結果、sftp上(ホストにボリュームマウントしてあるのでout_report/下)にファイルが作成されます。
```bash
$ ls out_report/
Report-2020-03-11_14.43.35.468.txt
$ cat out_report/Report-2020-03-11_14.43.35.468.txt
1       10      20
2       11      21
3       12      22
$
```

### 単独メッセージ処理
SQLReport(初期状態では無効化[グレーアイコン]されています)は下記の入力を受け付けます。これらのレコードの発生がトリガとなり、データ(reportレコード)の取得処理が発動します。取得処理完了時に該当reportレコードは削除されます。
```SQL
SQL> INSERT INTO report VALUES (1,1,10,20);
SQL> INSERT INTO report VALUES (1,2,11,21);
SQL> INSERT INTO report VALUES (1,3,12,22);
```
これでユースケース5が動作します。その結果,postgresql上にreportTargetレコードがINSERTされます。  

## その他
### プロダクションの初期化
下記のコマンドで、プロダクションを、初期化した上で再起動することができます。ポータルでの起動・停止と異なり、プロダクションの状態のリセット、蓄積したメッセージ、ログを削除します。
```bash
docker-compose exec iris iris session iris -U demo init
```
### 各コンテナへのアクセス方法

InterSystems IRIS 
```bash
$ docker-compose exec iris bash
irisowner@iris:~$ iris session iris -U demo

ノード: iris インスタンス: IRIS

DEMO>
DEMO>D ^init
```
See https://hub.docker.com/_/intersystems-iris-data-platform  
See https://docs.intersystems.com/iris20191j/csp/docbook/DocBook.UI.Page.cls?KEY=AFL_containers

PostgreSQL
```bash
$ docker-compose exec postgres bash
bash-5.0# psql -U postgres demo
psql (12.2)
Type "help" for help.

demo=# select * from report;
 seq | orderid | data1 | data2
-----+---------+-------+-------
   1 |       1 |    10 |    20
   1 |       2 |    11 |    21
   1 |       3 |    12 |    22
(3 rows)

demo=#
```
See https://hub.docker.com/_/postgres  
注) 本イメージは起動時にデータベース保存エリア用のvolumeを作成します。停止時に-vを指定しないと、このvolumeがディスク上に残ります。

SFTPサーバ
```bash
$ docker-compose exec sftp bash
root@sftp:/#
root@sftp:/# cd /home/foo/upload/demo/
root@sftp:/home/foo/upload/demo# ls
in_order    in_source1  out_report   out_target2  report.txt     source1_2.txt
in_process  order.txt   out_target1  process.txt  source1_1.txt
root@sftp:/home/foo/upload/demo#
```
See https://hub.docker.com/r/atmoz/sftp/

FTPサーバ
```bash
$ docker-compose exec ftp bash
root@ftp:/# cd /home/foo/upload/demo/
root@ftp:/home/foo/upload/demo# ls
in_order    in_source1  out_report   out_target2  report.txt     source1_2.txt
in_process  order.txt   out_target1  process.txt  source1_1.txt
root@ftp:/home/foo/upload/demo#
```
See https://hub.docker.com/r/stilliard/pure-ftpd/