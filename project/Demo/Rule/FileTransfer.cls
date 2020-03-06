/// 
Class Demo.Rule.FileTransfer Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="Demo.Production1">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="1">
<send transform="" target="FTPTarget1,FTPTarget2"></send>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
