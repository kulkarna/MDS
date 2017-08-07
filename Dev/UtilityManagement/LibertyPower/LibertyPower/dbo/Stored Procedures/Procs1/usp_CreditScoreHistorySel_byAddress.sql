-- =============================================================
-- Author:		Antonio Jr
-- Create date: 9/25/2009
-- Description:	Gets the last record in the History
--              given the BusinessName, Street, City, State, Zip
-- =============================================================
CREATE PROCEDURE [dbo].[usp_CreditScoreHistorySel_byAddress]
	
	@p_CustomerName VARCHAR(100),
	@p_StreetAddress VARCHAR(100),
	@p_City VARCHAR(100),
	@p_State CHAR(2),
	@p_ZipCode NCHAR(15)
	
AS
BEGIN
	
	SET NOCOUNT ON;

   
	SELECT TOP 1
	    CreditScoreHistoryID,CustomerName, StreetAddress, City, [State], ZipCode,
		DateAcquired, AgencyReferenceID, CreditAgencyID, Score,
		ScoreType, FullXMLReport, Source, CustomerID,
		Contract_nbr, Account_nbr, Username, DateCreated
	FROM dbo.CreditScoreHistory
	WHERE CustomerName = @p_CustomerName AND
	      StreetAddress = @p_StreetAddress AND
	      City = @p_City AND
	      [State] = @p_State AND
	      ZipCode = @p_ZipCode
	ORDER BY DateAcquired desc
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditScoreHistorySel_byAddress';

