Class Demo.Operation.SendMail Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method Exec(pRequest As Ens.StreamContainer, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set pResponse=##class(Ens.Response).%New()
	$$$LOGINFO("SendMail Called.")
	Return tSC
}

Method Exec2(pRequest As Ens.StringRequest, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set pResponse=##class(Ens.Response).%New()
	$$$LOGINFO("SendMail Called.")
	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StreamContainer"> 
		<Method>Exec</Method>
	</MapItem>
	<MapItem MessageType="Ens.StringRequest"> 
		<Method>Exec2</Method>
	</MapItem>
</MapItems>
}

}
