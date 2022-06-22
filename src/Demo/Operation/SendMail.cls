Class Demo.Operation.SendMail Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method Exec(pRequest As Demo.Request.SendMail, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set pResponse=##class(Ens.Response).%New()

	Set tMail=##class(%Net.MailMessage).%New()
	Set pSubject=pRequest.Subject
	Set pHTML=pRequest.Body_$C(13,10)
	Set pHTML=pHTML_"詳細は <a href=www.intersystems.co.jp>こちら</a> をご覧ください。"
	Set pEmailAddress=pRequest.MailTo
	Set pFrom=pRequest.MailFrom

	Do tMail.To.Insert(pEmailAddress)
	Set tMail.Subject="=?UTF-8?B?"_##class(%SYSTEM.Encryption).Base64Encode($ZCVT(pSubject,"O","UTF8"))_"?="
	Set tMail.From=pFrom
	Set tMail.IsHTML=1
	Set tMail.IsBinary=0
	Set tMail.ContentType="text/html"
	Set tSC=tMail.TextData.Write(pHTML) Quit:$$$ISERR(tSC)
	Set tSC=..Adapter.SendMail(tMail)

	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.Request.SendMail"> 
		<Method>Exec</Method>
	</MapItem>
</MapItems>
}

}
