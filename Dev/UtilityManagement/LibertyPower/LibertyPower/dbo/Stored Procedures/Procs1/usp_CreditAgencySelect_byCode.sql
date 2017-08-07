
CREATE proc [dbo].[usp_CreditAgencySelect_byCode] 
@p_code VARCHAR(30)
AS
	/* SET NOCOUNT ON */
	SELECT CreditAgencyID, [Name], [Code], TypeOfCreditAgency
	  FROM dbo.CreditAgency
	  WHERE [Code] = @p_code

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditAgencySelect_byCode';

