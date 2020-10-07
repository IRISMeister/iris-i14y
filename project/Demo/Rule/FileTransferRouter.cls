/// 
Class Demo.Rule.FileTransferRouter Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="Demo.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="Document.OriginalFilename=&quot;source1_1.txt&quot;">
<send transform="" target="FTPTarget1PassThrough"></send>
<return></return>
</when>
<when condition="MyFunction(Document.OriginalFilename,Source)">
<send transform="" target="FTPTarget2PassThrough"></send>
<return></return>
</when>
<when condition="Document.OriginalFilename=&quot;source1_3.txt&quot;">
<send transform="" target="FTPTarget1PassThrough,FTPTarget2PassThrough"></send>
<return></return>
</when>
<otherwise>
<send transform="" target="SendMail"></send>
</otherwise>
</rule>
</ruleSet>
</ruleDefinition>
}

}
