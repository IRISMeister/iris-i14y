/// RECORDMAP: Generated from RecordMap 'User.Process'
/// on 2020-03-25 at 17:16:53.734 [2020-03-25 08:16:53.734 UTC]
/// by user SuperUser
Class User.Process.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property orderid As %String [ SqlColumnNumber = 2 ];

Property processid As %String [ SqlColumnNumber = 3 ];

Property data1 As %String [ SqlColumnNumber = 4 ];

Property data2 As %String [ SqlColumnNumber = 5 ];

Property memo As %String [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>orderid</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>data1</Value>
</Value>
<Value name="5">
<Value>data2</Value>
</Value>
<Value name="6">
<Value>%ParentBatch</Value>
</Value>
<Value name="7">
<Value>processid</Value>
</Value>
<Value name="8">
<Value>memo</Value>
</Value>
</Data>
<DataLocation>^User.Process.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^User.Process.RecordD</IdLocation>
<IndexLocation>^User.Process.RecordI</IndexLocation>
<StreamLocation>^User.Process.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Parameter RECORDMAPGENERATED = 1;

Relationship %ParentBatch As User.Process.Batch [ Cardinality = one, Inverse = Records ];

Index %ParentBatchIdx On %ParentBatch;

}
