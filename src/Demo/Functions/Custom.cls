Include Ensemble

Class Demo.Functions.Custom Extends Ens.Rule.FunctionSet
{

ClassMethod MyFunction(OriginalFilename As %String, src As %String) As %Integer [ Final ]
{
    // Dump local variables for debugging purpose
    // $ docker-compose exec iris cat /home/irisuser/dump.txt
    // Set file="/home/irisuser/dump.txt" open file:"NWS" use file zw  zw src close file

    // This is equivalent to condition:Document.OriginalFilename="source1_2.txt"
    If OriginalFilename="source1_2.txt" { 
        Return 1 
    }
    Else {Return 0}
}

ClassMethod MyFunction2(doc As EnsLib.HTTP.GenericMessage, src As %String) As %Integer [ Final ]
{
    //Set file="/home/irisuser/dump.txt" open file:"NWS" use file zw  zw src close file
    // WIP.
    //curl -X POST http://localhost:52773/csp/demo/restpassthrough/RESTPassThrough -F data=@upload/demo/source1_1.txt -v
    If (doc.Stream.Size>0)&(doc.HTTPHeaders.GetAt("HttpRequest")="POST") { 
        // note, Stream contains mime data like this
        //--------------------------077932247b0d1769
        //Content-Disposition: form-data; name="data"; filename="source1_1.txt"
        //Content-Type: text/plain
        //
        // 任意のファイル1
        //内容不等
        //
        //--------------------------077932247b0d1769--
        Return 1 
    }
    Else {Return 0}
}

}
