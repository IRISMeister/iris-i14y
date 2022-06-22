Class Demo.Operation.FTPCustom Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.FTP.OutboundAdapter";

Property Adapter As EnsLib.FTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method Exec(pRequest As Ens.StringContainer, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSC=..Adapter.NameList(.pFileList)
		$$$ThrowOnError(tSC)

		#; Get list of filenames
		Set fileCount=pFileList.Count()
		For i=1:1:fileCount {
			Set filename=pFileList.GetAt(i)
			$$$TRACE("File #"_i_" "_filename)

			#; Read the content and dump it to trace log, if #1
			If (i=1) {
				Set tSC=..Adapter.GetStream(filename,.pStream)
				$$$ThrowOnError(tSC)
				$$$TRACE("File #1 contents:"_pStream.Read(pStream.Size))
			}
		}

		#; Put a new file. Will override exisiting one.
		Set pStream=##class(%Stream.TmpCharacter).%New()
		Set json={}.%FromJSON(pRequest.StringValue)
		Do pStream.WriteLine("現在のReportレコードの件数:"_json.Reccnt_" 取得時刻:"_json.TimeStamp)
		Set tSC=..Adapter.PutStream("latest.txt",.pStream)
		$$$ThrowOnError(tSC)
	}
	Catch e {
		Set tSC=e.AsStatus()
	}

	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StringContainer"> 
		<Method>Exec</Method>
	</MapItem>
</MapItems>
}

}
