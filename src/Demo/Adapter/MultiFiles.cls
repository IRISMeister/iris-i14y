Class Demo.Adapter.MultiFiles Extends Ens.InboundAdapter
{

Property WatchFolders As list Of %String;

Method OnTask() As %Status
{
	Set tSC=$$$OK
	Set matchall=0
	Set match=0
	Set folderCount=..WatchFolders.Count()
	Set msg=##class(Demo.Request.ListOfFiles).%New()

	For i=1:1:folderCount {
	  Set filepattern=..WatchFolders.GetAt(i)
	  SET file=$ZSEARCH(filepattern)
	  If (file'="") { //if file exists
			Set match=match+1
			Do msg.Files.Insert(file)
	  		SET file=$ZSEARCH(-1) ; relase directory lock
	  }
	  If (match=folderCount) { Set matchall=1 }
	}

	If (matchall=1) {
		If ($IsObject(msg)) {
			
			Set tSC=..BusinessHost.ProcessInput(msg)
		}
	}

	Set ..BusinessHost.%WaitForNextCallInterval=1
	Quit tSC
}

Method OnInit() As %Status
{
	Set sc = $$$OK
	Do ..WatchFolders.Insert("/home/irisowner/upload/local/watch1/*.txt")
	Do ..WatchFolders.Insert("/home/irisowner/upload/local/watch2/*.txt")
	Do ..WatchFolders.Insert("/home/irisowner/upload/local/watch3/*.txt")
	Quit sc
}

}
