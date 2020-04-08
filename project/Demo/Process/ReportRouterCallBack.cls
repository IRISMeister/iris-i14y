/// 
Class Demo.Process.ReportRouterCallBack Extends Ens.BusinessProcessBPL [ ClassType = persistent, DependsOn = Demo.Context.ReportRouter, ProcedureBlock ]
{

Property TargetConfigName As %String(MAXLEN = 128);

Parameter SETTINGS = "TargetConfigName:Additional:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigName",.tValue) {
		Set pArray(tValue)="" 
	}
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' contextsuperclass='Demo.Context.ReportRouter' height='2000' width='2000' >
<sequence xend='200' yend='600' >
<if condition='context.CheckResponseStatus(process)' xpos='200' ypos='250' xend='200' yend='500' >
<false>
<trace value='"error"' xpos='335' ypos='400' >
<annotation><![CDATA[エラー発生。Do something]]></annotation>
</trace>
</false>
</if>
</sequence>
</process>
}

Storage Default
{
<Data name="ReportRouterCallBackDefaultData">
<Subscript>"ReportRouterCallBack"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
</Data>
<DefaultData>ReportRouterCallBackDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
