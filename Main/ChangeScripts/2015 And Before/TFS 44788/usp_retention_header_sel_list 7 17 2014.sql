USE [lp_enrollment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_retention_header_sel_list' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_retention_header_sel_list];
GO
  
-- =========================================================================        
-- Eric Hernandez   
-- Modified: 6-30-2014  
-- Changed filter for deenrollment dates older than 90 days.  Previously if the date was not available, it would filter out the record.  
-- Now, instead, it checks to see if the record has been in the retention queue for more than 90 days.  
-- 1-558038101      
-- =========================================================================     
-- Agata Studzinska  
-- Modified: 7-3-2014  
-- Replaced join LibertyPower.dbo.AccountLatestService with Left Join  
-- 1-558038101      
-- =========================================================================      
-- Agata Studzinska
-- Modified: 7-17-2014
-- Changed date created filter.
-- TFS 448383
-- =========================================================================   
-- Pradeep Katiyar
-- Modified: 7-24-2014
-- Rolled back the filter criteria for service dates.
-- TFS 44788
-- =========================================================================

CREATE PROCEDURE [dbo].[usp_retention_header_sel_list]      
(@p_username                         NCHAR(100),   
 @p_view                             VARCHAR(35),      
 @p_rec_sel                          INT = 50,      
 @p_call_status_filter               VARCHAR(05) = NULL,      
 @p_call_reason_code_filter          VARCHAR(05) = NULL,      
 @p_assigned_to_username_filter      NCHAR(100)  = NULL,      
 @p_phone_filter                     VARCHAR(20) = NULL,      
 @p_call_request_id_filter           CHAR(15)  = NULL,  
 @p_date_from       DATETIME = NULL, --6/4/2014 TFS#40668  
 @p_date_to        DATETIME = NULL) --6/4/2014 TFS#40668     
    
AS      
    
      
    
SET NOCOUNT ON        
      
    
DECLARE @SELECT_clause   VARCHAR(2000)      
    
 ,@orderby_clause   VARCHAR(50)      
    
      
    
IF @p_call_status_filter IN ('NONE','ALL')          SET @p_call_status_filter = NULL      
IF @p_call_reason_code_filter IN ('NONE','ALL')     SET @p_call_reason_code_filter = NULL      
IF @p_assigned_to_username_filter IN ('ALL')  SET @p_assigned_to_username_filter = NULL      
IF @p_phone_filter IN ('NONE','ALL')                SET @p_phone_filter = NULL      
IF @p_call_request_id_filter IN ('NONE','ALL')      SET @p_call_request_id_filter = NULL      
  
SET @p_call_status_filter = LTRIM(RTRIM(@p_call_status_filter))      
    
    
    
CREATE TABLE #Temp (      
    
 call_request_id char(15),    
 phone varchar(20),      
 no_of_accounts int,     
 total_annual_usage float,      
 call_status varchar(20),      
 nbr_prev_attempts int,      
 nextcalldate varchar (500),      
 assigned_to_username nchar (100),      
 username nchar(100),       
 date_created datetime,    
 date_created_formatted varchar (500),      
 deenrollment_date varchar (500),       
 active smallint,      
 excluded_by_username nchar(100),      
 retail_mkt_id varchar (50),       
 PriceID BIGINT,       
 LegacyProductID VARCHAR(100),       
 IsContractedRate BIT     
    
)    
    
SET ROWCOUNT @p_rec_sel      
    
    
INSERT INTO #Temp    
    
SELECT a.call_request_id,      
 a.phone,      
 a.no_of_accounts,      
 a.total_annual_usage,      
 call_status = CASE WHEN a.call_status = 'L' THEN 'Lost'        
      WHEN a.call_status = 'S' THEN 'Save'        
      WHEN a.call_status = 'A' THEN 'Attempted'        
      WHEN a.call_status = 'O' THEN 'Open'  
      WHEN a.call_status = 'E' THEN 'Expired'  
      END,   
 nbr_prev_attempts = dbo.ufn_retention_detail_count_attempt( @p_username, a.call_request_id),      
 nextcalldate = lp_enrollment.dbo.ufn_date_format(dbo.ufn_retention_nextcalldate_attempt( @p_username, a.call_request_id),'<m>/<dd>/<yyyy>'),    
 a.assigned_to_username,         
 a.username,        
 a.date_created AS date_created,        
 lp_enrollment.dbo.ufn_date_format(a.date_created,'<m>/<dd>/<yyyy>') AS date_created_formatted,        
 lp_enrollment.dbo.ufn_date_format(ASERVICE.enddate,'<m>/<dd>/<yyyy>') as deenrollment_date,        
 a.active,        
 a.excluded_by_username,        
 M.MarketCode AS retail_mkt_id,      
 CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.PriceID ELSE AC_DefaultRate.PriceID END AS PriceID, --5/1/2014    
 CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS LegacyProductID, --5/1/2014    
 CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.IsContractedRate ELSE AC_DefaultRate.IsContractedRate END AS IsContractedRate --5/12/2014    
    
FROM retention_header a WITH (NOLOCK)     
JOIN LibertyPower..Account b WITH (NOLOCK)      ON a.account_id = b.AccountIdLegacy  
JOIN LibertyPower.dbo.AccountContract AC WITH (NOLOCK)  ON b.AccountID = AC.AccountID AND b.CurrentContractID = AC.ContractID       
JOIN LibertyPower.dbo.Market M   WITH (NOLOCK)   ON b.RetailMktID = M.ID      
JOIN LibertyPower.dbo.[Contract] CONT WITH (NOLOCK)   ON b.CurrentContractID = CONT.ContractID      
--BEGIN 5/1/2014    
JOIN LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID     
LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID       
    FROM LibertyPower.dbo.AccountContractRate ACRR WITH (NOLOCK)      
    WHERE ACRR.IsContractedRate = 0       
    GROUP BY ACRR.AccountContractID      
        ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID      
LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate WITH (NOLOCK)        
ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID       
--END 5/1/2014      
JOIN LibertyPower.dbo.SalesChannel SC WITH (NOLOCK)  ON CONT.SalesChannelID = SC.ChannelID       
LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON b.AccountID = ASERVICE.AccountID     --7/3/2014  
JOIN LibertyPower.dbo.AccountStatus ACS      WITH (NOLOCK) ON AC.AccountContractID = ACS.AccountContractID      
   
WHERE 1=1     
AND a.call_status  = isnull(@p_call_status_filter,a.call_status)      
AND a.call_reason_code  = isnull(@p_call_reason_code_filter,a.call_reason_code)       
AND a.assigned_to_username = isnull(@p_assigned_to_username_filter,a.assigned_to_username)      
AND a.phone     = isnull(@p_phone_filter,a.phone)      
AND a.call_request_id  = isnull(@p_call_request_id_filter,a.call_request_id)      
AND SC.ChannelName   not like '%TCC%'      
AND SC.AllowRetentionSave  = 1      
--6-30-2014 BEGIN  
 AND getdate() <= DATEADD(dd, 90,  (CASE WHEN acs.Status in ('999998','999999','01000','03000','04000','05000') THEN CAST('1900-01-01 00:00:00' AS DATETIME)    
            WHEN  acs.Status in ('13000') AND acs.SubStatus in ('70','80')  THEN CAST('1900-01-01 00:00:00' AS DATETIME)    
            ELSE ISNULL(ASERVICE.EndDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END )) 
AND (  
  (@p_call_status_filter = 'E' AND a.call_status = 'E')  
  OR  
  (@p_call_status_filter <> 'E' AND a.call_status in ('L', 'O', 'S', 'A'))  
  OR  
  (@p_call_status_filter IS NULL AND a.call_status in ('L', 'O', 'S', 'A'))  
 )  
-- 6-30-2014 END  
AND b.AccountTypeID <> 1 --exclude LCI      
AND (@p_date_from IS NULL OR (CAST( a.date_created AS DATE)) >= @p_date_from)  --7/17
AND (@p_date_to IS NULL OR (CAST (a.date_created AS DATE)) <= @p_date_to) --7/17


SET @SELECT_clause = '    
SELECT t.*,      
 CASE WHEN t.IsContractedRate = 0 THEN UPPER(g.product_category)    
 ELSE UPPER(isnull(PT.Name, g.product_category))  END AS product_category, --5/12/2014    
 UPPER(isnull(t.LegacyProductID, g.product_id)) AS product_id      
FROM #Temp t      
LEFT JOIN lp_common..common_product g (NOLOCK) ON t.LegacyProductID = g.product_id     
LEFT OUTER JOIN LibertyPower..Price P with (NOLOCK) ON P.ID = t.PriceID    
LEFT OUTER JOIN LibertyPower..ProductBrand PB with (NOLOCK) ON isnull(P.ProductBrandID, g.ProductBrandID) = PB.ProductBrandID       
LEFT OUTER JOIN Libertypower..ProductType PT WITH (NOLOCK) ON PB.ProductTypeID = PT.ProductTypeID  '    
    
SET @ORDERBY_clause = ' order ' + lower(@p_view) + ' '      
      
    
exec(@SELECT_clause + @ORDERBY_clause)      
  
SET NOCOUNT OFF        
    