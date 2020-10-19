Class Demo.Service.Direct Extends Ens.BusinessService [ Language = objectscript ]
{

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSC=..SendRequestSync("SendMail",pInput,.pOutput)
	}
	Catch e {
		Set tSC=e.AsStatus()
	}
	
	Return tSC
}

}
