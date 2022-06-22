/// 
Class Demo.Rule.VDocRoutingEngineRoutingRuleNoSchema Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.VDocRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.VDocRoutingEngine" production="Demo.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="Document.{/Person/Home/Zip}=&quot;82099&quot;">
<send transform="" target="XMLOut"></send>
<return></return>
</when>
<otherwise>
<send transform="" target="XMLIgnored"></send>
<return></return>
</otherwise>
</rule>
</ruleSet>
</ruleDefinition>
}

}
