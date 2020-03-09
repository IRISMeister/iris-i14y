/// RECORDMAP: Generated from RecordMap 'User.Report'
/// on 2020-03-06 at 14:16:26.128 [2020-03-06 05:16:26.128 UTC]
/// by user _SYSTEM
Class User.Report.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property orderid As %String [ SqlColumnNumber = 2 ];

Property data1 As %String [ SqlColumnNumber = 3 ];

Property data2 As %String [ SqlColumnNumber = 4 ];

Parameter RECORDMAPGENERATED = 1;

Relationship %ParentBatch As User.Report.Batch [ Cardinality = one, Inverse = Records ];

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
<Value>%ParentBatch</Value>
</Value>
<Value name="6">
<Value>data1</Value>
</Value>
</Data>
<DataLocation>^User.Report.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^User.Report.RecordD</IdLocation>
<IndexLocation>^User.Report.RecordI</IndexLocation>
<StreamLocation>^User.Report.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
