


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_accounts_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

DECLARE	@w_OE_ACCOUNT_ID	int,
		@w_ACCOUNT_ID		varchar(50),
		@w_ACCOUNT_NUMBER	varchar(50),
		@w_row_count		int

CREATE TABLE #Accounts	(OE_ACCOUNT_ID int, ACCOUNT_ID varchar(50), ACCOUNT_NUMBER varchar(50))

INSERT INTO #Accounts
SELECT	OE_ACCOUNT_ID, ACCOUNT_ID, ACCOUNT_NUMBER
FROM	OE_OFFER_ACCOUNTS
WHERE	OFFER_ID = @p_offer_id	


SELECT	TOP 1 @w_OE_ACCOUNT_ID = OE_ACCOUNT_ID, @w_ACCOUNT_ID = ACCOUNT_ID, @w_ACCOUNT_NUMBER = ACCOUNT_NUMBER
FROM	#Accounts

SET		@w_row_count = @@ROWCOUNT

WHILE	@w_row_count > 0
	BEGIN
		INSERT INTO	OE_OFFER_ACCOUNTS (OFFER_ID, OE_ACCOUNT_ID, ACCOUNT_ID, ACCOUNT_NUMBER)
		VALUES		(@p_offer_id_clone, @w_OE_ACCOUNT_ID, @w_ACCOUNT_ID, @w_ACCOUNT_NUMBER)

		DELETE FROM	#Accounts
		WHERE		ACCOUNT_NUMBER = @w_ACCOUNT_NUMBER

		SELECT	TOP 1 @w_OE_ACCOUNT_ID = OE_ACCOUNT_ID, @w_ACCOUNT_ID = ACCOUNT_ID, @w_ACCOUNT_NUMBER = ACCOUNT_NUMBER
		FROM	#Accounts

		SET		@w_row_count = @@ROWCOUNT
	END

DROP TABLE #Accounts
