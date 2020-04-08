Class Demo.Service.SQLReport Extends Ens.BusinessService [ Language = objectscript ]
{

Property TargetConfigName As %String(MAXLEN = 128);

Parameter SETTINGS = "TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set req=##class(User.Report.Record).%New()
	Set req.orderid=pInput.Get("orderid")
	Set req.data1=pInput.Get("data1")
	Set req.data2=pInput.Get("data2")
	Set req.memo=pInput.Get("memo")
	$$$TRACE("orderid:"_req.orderid_" data1:"_req.data1_" data2:"_req.data2_" memo:"_req.memo)
	Set tSC=..SendRequestSync(..TargetConfigName,req,.pOutput)
	Return $$$OK
}

/// プロダクション画面の接続線の描画ロジック
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigName",.tValue) {
		Set pArray(tValue)="" 
	}
}

}
