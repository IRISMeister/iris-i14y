/// RECORDMAP: Generated from RecordMap 'User.ReportExtra'
/// on 2020-04-15 at 15:59:46.791 [2020-04-15 06:59:46.791 UTC]
/// by user SuperUser
Class User.ReportExtra.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property orderid As %String [ SqlColumnNumber = 2 ];

Property data1 As %String [ SqlColumnNumber = 3 ];

Property data2 As %String [ SqlColumnNumber = 4 ];

Property memo As %String [ SqlColumnNumber = 5 ];

Property Extra1 As %String [ SqlColumnNumber = 6 ];

Property Extra2 As %String [ SqlColumnNumber = 7 ];

Parameter RECORDMAPGENERATED = 1;

Relationship %ParentBatch As User.ReportExtra.Batch [ Cardinality = one, Inverse = Records ];

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
<Value>Extra1</Value>
</Value>
<Value name="7">
<Value>Extra2</Value>
</Value>
<Value name="8">
<Value>%ParentBatch</Value>
</Value>
<Value name="9">
<Value>data1</Value>
</Value>
</Data>
<DataLocation>^User.ReportExtra.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^User.ReportExtra.RecordD</IdLocation>
<IndexLocation>^User.ReportExtra.RecordI</IndexLocation>
<StreamLocation>^User.ReportExtra.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
