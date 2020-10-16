Class Demo.Operation.SendMail Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method Exec(pRequest As Ens.StreamContainer, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StreamContainer"> 
		<Method>Exec</Method>
	</MapItem>
</MapItems>
}

}
