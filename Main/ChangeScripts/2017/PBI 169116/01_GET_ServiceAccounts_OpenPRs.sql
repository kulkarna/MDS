USE [LIBERTYCRM_MSCRM]
GO
/****** Object:  StoredProcedure [dbo].[GET_ServiceAccounts_OpenPRs]    Script Date: 3/29/2017 3:10:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Yhanss Herrera
-- Create date: 10/18/2016
-- Description: Retrive all the services account on open PR with a null usage data and older than 45 days   
-- =============================================  
ALTER PROCEDURE  [dbo].[GET_ServiceAccounts_OpenPRs]   
@usagedate datetime

AS  
BEGIN  
   
                                IF OBJECT_ID(N'tempdb..#OpenPRs') IS NOT NULL  
                                BEGIN  
                                    DROP TABLE #OpenPRs  
                                END  
  
                                -- Gather Price Requests which are linked to an open opportunity  
                                SELECT PR.lpc_pricerequestid  
                                INTO #OpenPRs --new empty table. Assure using the Where 1=0 
                                FROM DBO.OPPORTUNITY O (NOLOCK)
                                JOIN DBO.LPC_PRICEREQUEST PR (NOLOCK) ON PR.LPC_OPPORTUNITYID = O.OPPORTUNITYID  
                                WHERE O.STATECODE = 0 --open prs  
  
                                CREATE CLUSTERED INDEX idx_ID on #OpenPRs (lpc_pricerequestid)  with (fillfactor = 100)--relational_index_option

 
                                IF OBJECT_ID(N'tempdb..#SAs_Needing_Usage') IS NOT NULL  
                                                                BEGIN  
                                                                    DROP TABLE #SAs_Needing_Usage  
                                                                END

								DECLARE @now datetime = cast(getdate() AS DATE);
								DECLARE @outdated datetime = DATEADD(d, -30, @now)																
  
                                -- Grab Service Accounts which appear to not have current usage.  
                                -- This query was broken out from the final query to improve performance.  
                                SELECT SA.lpc_serviceaccountid,
									   LPC_ACCOUNTNUMBER,
									   lpc_UtilityId,
									   lpc_kwh_annualusage,
									   lpc_mwh_annualusage,
									   lpc_UsageDate,
									   lpc_LastDateUpdateGetAnnualUsage
                                INTO #SAs_Needing_Usage  
                                FROM DBO.lpc_ServiceAccount SA (NOLOCK)  
								WHERE (SA.lpc_UsageDate IS NULL or SA.lpc_UsageDate < @usagedate)
									  AND
									  (@outdated > sa.lpc_LastDateUpdateGetAnnualUsage OR sa.lpc_LastDateUpdateGetAnnualUsage is null)  
                                 
  
                                CREATE CLUSTERED INDEX idx_ID2 on #SAs_Needing_Usage (lpc_serviceaccountid)  with (fillfactor = 100)  

  
                                -- By joining the tables above, we grab service accounts which lack usage and are linked to an open opportunity.  
                                SELECT DISTINCT
                                    SA.LPC_ACCOUNTNUMBER   
                                    , u.lpc_utility_id  
                                    , u.lpc_UtilityCode
									, sa.lpc_UsageDate
									, sa.lpc_mwh_annualusage
									, sa.lpc_kwh_annualusage
									, sa.lpc_LastDateUpdateGetAnnualUsage 
                                FROM #OpenPRs pr (NOLOCK)  
                                JOIN DBO.lpc_pricerequestproduct prp (NOLOCK) ON pr.lpc_pricerequestid = prp.lpc_productsid  
                                JOIN DBO.lpc_pricerequestproductsa prpsa (NOLOCK) ON prp.lpc_pricerequestproductid = prpsa.lpc_serviceaccountsid  
                                JOIN #SAs_Needing_Usage sa (NOLOCK) ON sa.lpc_serviceaccountid = prpsa.lpc_sa  
                                JOIN DBO.lpc_utility u ON u.lpc_utilityId = sa.lpc_UtilityId
                                
  
END  