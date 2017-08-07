
/*******************************************************************************
 * usp_AuditUsageUsedLogInsert
 * logs errors from the Calculate Annual Usage logic of the Framework
 *
 * History
 *******************************************************************************
 * 03/05/2010 - Eduardo Patino
 * Created.
 *******************************************************************************
 */
create PROCEDURE [dbo].[usp_AuditUsageUsedLogInsert]
	@namespace		varchar(50),
	@method			varchar(50),
	@errorNumber	int = -1,
	@errorMessage	varchar(500),
	@comment		varchar(500) = '',
	@createdBy		varchar(50)
AS
-- select * from AuditUsageUsedLog
BEGIN
	SET NOCOUNT ON;

	INSERT INTO AuditUsageUsedLog
		([namespace], method, errorNumber, errorMessage, comment, createdBy)
	VALUES
		(@namespace, @method, @errorNumber, @errorMessage, @comment, @createdBy)

	SELECT Scope_Identity() as ID

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

