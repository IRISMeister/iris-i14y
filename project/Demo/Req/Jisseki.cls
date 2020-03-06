Class Demo.Req.Jisseki Extends %Persistent
{

Property orderid As %Integer;

Property data1 As %Integer;

Property data2 As %Integer;

Property csvseq As Demo.Req.JissekiHeader;

Storage Default
{
<Data name="JissekiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
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
<Value>csvseq</Value>
</Value>
</Data>
<DataLocation>^Demo.Req.JissekiD</DataLocation>
<DefaultData>JissekiDefaultData</DefaultData>
<IdLocation>^Demo.Req.JissekiD</IdLocation>
<IndexLocation>^Demo.Req.JissekiI</IndexLocation>
<StreamLocation>^Demo.Req.JissekiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
