CREATE TRIGGER DBTrg_Audit_schema_changes
ON DATABASE 
FOR DDL_TABLE_VIEW_EVENTS, DDL_FUNCTION_EVENTS, DDL_PROCEDURE_EVENTS, DDL_TRIGGER_EVENTS, DDL_ASSEMBLY_EVENTS
AS 
BEGIN

	Set nocount on

	Insert into DBAWORK.DBO.DDL_Log
	(	HostName
	,	LoginName
	,   	DBName	
	,   	ObjectName	
	,	EventType
	,	[TSQL]	
	)
	SELECT 
		sp.HostName
	,	sp.Loginame
	,	sd.Name
	,	EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(128)')
	,	EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','nvarchar(100)')
	,	EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand)[1]','nvarchar(max)')
	From master.sys.sysprocesses sp (nolock)
	join master.sys.sysdatabases sd (nolock) on sd.dbid = sp.dbid
	Where Spid = @@spid

END

