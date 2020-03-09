/// 
Class Demo.Rule.FileTransfer Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="Demo.Production1">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="Document.OriginalFilename=&quot;source1_1.txt&quot;">
<send transform="" target="FTPTarget1PathThrough"></send>
</when>
<when condition="Document.OriginalFilename=&quot;source1_2.txt&quot;">
<send transform="" target="FTPTarget2PathThrough"></send>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
