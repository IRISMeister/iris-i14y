Class Demo.Operation.SQL Extends Ens.BusinessOperation [ Language = objectscript ]
{

Property SkipHeader As %Boolean;

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "SkipHeader";

/// 受信したBatchをINSERTに再構成し実行
Method ExecOrderBatch(pRequest As User.Order.Batch, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set sql="insert into orderinfo (orderid,data1,data2) values (?,?,?)"
	
	Try {
		Set pResponse=##class(Ens.Response).%New()
		Set reccnt=pRequest.Records.Count()
		// ヘッダ情報(1行目)を無視するかどうか
		Set start=1 If (..SkipHeader) { Set start=2 } 
		For i=start:1:reccnt { 
			Set rec=pRequest.Records.GetAt(i)
			Set tSC = ..Adapter.ExecuteUpdate(.nrows,sql,rec.orderid,rec.data1,rec.data2)
			$$$ThrowOnError(tSC)
			$$$TRACE("Inserted "_nrows_" rows")	
		}
	}
	Catch e {
		Set tSC=e.AsStatus()
	}

	Return tSC
}

/// 受信したBatchをINSERTに再構成し実行
Method ExecProcessBatch(pRequest As User.Process.Batch, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set sql="insert into process (orderid,processid,data1,data2) values (?,?,?,?)"
	
	Try {
		Set pResponse=##class(Ens.Response).%New()
		Set reccnt=pRequest.Records.Count()
		// ヘッダ情報(1行目)を無視するかどうか
		Set start=1 If (..SkipHeader) { Set start=2 } 
		For i=start:1:reccnt { 
			Set rec=pRequest.Records.GetAt(i)
			Set tSC = ..Adapter.ExecuteUpdate(.nrows,sql,rec.orderid,rec.processid,rec.data1,rec.data2)
			$$$ThrowOnError(tSC)
			$$$TRACE("Inserted "_nrows_" rows")	
		}
	}
	Catch e {
		Set tSC=e.AsStatus()
	}

	Return tSC
}

/// SQL->SQLの例
Method ExecReport(pRequest As %RegisteredObject, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set sql="insert into reportTarget (orderid,data1,data2) values (?,?,?)"
	Try {
		Set pResponse=##class(Ens.Response).%New()
		Set tSC = ..Adapter.ExecuteUpdate(.nrows,sql,pRequest.orderid,pRequest.data1,pRequest.data2)
		$$$ThrowOnError(tSC)
		$$$TRACE("Inserted "_nrows_" rows")	
	}
	Catch e {
		Set tSC=e.AsStatus()
	}

	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="User.Report.Record"> 
		<Method>ExecReport</Method>
	</MapItem>
	<MapItem MessageType="User.Order.Batch"> 
		<Method>ExecOrderBatch</Method>
	</MapItem>
	<MapItem MessageType="User.Process.Batch"> 
		<Method>ExecProcessBatch</Method>
	</MapItem>
	
</MapItems>
}

}
