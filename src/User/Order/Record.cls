/// RECORDMAP: Generated from RecordMap 'User.Order'
/// on 2020-03-25 at 17:33:19.670 [2020-03-25 08:33:19.670 UTC]
/// by user SuperUser
Class User.Order.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property orderid As %String [ SqlColumnNumber = 2 ];

Property data1 As %String [ SqlColumnNumber = 3 ];

Property data2 As %String [ SqlColumnNumber = 4 ];

Property memo As %String [ SqlColumnNumber = 5 ];

Parameter RECORDMAPGENERATED = 1;

Relationship %ParentBatch As User.Order.Batch [ Cardinality = one, Inverse = Records ];

Index %ParentBatchIdx On %ParentBatch;

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
<Value>data2</Value>
</Value>
<Value name="5">
<Value>memo</Value>
</Value>
<Value name="6">
<Value>%ParentBatch</Value>
</Value>
<Value name="7">
<Value>data1</Value>
</Value>
</Data>
<DataLocation>^User.Order.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^User.Order.RecordD</IdLocation>
<IndexLocation>^User.Order.RecordI</IndexLocation>
<StreamLocation>^User.Order.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
