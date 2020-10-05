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
非docker環境の既存のIRISインスタンスに、IRISの構成要素だけを導入する事が可能です。以下、Git Repositoryを/home/user1/git/(Winodwsの場合、c:\home\user1\git\)下にcloneしたと仮定します。  
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

以下、コンテナを起動した環境のホスト名を***irishost***と仮定します。プロダクションへのリンクは、このホスト名を使用しています。

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
|3|reportTriggerテーブル| Postgresに対してSELECTを定期的に実行。reportテーブルのレコードをCSVに編成。FTP経由でファイルを出力。|out_report/|バッチによる処理を行います。|
|4|in_source1/*.txt| FTP経由でのフォルダ監視及びファイルの取得。FileTransferのRule定義にしたがって、送信先を決定。FTP経由でファイルを出力。|out_target1/,<br>out_target2/*|受信ファイルをパススルーで送信する例です。ファイル内容は任意です。|
|5|report3テーブル| Postgresに対してSELECTを定期的に実行。取得したレコードは、再取得されないよう[削除クエリ]によりDELETEする例。その内容から作成したファイルを送信。ファイル送信結果をPostgresに対してINSERT実行。|out_report1/,<br>out_report2/,<br>out_report3/,<br>reportresultレコード|Router,Rule,DTLを使用した例です。FTPへの送信が成功したか否かを確認するためにレスポンス・ターゲット構成を使用しています。その確認結果をPostgresに記録します。|
|5a|report4テーブル| 5と同じ。取得したレコードは、再取得されないよう、[削除クエリ]によりUPDATEする例。|||
|5b|report5テーブル| 5と同じ。取得したレコードは、再取得されないよう、seqを純増する値と見なし、[パラメータ]として%LastKeyを使用する例。|||
|6|report2テーブル| Postgresに対して全件取得するSELECTを定期的に実行。|なし|3,5のケースと異なり、毎回全レコードを取得する例です。単独メッセージ処理とバッチによる処理の2種類があります。|
|7|local/in_order/order.txt|フォルダ監視及びファイルの取得。個々のレコードの内容をフォルダに対して出力|local/out_order/|処理ロジックは異なりますが、出力ファイル名を入力ファイル名と同一にしてある(個々のレコードの内容が同一ファイルにアペンドされる)ため、パススルーと同様の結果が得られます。|
|8|xmlvdoc/in_order/order.xml|VDOCを使用したフォルダ監視及びXMLファイルの取得。内容をフォルダに対して出力|xmlvdoc/out/|スキーマ定義があるXMLファイルのハンドリング|
|8a|xmlvdoc/in_person/person.xml|8と同じ。|xmlvdoc/out/|スキーマ定義があるXMLファイルのハンドリング|
|8b|xmlvdoc/in_order/order.xml,<br>xmlvdoc/in_person/person.xml,<br>xmlvdoc/in_person/person-noschema.xml,|8と同じ。|xmlvdoc/out/,<br>xmlvdoc/ignored/|スキーマ定義が無いXMLファイルのハンドリング|
## ビジネスホスト一覧
BS:ビジネスサービス,BP:ビジネスプロセス,BO:ビジネスオペレーション  
ビジネスホスト名がリンクされているものはカスタムコーディングを伴うもの  

|ビジネスホスト名|クラス|アダプタ|I/O|処理概要|ユースケース|
|:--|:--|:--|:--|:--|:--|
|BS/FTPOrderInfo|EnsLib.RecordMap.Service.FTPService|FTP|I|in_orderフォルダ監視、ファイル取得、Orderメッセージ作成|1|
|BS/FTPOrderInfoBatch|EnsLib.RecordMap.Service.BatchFTPService|FTP|I|in_orderフォルダ監視、ファイル取得、バッチ用Orderメッセージ作成|1|
|BS/FTPProcess|EnsLib.RecordMap.Service.FTPService|SFTP|I|in_processフォルダ監視、ファイル取得、Processメッセージ作成|2|
|BS/FTPProcessBatch|EnsLib.RecordMap.Service.BatchFTPService|SFTP|I|in_processフォルダ監視、ファイル取得、バッチ用Processメッセージ作成|2|
|BS/FTPSource1PassThrough|EnsLib.FTP.PassthroughService|SFTP|I|in_source1フォルダ監視、ファイル取得、パススルー用メッセージ作成|4|
|BS/SQLEntireTable|[Demo.Service.SQLEntireTable](project/Demo/Service/SQLEntireTable.cls)|JDBC|I|report2レコード監視、report2レコード取得|6|
|BS/SQLEntireTableBulk|[Demo.Service.SQLEntireTableBulk](project/Demo/Service/SQLEntireTableBulk.cls)|JDBC|I|仮想レコード監視(select 1)、report2レコード取得|6|
|BS/SQLReport|[Demo.Service.SQLReport](project/Demo/Service/SQLReport.cls)|JDBC|I|report3レコード監視、report3レコード取得、Reportメッセージ作成|5|
|BS/SQLReport_update|[Demo.Service.SQLReport](project/Demo/Service/SQLReport.cls)|JDBC|I|report4レコード監視、report4レコード取得、Reportメッセージ作成|5a|
|BS/SQLReport_lastkey|[Demo.Service.SQLReport](project/Demo/Service/SQLReport.cls)|JDBC|I|report5レコード監視、report5レコード取得、Reportメッセージ作成|5b|
|BS/SQLReportBatch|[Demo.Service.SQLReportBatch](project/Demo/Service/SQLReportBatch.cls)|JDBC|I|reportTriggerレコード監視、reportレコード取得、バッチ用Reportメッセージ作成|3|
|BS/SQLReportBatchODBC|[Demo.Service.SQLReportBatch](project/Demo/Service/SQLReportBatch.cls)|ODBC|I|SQLReportBatchのODBC接続版。|3|
|BS/FILEOrderInfo|EnsLib.RecordMap.Service.FileService|File|I|in_orderフォルダ監視、ファイル取得、Orderメッセージ作成|7|
|BS/XMLOrder|EnsLib.EDI.XML.Service.FileService|File|I|xmlvdoc/in_orderフォルダ監視、ファイル取得、EnsLib.EDI.XML.Documentメッセージ作成|8|
|BS/XMLPerson|EnsLib.EDI.XML.Service.FileService|File|I|xmlvdoc/in_personフォルダ監視、ファイル取得、EnsLib.EDI.XML.Documentメッセージ作成|8a|
|BS/XMLNoSchema|EnsLib.EDI.XML.Service.FileService|File|I|xmlvdoc/in_noschemaフォルダ監視、ファイル取得、EnsLib.EDI.XML.Documentメッセージ作成|8b|
|BS/AccessLocalDB|[Demo.Service.AccessLocalDB](project/Demo/Service/AccessLocalDB.cls)||N/A|一定時間間隔でローカルデータベースをアクセスする例。||
|BP/FileTransferRouter|EnsLib.MsgRouter.RoutingEngine||I/O|Rule適用,オペレーションへの送信|4|
|BP/FileTransferRouterCallBack|[Demo.Process.FileTransferRouterCallBack](project/Demo/Process/FileTransferRouterCallBack.cls)||I/O|(オプション)オペレーションからの戻り値のテスト|4|
|BP/ReportRouter|EnsLib.MsgRouter.RoutingEngine||I/O|Rule適用,オペレーションへの送信|5|
|BP/ReportRouterCallBack|[Demo.Process.ReportRouterCallBack](project/Demo/Process/ReportRouterCallBack.cls)||I/O|(オプション)オペレーションからの戻り値のテスト。戻り値をBOに送信|5|
|BP/XMLVDocRouter|EnsLib.MsgRouter.VDocRoutingEngine||I/O|Rule適用,オペレーションへの送信|8,8a|
|BP/XMLVDocNoSchemaRouter|EnsLib.MsgRouter.VDocRoutingEngine||I/O|Rule適用,オペレーションへの送信|8b|
|BO/FTPReportBatch|EnsLib.RecordMap.Operation.BatchFTPOperation|SFTP|O|Reportファイルの作成、FTP出力|3|
|BO/FTPTarget1PassThrough|EnsLib.FTP.PassthroughOperation|SFTP|O|受信ファイルから送信用ファイルを複製、FTP出力|4|
|BO/FTPTarget2PassThrough|EnsLib.FTP.PassthroughOperation|SFTP|O|同上|4|
|BO/Postgres1|[Demo.Operation.SQL](project/Demo/Operation/SQL.cls)|JDBC|O|受信メッセージに従ったINSERT文の組み立て,PostgresへのレコードのINSERT|1,2,5|
|BO/FILEOrderInfoOut|EnsLib.RecordMap.Operation.FileOperation|File|O|Orderファイルの作成|7|
|BO/XMLOut|EnsLib.EDI.XML.Operation.FileOperation|File|O|O\order.xml,person.xmlファイルの作成|8,8a,8b|
|BO/XMLIgnored|EnsLib.EDI.XML.Operation.FileOperation|File|O|order.xml,person.xml,person-noschema.xmlファイルの作成|8b|
|BO/FTPReport1|EnsLib.RecordMap.Operation.FTPOperation|SFTP|O|Reportファイルの作成、FTP出力|5|
|BO/FTPReport2|EnsLib.RecordMap.Operation.FTPOperation|SFTP|O|Reportファイルの作成、FTP出力|5|
|BO/FTPReport3|EnsLib.RecordMap.Operation.FTPOperation|SFTP|O|Reportファイルの作成、FTP出力|5|
|BO/FTPCustom|[Demo.Operation.FTPCustom](project/Demo/Operation/FTPCustom.cls)|FTP|O|FTPへのNameList(),GetStream(),PutStream()実行例||

プロダクションに関する情報は下記URLにて閲覧可能です。  
プロダクション画面  
http://irishost:52773/csp/demo/EnsPortal.ProductionConfig.zen?$NAMESPACE=DEMO&$NAMESPACE=DEMO  
インターフェースマップ  
http://irishost:52773/csp/demo/EnsPortal.InterfaceMaps.zen?$NAMESPACE=DEMO&$NAMESPACE=DEMO


## ビジネスホスト以外の主な構成要素  
CTX:BPコンテキストスーパークラス, DTL:データ変換

|要素|クラス|処理概要|ユースケース|
|:--|:--|:--|:--|
|CTX|[Demo.Context.ReportRouter](project/Demo/Context/ReportRouter.cls)|BP/ReportRouterCallBackにて使用。BP/ReportRouterの[レスポンスターゲット構成]設定経由のBOからのメッセージを処理。BOにメッセージを送信。|5|
|DTL|[Demo.DTL.Report2ReportExtra](project/Demo/DTL/Report2ReportExtra.cls)|BP/ReportRouterで適用されるRuleで変換処理を担う。|5|

## ビジネスルール一覧
下記のビジネスルールを定義・使用しています。  

|ルール名|用途|Link|ユースケース|
|:--|:--|:--|:--|
|[Demo.Rule.FileTransferRouter](project/Demo/Rule/FileTransferRouter.cls)|ファイル送信先を決定|[Link](http://irishost:52773/csp/demo/EnsPortal.RuleEditor.zen?RULE=Demo.Rule.FileTransferRouter)||
|[Demo.Rule.ReportRouter](project/Demo/Rule/ReportRouter.cls)|BP/ReportRouterで適用されるRule。ファイル送信先を決定|[Link](http://irishost:52773/csp/demo/EnsPortal.RuleEditor.zen?RULE=Demo.Rule.ReportRouter)|5|
|[Demo.Rule.VDocRoutingEngineRoutingRule](project/Demo/Rule/VDocRoutingEngineRoutingRule.cls)|スキーマ依存パスを使用したconditionによりファイル送信先を決定|[Link](http://irishost:52773/csp/demo/EnsPortal.RuleEditor.zen?RULE=Demo.Rule.VDocRoutingEngineRoutingRule)|8,8a|
|[Demo.Rule.VDocRoutingEngineRoutingRuleNoSchema](project/Demo/Rule/VDocRoutingEngineRoutingRuleNoSchema.cls)|DOMスタイルパスを使用したconditionによりファイル送信先を決定|[Link](http://irishost:52773/csp/demo/EnsPortal.RuleEditor.zen?RULE=Demo.Rule.VDocRoutingEngineRoutingRuleNoSchema)|8b|


スキーマ依存パスについて  
https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=EXML_schema_path  
DOMスタイルパスについて  
https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=EXML_dom_path

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

下記URLにて閲覧可能です。  
http://irishost:52773/csp/sys/mgr/UtilSqlGateway.csp?$ID1=1&$ID2=postgresqljdbc&$NAMESPACE=DEMO

ODBC接続については、[直接データソース定義](odbc/odbc.ini)を参照しているので、SQL Gateway接続の定義はありません。

## XMLスキーマ
下記のXMLスキーマを定義・使用しています。  

|カテゴリ|用途|xsd|
|:--|:--|:--|
|order|ファイル入力時のXMLバリデーション及び、ルール内でのスキーマ依存パスの使用|[order.xsd](resources/order.xsd)|
|person|ファイル入力時のXMLバリデーション及び、ルール内でのスキーマ依存パスの使用|[person.xsd](resources/person.xsd)|

下記URLにて閲覧可能です。  
http://irishost:52773/csp/demo/EnsPortal.EDI.XML.SchemaMain.zen?$NAMESPACE=DEMO

## ユースケース1,2の実行方法
ftp/sftpコンテナ内のフォルダは、ローカルホストのupload/demoフォルダにボリュームマウントしてありますので、下記の実行例のようにローカルのフォルダへの読み書きによる操作・確認が可能です。
```bash
$ cd upload/demo
cp order.txt in_order/ 
```
を実行することで、ユースケース1が動作します。その結果、postgresql上にorderinfoレコードがINSERTされます。下記コマンドにて確認可能です。
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
ファイル、入力フォルダ、出力先テーブル名が異なるだけで、ユースケース2も同様です。
```bash
cp process.txt in_process/ 
```
```SQL
SQL> SELECT * FROM orderinfo;
```
## ユースケース4の実行方法
```bash
$ cd upload/demo
$ cp source1_1.txt in_source1/
$ cp source1_2.txt in_source1/
```
を実行することで、ユースケース4が動作します。その結果、out_target1/もしくはout_target2/直下にファイルがputされます。下記コマンドにて確認可能です。
```bash
$ ls out_target1/
source1_1.txt_2020-04-17_17.45.05.230
$ ls out_target2/
source1_2.txt_2020-04-17_17.45.35.278
$
```
## ユースケース3の実行方法
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
を実行することで、ユースケース3が動作します。このレコードの発生がトリガとなり、データ(reportレコード)の取得処理が発動します。取得処理完了時に該当reportTriggerレコードは削除されます。その結果、out_report/直下にファイルが作成されます。下記コマンドにて確認可能です。

```bash
$ ls out_report/
Report-2020-03-11_14.43.35.468.txt
$ cat out_report/Report-2020-03-11_14.43.35.468.txt
1       10      20      abc
2       11      21      日本語
3       12      22      ｱｲｳｴｵ
$
```
```SQL
SQL> SELECT * FROM reportTrigger;
+------------+
| seq        |
+------------+
+------------+
SQLRowCount returns 0
```
## ユースケース5の実行方法
```SQL
SQL> INSERT INTO report3 VALUES (1,4,10,20,'aaa');
SQL> INSERT INTO report3 VALUES (1,5,11,21,'bbb');
SQL> INSERT INTO report3 VALUES (1,6,12,1000,'ccc');
```
を実行することで、ユースケース5が動作します。これらのレコードの発生がトリガとなり、データ(report3レコード)の取得処理が発動します。取得処理完了時には[削除クエリ]設定により、該当report3レコードは削除されます。その結果,postgresql上にreportresultレコードがINSERTされます。下記コマンドにて確認可能です。
```SQL
SQL> SELECT * FROM reportresult;
+---------------------------+----------------+------------+------------+------------+
| logtimestamp              | target         | orderid    | data1      | result     |
+---------------------------+----------------+------------+------------+------------+
| 2020-04-17 17:18:29.013665| FTPReport1     | 4          | 10         | 1          |
| 2020-04-17 17:18:29.025803| FTPReport3     | 4          | 10         | 1          |
| 2020-04-17 17:18:29.035715| FTPReport2     | 4          | 10         | 1          |
| 2020-04-17 17:19:44.157413| FTPReport1     | 5          | 11         | 1          |
| 2020-04-17 17:19:44.171595| FTPReport2     | 5          | 11         | 1          |
| 2020-04-17 17:19:44.183336| FTPReport3     | 5          | 11         | 1          |
| 2020-04-17 17:19:49.221722| FTPReport3     | 6          | 12         | 1          |
| 2020-04-17 17:19:49.237931| FTPReport2     | 6          | 12         | 1          |
| 2020-04-17 17:19:49.243853| FTPReport1     | 6          | 12         | 1          |
+---------------------------+----------------+------------+------------+------------+
SQLRowCount returns 9
9 rows fetched
SQL> SELECT * FROM report3;
+------------+------------+------------+------------+---------------------+
| seq        | orderid    | data1      | data2      | memo                |
+------------+------------+------------+------------+---------------------+
+------------+------------+------------+------------+---------------------+
SQLRowCount returns 0
```

## ユースケース7の実行方法
ftp/sftpの場合とは、ファイルを操作するフォルダが異なりますので、ご注意ください。
```bash
$ cd upload/local
$ cp order.txt in_order/
```
を実行することで、ユースケース7が動作します。その結果、out_order/直下にファイルが作成されます。下記コマンドにて確認可能です。
```bash
$ ls out_order/
order.txt
$ cat out_order/order.txt
1       100     200     abc
2       101     201     日本語
3       102     202     ｱｲｳｴｵ
$
```
注)この例では出力ファイル名として%f(元のファイル名)を使用しています。そのため、入力ファイル名が同一であれば、メッセージが複数に分かれていても、同じ出力ファイルにアペンドされていきます。
```bash
$ cp order.txt in_order/
$ cat out_order/order.txt
1       100     200     abc
2       101     201     日本語
3       102     202     ｱｲｳｴｵ
1       100     200     abc
2       101     201     日本語
3       102     202     ｱｲｳｴｵ
```
## ユースケース8の実行方法
ftp/sftpの場合とは、ファイルを操作するフォルダが異なりますので、ご注意ください。

スキーマ定義を伴う(EnsLib.EDI.XML.Service.FileServiceにおいてDocSchemaCategoryの指定がある)例。(8,8a)
```bash
$ cd upload/xmlvdoc
$ cp order.xml in_order/
$ cp person.xml in_person/
```
を実行することで、ユースケースXが動作します。その結果、out/直下にファイルが作成されます。下記コマンドにて確認可能です。
```bash
$ ls out/
order.xml_2020-06-09_16.34.37.521  person.xml_2020-06-09_17.06.59.279
$
```
また、これらのスキーマがValidであることを下記コマンドにて確認できます。
```bash
$ xmllint --schema ../../resources/order.xsd order.xml -noout
$ xmllint --schema ../../resources/person.xsd person.xml -noout
```

スキーマ定義を伴わない例。(8b)
```bash
$ cd upload/xmlvdoc
$ cp order.xml in_noschema/
$ cp person.xml in_noschema/
$ cp person-noschema.xml in_noschema/
```
を実行することで、ユースケースXが動作します。その結果、out/もしくはignored/直下にファイルが作成されます。どちらのフォルダに保存されるかは、ルールにて決定されます。  
下記コマンドにて確認可能です。
```bash
$ ls out/
person-noschema.xml_2020-06-09_17.49.21.605  person.xml_2020-06-09_17.47.36.666
$ ls ignored/
order.xml_2020-06-09_17.48.01.563
$
```

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
mysql> SHOW VARIABLES LIKE '%char%';
+--------------------------+--------------------------------+
| Variable_name            | Value                          |
+--------------------------+--------------------------------+
| character_set_client     | utf8                           |
| character_set_connection | utf8                           |
| character_set_database   | utf8                           |
| character_set_filesystem | binary                         |
| character_set_results    | utf8                           |
| character_set_server     | utf8                           |
| character_set_system     | utf8                           |
| character_sets_dir       | /usr/share/mysql-8.0/charsets/ |
+--------------------------+--------------------------------+
8 rows in set (0.27 sec)
mysql> show global VARIABLES like '%buffer_pool%size';
+-------------------------------+----------+
| Variable_name                 | Value    |
+-------------------------------+----------+
| innodb_buffer_pool_chunk_size | 33554432 |
| innodb_buffer_pool_size       | 33554432 |
+-------------------------------+----------+
2 rows in set (0.00 sec)
mysql>
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
