Class Demo.DTL.NotifyManager Extends Ens.DataTransformDTL
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Ens.Alerting.NotificationRequest' targetClass='Ens.Alerting.Context.Notify' create='existing' language='objectscript' >
<assign value='"bot@localhost"' property='evrything' action='set' />
<assign value='"netteam@localhost"' property='network' action='set' />
<assign value='"osteam@localhost"' property='os' action='set' />
<assign value='"appteam@localhost"' property='app' action='set' />
<assign value='"sqlteam@localhost"' property='sql' action='set' />
<assign value='"EnsLib.EMail.AlertOperation"' property='target.Targets.(1).TargetConfigName' action='set' />
<assign value='"Alert"' property='target.Targets.(2).TargetConfigName' action='set' />
<assign value='1' property='target.Notify' action='set' />
<assign value='evrything' property='target.Targets.(1).AlertDestinations' action='append' />
<if condition='..Contains(source.ManagedAlert.AlertGroups,"NET")' >
<true>
<assign value='network' property='target.Targets.(1).AlertDestinations' action='append' />
</true>
</if>
<if condition='..Contains(source.ManagedAlert.AlertGroups,"LOCAL")' >
<true>
<assign value='os' property='target.Targets.(1).AlertDestinations' action='append' />
</true>
</if>
<if condition='..Contains(source.ManagedAlert.AlertGroups,"SQL")' >
<true>
<assign value='sql' property='target.Targets.(1).AlertDestinations' action='append' />
</true>
</if>
<if condition='source.ManagedAlert.EscalationLevel&gt;0' >
<true>
<assign value='app' property='target.Targets.(1).AlertDestinations' action='append' />
</true>
</if>
</transform>
}

}
