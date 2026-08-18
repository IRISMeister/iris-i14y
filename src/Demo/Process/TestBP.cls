/// 
Class Demo.Process.TestBP Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='950' >
<code name='code1' xpos='200' ypos='250' >
<![CDATA[ s a=1]]>
</code>
<call name='call1' target='TestOP' async='1' xpos='200' ypos='350' >
<request type='Ens.Request' />
<response type='Ens.Response' />
</call>
<sync calls='call1' type='all' xpos='200' ypos='450' />
<code name='code2' xpos='200' ypos='550' >
<![CDATA[ s b=1,x=3/$$GetValue^test()]]>
</code>
<call name='call2' target='TestOP' async='1' xpos='200' ypos='650' >
<request type='Ens.Request' />
<response type='Ens.Response' />
</call>
<sync calls='call2' type='all' xpos='200' ypos='750' />
<call name='call3' target='TestOP' async='0' xpos='200' ypos='850' >
<request type='Ens.Request' />
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

}
