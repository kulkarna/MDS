USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetIdrUsageDate]    Script Date: 9/14/2015 10:45:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_GetIdrUsageDate
 * <Purpose,,>
 * This  SP Retrurns  the most recent IDR UsageDate value for the Account/UtilityCode Passed in
 * 
 * History

 *******************************************************************************
 * 09/14/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_GetIdrUsageDate] 
	(@p_AccountNumber			VARCHAR(30)		= NULL
	,@p_UtilityCode				VARCHAR(15)		= NULL
	)
AS

BEGIN
   SET NOCOUNT ON;         
   BEGIN TRY
           DECLARE @SQLQuery			VARCHAR(500)
			      ,@strMessage			VARCHAR(500)	
			
           DECLARE @IDRusageDate	TABLE (
				 ID						INT IDENTITY (1,1)
				,AccountNumber			VARCHAR(30)
				,UtilityCode			VARCHAR(15)
				,UsageDate               DATETIME) ;

        
				

		IF @p_AccountNumber IS NULL
			RAISERROR 50000 'Missing the and Account Number'

		IF @p_UtilityCode IS NULL
			RAISERROR 50000 'Missing  the Utility Code'
       
		--If both arguments valid Check the EdiAccount Table for BillGroup Data 
		IF (@p_AccountNumber IS NOT NULL) AND  (@p_UtilityCode IS NOT NULL)
		BEGIN

		    ---Get the Changed account details if  account Number previously changed.
		    SELECT * INTO #TEMPACCOUNTS
				FROM LP_ACCOUNT.DBO.ufn_GetChangedAccountList(@p_AccountNumber)

            ---- Select the IDRUsageDate for the account Number
			INSERT Into @IDRusageDate
				Select b.AccountNumber,b.UtilityCode,a.Date from lp_transactions..IdrUsageHorizontal(nolock) a
				INNER JOIN lp_transactions..EdiAccount(nolock) b
				ON a.EdiAccountId = b.ID
				where b.AccountNumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))
				AND b.UtilityCode = @p_UtilityCode
				AND a.UnitOfMeasurement = 'KH'

			

			IF @@ROWCOUNT > 0 ---This means at  least one row with a valid Date Exist, so get the latest UsageDate.
				BEGIN
					 Select Max(UsageDate) from @IDRusageDate;
				END	
			ELSE	 --- No UsageDate found for the AccountNumber/UtilityCode combination
				BEGIN
					SET @strMessage		= 'IDR USageDate Not Found For the Account informed: ' + LTRIM(RTRIM(@p_AccountNumber)) + '(' + LTRIM(RTRIM(@p_UtilityCode))
					RAISERROR 50000 @strMessage
				END	 
		END		
	   
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
	
    SET NOCOUNT OFF;
END

-- Copyright 06/11/2015 Liberty Power
