Class Demo.Service.Test Extends Ens.BusinessService [ Language = objectscript ]
{

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSC=..SendRequestSync("TestBP",pInput,.pOutput)
	}
	Catch e {
		Set tSC=e.AsStatus()
	}
	
	Return tSC
}

}
