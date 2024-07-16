/// 
Class Demo.Process.SimpleSendMail Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StringContainer' response='Ens.StringContainer' height='2000' width='2000' >
<sequence xend='200' yend='550' >
<trace value='"test"' xpos='200' ypos='250' disabled="true"/>
<call name='call1' target='SendMail' async='1' xpos='200' ypos='350' >
<request type='Demo.Request.SendMail' >
<assign property="callrequest.Body" value="request.StringValue" action="set" />
<assign property="callrequest.Subject" value="&quot;お知らせ&quot;" action="set" />
<assign property="callrequest.MailFrom" value="&quot;iris@iris.example.org&quot;" action="set" />
<assign property="callrequest.MailTo" value="&quot;bot@foo.example.com&quot;" action="set" />
</request>
<response type='Ens.StringContainer' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<sync calls='call1' timeout='"P1Y2M3DT10H30M"' type='all' xpos='200' ypos='450' />
</sequence>
</process>
}

}
