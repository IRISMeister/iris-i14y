Class Demo.Context.ReportRouter Extends Ens.BP.Context
{

/// ReportRouterCallBackからコールされる。processには当該BPのインスタンスIDが渡る。
Method CheckResponseStatus(process As Demo.Process.ReportRouterCallBack) As %Status
{
	Set WasError=0
	#;BOからの戻り値を参照するために、それら複数のメッセージID(List形式)を取得
	Set MessageBodyId=process.%PrimaryRequestHeader.MessageBodyId
	#;メッセージIDの個数を取得
	Set LL=$LL(MessageBodyId)
	$$$TRACE("Number of MessageBodyId:"_LL)
	For i=1:1:LL {
		Set id=$LIST(MessageBodyId,i)
		Set obj=##class(Ens.MessageHeader).%OpenId(id)
		#;ここにBOの構成名が保存されている。名称がSourceになっているのは、このメッセージはBOが発生源になっているため。
		Set src=obj.SourceConfigName
		If obj.IsError=1 { Set WasError=1 }

		#;以下で、BOに送信されたメッセージの内容へのアクセスを行う。
		#;BOに送られたメッセージのメッセージヘッダを取得
		Set req=##class(Ens.MessageHeader).%OpenId(obj.CorrespondingMessageId)

		#;BOに送られたメッセージのクラス名とIDを取得
		Set bodycls=req.MessageBodyClassName, reqbodyid=req.MessageBodyId

		#;興味の対象となるプロパティ値を取得
		Set reqbody=$CLASSMETHOD(bodycls,"%OpenId",reqbodyid)

		$$$TRACE("SourceConfigName:"_src_" MessageBodyId:"_id_" IsError:"_obj.IsError_" ErrorStatus:"_obj.ErrorStatus_" OrderId:"_reqbody.orderid_" data1:"_reqbody.data1)
		#; BPにこれらの情報を返却して、そこからRDBへの更新要求を送信しても良いが、ここではコーディングでの記述を選択。
		Do ..SendRequest(process,src,obj,reqbody)

	}
	#; 1件でもエラーがあった場合にはエラーを返す。
	If (WasError) {
		Return '$$$OK
	} Else {
		Return $$$OK
	}
}

Method SendRequest(process, src, obj, reqbody) As %Status
{
	Set tSC=$$$OK
	#;メッセージ作成
	#;Send
	Set tSC=process.SendRequestSync(process.target,reqbody,.tOutput)

	Return tSC
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
