CREATE PROCEDURE create_zaudit
	@table_name varchar(60)
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #output
	(
		cnt				int NOT NULL PRIMARY KEY IDENTITY(1,1),
		column_name		sysname,
		column_type		sysname,
		column_length	varchar(10)
	)
	
	INSERT INTO #output 
	(
		column_name, 
		column_type, 
		column_length
	)
	SELECT	'[' + SC.name + ']', 
			'[' + ST.name + ']',
			rtrim(convert(char, SC.length))
	FROM	sysobjects SO, syscolumns SC, systypes ST 
	WHERE SO.id = SC.id 
	AND SC.xusertype = ST.xusertype 
	AND SO.name = @table_name 
	ORDER BY colid
	
	UPDATE	#output 
	SET		column_type = column_type + ' (' + column_length + ')' 
	WHERE	column_type IN ('[varchar]', '[char]', '[nvarchar]')

	PRINT 'IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N''[TR_zAudit_' + @table_name + '_insert]'') and OBJECTPROPERTY(id, N''IsTrigger'') = 1)'
	PRINT 'DROP TRIGGER [TR_zAudit_' + @table_name + '_insert]'
	PRINT 'GO'
	PRINT ''

	PRINT 'IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N''[TR_zAudit_' + @table_name + '_update]'') and OBJECTPROPERTY(id, N''IsTrigger'') = 1)'
	PRINT 'DROP TRIGGER [TR_zAudit_' + @table_name + '_update]'
	PRINT 'GO'
	PRINT ''

	PRINT 'IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N''[TR_zAudit_' + @table_name + '_delete]'') and OBJECTPROPERTY(id, N''IsTrigger'') = 1)'
	PRINT 'DROP TRIGGER [TR_zAudit_' + @table_name + '_delete]'
	PRINT 'GO'
	PRINT ''

	PRINT 'IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N''[TR_zAudit_' + @table_name + '_insteadof]'') and OBJECTPROPERTY(id, N''IsTrigger'') = 1)'
	PRINT 'DROP TRIGGER [TR_zAudit_' + @table_name + '_insteadof]'
	PRINT 'GO'
	PRINT ''

	PRINT 'IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N''[zAudit_' + @table_name + ']'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'
	PRINT 'DROP TABLE [zAudit_' + @table_name + ']'
	PRINT 'GO'
	PRINT ''

	PRINT 'CREATE TABLE [zAudit_' + @table_name + ']'
	PRINT '('
	SELECT '    ' + column_name + ' ' + column_type + ' NULL,'  from #output
	PRINT '    [audit_change_type]      [char]     (3)  NOT NULL,'
	PRINT '    [audit_change_dt]        [datetime]      NOT NULL CONSTRAINT [DF_zAudit' + @table_name + '__audit_change_dt] DEFAULT (getdate()),'
	PRINT '    [audit_change_by]        [varchar] (30)  NOT NULL CONSTRAINT [DF_zAudit' + @table_name + '__audit_change_by] DEFAULT (substring(suser_sname(),1,30)),'
	PRINT '    [audit_change_location]  [varchar] (30)  NOT NULL CONSTRAINT [DF_zAudit' + @table_name + '__audit_change_location] DEFAULT (substring(host_name(),1,30))'
	PRINT ')'
	PRINT 'GO'
	PRINT ''
	
	PRINT 'CREATE TRIGGER [TR_zAudit_' + @table_name + '_insert]'
	PRINT 'ON [' + @table_name + ']'
	PRINT 'FOR INSERT'
	PRINT 'NOT FOR REPLICATION'
	PRINT 'AS'
	PRINT '    SET NOCOUNT ON'
	PRINT ''
	PRINT '    INSERT INTO [zAudit_' + @table_name + ']'
	PRINT '    ('
	SELECT '    ' + column_name + ',' from #output
	PRINT '    [audit_change_type]'
	PRINT '    )'
	PRINT '    SELECT '
	SELECT '    ' + column_name + ',' from #output
	PRINT '    ''INS'''
	PRINT '    FROM inserted'
	PRINT 'GO'
	PRINT ''
	
	PRINT 'CREATE TRIGGER [TR_zAudit_' + @table_name + '_update]'
	PRINT 'ON [' + @table_name + ']'
	PRINT 'FOR UPDATE'
	PRINT 'NOT FOR REPLICATION'
	PRINT 'AS'
	PRINT '    SET NOCOUNT ON'
	PRINT ''
	PRINT '    INSERT INTO [zAudit_' + @table_name + ']'
	PRINT '    ('
	SELECT '    ' + column_name + ',' from #output
	PRINT '    [audit_change_type]'
	PRINT '    )'
	PRINT '    SELECT '
	SELECT '    ' + column_name + ',' from #output
	PRINT '    ''UPD'''
	PRINT '    FROM inserted'
	PRINT 'GO'
	PRINT ''
	
	PRINT 'CREATE TRIGGER [TR_zAudit_' + @table_name + '_delete]'
	PRINT 'ON [' + @table_name + ']'
	PRINT 'FOR DELETE'
	PRINT 'NOT FOR REPLICATION'
	PRINT 'AS'
	PRINT '    SET NOCOUNT ON'
	PRINT ''
	PRINT '    INSERT INTO [zAudit_' + @table_name + ']'
	PRINT '    ('
	SELECT '    ' + column_name + ',' from #output
	PRINT '    [audit_change_type]'
	PRINT '    )'
	PRINT '    SELECT '
	SELECT '    ' + column_name + ',' from #output
	PRINT '    ''DEL'''
	PRINT '    FROM deleted'
	PRINT 'GO'
	PRINT ''
	
	PRINT 'CREATE TRIGGER [TR_zAudit_' + @table_name + '_insteadof]'
	PRINT 'ON [zAudit_' + @table_name + ']'
	PRINT 'INSTEAD OF DELETE, UPDATE'
	PRINT 'NOT FOR REPLICATION'
	PRINT 'AS'
	PRINT '    RAISERROR (''Can not update or delete audit information.'', 16, 1)'
	PRINT 'GO'
	PRINT ''
	
	SET NOCOUNT OFF
END



