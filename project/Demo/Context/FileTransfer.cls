Class Demo.Context.FileTransfer Extends Ens.BP.Context
{

Method CheckResponseStatus(process) As %Status
{
	Set WasError=0
	Set MessageBodyId=process.%PrimaryRequestHeader.MessageBodyId
	Set LL=$LL(MessageBodyId)
	For i=1:1:LL {
		Set obj=##class(Ens.MessageHeader).%OpenId($LIST(MessageBodyId,i))
		If obj.IsError=1 { Set WasError=1 }
		zw obj        ; for debug
	}
	If (WasError) {
		Return '$$$OK
	} Else {
		Return $$$OK
	}
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
