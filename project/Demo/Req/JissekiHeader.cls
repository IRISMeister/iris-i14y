/// 実績をCSV化する際にひとつのCSVに含めるレコード群を特定するためのユニークID(csvseq)を保持するテーブル
Class Demo.Req.JissekiHeader Extends %Persistent
{

Storage Default
{
<Data name="JissekiHeaderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Demo.Req.JissekiHeaderD</DataLocation>
<DefaultData>JissekiHeaderDefaultData</DefaultData>
<IdLocation>^Demo.Req.JissekiHeaderD</IdLocation>
<IndexLocation>^Demo.Req.JissekiHeaderI</IndexLocation>
<StreamLocation>^Demo.Req.JissekiHeaderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
