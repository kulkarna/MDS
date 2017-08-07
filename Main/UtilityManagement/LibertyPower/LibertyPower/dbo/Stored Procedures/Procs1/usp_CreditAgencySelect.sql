
CREATE PROCEDURE [dbo].[usp_CreditAgencySelect]
@p_CreditAgencyID int
AS
	/* SET NOCOUNT ON */
	SELECT CreditAgencyID, [Name], [Code], TypeOfCreditAgency
	  FROM dbo.CreditAgency
	  WHERE CreditAgencyID = @p_CreditAgencyID

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditAgencySelect';

