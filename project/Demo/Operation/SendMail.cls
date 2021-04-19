Class Demo.Operation.SendMail Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method Exec(pRequest As Ens.StreamContainer, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set pResponse=##class(Ens.Response).%New()
	$$$LOGINFO("SendMail Called. Not Yet Implemented.")
	Return tSC
}

Method Exec2(pRequest As Ens.StringContainer, Output pResponse As Ens.StringContainer) As %Status
{
	Set tSC=$$$OK
	h 10
	Set pResponse=##class(Ens.StringContainer).%New()
	Set pResponse.StringValue="Not Yet Implemented"
	$$$LOGINFO("SendMail Called. Not Yet Implemented.")
	Return tSC
}

Method Exec3(pRequest As User.Order.Record, Output pResponse As Ens.StringContainer) As %Status
{
	Set tSC=$$$OK
	h 10
	Set pResponse=##class(Ens.StringContainer).%New()
	Set pResponse.StringValue="Not Yet Implemented"
	$$$LOGINFO("SendMail Called. Not Yet Implemented.")
	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StreamContainer"> 
		<Method>Exec</Method>
	</MapItem>
	<MapItem MessageType="Ens.StringContainer"> 
		<Method>Exec2</Method>
	</MapItem>
	<MapItem MessageType="User.Order.Record"> 
		<Method>Exec3</Method>
	</MapItem>
</MapItems>
}

}
