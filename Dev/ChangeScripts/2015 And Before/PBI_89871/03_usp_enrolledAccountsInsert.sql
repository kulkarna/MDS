USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetBillGroupRecent]    Script Date: 10/8/2015 4:54:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_EnrolledAccounts_Insert 
 * <Purpose,,>
 * This  SP Retrurns  the List of Accounts currently actively enrolled
 * 
 * History

 *******************************************************************************
 * 10/08/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */
ALTER PROC usp_EnrolledAccounts_Insert
    
AS
BEGIN
   SET NOCOUNT ON;         
   BEGIN TRY

         -- Truncate the table  before making fresh Insert
		 TRUNCATE TABLE [dbo].[AnnualUsageTranDetail];
		 ---Make the insert into the table by selecting the data from Enrolled accounts.
		 INSERT INTO [dbo].[AnnualUsageTranDetail]
					  SELECT a.AccountId,
							 a.AccountNumber,
							 a.UtilityId,
							 null,
							 GETDATE(),
							 null
					  FROM libertypower..AccountContract ac(nolock)
						   JOIN libertypower..Account a(nolock)
						   ON ac.AccountID = a.AccountID
						   JOIN LibertyPower..Contract c(nolock)
						   ON c.ContractID = ac.ContractID
						  AND C.ContractID = A.CurrentContractID
						   JOIN LIbertyPower..AccountStatus ST(NOLock)
						   ON ST.AccountContractID = AC.AccountContractID
						   JOIN LibertyPower..AccountLatestService(nolock)als
						   ON als.AccountID = a.AccountID
						   JOIN Lp_account..enrollment_status_substatus_vw evw(NoLock)
						   ON evw.status = ST.Status
						   AND evw.sub_status = st.SubStatus
					  WHERE 1 = 1
							--Curretnly inservice
						   AND als.StartDate <= GETDATE()
						   AND (als.EndDate >= GETDATE()
						   OR als.EndDate IS NULL)
						    --in enrolled DOne Status 
						   AND st.Status + '-' + st.SubStatus IN('905000-10')
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
