--exec usp_FindDeEnrollmentLetterCandidates

-- =============================================
-- Author:		Sheri Scott
-- Create date: 2012-07-20
-- Description:	Inserts a row into LetterQueue 
-- with document type of "De-enrollment letter"
-- for each account which had an End Date value
-- with 7 days of run date.
-- =============================================
CREATE PROCEDURE [dbo].[usp_FindDeEnrollmentLetterCandidates]
	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE @contract_nbr varchar(50)
			, @AccountID int
			, @document_type_id int
			, @print_day datetime
			, @today datetime
			, @account_type varchar(50)
			, @sales_channel varchar(50)
			, @AccountCnt int
	
	SET @document_type_id = 49
	SET @today = lp_enrollment.dbo.ufn_date_format(getdate(), '<YYYY>-<MM>-<DD>')
	SET @AccountCnt = 0
	
	SELECT a.AccountID
	INTO #NotLost
	FROM lp_enrollment..retention_detail d (NOLOCK)
	JOIN lp_enrollment..retention_header h (NOLOCK) ON d.call_request_id = h.call_request_id
	JOIN LibertyPower..Account a (NOLOCK) ON d.account_id = a.AccountIDLegacy
	WHERE h.call_status != 'L'
	
	-- Get accounts lost in retention
	CREATE TABLE #QueueInserts (ContractNumber VARCHAR(50), AccountID VARCHAR(50))
	
	INSERT INTO #QueueInserts (ContractNumber, AccountID)
	SELECT a.contract_nbr, a.AccountID
	FROM libertypower.dbo.AccountLatestService i (nolock)
	JOIN lp_account.dbo.account a (nolock) ON i.AccountID = a.AccountID
	LEFT JOIN Libertypower..LetterQueue lq (nolock) ON a.AccountID = lq.AccountID AND a.contract_nbr = lq.ContractNumber AND lq.DocumentTypeID = @document_type_id
	WHERE a.AccountID NOT IN (SELECT AccountID FROM #NotLost)
	AND i.EndDate > '2012-07-25'
	AND lq.LetterQueueID IS NULL -- Ensures the sames contract/account does not get multiple letters.
	
	INSERT INTO [LibertyPower].[dbo].[LetterQueue]
           ([Status]
           ,[ContractNumber]
           ,[AccountID]
           ,[DocumentTypeID]
           ,[DateCreated]
           ,[ScheduledDate]
           ,[Username])
     SELECT 'Scheduled'
            ,ContractNumber
            ,AccountID
            ,@document_type_id
            ,@today
            ,@today
            ,'JOB'
       FROM #QueueInserts
      WHERE NOT EXISTS (SELECT * 
                          FROM LetterQueue 
                         WHERE AccountID = @AccountID 
                           AND DocumentTypeID = @document_type_id)
	
	PRINT @@ROWCOUNT
	
END

