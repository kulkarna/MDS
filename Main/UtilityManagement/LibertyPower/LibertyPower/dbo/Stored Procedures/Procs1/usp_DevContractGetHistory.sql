
-- EXEC [dbo].[usp_DevContractGetHistory]

CREATE PROCEDURE [dbo].[usp_DevContractGetHistory]
	@ContractNumber VARCHAR(50) = NULL
AS
BEGIN
-- set nocount on and default isolation level
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET FMTONLY OFF
	SET NO_BROWSETABLE OFF
	
	IF @ContractNumber IS NULL
	BEGIN
		SELECT	TOP(10) * FROM lp_account..zaudit_account z (NOLOCK)
	END
	ELSE
	BEGIN
		SET @ContractNumber = RTRIM(LTRIM(@ContractNumber));
	
		SELECT	* FROM	lp_account..zaudit_account z (NOLOCK)
		WHERE	RTRIM(LTRIM(contract_nbr)) = @ContractNumber;
	END
	
END	
