Class Demo.Service.AccessLocalDB Extends Ens.BusinessService [ Language = objectscript ]
{

Parameter ADAPTER = "Ens.InboundAdapter";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	Set tSC=$$$OK
	Try {
		#; 時間経過と共に極端に重たくなっていくような処理は避けること
		&SQL(SELECT COUNT(*) into :cnt FROM User_Report.Record)
		$$$TRACE("Record Count of User_Report.Record:"_cnt)

		Set pRequest=##class(Ens.StringContainer).%New()
		Set pRequest.StringValue={"Reccnt":(cnt),"TimeStamp":($ZDATETIME($H,3))}.%ToJSON()
		Set tSC=..SendRequestAsync("FTPCustom",pRequest)
		$$$ThrowOnError(tSC)
	}
	Catch e {
		Set tSC=e.AsStatus()
	}
	
	Return tSC
}

}
