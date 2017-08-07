-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Creates an account that filed a complaint and never was an LP customer.
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountCreateOrUpdate] 
    @AccountID int,
    @UtilityAccountNumber varchar(30) = NULL,
    @AccountName varchar(200) = NULL,
    @UtilityID int = NULL,
    @MarketCode char(2),
    @Address nvarchar(150) = NULL,
    @City nvarchar(100) = NULL,
    @Zip char(10) = NULL,
    @SalesAgent varchar(64) = NULL,
    @SalesChannelID int = NULL
AS

BEGIN
	SET NOCOUNT ON;

    IF (@AccountID > 0)
		UPDATE ComplaintAccount SET
			UtilityAccountNumber = @UtilityAccountNumber,
			AccountName = @AccountName,
			UtilityID = @UtilityID,
			MarketCode = @MarketCode,
			[Address] = @Address,
			City = @City,
			Zip = @Zip,
			SalesAgent = @SalesAgent,
			SalesChannelID = @SalesChannelID
		WHERE ComplaintAccountID = @AccountID
    ELSE
		BEGIN
			INSERT INTO ComplaintAccount(
					UtilityAccountNumber,
					AccountName,
					UtilityID,
					MarketCode,
					[Address],
					City,
					Zip,
					SalesAgent,
					SalesChannelID
					)
			VALUES (
					@UtilityAccountNumber,
					@AccountName,
					@UtilityID,
					@MarketCode,
					@Address,
					@City,
					@Zip,
					@SalesAgent,
					@SalesChannelID
					)
					
			SET @AccountID = SCOPE_IDENTITY()
		END
		
		SELECT @AccountID as AccountID
END
