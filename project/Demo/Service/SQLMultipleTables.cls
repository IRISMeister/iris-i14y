Class Demo.Service.SQLMultipleTables Extends Ens.BusinessService [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set tSC=$$$OK	
	Try 
	{		
		$$$ThrowOnError(..Processlogtable1())
		;Do ..ProcessNewCategories()
		;Do ..ProcessNewEquipments() //gets equipment, groups and models
	}
	Catch e
	{
		Set tSC=e.AsStatus()
	}
	
	Return tSC
}

Method Processlogtable1()
{
	#Dim tRS As EnsLib.SQL.GatewayResultSet
	Set tSC=$$$OK	
	
	Try {
		Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "Lastlogtable1Key")
		$$$LOGINFO("logtable1 Next event Id "_tLastKey_"...")
		
		/// Gets all the new received events where equipment is involved, infer form here which ones are new
		Set tQueryStatement="SELECT logtable1_id, data1 FROM logtable1 WHERE logtable1_id>? ORDER BY logtable1_id"
		$$$ThrowOnError(..Adapter.ExecuteQuery(.tRS, tQueryStatement, tLastKey))

		If tRS.%SQLCODE<0 {
			$$$LOGERROR("SQL Failed SQLCODE:"_tRS.%SQLCODE)
		}

		While(tRS.Next())
		{
			Set tLastKey = tRS.Get("logtable1_id")
			$$$LOGINFO(tRS.Get("logtable1_id")_"/"_tRS.Get("data1"))
		}
		Do ..Adapter.SetPersistentValue(..%ConfigName, "Lastlogtable1Key", tLastKey)
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
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "Lastlogtable1Key", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "Lastlogtable2Key", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "Lastlogtable3Key", 0)
   Quit $$$OK
}

}
