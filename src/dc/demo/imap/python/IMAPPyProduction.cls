Class dc.demo.imap.python.IMAPPyProduction Extends Ens.Production
{

ClassMethod OnStart(pTimeStarted As %String) As %Status
{
  Set tSC=$$$OK
  Try {
    #; Refresh Tokenを使ったoAuth2認証の例
    Set file="/run/secrets/gmail_cred"
    if ##class(%File).Exists(file) {
      Set stream = ##class(%Stream.FileCharacter).%New()
      Set sc = stream.LinkToFile(file)
      Set json = {}.%FromJSON(stream)
      Set tSC=##class(Ens.Config.Credentials).SetCredential("mail-gmail",json.UserName,"",1)
    }
    #; これとは別にCLientId,ClientSecret,RefreshTokenを取得し、プロダクションに反映する
    Set file="/run/secrets/gmail_client_secret"
    if ##class(%File).Exists(file) {
      Set stream = ##class(%Stream.FileCharacter).%New()
      Set sc = stream.LinkToFile(file)
      Set json = {}.%FromJSON(stream)

      Do ##class(Ens.Director).GetAdapterSettings("IMAP-GMAIL",.p)
      Set p("ClientId")=json."client_id"
      Set p("ClientSecret")=json."client_secret"
      Set p("RefreshToken")=json."refresh_token"
      Merge settings("IMAP-GMAIL","Adapter")=p
      Set tSC=##class(Ens.Production).ApplySettings("dc.demo.imap.python.IMAPPyProduction",.settings)
    }
	}
	Catch e {
		Set tSC=e.AsStatus()
	}
  //必須ではないので常に成功させる
	Return $$$OK
}

XData ProductionDefinition
{
<Production Name="dc.demo.imap.python.IMAPPyProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="IMAP-GMAIL" Category="mail,custom" ClassName="dc.demo.imap.python.IMAPPyTestService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="POP3Port">993</Setting>
    <Setting Target="Adapter" Name="POP3Server">imap.gmail.com</Setting>
    <Setting Target="Adapter" Name="Credentials">mail-gmail</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Mailbox">INBOX</Setting>
    <Setting Target="Adapter" Name="CallInterval">30</Setting>
    <Setting Target="Adapter" Name="MatchSubject">[IMAP test]</Setting>
    <Setting Target="Adapter" Name="FilePath">/var/tmp/</Setting>
  </Item>
  <Item Name="dc.demo.imap.IMAPTestSendEmailOperation" Category="" ClassName="dc.demo.imap.IMAPTestSendEmailOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">mail-gmail</Setting>
    <Setting Target="Adapter" Name="SMTPPort">465</Setting>
    <Setting Target="Adapter" Name="SMTPServer">smtp.mail.yahoo.com</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="From"></Setting>
    <Setting Target="Adapter" Name="Recipient"></Setting>
    <!-- <Setting Target="Adapter" Name="SSLCheckServerIdentity">1</Setting> -->
  </Item>
</Production>
}

}
