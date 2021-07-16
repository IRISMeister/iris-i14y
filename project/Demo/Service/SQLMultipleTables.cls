Class Demo.Service.SQLMultipleTables Extends Ens.BusinessService [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set tSC=$$$OK	
	Try 
	{		
		$$$ThrowOnError(..ProcessMulti1())
		;Do ..ProcessNewCategories()
		;Do ..ProcessNewEquipments() //gets equipment, groups and models
	}
	Catch e
	{
		Set tSC=e.AsStatus()
	}
	
	Return tSC
}

Method ProcessMulti1()
{
	#Dim tRS As EnsLib.SQL.GatewayResultSet
	Set tSC=$$$OK	
	
	Try {
		Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastMulti1Key")
		$$$LOGINFO("Multi1 Next event Id "_tLastKey_"...")
		
		/// Gets all the new received events where equipment is involved, infer form here which ones are new
		Set tQueryStatement="SELECT multi1_id, data1 FROM multi1 WHERE multi1_id>? ORDER BY multi1_id"
		$$$ThrowOnError(..Adapter.ExecuteQuery(.tRS, tQueryStatement, tLastKey))

		If tRS.%SQLCODE<0 {
			$$$LOGERROR("SQL Failed SQLCODE:"_tRS.%SQLCODE)
		}

		While(tRS.Next())
		{
			Set tLastKey = tRS.Get("multi1_id")
			$$$LOGINFO(tRS.Get("multi1_id")_"/"_tRS.Get("data1"))
		}
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastMulti1Key", tLastKey)
	}
	Catch e
	{
		Set tSC=e.AsStatus()
	}
	
	Return tSC
}

Method OnInit() As %Status
{
   #; initialize persistent last key value (if not exists already)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastMulti1Key", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastMulti2Key", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastMulti3Key", 0)
   Quit $$$OK
}

}
