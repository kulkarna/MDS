/********************************* [dbo].[usp_IDRAccountsUpdate] ********************/
CREATE PROCEDURE [dbo].[usp_IDRAccountsUpdate]
	  @UtilityID varchar(15)
	, @AccountNumber varchar(10)
	, @IDRStartDate datetime
	, @SiteUploadDate datetime
	, @CreateDate datetime
	, @ModifiedBy varchar(10)
AS
BEGIN
	-- First delete the account from the table
	DECLARE @Count INT
	SET @Count = (	SELECT	COUNT(AccountNumber) 
					FROM	dbo.IDRAccounts 
					WHERE	UtilityID = @UtilityID 
					AND		AccountNumber = @AccountNumber
					)

	IF 	@Count = '0' 
	BEGIN
	
		INSERT INTO dbo.IDRAccounts
			   (
				UtilityID,
				AccountNumber,
				IDRStartDate,
				SiteUploadDate,
				CreateDate,
				ModifiedBy)
		 VALUES
			   (
				 @UtilityID
				,@AccountNumber
				,@IDRStartDate
				,@SiteUploadDate
				,@CreateDate
				,@ModifiedBy)
	END

END
