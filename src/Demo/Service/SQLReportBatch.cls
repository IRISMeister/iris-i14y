/// SQL InboundAdapterは、各行に対してOnProcessInput()をコールする。
/// 例えば一度のPollingの際のSELECT実行の結果が3行あれば、OnProcessInput()が3回コールされる。
/// 明示的にPollingの終了時に呼ばれるコールバック関数は無いため、複数のテーブル行を、1つのCSVファイルにまとめるような処理を実行するには
/// 本実装で示すような、仕組みが必要になる。
Class Demo.Service.SQLReportBatch Extends Ens.BusinessService [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set tSC=$$$OK
	Try {
		#; トリガテーブルからSELECT(１行分)したseq値を元に、取得対象のテーブルからレコード群をSELECTする
		Set seq=pInput.Get("seq")
		Do ..Adapter.ExecuteQuery(.tRS,"select * from report where seq=? order by orderid",seq)
		If tRS.%SQLCODE<0 {
			$$$LOGERROR("SQL Failed : seq:"_seq_" SQLCODE:"_tRS.%SQLCODE)
		}
		
		Set header=##class(User.Report.Batch).%New()
		While(tRS.Next()) {
			Set record=##class(User.Report.Record).%New()
			Set record.orderid=tRS.Get("orderid")
			Set record.data1=tRS.Get("data1")
			Set record.data2=tRS.Get("data2")
			#; Linux+UnixODBCの場合、日本語は明示的にUTF8->Unicode変換を行う必要がある
			If ($this.Adapter.JGService="")&($SYSTEM.Version.GetOS()="UNIX") {
				Set record.memo=$ZCVT(tRS.Get("memo"),"I","UTF8")
			}
			Else { Set record.memo=tRS.Get("memo") }
			Set tSC=header.Records.Insert(record)
			$$$ThrowOnError(tSC)
			$$$TRACE("orderid:"_record.orderid_" data1:"_record.data1_" data2:"_record.data2_" memo:"_record.memo)
		}
		Set tSC=header.%Save()
		$$$ThrowOnError(tSC)
		
		Set tSC=..SendRequestSync("FTPReportBatch",header,.tOutput)
		$$$ThrowOnError(tSC)

	}
	Catch e {
		Set tSC=e.AsStatus()
	}
	
	Return tSC
}

}
