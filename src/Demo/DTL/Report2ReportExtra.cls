Class Demo.DTL.Report2ReportExtra Extends Ens.DataTransformDTL [ DependsOn = (User.Report.Record, User.ReportExtra.Record) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='User.Report.Record' targetClass='User.ReportExtra.Record' create='new' language='objectscript' >
<assign value='source.orderid' property='target.orderid' action='set' />
<assign value='source.data1' property='target.data1' action='set' />
<assign value='source.data2' property='target.data2' action='set' />
<assign value='source.memo' property='target.memo' action='set' />
<assign value='source.%Source' property='target.%Source' action='set' />
<assign value='..Length(source.memo)' property='target.Extra1' action='set' />
<if condition='source.data2&lt;100' >
<true>
<assign value='"Small number"' property='target.Extra2' action='set' />
</true>
<false>
<assign value='"Large number"' property='target.Extra2' action='set' />
</false>
</if>
</transform>
}

}
