Include Ensemble

Class Demo.Functions.Custom Extends Ens.Rule.FunctionSet
{

ClassMethod MyFunction(OriginalFilename As %String, src As %String) As %Integer [ Final ]
{
    // Dump local variables for debugging purpose
    // $ docker-compose exec iris cat /home/irisuser/dump.txt
    Set file="/home/irisuser/dump.txt" open file:"NWS" use file zw  zw src close file

    // This is equivalent to condition:Document.OriginalFilename="source1_2.txt"
    If OriginalFilename="source1_2.txt" { 
        Return 1 
    }
    Else {Return 0}
}

}
