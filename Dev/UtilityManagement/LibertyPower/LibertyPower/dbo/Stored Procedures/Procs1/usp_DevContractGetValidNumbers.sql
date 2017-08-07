

CREATE PROCEDURE [dbo].[usp_DevContractGetValidNumbers]
	@MigrationComplete BIT = NULL,
	@IsRenewals BIT = 0
as
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	
	SELECT C.Number
	FROM Libertypower..[Contract] C (NOLOCK)
	WHERE C.MigrationComplete = ISNULL(@MigrationComplete, C.MigrationComplete)
	
	
	--IF @IsRenewals = 0
	--BEGIN
	--	SELECT C.Number
	--	FROM Libertypower..[Contract] C (NOLOCK)
	--	WHERE C.MigrationComplete = ISNULL(@MigrationComplete, C.MigrationComplete)
	--	AND C.Number IN
	--	(SELECT DISTINCT b.contract_nbr FROM lp_account..account_bak b)
	--	;
	--END
	--ELSE
	--BEGIN
	--	SELECT C.Number
	--	FROM Libertypower..[Contract] C (NOLOCK)
	--	WHERE C.MigrationComplete = ISNULL(@MigrationComplete, C.MigrationComplete)
	--	AND C.Number IN
	--	(SELECT DISTINCT b.contract_nbr FROM lp_account..account_renewal_bak b)
	--	;
	--END
END	
