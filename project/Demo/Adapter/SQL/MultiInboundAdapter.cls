Class Demo.Adapter.SQL.MultiInboundAdapter Extends EnsLib.SQL.InboundAdapter
{

Property DSN As %String;

/// Setting InitialExpression to "select 1"
Property Query As %String(MAXLEN = "") [ InitialExpression = "select 1", Required ];

}
