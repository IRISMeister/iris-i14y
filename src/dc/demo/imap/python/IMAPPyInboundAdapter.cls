/// Description
Class dc.demo.imap.python.IMAPPyInboundAdapter Extends EnsLib.EMail.InboundAdapter
{

/// Description
Property MailServer As dc.demo.imap.python.POP3ToIMAPPyAdapter;

/// Description
Property Mailbox As %String [ InitialExpression = "INBOX" ];

Property FilePath As %String(MAXLEN = 1000);

Parameter SETTINGS = "POP3Server:Basic,POP3Port:Basic,Credentials:Basic:credentialsSelector,SSLConfig:Connection:sslConfigSelector,SSLCheckServerIdentity:Connection,MatchFrom,MatchTo,MatchSubject,Mailbox,FilePath";

Method OnInit() As %Status
{
    $$$TOE(sc, ##super())
    Do ..MailServer.SetMailboxName(..Mailbox)
    Return $$$OK
}

}
