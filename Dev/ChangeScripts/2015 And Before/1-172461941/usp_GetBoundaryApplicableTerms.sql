USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetBoundaryApplicableTerms]    Script Date: 08/09/2013 10:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sadiel Jarvis
-- Create date: Aug 9th, 2013
-- Description:	Given a @Term, need to return nearest lower (and next) applicable terms
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetBoundaryApplicableTerms]
(
	@Term int,
	@EffectiveDate datetime,
	@EffectiveDateStart datetime,
	@RetailMarket char(2),
	@Utility varchar(20),
	@AccountType char(3),
	@LowerApplicableTerm int OUTPUT,
	@HigherApplicableTerm int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Found bit
	SET @Found = 0

	DECLARE db_cursor CURSOR FOR  
	select distinct term from AccountEtfMarketRate 
	where 
	([EffectiveDate] = @EffectiveDate or ([EffectiveDate] between @EffectiveDateStart and @EffectiveDate))
			AND [RetailMarket] = @RetailMarket
			AND [Utility] = @Utility
			AND AccountType = @AccountType
	order by term

	OPEN db_cursor   
	FETCH NEXT FROM db_cursor INTO @HigherApplicableTerm   

	WHILE @@FETCH_STATUS = 0 AND @Found = 0  
	BEGIN   
		SET @LowerApplicableTerm = @HigherApplicableTerm
		FETCH NEXT FROM db_cursor INTO	@HigherApplicableTerm

		 IF @Term < @HigherApplicableTerm
		 BEGIN
		    SET @Found = 1			
		 END		 
	END   

	CLOSE db_cursor   
	DEALLOCATE db_cursor
	
	SET NOCOUNT OFF;	
END
