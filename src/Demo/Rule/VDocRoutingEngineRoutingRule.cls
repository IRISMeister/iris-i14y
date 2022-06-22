/// 
Class Demo.Rule.VDocRoutingEngineRoutingRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.VDocRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.VDocRoutingEngine" production="Demo.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.EDI.XML.Document"></constraint>
<constraint name="docCategory" value="person"></constraint>
<constraint name="docName" value="Person"></constraint>
<when condition="1">
<send transform="" target="XMLOut"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.EDI.XML.Document"></constraint>
<constraint name="docCategory" value="order"></constraint>
<constraint name="docName" value="Order"></constraint>
<when condition="Document.{OrderItems(1).Name}=&quot;商品名ABC&quot;">
<send transform="" target="XMLOut"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
