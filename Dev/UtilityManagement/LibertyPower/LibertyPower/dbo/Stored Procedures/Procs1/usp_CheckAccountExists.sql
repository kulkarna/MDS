-- =============================================
-- Author:		Rafael Vasconcelos
-- Create date: 5/15/2012
-- Description:	Check if an account with the specified account number or account is exists in the database
-- =============================================
CREATE PROCEDURE [dbo].[usp_CheckAccountExists]
	@AccountID INT =  NULL,
	@AccountNumber VARCHAR(30) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @AccountExists as bit
	
	SET @AccountExists = 0

IF((@AccountID IS NOT NULL) OR (@AccountNumber IS NOT NULL))
BEGIN
    SELECT @AccountExists = 
		CASE WHEN
		(SELECT  COUNT(*) FROM LibertyPower..Account a with (nolock)
			WHERE		
				a.AccountNumber = COALESCE(@AccountNumber, a.AccountNumber)
				AND a.AccountId = COALESCE(@AccountID, a.AccountId)
				 ) > 0
		THEN 1
		ELSE 0
		END
END
			
	SELECT @AccountExists
			
END
