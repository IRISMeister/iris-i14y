/// RECORDMAP: Modified during compilation of RecordMap 'User.Order'
/// on 2020-03-25 at 17:33:19.677 [2020-03-25 08:33:19.677 UTC]
/// by user SuperUser
Class User.Order.Batch Extends (%Library.Persistent, EnsLib.RecordMap.SimpleBatch)
{

Parameter XMLNAME = "User_Order_Batch";

Parameter RECORDMAPGENERATED = 1;

Parameter BatchHeader;

Parameter HeaderTerm;

Parameter BatchTrailer;

Parameter TrailerTerm;

Parameter IgnoreLeadingData = 0;

Relationship Records As User.Order.Record [ Cardinality = many, Inverse = %ParentBatch ];

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ..deleteRecords({ID})
}

Parameter XMLTYPE = "User_Order_Batch";

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
<DataLocation>^User.Order.BatchD</DataLocation>
<DefaultData>BatchDefaultData</DefaultData>
<IdLocation>^User.Order.BatchD</IdLocation>
<IndexLocation>^User.Order.BatchI</IndexLocation>
<StreamLocation>^User.Order.BatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
