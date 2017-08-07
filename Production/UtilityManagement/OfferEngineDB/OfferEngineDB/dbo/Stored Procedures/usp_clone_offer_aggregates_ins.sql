


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_aggregates_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

DECLARE		@w_ID		int,
			@w_UTILITY	varchar(50),
			@w_ZONE		varchar(50),
			@w_ICAP		decimal(18,9),
			@w_TCAP		decimal(18,9),
			@w_LOSSES	decimal(18,9),
			@w_ACCEPT	tinyint,
			@w_row_count	int

CREATE TABLE #Aggregates	(ID int IDENTITY(1,1) NOT NULL, UTILITY varchar(50), ZONE varchar(50), ICAP decimal(18,9), 
							TCAP decimal(18,9), LOSSES decimal(18,9), ACCEPT int)

INSERT INTO #Aggregates
SELECT		UTILITY, ZONE, ICAP, TCAP, LOSSES, ACCEPT
FROM		OE_OFFER_AGGREGATES
WHERE		OFFER_ID = @p_offer_id	


SELECT	TOP 1 @w_ID = ID, @w_UTILITY = UTILITY, @w_ZONE = ZONE, @w_ICAP = ICAP, @w_TCAP = TCAP, @w_LOSSES = LOSSES, @w_ACCEPT = ACCEPT
FROM	#Aggregates

SET		@w_row_count = @@ROWCOUNT


WHILE	@w_row_count > 0
	BEGIN
		INSERT INTO	OE_OFFER_AGGREGATES (OFFER_ID, UTILITY, ZONE, ICAP, TCAP, LOSSES, ACCEPT)
		VALUES		(@p_offer_id_clone, @w_UTILITY, @w_ZONE, @w_ICAP, @w_TCAP, @w_LOSSES, @w_ACCEPT)

		DELETE FROM	#Aggregates
		WHERE		ID = @w_ID

		SELECT	TOP 1 @w_ID = ID, @w_UTILITY = UTILITY, @w_ZONE = ZONE, @w_ICAP = ICAP, @w_TCAP = TCAP, @w_LOSSES = LOSSES, @w_ACCEPT = ACCEPT
		FROM	#Aggregates

		SET		@w_row_count = @@ROWCOUNT
	END

DROP TABLE #Aggregates
