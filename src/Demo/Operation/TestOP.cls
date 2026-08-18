Class Demo.Operation.TestOP Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter INVOCATION = "Queue";

Method Exec(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set pResponse=##class(Ens.Response).%New()
	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.Request"> 
		<Method>Exec</Method>
	</MapItem>
</MapItems>
}

}
