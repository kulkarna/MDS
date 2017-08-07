
/*******************************************************************************
 * usp_CheckAuditUsageUsed
 * searches the audit log for annual usage related errors
 *
 * History
 *
 *******************************************************************************
 * 01/12/2011 - Leonardo Lima
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_CheckAuditUsageUsed]
	@p_account_number varchar(30)
AS
BEGIN
	-- usp_CheckAuditUsageUsed '2975389048'
	SET NOCOUNT ON;

	SELECT TOP 1 * FROM libertypower..AuditUsageUsedLog (NOLOCK) 
	WHERE created >= dateadd(d, -7, getdate()) and comment LIKE '%' + @p_account_number + '%' 
	ORDER BY 1 DESC

	SET NOCOUNT OFF;
END

