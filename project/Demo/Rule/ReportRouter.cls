/// 
Class Demo.Rule.ReportRouter Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="Demo.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="">
<when condition="1">
<send transform="" target="FTPReport1,FTPReport2,FTPReport3"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
