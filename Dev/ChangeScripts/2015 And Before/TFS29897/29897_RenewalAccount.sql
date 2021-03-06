USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_renewal_account_sel]    Script Date: 01/07/2014 15:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------------
--Modified  Jan 7 2014
--Sara lakshmanan
--Modified the where condition for Status 
--modified the procedure to match the same procedure in lp_Account dataabse

---------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[usp_account_renewal_account_sel]

	@p_account_number		varchar(30)

AS
BEGIN

Set NoCount ON;
SELECT 
	A.AccountIdLegacy AS account_id
FROM 
	LibertyPower.dbo.Account A WITH (NOLOCK) 
	JOIN LibertyPower.dbo.AccountContract AC	 WITH (NOLOCK) 		ON A.AccountID = AC.AccountID AND A.CurrentRenewalContractID = AC.ContractID
	JOIN LibertyPower.dbo.[Contract] C			 WITH (NOLOCK) 		ON  AC.ContractID = C.ContractID 
	JOIN LibertyPower.dbo.AccountStatus ACS		 WITH (NOLOCK) 		ON AC.AccountContractID = ACS.AccountContractID
WHERE 
	a.CurrentRenewalContractID IS NOT NULL AND a.CurrentContractID IS NOT NULL
	--AND ACS.SubStatus NOT IN ('80','90') -- Renewal is not cancelled
	AND (LTRIM(RTRIM(ACS.[Status])) + LTRIM(RTRIM(ACS.SubStatus)) NOT IN ('0700080','0700090','99999810','9999910')) -- Renewal is not cancelled
	AND C.ContractStatusID	<> 2		 -- Renewal is not rejected
	AND A.AccountNumber = @p_account_number

Set NoCount OFF;
END

GO
