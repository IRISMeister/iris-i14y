/// RECORDMAP: Modified during compilation of RecordMap 'User.ReportExtra'
/// on 2020-04-15 at 15:59:46.887 [2020-04-15 06:59:46.887 UTC]
/// by user SuperUser
Class User.ReportExtra.Batch Extends (%Library.Persistent, EnsLib.RecordMap.SimpleBatch)
{

Parameter XMLNAME = "User_ReportExtra_Batch";

Parameter RECORDMAPGENERATED = 1;

Parameter BatchHeader;

Parameter HeaderTerm;

Parameter BatchTrailer;

Parameter TrailerTerm;

Parameter IgnoreLeadingData = 0;

Relationship Records As User.ReportExtra.Record [ Cardinality = many, Inverse = %ParentBatch ];

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ..deleteRecords({ID})
}

Parameter XMLTYPE = "User_ReportExtra_Batch";

Storage Default
{
<Data name="BatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%Source</Value>
</Value>
<Value name="3">
<Value>BatchHeader</Value>
</Value>
<Value name="4">
<Value>BatchTrailer</Value>
</Value>
</Data>
<DataLocation>^User.ReportExtra.BatchD</DataLocation>
<DefaultData>BatchDefaultData</DefaultData>
<IdLocation>^User.ReportExtra.BatchD</IdLocation>
<IndexLocation>^User.ReportExtra.BatchI</IndexLocation>
<StreamLocation>^User.ReportExtra.BatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
