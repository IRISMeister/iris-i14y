Class dc.demo.imap.python.IMAPPyTestService Extends Ens.BusinessService
{

Parameter ADAPTER = "dc.demo.imap.python.IMAPPyInboundAdapter";

Method OnProcessInput(pMailMessage As %Net.MailMessage, pOutput As %RegisteredObject) As %Status
{
    Set tSC = $$$OK
    Try {
        $$$TRACE("received email from "_pMailMessage.From_". To "_pMailMessage.To.GetAt(1)_". Subject"_pMailMessage.Subject)
        $$$TRACE("ContentType: "_pMailMessage.ContentType)

        If pMailMessage.IsBinary
        {
            $$$TRACE("This message is binary; not expected")
            Quit
        }

        //Check if mail message has multiple parts
        If pMailMessage.IsMultiPart
        {
            $$$TRACE("This message has multiple parts.")

            Set parts=pMailMessage.Parts
            $$$TRACE("MultiPart Count:"_parts.Count())

            For i=1:1:parts.Count() {
                Set mp=parts.GetAt(i)
                $$$TRACE("mp.ContentType["_i_"]: "_mp.ContentType)

                if mp.IsMultiPart {
                    $$$TRACE("further multiple parts. Do nothing.")
                    /*
                    Set parts2=mp.Parts
                    For j=1:1:parts2.Count() {
                        Set mp2=parts2.GetAt(i)
                        $$$TRACE("mp2.ContentType: "_mp2.ContentType)

                        $$$TRACE("mp2.IsMultiPart:"_mp2.IsMultiPart)
                        $$$TRACE("mp2.IsHTML:"_mp2.IsHTML)
                        $$$TRACE("mp2.IsBinary:"_mp2.IsBinary)
                        Set maildata=mp2.TextData // %Library.FileCharacterStream
                        $$$TRACE("TextData:["_maildata.Read(100)_"]")
                        Set maildata=mp2.BinaryData // %Library.FileCharacterStream
                        $$$TRACE("BinaryData:["_maildata.Read(100)_"]")
                    }
                    */

                }
                Elseif mp.IsHTML {
                    $$$TRACE("Ignoring HTML part.")
                }
                Elseif mp.IsBinary {
                    $$$TRACE("Binary part. : ContentType "_mp.ContentType_" Size:"_mp.BinaryData.Size)
                    If mp.IsBase64 {
                        ; d mp.BinaryData.Rewind()
                        b
                    }
                }
                Else {
                    Set maildata=mp.TextData // %Library.FileCharacterStream
                    $$$TRACE("maildata:["_maildata.Read(maildata.Size)_"]")
                }
            }
        }


        //now safe to get text of message
        ;Set pReq=##class(EEMA.EmailContents).%New()
        ;Set pReq.MessageText=pMailMessage.TextData

        /*
        Set tSendReply = ##class(dc.demo.imap.IMAPTestReplyMsg).%New()
        Set tSendReply.Text = tSubject
        Set tSendReply.Destination = pMailMessage.From
        Set tSendReply.Sender = pMailMessage.To.GetAt(1)
        Set tSC = ..SendRequestAsync("dc.demo.imap.IMAPTestSendEmailOperation", tSendReply)
        $$$TRACE("SendRequestAsync to dc.demo.imap.IMAPTestSendEmailOperation")    
        */
    } Catch(ex) {
        Set tSC = ex.AsStatus()
    }
    Quit tSC
}

}
