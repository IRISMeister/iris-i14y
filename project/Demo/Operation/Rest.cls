Class Demo.Operation.Rest Extends EnsLib.REST.Operation
{

Method Exec(pRequest As Ens.StreamContainer, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Try {
		Set pResponse=##class(Ens.Response).%New()
		$$$LOGINFO("Rest Called. File Size:"_pRequest.Stream.Size)

		#; なんらかの方法でファイルのエンコードを知る必要がある。ここでは受信ファイル名の一部を使用する。
		Set encode="UTF8"
		if $ZCVT(pRequest.OriginalFilename,"U")["SJIS" {
			Set encode="SJIS"
		}

		#; jsonを文字列化したサイズがローカル変数の上限サイズ以下の場合(超えると<MAXSTRING>エラーが発生する)
		Set json={"OriginalFilename":(pRequest.OriginalFilename),"Data":($ZCVT(pRequest.Stream.Read(),"I",encode))}

		#; Set tSC = ..Adapter.Post(.tResponse,,json.%ToJSON())
		#; Post()は固定でtext/htmlになるので使用しない。
		Set req=##class(%Net.HttpRequest).%New()
		Do req.SetHeader("content-type","application/json; charset=UTF-8") 
		Set pData(1)=json.%ToJSON()
		Set tSC = ..Adapter.SendFormDataArray(.tResponse,"POST",req,,.pData)
	}
	Catch e {
		Set tSC=e.AsStatus()
	}

	Return tSC
}

Method Exec2(pRequest As Ens.StringRequest, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Set pResponse=##class(Ens.Response).%New()
	$$$LOGINFO("Rest Called. Not Yet Implemented.")
	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StreamContainer"> 
		<Method>Exec</Method>
	</MapItem>
	<MapItem MessageType="Ens.StringRequest"> 
		<Method>Exec2</Method>
	</MapItem>
</MapItems>
}

}
