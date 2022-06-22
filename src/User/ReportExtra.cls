/// RECORDMAP: Modified during compilation of RecordMap 'User.ReportExtra'
/// on 2020-04-15 at 15:59:47.005 [2020-04-15 06:59:47.005 UTC]
/// by user SuperUser
Class User.ReportExtra Extends EnsLib.RecordMap.RecordMap
{

Parameter OBJECTNAME = "User.ReportExtra.Record";

/// Method to retrieve a record from a stream or device. This method will be generated based on the
/// structure of the RecordMap. For testing purposes, a file name may be passed in the pStream argument.
ClassMethod GetObject(pStream As %IO.DeviceStream, Output pObject As %RegisteredObject, pTimeout As %Numeric = -1, ByRef pLookAhead As %String = "", pLabelFound As %Boolean = 0) As %Status
{
	Try {
		Set tStatus = $$$OK
		Set pObject = $$$NULLOREF
		If '$IsObject(pStream) {
			Set tFilename = pStream
			Set pStream = ##class(%IO.FileStream).%New()
			Do pStream.Open(tFilename,,pTimeout,"UTF-8", .tStatus)
			If $$$ISERR(tStatus) Quit
		}
		Set tObjectName = $parameter($this,"OBJECTNAME")
		Set tObject = $classmethod(tObjectName,"%New")
		If '$IsObject(tObject) {
			Set tStatus = $$$ERROR($$$CannotCreateObject,tObjectName)
			Quit
		}
		Set tObject.%Source = pStream.Name
		Set tGetTopFields = $parameter(tObject,"INCLUDETOPFIELDS")
		If pStream.AtEnd && (""=pLookAhead) {
			Set tStatus = $$$ERROR($$$EnsRecordMapErrStreamAtEnd, pStream.Name)
			Quit
		}
		Set pStream.CharEncoding = "UTF-8"

		#; Parse incoming stream
		Set tStatus = ..GetRecord(pStream, tObject, tGetTopFields, pTimeout, .pLookAhead, pLabelFound)
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	If $$$ISERR(tStatus) { Set pObject = $$$NULLOREF }
	Else { Set pObject = tObject }
	Quit tStatus
}

/// Method to write a record to a stream or device. This method will be generated based on the
/// structure of the RecordMap. For testing purposes, a file name may be passed in the pStream argument.
ClassMethod PutObject(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pFlush As %Boolean = 1, ByRef pPadArray As %String) As %Status
{
	Try {
		Set tStatus = $$$OK
		If '$IsObject(pStream) {
			Set tFilename = pStream
			Set pStream = ##class(%IO.FileStream).%New()
			Do pStream.Open(tFilename,"WAE",,"UTF-8", .tStatus)
			If $$$ISERR(tStatus) Quit
		}
		Set tHasTopFields = $parameter(pObject,"INCLUDETOPFIELDS")
		Set pStream.CharEncoding = "UTF-8"

		Set tStatus = ..PutRecord(pStream, pObject, tHasTopFields, .pPadArray)
		If $$$ISERR(tStatus) Quit
		If pFlush Do pStream.Flush(.tStatus)
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Internal helper method to perform parse of incoming data
ClassMethod GetRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pGetTopFields As %Boolean, pTimeout As %Numeric, ByRef pLookAhead As %String = "", pLabelFound As %Boolean = 0) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	If pLabelFound { Set tRecLabel = "" } 
	Else { Set tRecLabel = "" } 
	Set tStatus = ..chunkRecord(pStream, .tRecordData, .tCharCount, "", pTimeout, $char(10), tRecLabel, .pLookAhead, "")
	If $$$ISERR(tStatus) Quit tStatus
	Set tMaxLocal = $$$MaxLocalLength
	Set tRecordData("charcount") = +$get(tCharCount)
	Set tCurrChunk = 1
	Set tTopPiece = 1
	Set tCurrSep = 1
	Set tStrings = 1
	Set tCurrString = ""
	Set tSeps = $listbuild($char(9))
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(9), tTopPiece)
	}
	Else {
		Set tCurrString = tRecordData(tCurrChunk)
		Set tCurrPiece = 1
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(9), .tTopPiece)
	If pGetTopFields {
		Set pObject.orderid = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(9), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(9), .tTopPiece)
	If pGetTopFields {
		Set pObject.data1 = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(9), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(9), .tTopPiece)
	If pGetTopFields {
		Set pObject.data2 = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(9), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(9), .tTopPiece)
	If pGetTopFields {
		Set pObject.memo = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(9), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(9), .tTopPiece)
	If pGetTopFields {
		Set pObject.Extra1 = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(9), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(9), .tTopPiece)
	If pGetTopFields {
		Set pObject.Extra2 = tCurrString
	}
	Quit tStatus
}

/// Internal helper method to output object to a stream
ClassMethod PutRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pHasTopFields As %Boolean, ByRef pPadArray As %String) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	Do pStream.Write($select(pHasTopFields: pObject.orderid,1: ""),0)
	Do pStream.Write($char(9) _ $select(pHasTopFields: pObject.data1,1: ""),0)
	Do pStream.Write($char(9) _ $select(pHasTopFields: pObject.data2,1: ""),0)
	Do pStream.Write($char(9) _ $select(pHasTopFields: pObject.memo,1: ""),0)
	Do pStream.Write($char(9) _ $select(pHasTopFields: pObject.Extra1,1: ""),0)
	Do pStream.Write($char(9) _ $select(pHasTopFields: pObject.Extra2,1: ""),0)
	Do pStream.Write($char(10), 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	Quit tStatus
}

ClassMethod GetGeneratedClasses(Output pClasses As %String) As %Status
{
	Kill pClasses
	Set pClasses("User.ReportExtra.Batch")=""
	Set pClasses("User.ReportExtra.Record")=""
	Set pClasses($classname())=""
	Quit $$$OK
}

ClassMethod getIdentifier() As %String [ CodeMode = expression ]
{
""
}

ClassMethod getType() As EnsLib.RecordMap.Model.DataType.RecordType [ CodeMode = expression ]
{
"delimited"
}

XData RecordMap [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<Record xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="User.ReportExtra" type="delimited" char_encoding="UTF-8" targetClassname="User.ReportExtra.Record" batchClass="User.ReportExtra.Batch" complexBatchManaged="0" padFromLeft="0" recordTerminator="\x0a" allowEarlyTerminator="0">
  <Separators>
    <Separator>\x09</Separator>
  </Separators>
  <Field name="orderid" datatype="%String" sqlColumn="2">
  </Field>
  <Field name="data1" datatype="%String" sqlColumn="3">
  </Field>
  <Field name="data2" datatype="%String" sqlColumn="4">
  </Field>
  <Field name="memo" datatype="%String" sqlColumn="5">
  </Field>
  <Field name="Extra1" required="0" ignored="0" datatype="%String" sqlColumn="6" repeating="0">
  </Field>
  <Field name="Extra2" required="0" ignored="0" datatype="%String" sqlColumn="7" repeating="0">
  </Field>
</Record>
}

}
