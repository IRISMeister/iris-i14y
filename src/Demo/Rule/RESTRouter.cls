/// 
Class Demo.Rule.RESTRouter Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="Demo.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="(Source=&quot;RESTPassThrough&quot;)&amp;&amp;MyFunction2(Document,Source)">
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
