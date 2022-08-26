/// RECORDMAP: Generated from RecordMap 'User.Order'
/// on 2020-03-25 at 17:33:19.670 [2020-03-25 08:33:19.670 UTC]
/// by user SuperUser
Class Demo.Request.ReportTable Extends Ens.Request
{

Property seq As %Integer [ SqlColumnNumber = 2 ];

Property orderid As %String [ SqlColumnNumber = 3 ];

Property data1 As %String [ SqlColumnNumber = 4 ];

Property data2 As %String [ SqlColumnNumber = 5 ];

Property memo As %String [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RecordDefaultData">
<Subscript>"Record"</Subscript>
<Value name="1">
<Value>seq</Value>
</Value>
<Value name="2">
<Value>orderid</Value>
</Value>
<Value name="3">
<Value>data1</Value>
</Value>
<Value name="4">
<Value>data2</Value>
</Value>
<Value name="5">
<Value>memo</Value>
</Value>
</Data>
<DefaultData>RecordDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
