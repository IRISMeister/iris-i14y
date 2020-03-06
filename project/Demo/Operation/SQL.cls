Class Demo.Operation.SQL Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method ExecSingle(pRequest As %RegisteredObject, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Try {
		Set pResponse=##class(Ens.Response).%New()
	 	Set sql="insert into jissekiTarget (orderid,data1,data2) values (?,?,?)"
		Set tSC = ..Adapter.ExecuteUpdate(.nrows,sql,pRequest.orderid,pRequest.data1,pRequest.data2)
		$$$TRACE("Inserted "_nrows_" rows")	
	}
	Catch e {
		Set tSC=e.AsStatus()
	}

	Return tSC
}

Method ExecBatch(pRequest As User.Order.Batch, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Try {
		Set reccnt=pRequest.Records.Count()
		For i=2:1:reccnt { // skipping header
			Set rec=pRequest.Records.GetAt(i)
			Set tSC=..ExecSingle(rec,.tOutput)
		}
	}
	Catch e {
		Set tSC=e.AsStatus()
	}

	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.Req.Jisseki"> 
		<Method>ExecSingle</Method>
	</MapItem>
	<MapItem MessageType="User.Order.Record"> 
		<Method>ExecSingle</Method>
	</MapItem>
	<MapItem MessageType="User.Order.Batch"> 
		<Method>ExecBatch</Method>
	</MapItem>
	
</MapItems>
}

}
