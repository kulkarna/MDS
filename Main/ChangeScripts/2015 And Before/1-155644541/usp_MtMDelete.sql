USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_HourlyAccountForecastCreate]    Script Date: 08/16/2013 13:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	8/16/2013																		*
 *	Descp:		Delete MtMData by CustomID,ContractID				 							*
 *																								*
 ********************************************************************************************** */
 --exec usp_MtMDelete NULL, 1234
  
CREATE	PROCEDURE	[dbo].[usp_MtMDelete]
(	@CustomDealID AS INT = NULL,
	@ContractID AS INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MtMCount AS INT

	BEGIN TRANSACTION DeleteMtMTables

		-- Get the ID of the MtMAccounts to be deleted
		SELECT	ID AS DeleteID
		INTO	#Del
		FROM	MtMAccount 
		WHERE	CustomDealID = @CustomDealID
		OR		ContractID = @ContractID
	
	-- Clean up the daily load forecast
		DELETE	l
		FROM	MtMDailyLoadForecast l 
		INNER	Join #Del d
		ON		l.MtMAccountID =d.DeleteID

		-- clean up the daily wholesale load forecast
		DELETE	l
		FROM	MtMDailyWholesaleLoadForecast l 
		INNER	Join #Del d
		ON		l.MtMAccountID =  d.DeleteID

		DELETE	l
		FROM	MtMDailyWholesaleLoadDates l 
		INNER	Join #Del d
		ON		l.MtMAccountID = d.DeleteID

		-- delete the usage
		DELETE	l
		FROM	MtMUsage l 
		INNER	Join #Del d
		ON		l.MtMAccountID = d.DeleteID

		-- delete the logs
		DELETE	l
		FROM	MtMTracking l
		INNER	JOIN MtMAccount a
		ON		l.QuoteNumber = a.QuoteNumber
		AND		l.BatchNumber = a.BatchNumber 
		INNER	Join #Del d
		ON		a.ID = d.DeleteID

		-- delete the account
		DELETE	l
		FROM	MtMAccount l  
		INNER	Join #Del d
		ON		l.ID = d.DeleteID
		
		SET	@MtmCount = @@ROWCOUNT
		
	IF @@ERROR = 0         
		BEGIN
			COMMIT
		END
	ELSE
		ROLLBACK
	
	SELECT	@MtMCount as MtMCount
	
	SET NOCOUNT OFF;
END


