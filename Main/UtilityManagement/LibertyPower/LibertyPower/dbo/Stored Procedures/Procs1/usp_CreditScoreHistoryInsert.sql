-- =============================================
-- Author:		Antonio Jr
-- Create date: 9/25/2009
-- Description:	Insert a record in CreditScoreHistory
-- =============================================
CREATE PROCEDURE [dbo].[usp_CreditScoreHistoryInsert]
(
	@p_CustomerName VARCHAR(100),
	@p_StreetAddress VARCHAR(100),
	@p_City VARCHAR(100),
	@p_State CHAR(2),
	@p_ZipCode NCHAR(15),
	@p_DateAcquired DATETIME,
	@p_AgencyReferenceID INT,
	@p_CreditAgencyID INT,
	@p_Score NUMERIC(8,2),
	@p_ScoreType VARCHAR(30),
	@p_FullXMLReport VARCHAR(max),
	@p_Source VARCHAR(30),
	@p_CustomerID INT = NULL,
	@p_Contract_nbr CHAR(30),
	@p_Account_nbr CHAR(30),
	@p_Username VARCHAR(50),
	@p_DateCreated DATETIME
)
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO CreditScoreHistory
	(
		CustomerName, StreetAddress, City, [State], ZipCode,
		DateAcquired, AgencyReferenceID, CreditAgencyID, Score,
		ScoreType, FullXMLReport, Source, CustomerID,
		Contract_nbr, Account_nbr, Username, DateCreated
	)
	VALUES
	(
		@p_CustomerName, @p_StreetAddress, @p_City, @p_State, @p_ZipCode,
		@p_DateAcquired, @p_AgencyReferenceID, @p_CreditAgencyID, @p_Score,
		@p_ScoreType, @p_FullXMLReport, @p_Source, @p_CustomerID,
		@p_Contract_nbr, @p_Account_nbr, @p_Username, @p_DateCreated
	)
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditScoreHistoryInsert';

