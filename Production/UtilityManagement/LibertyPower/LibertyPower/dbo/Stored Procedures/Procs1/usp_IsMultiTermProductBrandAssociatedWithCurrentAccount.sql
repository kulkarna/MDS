-- =============================================
-- Author:		Lev Rosenblum 
-- Create date: 2/7/2013
-- Description:	Verify that product brand assosiated with account isMultiTerm or not
-- =============================================
CREATE PROCEDURE dbo.usp_IsMultiTermProductBrandAssociatedWithCurrentAccount
(
	@AccountIdLegacy char(12)
	, @CurrentDate datetime = getdate
)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @CurrContractId int, @CurrAccountId int, @ApprovedContractStatusId int, @IsMultiTerm bit
	SET @ApprovedContractStatusId=3;
	SET @IsMultiTerm=0;

	SELECT @CurrContractId=MAX(c.ContractID), @CurrAccountId=a.AccountId
	FROM [Libertypower].dbo.[Contract] c with (nolock)
	INNER JOIN [Libertypower].dbo.AccountContract ac with (nolock) ON ac.ContractID=c.ContractID
	INNER JOIN [Libertypower].dbo.Account a with (nolock) ON a.AccountID=ac.AccountID

	WHERE a.AccountIdLegacy=@AccountIdLegacy
	and c.ContractStatusID = @ApprovedContractStatusId
	and c.StartDate <= @CurrentDate
	GROUP BY a.AccountId

	SET @IsMultiTerm =
	(
		SELECT TOP 1 pb.IsMultiTerm
		FROM dbo.ProductBrand pb with (nolock)
			INNER JOIN dbo.Price prc with (nolock) ON prc.ProductBrandID=pb.ProductBrandID
			INNER JOIN dbo.AccountContractRate acr with (nolock) ON acr.PriceID=prc.ID
			INNER JOIN dbo.AccountContract ac with (nolock) ON ac.AccountContractID=acr.AccountContractID
		WHERE ac.AccountID=@CurrAccountId and  ac.ContractID=@CurrContractId
	)

	Return @IsMultiTerm;
END
