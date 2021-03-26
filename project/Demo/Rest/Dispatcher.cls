Class Demo.Rest.Dispatcher Extends %CSP.REST
{

Parameter CONVERTINPUTSTREAM = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/info" Method="GET" Call="GetInfo" Cors="true" />
<Route Url="/repo" Method="POST" Call='PostRepo' Cors="true" />
</Routes>
}

ClassMethod GetInfo() As %Status
{
    Set info={"HostName":($SYSTEM.INetInfo.LocalHostName()),"UserName":($USERNAME),"Status":"OK","TimeStamp":($ZDATETIME($H))}
	write info.%ToJSON()
    return $$$OK
}

ClassMethod PostRepo() As %Status
{
    #; How to call 
    #; curl -X POST -H "Content-Type: application/json; charset=UTF-8" -d '{"Name":"あいうえお", "Age":"100"}' http://localhost:52773/csp/demo/rest/repo -u SuperUser:SYS -v
    #; Don't call it from Windows. Will be garbled. Use Linux where LANG=ja_JP.UTF-8, instead.

    #; Content-Type: application/json; charset=UTF-8 を指定
	Set %response.ContentType="application/json"
	Set %response.CharSet=%request.CharSet

    #; 文字列のまま取り出し
    Set data=%request.Content.Read()
    #; ダイナミックオブジェクト化
    Set json={}.%FromJSON(data)

    Set id=$INCREMENT(^RestLog)
    Set ^RestLog(id)=data
    Set ^RestLog(id,"OriginalFilename")=json.OriginalFilename

    Set result={"Status":"OK","TimeStamp":($ZDATETIME($H))}
	write result.%ToJSON()

    return $$$OK
}

}
