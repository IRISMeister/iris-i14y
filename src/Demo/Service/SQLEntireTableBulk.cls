Class Demo.Service.SQLEntireTableBulk Extends Ens.BusinessService [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set tSC=$$$OK
	Try {
		#; 取得対象のテーブルからレコード群をSELECTする
		Do ..Adapter.ExecuteQuery(.tRS,"select * from report2 order by orderid")
		If tRS.%SQLCODE<0 {
			$$$LOGERROR("SQL Failed : seq:"_seq_" SQLCODE:"_tRS.%SQLCODE)
		}
		
		Set header=##class(User.Report.Batch).%New()
		While(tRS.Next()) {
			Set record=##class(User.Report.Record).%New()
			Set record.orderid=tRS.Get("orderid")
			Set record.data1=tRS.Get("data1")
			Set record.data2=tRS.Get("data2")
			Set memo=tRS.Get("memo")
			Set tSC=header.Records.Insert(record)
			$$$ThrowOnError(tSC)
			$$$LOGINFO("orderid:"_record.orderid_" data1:"_record.data1_" data2:"_record.data2_" memo:"_memo)
		}
		Set tSC=header.%Save()
		$$$ThrowOnError(tSC)
		
		;Set tSC=..SendRequestSync("FTPReport",header,.tOutput)
		;$$$ThrowOnError(tSC)

	}
	Catch e {
		Set tSC=e.AsStatus()
	}
	
	Return tSC
}

}
