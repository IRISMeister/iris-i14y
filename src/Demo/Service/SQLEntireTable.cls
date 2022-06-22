Class Demo.Service.SQLEntireTable Extends Ens.BusinessService [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set tSC=$$$OK
	Try {
		Set req=##class(User.Report.Record).%New()
		Set req.orderid=pInput.Get("orderid")
		Set req.data1=pInput.Get("data1")
		Set req.data2=pInput.Get("data2")
		Set memo=pInput.Get("memo")
		$$$LOGINFO("orderid:"_req.orderid_" data1:"_req.data1_" data2:"_req.data2_" memo:"_memo)
		//Set tSC=..SendRequestSync("Postgres1",req,.pOutput)
	}
	Catch e {
		Set tSC=e.AsStatus()
	}
	
	Return tSC
}

}
