Class Demo.Service.AccessLocalDB Extends Ens.BusinessService [ Language = objectscript ]
{

Parameter ADAPTER = "Ens.InboundAdapter";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#; 時間経過と共に重たくなっていくような処理は避けること
	&SQL(SELECT COUNT(*) into :cnt FROM User_Report.Record)
	$$$TRACE("Record Count of User_Report.Record:"_cnt)
	Return $$$OK
}

}
