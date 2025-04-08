Class Demo.Operation.MultiFiles Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method Exec(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	For i=1:1:pRequest.Files.Count() {
		Set file=pRequest.Files.GetAt(i)
		Set tSC=##class(%File).Delete(file, .return)
		If $$$ISERR(tSC) {
			$$$LOGERROR("Error deleting file "_file_" "_tSC)
		}
	}
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.Request.ListOfFiles"> 
		<Method>Exec</Method>
	</MapItem>
</MapItems>
}

}
