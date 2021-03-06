USE [Lp_contract_renewal]
GO
/****** Object:  StoredProcedure [dbo].[usp_contracts_accounts_sel_bycontract]    Script Date: 10/31/2012 17:13:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_contracts_accounts_sel_bycontract]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_contracts_accounts_sel_bycontract]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_contracts_accounts_sel_bycontract]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- ===============================================================
-- Modified Isabelle Tamanini 4/14/2011
-- Changing the from clause to a left join with the lp_account..account
-- to show add on accounts
-- Ticket 22541 
------------------------------------------------------------------
-- Modified 10/31/2012 - Rick Deigsler
-- Removed join on account view
-- ===============================================================
-- exec usp_contracts_accounts_sel_bycontract ''admin'', ''1035003''
 
CREATE procedure [dbo].[usp_contracts_accounts_sel_bycontract] 
(@p_username                                        nchar(100),
 @p_contract_nbr_new								char(12),
 @p_contract_nbr_current                            char(12))
as

select a.option_id,
       a.return_value
from (select seq                                    = ''0'',
             option_id                              = ''Contract'',
             return_value                           = ''CONTRACT''
      union
      select	seq                                 = a.account_id,
				option_id                           = ''Account # '' + a.account_number,
				return_value                        = a.account_number
      from		lp_contract_renewal..deal_contract_account a WITH (NOLOCK)
				LEFT JOIN LibertyPower.dbo.Account ac WITH (NOLOCK)on a.account_id = ac.AccountIdLegacy
				JOIN LibertyPower.dbo.AccountDetail ad	 WITH (NOLOCK)	ON ad.AccountID = ac.AccountID
				JOIN LibertyPower.dbo.[Contract] c	WITH (NOLOCK)				ON ac.CurrentContractID = c.ContractID
      where		(c.Number                      = @p_contract_nbr_current
	  OR		a.contract_nbr                      = @p_contract_nbr_new)
	  AND		a.renew								= 1
) a 

order by a.seq' 
END
GO
