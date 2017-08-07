
/*******************************************************************************
 * usp_AuditUsageUsed
 * Logs meter reads used to calculate the annual usage (for starters)..
 *
 * History
 *******************************************************************************
 * 03/10/2010 - Eduardo Patino
 * Created.
 *******************************************************************************
 */
create PROCEDURE [dbo].[usp_AuditUsageUsed]
	@AccountNumber		varchar(50),
	@RowId				bigint,
	@TriggeringEvent	varchar(80),
	@CreatedBy			varchar(30),
	@Created			datetime
AS
-- select * from AuditUsageUsed
BEGIN
	SET NOCOUNT ON;

	INSERT INTO	AuditUsageUsed (AccountNumber, RowId, TriggeringEvent, Created, CreatedBy)
	VALUES (@AccountNumber, @RowId, @TriggeringEvent, @Created, @CreatedBy)

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

