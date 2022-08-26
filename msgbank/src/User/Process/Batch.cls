/// RECORDMAP: Modified during compilation of RecordMap 'User.Process'
/// on 2020-03-25 at 17:16:53.741 [2020-03-25 08:16:53.741 UTC]
/// by user SuperUser
Class User.Process.Batch Extends (%Library.Persistent, EnsLib.RecordMap.SimpleBatch)
{

Parameter XMLNAME = "User_Process_Batch";

Parameter RECORDMAPGENERATED = 1;

Parameter BatchHeader;

Parameter HeaderTerm;

Parameter BatchTrailer;

Parameter TrailerTerm;

Parameter IgnoreLeadingData = 0;

Relationship Records As User.Process.Record [ Cardinality = many, Inverse = %ParentBatch ];

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ..deleteRecords({ID})
}

Parameter XMLTYPE = "User_Process_Batch";

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
<DataLocation>^User.Process.BatchD</DataLocation>
<DefaultData>BatchDefaultData</DefaultData>
<IdLocation>^User.Process.BatchD</IdLocation>
<IndexLocation>^User.Process.BatchI</IndexLocation>
<StreamLocation>^User.Process.BatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
