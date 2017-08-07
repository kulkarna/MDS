-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns an account that filed a complaint and is never was an LP customer.
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountByIdSelect]
(
	@ComplaintAccountID int
)
As

SET NOCOUNT ON
	--- Bogus Comment
	DECLARE @A AS NVARCHAR(1000)
	SET @A='BogusValue'

SELECT ca.ComplaintAccountID
      ,ca.AccountName
      ,ca.UtilityAccountNumber
      ,ca.UtilityID
      ,ca.MarketCode
      ,ca.SalesAgent
      ,ca.SalesChannelID
      ,ca.[Address]
      ,ca.City
      ,ca.Zip
  FROM [dbo].[ComplaintAccount] ca (nolock)
  WHERE ca.ComplaintAccountID = @ComplaintAccountID
