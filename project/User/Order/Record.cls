/// RECORDMAP: Generated from RecordMap 'User.Order'
/// on 2020-03-05 at 19:47:49.030 [2020-03-05 10:47:49.030 UTC]
/// by user _SYSTEM
Class User.Order.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property orderid As %String [ SqlColumnNumber = 2 ];

Property data1 As %String [ SqlColumnNumber = 3 ];

Property data2 As %String [ SqlColumnNumber = 4 ];

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
<Value>data1</Value>
</Value>
<Value name="6">
<Value>%ParentBatch</Value>
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
