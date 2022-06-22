Class Demo.Context.FileTransferRouter Extends Ens.BP.Context
{

/// BP(FileTransferRouterCallBack)からコールされる。processには実行BPのインスタンスIDが渡る。
Method CheckResponseStatus(process) As %Status
{
	Set tSC=$$$OK
	Set WasError=0
	Try {
		// contains list of MessageHeader IDs.
		Set MessageHeaderIds=process.%PrimaryRequestHeader.MessageBodyId
		Set LL=$LL(MessageHeaderIds)
		For i=1:1:LL {
			Set obj=##class(Ens.MessageHeader).%OpenId($LIST(MessageHeaderIds,i))
			If obj.IsError=1 { Set WasError=1 }
			zw obj        ; for debug
		}
	}
	Catch e {
		Set tSC='$$$OK
	}
	#; If there was at least one error
	If (WasError) {
		Return 'tSC
	} Else {
		Return tSC
	}
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
