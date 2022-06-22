Class Demo.Service.MyFTPService Extends EnsLib.RecordMap.Service.BatchFTPService
{

/// Ensure that the Batch object exists and extends EnsLib.RecordMap.Batch.
Method OnInit() As %Status
{
	Set tStatus = ##super()
	If $$$ISERR(tStatus) Quit tStatus
	
	Set ##class(%SYS.NLS.Table).%New("Process").File="UTF8"
	
	Quit $$$OK
}

}
