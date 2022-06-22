Class Demo.Request.SendMail Extends Ens.Request
{

Property Body As %String;

Property Subject As %String;

Property MailFrom As %String;

Property MailTo As %String;

Storage Default
{
<Data name="SendMailDefaultData">
<Subscript>"SendMail"</Subscript>
<Value name="1">
<Value>Body</Value>
</Value>
<Value name="2">
<Value>Subject</Value>
</Value>
<Value name="3">
<Value>MailFrom</Value>
</Value>
<Value name="4">
<Value>MailTo</Value>
</Value>
</Data>
<DefaultData>SendMailDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
