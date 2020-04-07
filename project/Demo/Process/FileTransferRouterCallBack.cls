/// 
Class Demo.Process.FileTransferRouterCallBack Extends Ens.BusinessProcessBPL [ ClassType = persistent, DependsOn = Demo.Context.FileTransferRouter, ProcedureBlock ]
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' contextsuperclass='Demo.Context.FileTransferRouter' height='2000' width='2000' >
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
<Type>%Storage.Persistent</Type>
}

}
