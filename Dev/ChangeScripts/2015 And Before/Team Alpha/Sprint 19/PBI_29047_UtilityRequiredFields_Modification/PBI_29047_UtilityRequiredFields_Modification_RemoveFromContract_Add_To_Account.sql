USE OnlineEnrollment
go

DECLARE @sql nvarchar(1000)
DECLARE constraints CURSOR LOCAL FOR
SELECT 'ALTER TABLE Contract DROP CONSTRAINT ' + df.name
FROM sys.default_constraints df
INNER JOIN sys.tables t ON df.parent_object_id = t.object_id
INNER JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
WHERE t.name = 'Contract'
AND c.name IN ('BillingAccount', 'MeterDataMgmtAgent', 'MeterInstaller', 'MeterReader', 'MeterOwner', 'MeterServiceProvider', 'NameKey', 'SchedulingCoordinator')

OPEN constraints
FETCH NEXT FROM constraints INTO @sql
WHILE @@FETCH_STATUS = 0
BEGIN
 EXECUTE sp_executesql @sql 
 --SELECT @sql
 FETCH NEXT FROM constraints INTO @sql
END
CLOSE constraints
DEALLOCATE constraints

ALTER TABLE Contract Drop Column BillingAccount
ALTER TABLE Contract Drop Column MeterDataMgmtAgent
ALTER TABLE Contract Drop Column MeterInstaller
ALTER TABLE Contract Drop Column MeterReader
ALTER TABLE Contract Drop Column MeterOwner
ALTER TABLE Contract Drop Column MeterServiceProvider
ALTER TABLE Contract Drop Column NameKey
ALTER TABLE Contract Drop Column SchedulingCoordinator

ALTER TABLE Account ADD BillingAccount VARCHAR(50) DEFAULT NULL
ALTER TABLE Account ADD MeterDataMgmtAgent VARCHAR(50) DEFAULT NULL
ALTER TABLE Account ADD MeterInstaller VARCHAR(50) DEFAULT NULL
ALTER TABLE Account ADD MeterReader VARCHAR(50) DEFAULT NULL
ALTER TABLE Account ADD MeterOwner VARCHAR(50) DEFAULT NULL
ALTER TABLE Account ADD MeterServiceProvider VARCHAR(50) DEFAULT NULL
ALTER TABLE Account ADD NameKey VARCHAR(50) DEFAULT NULL
ALTER TABLE Account ADD SchedulingCoordinator VARCHAR(50) DEFAULT NULL