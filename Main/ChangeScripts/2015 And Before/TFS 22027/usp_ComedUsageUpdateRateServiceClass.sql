USE [lp_transactions]
GO
/****** Object:  Trigger [dbo].[ComedUsageUpdateDealCaptureRateServiceClass]    Script Date: 10/14/2013 09:24:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Munoz - SWSC
-- Create date: 10/15/2013
-- Description:	Process the rateclass update in the AccountTable
--				with information from the table "lp_transactions..ComedUsage"
-- =============================================
CREATE PROCEDURE [dbo].[usp_ComedUsageUpdateRateServiceClass] 
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @ProcessDate		DATETIME
		,@username				VARCHAR(100)
	
	SELECT @ProcessDate			= GETDATE()
		,@username				= SUSER_SNAME()
	
	BEGIN TRY
	
		BEGIN TRAN	
		
		SELECT ComedUsageID
		INTO #TEMP
		FROM lp_transactions..ComedUsageUpdateControl WITH(NOLOCK)
		WHERE DateUpdateAccount		IS NULL
		
		CREATE UNIQUE CLUSTERED INDEX UDX_ComedUsageID ON #TEMP (ComedUsageID)
		
		INSERT INTO lp_account..account_comments
		SELECT a.AccountIdLegacy, @ProcessDate, 'Automatically Update', 'Rate Service Class update. Procedure(usp_ComedUsageUpdateRateServiceClass)', @username, 0 
		FROM Libertypower..Account a WITH(NOLOCK)
		INNER JOIN lp_transactions..ComedUsage  i WITH(NOLOCK)
		ON a.AccountNumber			= i.AccountNumber
		INNER JOIN Libertypower..Utility u WITH (NOLOCK) 
		ON u.ID						= a.UtilityID
		WHERE u.UtilityCode			= 'COMED'
		AND i.Rate					<> a.ServiceRateClass
		AND i.Rate					<> ''
		AND NOT (i.Rate				IS NULL)
		AND i.Id					IN (SELECT ComedUsageID FROM #TEMP WITH (NOLOCK))
		
		
		UPDATE Libertypower..Account
		SET ServiceRateClass		= i.Rate
		FROM Libertypower..Account a WITH(NOLOCK)
		INNER JOIN lp_transactions..ComedUsage i WITH(NOLOCK)
		ON a.AccountNumber			= i.AccountNumber
		INNER JOIN Libertypower..Utility u WITH (NOLOCK) ON a.UtilityID = u.ID	
		WHERE u.UtilityCode			= 'COMED'
		AND i.Rate					<> a.ServiceRateClass
		AND i.Rate					<> ''
		AND NOT (i.Rate				IS NULL)
		AND i.Id					IN (SELECT ComedUsageID FROM #TEMP WITH (NOLOCK))
		
		UPDATE lp_transactions..ComedUsageUpdateControl 
		SET DateUpdateAccount		= @ProcessDate
		WHERE ComedUsageID			IN (SELECT ComedUsageID FROM #TEMP WITH (NOLOCK))
		
		COMMIT TRAN
	END TRY
	BEGIN CATCH

		SELECT 
			ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;

		ROLLBACK TRAN
		
	END CATCH
		
	SET NOCOUNT OFF;
END
