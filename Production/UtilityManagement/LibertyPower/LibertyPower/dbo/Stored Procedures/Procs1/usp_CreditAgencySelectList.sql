
CREATE PROCEDURE [dbo].[usp_CreditAgencySelectList]
AS
	/* SET NOCOUNT ON */
	SELECT c.CreditAgencyID, [Name], (SELECT COUNT(*) FROM dbo.CreditRating r
	                                 WHERE c.CreditAgencyID = r.CreditAgencyID) AS Ratings
	  FROM dbo.CreditAgency c
	  ORDER BY SortOrder

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditAgencySelectList';

