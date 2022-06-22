Class dc.demo.imap.python.IMAPPyTestService Extends Ens.BusinessService
{

Parameter ADAPTER = "dc.demo.imap.python.IMAPPyInboundAdapter";

Method OnProcessInput(pMailMessage As %Net.MailMessage, pOutput As %RegisteredObject) As %Status
{
    Set tSC = $$$OK
    Try {
        $$$TRACE("received email from "_pMailMessage.From_". To "_pMailMessage.To.GetAt(1)_". Subject"_pMailMessage.Subject)

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
                if mp.IsMultiPart {
                    $$$TRACE("multiple parts unexpeced. Ignore it.")
                }
                Elseif mp.IsHTML {
                    $$$TRACE("Ignoring HTML part.")
                }
                Elseif mp.IsBinary {
                    $$$TRACE("Ignoring binary part.")
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
