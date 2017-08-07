
-- exec [usp_DevAccountContractGetValidIds] false
CREATE PROCEDURE [dbo].[usp_DevAccountContractGetValidIds]
	@MigrationComplete BIT = NULL
as
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	

	SELECT AC.AccountContractID
	FROM Libertypower..[AccountContract] AC (NOLOCK)
	WHERE AC.MigrationComplete = ISNULL(@MigrationComplete, AC.MigrationComplete)
	;
	
END	
