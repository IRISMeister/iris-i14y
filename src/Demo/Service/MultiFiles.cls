Class Demo.Service.MultiFiles Extends Ens.BusinessService
{

Parameter ADAPTER = "Demo.Adapter.MultiFiles";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	Do ..SendRequestSync("Demo.Operation.MultiFiles",pInput,pOutput)
	Quit $$$OK
}

}
