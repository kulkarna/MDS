USE [lp_account]

GO

/*******************************************************************************    
 * usp_UpdateComedDatePorEnrollment    
 *    
 * History    
 * 03/30/2012 (IT098): moving lp_transactions to it's new home :-)    
 *    
 *******************************************************************************    
 * Created: 2011-08-10    
 ******************************************************************************* */    
-- Modified by : Agata Studzinska  
-- Date : 10/18/2013  
-- Ticket: 1-249608014  
-- Replaced account view by legacy tables for better performance  
-- =============================================  
-- Modified by: Agata Studzinska
-- Date 12/09/2013
-- Ticket: 1-249608014
-- If the meter read of previous month is available schedule enrollment 
-- submission dates on the day after it, otherwise base the enrollment submission
-- date on the effective date minus lead time - accordingly to proc 
-- [Libertypower].[dbo].[ScheduleEnrollmentBasedOnMeterRead]  
--==================================================

ALTER PROCEDURE [dbo].[usp_UpdateComedDatePorEnrollment]    
(    
 @p_contractNumber VARCHAR(12)    
)    
AS   
  
BEGIN   

SET NOCOUNT ON;  
   
 declare @w_rateClass varchar(50)    
 declare @w_enrollmentLeadDays int    
 declare @w_annualUsage int    
 declare @w_datePorEnrollment datetime    
 declare @start_date datetime    
 declare @p_utility_id int    
 declare @p_utilityCode char(15)    
 declare @w_accountNumber varchar(30)    
    
 declare @w_m_readDate int  
    
 select  @w_datePorEnrollment = null    
    
 declare accounts cursor FAST_FORWARD for  
   
 SELECT   
  A.ServiceRateClass,   
  USAGE.AnnualUsage,  
  ISNULL(m.read_date,ISNULL(dateadd(dd,-1,CU.enddate),CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END)) as read_date,  
  U.Id,   
  A.AccountNumber,  
  U.UtilityCode,  
  CASE WHEN m.read_date IS NULL THEN 1 ELSE 0 END AS IsMeterReadNull
 FROM Libertypower..Account A WITH (NOLOCK)  
 INNER JOIN Libertypower..Utility U WITH (NOLOCK) ON A.UtilityID = u.ID   
 INNER JOIN LibertyPower.dbo.[Contract] C WITH (NOLOCK)    ON A.CurrentContractID = C.ContractID   
 LEFT JOIN LibertyPower.dbo.AccountUsage USAGE WITH (NOLOCK)  ON A.AccountID = USAGE.AccountID AND  C.StartDate = USAGE.EffectiveDate    
 INNER JOIN LibertyPower.dbo.AccountContract AC WITH (NOLOCK)  ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID    
 INNER JOIN LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1    
 LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID     
     FROM LibertyPower.dbo.AccountContractRate ACRR WITH (NOLOCK)    
        WHERE ACRR.IsContractedRate = 0     
        GROUP BY ACRR.AccountContractID    
          ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID    
 LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate WITH (NOLOCK) ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID     
 LEFT JOIN lp_common..meter_read_calendar M WITH (NOLOCK)  
  ON CAST((YEAR(DATEADD(mm, -1,(CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END)))) AS INT)  = M.calendar_year    
        AND MONTH (DATEADD(mm, -1, (CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END))) = M.calendar_month    
             AND A.BillingGroup = M.read_cycle_id    
             AND U.UtilityCode = M.utility_id   
 LEFT JOIN lp_transactions..ComedUsage CU WITH (NOLOCK) ON A.AccountNumber = CU.accountnumber    
         AND YEAR(CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END) = YEAR(CU.EndDate)  
         AND MONTH(CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END) = MONTH(CU.EndDate)  
 WHERE C.Number = @p_contractNumber  
   
open accounts    
 FETCH NEXT FROM accounts    
 INTO @w_rateClass, @w_annualUsage, @start_date, @p_utility_id, @w_accountNumber,@p_utilityCode, @w_m_readDate  
   
WHILE @@FETCH_STATUS = 0    
 BEGIN    
 if @p_utility_id = 17 and @w_rateClass is not null and @w_rateClass <> ''    
  begin    
  select @w_enrollmentLeadDays = ISNULL(EnrollmentLeadDays,0)    
   from Libertypower..UtilityServiceClassEnrollLeadTime WITH (NOLOCK)  
   where ServiceRateClass = @w_rateClass    
   and UtilityId = @p_utility_id    
    
   if @w_enrollmentLeadDays = 0   
   begin    
    if @w_annualUsage/17520 > 100    
    begin    
     select @w_enrollmentLeadDays = 7    
    end    
    else    
    begin    
     select @w_enrollmentLeadDays = 18    
    end    
   end    
    
   IF @w_m_readDate = 1   
   BEGIN  
	SELECT  @w_datePorEnrollment = dateadd(dd, -@w_enrollmentLeadDays, @start_date)    
	   -- if day lands on Saturday or Sunday, set it to the prior Friday.    
	IF datename(dw,@w_datePorEnrollment) = 'saturday'    
		SET @w_datePorEnrollment = dateadd(dd,-1,@w_datePorEnrollment)    
	IF datename(dw,@w_datePorEnrollment) = 'sunday'    
		SET @w_datePorEnrollment = dateadd(dd,-2,@w_datePorEnrollment)  
   END  
   ELSE   
   BEGIN   
	SELECT  @w_datePorEnrollment = dateadd(dd, 1, @start_date)   
   END  
  
      
 UPDATE Libertypower..AccountContract   
   SET SendEnrollmentDate = isnull(@w_datePorEnrollment,SendEnrollmentDate)  
   FROM   Libertypower..AccountContract AC WITH (NOLOCK)  
   JOIN Libertypower..Account A WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID  
   JOIN Libertypower..Utility U WITH (NOLOCK) ON U.ID = A.UtilityID  
   WHERE U.UtilityCode = @p_utilityCode    
   and AccountNumber = @w_accountNumber   
     
 END   
    
 FETCH NEXT FROM accounts    
 INTO @w_rateClass, @w_annualUsage, @start_date, @p_utility_id, @w_accountNumber, @p_utilityCode, @w_m_readDate  
 END    
 CLOSE accounts    
 DEALLOCATE accounts  
   
 SET NOCOUNT OFF;  
 
END    

GO