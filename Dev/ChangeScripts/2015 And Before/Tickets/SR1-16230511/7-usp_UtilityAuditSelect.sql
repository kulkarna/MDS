USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_UtilityAuditSelect]    Script Date: 07/09/2012 10:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC usp_UtilityAuditSelect @UtilityCode='TEST'

-- =============================================
-- Author:		Sheri Scott
-- Create date: 7/6/2012
-- Description:	Returns Utiltiy maintenance auditing log records.
-- =============================================
ALTER PROCEDURE [dbo].[usp_UtilityAuditSelect] 
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
    FROM LibertyPower..zAuditUtility ua
    LEFT OUTER JOIN LibertyPower..Market m ON m.ID = ua.MarketID
    WHERE UtilityCode = @UtilityCode
    ORDER BY AuditChangeDate DESC
    
    SET NOCOUNT OFF;

END
