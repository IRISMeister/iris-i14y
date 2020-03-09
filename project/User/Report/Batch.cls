/// RECORDMAP: Modified during compilation of RecordMap 'User.Report'
/// on 2020-03-06 at 14:16:26.131 [2020-03-06 05:16:26.131 UTC]
/// by user _SYSTEM
Class User.Report.Batch Extends (%Library.Persistent, EnsLib.RecordMap.SimpleBatch)
{

Parameter XMLNAME = "User_Report_Batch";

Parameter RECORDMAPGENERATED = 1;

Parameter BatchHeader;

Parameter HeaderTerm;

Parameter BatchTrailer;

Parameter TrailerTerm;

Parameter IgnoreLeadingData = 0;

Relationship Records As User.Report.Record [ Cardinality = many, Inverse = %ParentBatch ];

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ..deleteRecords({ID})
}

Parameter XMLTYPE = "User_Report_Batch";

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
<DataLocation>^User.Report.BatchD</DataLocation>
<DefaultData>BatchDefaultData</DefaultData>
<IdLocation>^User.Report.BatchD</IdLocation>
<IndexLocation>^User.Report.BatchI</IndexLocation>
<StreamLocation>^User.Report.BatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
