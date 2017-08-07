USE [Libertypower]
GO
/****** Object:  Trigger [dbo].[AfterUpdateCheckDeenrollment]    Script Date: 07/03/2013 09:41:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/15/2011
-- Description:	Part replacement for legacy trigger: tr_account_upd_ins
--			    The trigger had 2 operations, one was not linked to account status and was moved to the account table
--				The same logic is in the INSTEAD OF TRIGGER of the lp_account..account table and they both need to do the same
-- =============================================
-- Update		: 07/03/2013   Jose Munoz - SWCS
-- TFS 14194	: Update the query to verify the De-Enrollment date only
                  from the current active contract and not for history contracts.
-- =============================================
*/
ALTER TRIGGER [dbo].[AfterUpdateCheckDeenrollment]
   ON  [dbo].[AccountStatus]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE  @AccountNumber				VARCHAR(30)
			,@AccountID					CHAR(15)
			,@Message					VARCHAR(300)
    
    -- Insert statements for trigger here
	-- check deenrollment date
	IF UPDATE([Status]) OR UPDATE(SubStatus)
	BEGIN
		/* TFS 14194 Begin */
		SELECT  @AccountNumber		= AA.AccountNumber
				, @AccountID		= AA.AccountID 
		FROM Inserted I
		INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
		ON AC.AccountContractID		= I.AccountContractID
		INNER JOIN Libertypower..Account AA WITH (NOLOCK)
		ON AA.AccountID				= AC.AccountID
		AND AA.CurrentContractID	= AC.ContractID
		INNER JOIN LibertyPower.dbo.AccountLatestService AAS WITH (NOLOCK) 
		ON AAS.AccountID			= AA.AccountID
		WHERE ((I.[Status]			= '911000' AND I.[Substatus] = '10')
			OR (I.[Status]			= '11000' AND I.[Substatus] = '50'))	
		AND (AAS.EndDate			IS NULL OR CONVERT(VARCHAR(8),AAS.EndDate,112) = '19000101')
		/* TFS 14194 End */
		
		IF @@ROWCOUNT > 0
		BEGIN
			ROLLBACK
			SET @Message	=	'The Account number ' + LTRIM(RTRIM(@AccountNumber)) + ' (' + LTRIM(RTRIM(@AccountID)) + ') is in De-Enrollement Done status or Pending De-enrollment Confirmed status and the De-Enrollment date is invalid.' 
			SET NOCOUNT OFF;
			RAISERROR 26001 @Message
		END
	END  
	SET NOCOUNT OFF;
END
