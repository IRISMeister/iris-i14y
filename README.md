# InterSystems IRIS インターオペラビリティ機能の紹介
## 概要
InterSystems IRIS, postgresql, SFTPサーバ,FTPサーバ用のコンテナを使用した、InterSystems IRISの相互運用性(Interoperability)の例です。アダプタの使用方法にフォーカスしています。使用するファイルはUTF8エンコードを前提にしています。  
Ubuntu 18.04 LTS + Docker CE 19.03.7, Windows10 + Docker Desdktop 2.2.0.4(43472) にて動作確認済み。

## 起動前提条件
下記のイメージ実行が成功する環境であること。
```bash
$ sudo docker run hello-world
```
See https://docs.docker.com/install/linux/docker-ce/ubuntu/

docker-composeを導入済みであること。  

See https://docs.docker.com/compose/install/

## 起動方法
初回起動時のみイメージpullのために`docker-compose pull`を実行します。若干(2,3分程度)の時間を要します。  
```bash
$ git clone https://github.com/IRISMeister/iris-i14y.git
$ cd iris-i14y
$ docker-compose pull
```
注)明示的にpullせずにupすると、IRIS関連のイメージのビルドが実行されます。proxy設定など、正しく構成されたdocker環境であれば、ビルドは正常に完了します。デモ実行目的であればビルドは必要ありません。

2回目以降の起動時
```bash
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
非docker環境への適用  
非docker環境の既存のIRISインスタンスに、IRISの構成要素だけを導入する事が可能です。以下、Git Repositoryを/home/user1/git/以下にcloneしたと仮定します。  
注)IRIS for Windowsの場合も同様です。パス指定方法をWindowsスタイルに読み替えてください。  

```ObjectScript
USER>d $SYSTEM.OBJ.Load("/home/user1/git/iris-i14y/project/MyInstallerPackage/Installer.cls","ck")
USER>Set tVars("SRCDIR")="/home/user1/git/iris-i14y/project"
USER>d ##class(MyInstallerPackage.Installer).setup(.tVars) 
```

あるいは、既存のプロダクションが有効なネームスペース環境(以下の実行例ではDEMO)に、IRISの構成要素だけをインポートしたい場合、下記のコマンドを実行してください。この場合、認証情報の作成,postgres,sftp/ftpなど各サービスへの接続情報、odbc/jdbcドライバのインストールやDSN作成/設定などは別途マニュアル操作で実施する必要があります。
```ObjectScript
USER>zn "DEMO"
DEMO>d $SYSTEM.OBJ.ImportDir("/home/user1/git/iris-i14y/project/","*","ck",.e,1)
```

以下、コンテナを起動した環境のホスト名をirishostとします。  

## 管理ポータルへのアクセス
http://irishost:52773/csp/sys/%25CSP.Portal.Home.zen  
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
|3|reportTriggerテーブル| Postgresに対してSELECTを定期的に実行。reportテーブルのレコードをCSVに編成。FTP経由でファイルを出力。|out_report/*|バッチによる処理を行います。|
|4|in_source1/*.txt| FTP経由でのフォルダ監視及びファイルの取得。FileTransferのRule定義にしたがって、送信先を決定。FTP経由でファイルを出力。|out_target1/*|受信ファイルをパススルーで送信する例です。ファイル内容は任意です。|
|5|report3テーブル| Postgresに対してSELECTを定期的に実行。その内容から作成したファイルを送信。ファイル送信結果をPostgresに対してINSERT実行。|out_report1/*,<br>out_report2/*,<br>out_report3/*,<br>reportresultレコード|Router,Rule,DTLを使用した例です。FTPへの送信が成功したか否かを確認するためにレスポンス・ターゲット構成を使用しています。その確認結果をPostgresに記録します。|
|6|report2テーブル| Postgresに対してSELECTを定期的に実行。|なし|3,5のケースと異なり、毎回全レコードを取得する例です。単独メッセージ処理とバッチによる処理の2種類があります。|
|7|local/in_order/order.txt|フォルダ監視及びファイルの取得。個々のレコードの内容をフォルダに対して出力|orderinfoレコード|処理ロジックは異なりますが、出力ファイル名を入力ファイル名と同一にしてある(個々のレコードの内容が同一ファイルにアペンドされる)ため、パススルーと同様の結果が得られます。|
## ビジネスホスト一覧
BS:ビジネスサービス,BP:ビジネスプロセス,BO:ビジネスオペレーション  
ビジネスホスト名がリンクされているものはカスタムコーディングを伴うもの  

|ビジネスホスト名|クラス|アダプタ|I/O|処理概要|ユースケース|
|:--|:--|:--|:--|:--|:--|
|BS/FTPOrderInfo|EnsLib.RecordMap.Service.FTPService|FTP|I|in_orderフォルダ監視、ファイル取得、Orderメッセージ作成|1|
|BS/FTPOrderInfoBatch|EnsLib.RecordMap.Service.BatchFTPService|FTP|I|in_orderフォルダ監視、ファイル取得、バッチ用Orderメッセージ作成|1|
|BS/FTPProcess|EnsLib.RecordMap.Service.FTPService|SFTP|I|in_processフォルダ監視、ファイル取得、Processメッセージ作成|2|
|BS/FTPProcessBatch|EnsLib.RecordMap.Service.BatchFTPService|SFTP|I|in_processフォルダ監視、ファイル取得、バッチ用Processメッセージ作成|2|
|BS/FTPSource1PathThrough|EnsLib.FTP.PassthroughService|SFTP|I|in_source1フォルダ監視、ファイル取得、パススルー用メッセージ作成|4|
|BS/[SQLReport](project/Demo/Service/SQLReport.cls)|Demo.Service.SQLReport|JDBC|I|reportレコード監視、reportレコード取得、Reportメッセージ作成|5|
|BS/[SQLReportBatch](project/Demo/Service/SQLReportBatch.cls)|Demo.Service.SQLReportBatch|JDBC|I|reportTriggerレコード監視、reportレコード取得、バッチ用Reportメッセージ作成|3|
|BS/[SQLReportBatchODBC](project/Demo/Service/SQLReportBatch.cls)|Demo.Service.SQLReportBatch|ODBC|I|SQLReportBatchのODBC接続版。|3|
|BP/FileTransferRouter|EnsLib.MsgRouter.RoutingEngine||I/O|Rule適用,オペレーションへの送信|4|
|BP/[FileTransferRouterCallBack](project/Demo/Process/FileTransferRouterCallBack.cls)|Demo.Process.FileTransferRouterCallBack||I/O|(オプション)オペレーションからの戻り値のテスト|4|
|BP/ReportRouter|EnsLib.MsgRouter.RoutingEngine||I/O|Rule適用,オペレーションへの送信|5|
|BP/[ReportRouterCallBack](project/Demo/Process/ReportRouterCallBack.cls)|Demo.Process.ReportRouterCallBack||I/O|(オプション)オペレーションからの戻り値のテスト。戻り値をBOに送信|5|
|BO/FTPReportBatch|EnsLib.RecordMap.Operation.BatchFTPOperation|SFTP|O|Reportファイルの作成、FTP出力|3|
|BO/FTPTarget1PathThrough|EnsLib.FTP.PassthroughOperation|SFTP|O|受信ファイルから送信用ファイルを複製、FTP出力|4|
|BO/FTPTarget2PathThrough|EnsLib.FTP.PassthroughOperation|SFTP|O|同上|4|
|BO/[Postgres1](project/Demo/Operation/SQL.cls)|Demo.Operation.SQL|JDBC|O|受信メッセージに従ったINSERT文の組み立て,PostgresへのレコードのINSERT|1,2,5|
|BS/[SQLEntireTable](project/Demo/Service/SQLEntireTable.cls)|Demo.Service.SQLEntireTable|JDBC|I|report2レコード監視、reportレコード取得|6|
|BS/[SQLEntireTableBulk](project/Demo/Service/SQLEntireTableBulk.cls)|Demo.Service.SQLEntireTableBulk|JDBC|I|仮想レコード監視(select 1)、report2レコード取得|6|
|BS/FileOrderInfo|EnsLib.RecordMap.Service.FileService|File|I|in_orderフォルダ監視、ファイル取得、Orderメッセージ作成|7|
|BO/FileOrderInfoOut|EnsLib.RecordMap.Operation.FileOperation|File|O|Orderファイルの作成|7|
|BO/FTPReport1|EnsLib.RecordMap.Operation.FTPOperation|SFTP|O|Reportファイルの作成、FTP出力|5|
|BO/FTPReport2|EnsLib.RecordMap.Operation.FTPOperation|SFTP|O|Reportファイルの作成、FTP出力|5|
|BO/FTPReport3|EnsLib.RecordMap.Operation.FTPOperation|SFTP|O|Reportファイルの作成、FTP出力|5|

プロダクションに関する情報は下記URLにて閲覧可能です。  
プロダクション画面  
http://irishost:52773/csp/demo/EnsPortal.ProductionConfig.zen?$NAMESPACE=DEMO&$NAMESPACE=DEMO  
インターフェースマップ  
http://irishost:52773/csp/demo/EnsPortal.InterfaceMaps.zen?$NAMESPACE=DEMO&$NAMESPACE=DEMO


## ビジネスホスト以外の主な構成要素  
CTX:BPコンテキストスーパークラス, DTL:データ変換, Rule:ルール

|要素|クラス|処理概要|ユースケース|
|:--|:--|:--|:--|
|CTX|[Demo.Context.ReportRouter](project/Demo/Context/ReportRouter.cls)|BP/ReportRouterCallBackにて使用。BP/ReportRouterの[レスポンスターゲット構成]設定経由のBOからのメッセージを処理。BOにメッセージを送信。|5|
|Rule|[Demo.Rule.ReportRouter](project/Demo/Rule/ReportRouter.cls)|BP/ReportRouterで適用されるRule。|5|
|DTL|[Demo.DTL.Report2ReportExtra](project/Demo/DTL/Report2ReportExtra.cls)|BP/ReportRouterで適用されるRuleで変換処理を担う。|5|

## ビジネスルール一覧
下記のビジネスルールを定義・使用しています。  

|ルール名|備考|Link|
|:--|:--|:--|
|Demo.Rule.FileTransferRouter|ファイル送信先を決定|[Link](http://irishost:52773/csp/demo/EnsPortal.RuleEditor.zen?RULE=Demo.Rule.FileTransferRouter)|
|Demo.Rule.ReportRouter|ファイル送信先を決定|[Link](http://irishost:52773/csp/demo/EnsPortal.RuleEditor.zen?RULE=Demo.Rule.ReportRouter)|

## 認証情報一覧
下記の認証情報を定義・使用しています。  
|ID|ユーザ名|パスワード|用途|
|:--|:--|:--|:--|
|ftp|foo|pass|SFTP/FTPサーバへのログイン|

下記URLにて閲覧可能です。  
http://irishost:52773/csp/demo/EnsPortal.Credentials.zen?$NAMESPACE=DEMO

## RecordMap一覧
下記のRecordMapを定義・使用しています。  
|RecordMap名|生成クラス|生成バッチクラス|ユースケース|使用しているビジネスホスト名|
|:--|:--|:--|:--|:--|
|User.Order|User.Order.Record|User.Order.Batch|1|FTPOrderInfo,FTPOrderInfoBatch,Postgres1|
|User.Process|User.Process.Record|User.Process.Batch|2|FTPProcess,FTPProcessBatch,Postgres1|
|User.Report|User.Report.Record|User.Report.Batch|3,5,6|SQLReport,SQLReportBatch,Postgres1|
|User.ReportExtra|User.Report.RecordExtra|User.ReportExtra.Batch|5|FTPReport1,FTPReport2,FTPReport3|

下記URLにて閲覧可能です。  
http://irishost:52773/csp/demo/EnsPortal.RecordMapper.cls?MAP=User.Order&SHOWSAMPLE=1

## SQL Gateway接続
下記のSQL Gateway接続を定義・使用しています。  

|接続名|備考|
|:--|:--|
|postgresqljdbc|postgresqlへのJDBC接続情報|
|mysqljdbc|MySQLへのJDBC接続情報|
|oraclejdbc|oracleへのJDBC接続情報|

http://irishost:52773/csp/sys/mgr/UtilSqlGateway.csp?$ID1=1&$ID2=postgresqljdbc&$NAMESPACE=DEMO

ODBC接続については、[直接データソース定義](odbc/odbc.ini)を参照しているので、SQL Gateway接続の定義はありません。

## FTP Inboud処理について
FTP Inboundアダプタは下記の入力を受け付けます。  

```bash
$ cd upload/demo
$ cp order.txt in_order/
$ cp process.txt in_process/
$ cp source1_1.txt in_source1/
$ cp source1_2.txt in_source1/
```
cp order.txt in_order/ を実行することで、ユースケース1が動作します。その結果、postgresql上にorderinfoレコードがINSERTされます。ファイルや対象フォルダなどが異なるだけで、ユースケース2も同様です。
```bash
$ docker-compose exec iris isql postgresql -v
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
SQL> SELECT * FROM orderinfo;
+------------+------------+------------+---------------------+
| orderid    | data1      | data2      | memo                |
+------------+------------+------------+---------------------+
| 1          | 100        | 200        | abc                 |
| 2          | 101        | 201        | 日本語           |
| 3          | 102        | 202        | ｱｲｳｴｵ     |
+------------+------------+------------+---------------------+
SQLRowCount returns 3
3 rows fetched
SQL> [リターン押下で終了]
$ 
```

## FTP Outboud処理について

## SQL Inboud処理について
### バッチ処理
SQLReportBatchは下記の入力を受け付けます。このレコードの発生がトリガとなり、データ(reportレコード)の取得処理が発動します。取得処理完了時に該当reportTriggerレコードは削除されます。
```bash
$ docker-compose exec iris isql postgresql -v
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
1       10      20      abc
2       11      21      日本語
3       12      22      ｱｲｳｴｵ
$
```

### 単独メッセージ処理
SQLReportは下記の入力を受け付けます。これらのレコードの発生がトリガとなり、データ(report3レコード)の取得処理が発動します。取得処理完了時には[削除クエリ]設定により、該当report3レコードは削除されます。
```SQL
SQL> INSERT INTO report3 VALUES (1,4,10,20,'aaa');
SQL> INSERT INTO report3 VALUES (1,5,11,21,'bbb');
SQL> INSERT INTO report3 VALUES (1,6,12,22,'ccc');
```
これでユースケース5が動作します。その結果,postgresql上にreportresultレコードがINSERTされます。  
```SQL
SQL> SELECT * FROM reportresult
+---------------------------+-----------------+------------+------------+------------+
| logtimestamp              | target          | orderid    | data1      | result     |
+---------------------------+-----------------+------------+------------+------------+
| 2020-04-08 13:48:38.307145| FTPReport1      | 4          | 10         | 1          |
| 2020-04-08 13:48:38.3138  | FTPReport3      | 4          | 10         | 1          |
| 2020-04-08 13:48:38.341635| FTPReport2      | 4          | 10         | 1          |
+---------------------------+-----------------+------------+------------+------------+
SQLRowCount returns 3
3 rows fetched
```

## File Inboud処理について
BSのFileOrderInfoはFile Inboundアダプタを使用しており、下記の入力を受け付けます。  
```bash
$ cd upload/local
$ cp order.txt in_order/
```
結果はBOのFileOrderInfoOutを通じてファイルに出力されます。  
注)このBOでは出力ファイル名として%f(元のファイル名)を使用しています。そのため、入力ファイル名が同一であれば、メッセージが複数に分かれていても、同じ出力ファイルにアペンドされていきます。

## その他
### プロダクションの初期化
下記のコマンドで、プロダクションを、初期化した上で再起動することができます。ポータルでの起動・停止と異なり、プロダクションの状態のリセット、蓄積したメッセージ、ログを削除します。
```bash
$ docker-compose exec iris iris session iris -U demo init
```
### 各コンテナへのアクセス方法

* InterSystems IRIS 
```bash
$ docker-compose exec iris bash
irisowner@iris:~$ iris session iris -U demo

ノード: iris インスタンス: IRIS

DEMO>
DEMO>D ^init
```
See https://hub.docker.com/_/intersystems-iris-data-platform  
See https://docs.intersystems.com/iris20191j/csp/docbook/DocBook.UI.Page.cls?KEY=AFL_containers  
下記にて、本イメージに対応するgitのコミットIDを確認できます。
```bash
irisowner@iris:~$ cat commit.txt
588bb28703223be6fc91a04e41549e7d683c70c4
```
* PostgreSQL
```bash
$ docker-compose exec postgres bash
bash-5.0# psql -U postgres demo
psql (12.2)
Type "help" for help.

demo-# \dt
             List of relations
 Schema |     Name      | Type  |  Owner
--------+---------------+-------+----------
 public | mytable       | table | postgres
 public | orderinfo     | table | postgres
 public | process       | table | postgres
 public | report        | table | postgres
 public | report2       | table | postgres
 public | report3       | table | postgres
 public | reportresult  | table | postgres
 public | reporttarget  | table | postgres
 public | reporttrigger | table | postgres
(9 rows)

demo=# select * from report;
 seq | orderid | data1 | data2 |  memo
-----+---------+-------+-------+--------
   1 |       1 |    10 |    20 | abc
   1 |       2 |    11 |    21 | 日本語
   1 |       3 |    12 |    22 | ｱｲｳｴｵ
(3 rows)

demo=#
```
See https://hub.docker.com/_/postgres  
注) 本イメージは起動時にデータベース保存エリア用のvolumeを作成します。停止時に-vを指定しないと、このvolumeがディスク上に残ります。
* SFTPサーバ
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
SFTPサーバにおける文字エンコードの制限  
SFTPで扱うファイルの文字エンコードはLinuxではUTF8に統一するのが好ましいです。WindowsでIRISを稼働させる場合、SJIS以外の日本語文字を含むファイルの処理は、可能ですが、IRISのシステムロケールの変更やカスタムコーディング([Demo.Service.MyFTPService](project/Demo/Service/MyFTPService.cls))が必要になります。  
パススルー処理(ユースケース4)は、このような文字エンコードによる影響を受けません。

* FTPサーバ
```bash
$ docker-compose exec ftp bash
root@ftp:/# cd /home/foo/upload/demo/
root@ftp:/home/foo/upload/demo# ls
in_order    in_source1  out_report   out_target2  report.txt     source1_2.txt
in_process  order.txt   out_target1  process.txt  source1_1.txt
root@ftp:/home/foo/upload/demo#
```
See https://hub.docker.com/r/stilliard/pure-ftpd/

* MySQL  

起動方法  
```bash
$ docker-compose -f docker-compose.yml -f docker-compose-mysql.yml up -d
```
アクセス方法  
```bash
$ docker-compose -f docker-compose.yml -f docker-compose-mysql.yml exec mysql bash
root@mysql:/# mysql -u root -p
Enter password:SYS
mysql>
root@mysql:/# mysql -u demo -p demo
Enter password:demo
mysql> select * from report;
+------+---------+-------+-------+-------------------+
| seq  | orderid | data1 | data2 | memo              |
+------+---------+-------+-------+-------------------+
|    1 |       1 |    10 |    20 | abc               |
|    1 |       2 |    11 |    21 | NoJapanesePreset  |
|    1 |       3 |    12 |    22 | NoJapanesePreset2 |
+------+---------+-------+-------+-------------------+
3 rows in set (0.02 sec)

mysql>
```
See https://hub.docker.com/_/mysql  
注) 本イメージは起動時にデータベース保存エリアとして、ホストシステムの./mysql/dataを使用します。

* Oracle データベースサーバ  

事前準備  
下記の方法で、事前にイメージをビルドしておく必要があります。選択したEditionに相当するイメージ名をdocker-compose-oracle.ymlに反映してください。  
https://github.com/oracle/docker-images/blob/master/OracleDatabase/SingleInstance/README.md
Oracle JDBC Driver(ojdbc8.jarなど)をjars/直下に配置してください。

起動方法  
```bash
$ docker-compose -f docker-compose.yml -f docker-compose-oracle.yml up -d
```
アクセス方法  
```bash
$ docker-compose -f docker-compose.yml -f docker-compose-oracle.yml exec oracle bash
[oracle@oracle ~]$ sqlplus demo/demo@//localhost:1521/ORCLPDB1
SQL> select * from report;
       SEQ    ORDERID      DATA1      DATA2 MEMO
---------- ---------- ---------- ---------- ---------------------
         1          1         10         20 abc
         1          2         11         21 NoJapanesePreset
         1          3         12         22 NoJapanesePreset2
SQL>
```
コンテナDBへの接続  
```
[oracle@oracle ~]$ sqlplus sys/SYS@//localhost:1521/ORCLCDB as sysdba
```
