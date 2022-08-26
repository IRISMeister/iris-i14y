Class Demo.Request.ReportResult Extends Ens.Request
{

Property Body As User.ReportExtra.Record;

Property TargetConfigName As %String(MAXLEN = 128);

Property Result As %Integer;

Storage Default
{
<Data name="ReportResultDefaultData">
<Subscript>"ReportResult"</Subscript>
<Value name="1">
<Value>Body</Value>
</Value>
<Value name="2">
<Value>TargetConfigName</Value>
</Value>
<Value name="3">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>ReportResultDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
