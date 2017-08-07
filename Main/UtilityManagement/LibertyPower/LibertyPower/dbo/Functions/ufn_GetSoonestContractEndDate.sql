-- =============================================
-- Author:		Sadiel Jarvis
-- Create date: 2/21/2013
-- Description:	Returns soonest contract end date 
-- =============================================
CREATE FUNCTION ufn_GetSoonestContractEndDate
(
	@p_contract_nbr varchar(30)
)
RETURNS varchar(30)
AS
BEGIN
	DECLARE @MinDate datetime
	
	SELECT  
		@MinDate = MIN(lpa.date_end)
    FROM          LibertyPower.dbo.Contract AS lpc WITH (nolock) INNER JOIN
                           LibertyPower.dbo.AccountContract AS lpac WITH (nolock) ON lpc.ContractID = lpac.ContractID INNER JOIN
                           libertypower.dbo.account AS A WITH (NOLOCK) ON lpac.AccountID = A.AccountID INNER JOIN
                           [lp_account].[dbo].[tblAccounts_vw] AS lpa WITH (nolock) ON A.AccountidLegacy = lpa.Account_id
	where lpc.number = @p_contract_nbr
	
	RETURN convert(varchar,cast(@MinDate as datetime),101)	
END
