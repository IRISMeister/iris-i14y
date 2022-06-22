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
	Set sql="insert into orderinfo (orderid,data1,data2,memo) values (?,?,?,?)"
	
	Try {
		Set pResponse=##class(Ens.Response).%New()
		Set reccnt=pRequest.Records.Count()
		// ヘッダ情報(1行目)を無視するかどうか
		Set start=1 If (..SkipHeader) { Set start=2 } 
		For i=start:1:reccnt { 
			Set rec=pRequest.Records.GetAt(i)
			Set tSC = ..Adapter.ExecuteUpdate(.nrows,sql,rec.orderid,rec.data1,rec.data2,rec.memo)
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
	Set sql="insert into process (orderid,processid,data1,data2,memo) values (?,?,?,?,?)"
	
	Try {
		Set pResponse=##class(Ens.Response).%New()
		Set reccnt=pRequest.Records.Count()
		// ヘッダ情報(1行目)を無視するかどうか
		Set start=1 If (..SkipHeader) { Set start=2 } 
		For i=start:1:reccnt { 
			Set rec=pRequest.Records.GetAt(i)
			Set tSC = ..Adapter.ExecuteUpdate(.nrows,sql,rec.orderid,rec.processid,rec.data1,rec.data2,rec.memo)
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
Method ExecReport(pRequest As User.Report.Record, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set sql="insert into reportTarget (orderid,data1,data2,memo) values (?,?,?,?)"
	Try {
		Set pResponse=##class(Ens.Response).%New()
		Set tSC = ..Adapter.ExecuteUpdate(.nrows,sql,pRequest.orderid,pRequest.data1,pRequest.data2,pRequest.memo)
		$$$ThrowOnError(tSC)
		$$$TRACE("Inserted "_nrows_" rows")	
	}
	Catch e {
		Set tSC=e.AsStatus()
	}

	Return tSC
}

Method ExecReportResult(pRequest As Demo.Request.ReportResult, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set sql="insert into reportResult (logtimestamp,target,orderid,data1,result) values (current_timestamp,?,?,?,?)"
	Try {
		Set pResponse=##class(Ens.Response).%New()
		Set tSC = ..Adapter.ExecuteUpdate(.nrows,sql,pRequest.TargetConfigName,pRequest.Body.orderid,pRequest.Body.data1,pRequest.Result)
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
	<MapItem MessageType="Demo.Request.ReportResult"> 
		<Method>ExecReportResult</Method>
	</MapItem>
	
</MapItems>
}

}
