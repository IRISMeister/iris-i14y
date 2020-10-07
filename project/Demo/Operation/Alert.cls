Class Demo.Operation.Alert Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As Ens.Response) As %Status
{
	Quit $$$OK
}

}
