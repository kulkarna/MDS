
-- =============================================
-- Author:		Sheri Scott
-- Create date: 7/6/2012
-- Description:	Returns Utiltiy maintenance auditing log records.
-- =============================================
CREATE PROCEDURE [dbo].[usp_UtilityAuditSelect] 
	@UtilityCode VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    SELECT	UtilityCode
			,FullName
			,MarketCode
			,EntityId
			,DunsNumber
			,EnrollmentLeadDays
			,LeadScreenProcess
			,DealScreenProcess
			,AccountLength
			,AccountNumberPrefix
			,BillingType
			,PorOption
			,Phone
			,AuditChangeType
			,AuditChangeBy
			,AuditChangeDate
			,ColumnsChanged
    FROM LibertyPower..zAuditUtility ua (NOLOCK)
    LEFT OUTER JOIN LibertyPower..Market m (NOLOCK) ON m.ID = ua.MarketID
    WHERE UtilityCode = @UtilityCode
    ORDER BY AuditChangeDate DESC
    
    SET NOCOUNT OFF;

END
