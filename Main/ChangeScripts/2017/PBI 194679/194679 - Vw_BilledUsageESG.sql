USE [ISTA]
GO
/****** Object:  View [dbo].[vw_BilledUsageESG]    Script Date: 8/2/2017 4:03:23 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_BilledUsageESG]'))
DROP VIEW [dbo].[vw_BilledUsageESG]
GO
/****** Object:  View [dbo].[vw_BilledUsageESG]    Script Date: 8/2/2017 4:03:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_BilledUsageESG]'))
EXEC dbo.sp_executesql @statement = N'










/* 9/14/2016 -- added mapping table and account tables to remove duplicate for O&R - then changed it back to use invoice*/

/* 7/26/2017 - RaviChandra
	
	Changed the join to consider account number changes when Esg sends old acc number instead of a new one, check the old account numbers
	 cte_AllAccounts will create an in-memory list of all the accounts (libertypower accounts and old accounts) that can be used to join when
	  ESG sends an account number that is currently active or was active at any point in time. 
	 */

CREATE view [dbo].[vw_BilledUsageESG] as 


with cte_AllAccounts
as 
(
Select a.accountnumber, a.utilityID
From libertypower.dbo.Account a
join libertypower..ESGUtilityMap eu on eu.lp_utility_ID = a.UtilityID

union 

select anh.old_account_number as accountnumber, eu.LP_Utility_ID
from libertypower..account a 
join libertypower..ESGUtilityMap eu on eu.lp_utility_ID = a.UtilityID
left join lp_account..account_number_history anh on  a.AccountIdLegacy = anh.account_id
where account_id is not null
)


SELECT AccountNumber,Utility,UtilityDunsNumber, FromDate, ToDate, sum(TotalkWh) as TotalkWh

FROM (
       SELECT 
              AccountNumber = a.PremNo,
              Utility = eu.LP_Utility_Code,
              UtilityDunsNumber = eu.LP_DUNSNumber,
              FromDate = min(id.ServiceFrom),
              ToDate = max(id.ServiceTo),
              id.invoiceid,
                      TotalkWh = sum(round(id.InvDetQty,0))
          FROM 
       ISTA.[dbo].premise a with (NOLOCK) 
            join ista.dbo.account_LKP alkp with (nolock) on alkp.premid = a.premid
       --INNER JOIN ISTA.[dbo].invoice i with (NOLOCK) on a.custid = i.custid
           INNER JOIN ISTA.[dbo].InvoiceDetail id with (NOLOCK) on alkp.PremID = id.PremID 
                                        and alkp.customer_tkn = id.customer_tkn
                                    and alkp.customer_acct_tkn = id.customer_acct_tkn
                                    and alkp.account_Pkg_tkn = id.account_Pkg_tkn
/* 07/26/17 - Changed the join to consider old account numbers when Esg sends old acc number instead of a new one.
       --   join libertypower.dbo.account acct with (nolock) on acct.accountnumber = a.premno 
       --join LibertyPower.dbo.[ESGUtilityMap] eu (nolock) on eu.lp_utility_ID = acct.UtilityID
*/
	    join cte_AllAccounts c with (nolock) on a.premno = c.accountnumber
       join LibertyPower.dbo.[ESGUtilityMap] eu (nolock) on eu.lp_utility_ID = c.UtilityID --and a.LDCID = eu.ISTA_LDCID

 

          WHERE 1=1
and id.CategoryID = 1
and id.serviceTo > ''7/1/2016''
Group By 
 a.PremNo,
eu.LP_Utility_Code,
eu.LP_DUNSNumber,
id.invoiceid
) a
--where accountnumber = ''0159109118''
group by AccountNumber,Utility,UtilityDunsNumber, FromDate, ToDate













' 
GO
