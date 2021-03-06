USE [lp_documents]
GO
/****** Object:  StoredProcedure [dbo].[usp_document_print_template_table_address_sel]    Script Date: 01/16/2015 16:27:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC usp_document_print_template_table_address_sel @contract_number='2014-0104669'  
--EXEC usp_document_print_template_table_address_sel '101005697'  
    
-- ==========================================================================    
-- Created by: Gail Mangaroo    
-- Create Date: 4/4/2008    
-- Purpose: Returns data to be filled in the Product portion of templates    
-- ==========================================================================    
--    
-- LOOKS FOR DOCUMENT PRINT DATA IN THE FOLLOWING ORDER:    
--  Account Renewal Tables     ( lp_account..account_renewal )     
--  Renewal Deal Capture Contract Accounts ( lp_contract_renewal..deal_contract_account )    
--  Renewal Deal Capture Contract   ( lp_contract_renewal..deal_contract )    
--  Account Tables       ( lp_account..account )    
--  Deal Capture Contract Accounts   ( lp_deal_capture..deal_contract_account )     
--  Deal Capture Contract - mulitrate  ( lp_deal_capture..multi_rates )     
--  Deal Capture Contract - single rate  ( lp_deal_capture..deal_contract_print )     
-- ==========================================================================    
-- Modified 05/06/2008 - Added addiitonal data sources to cover renewal and contract print scenarios    
-- Modified 02/02/2009 - Added GenerateDate field.    
-- Modified 04/30/2009 - Added SSN Sales Rep and Term Fields     
-- Modified 05/01/2009 - Removed Term Fields -- template seems to pick up first field it finds with the tag name even if table name is specified     
-- Modified 05/08/2009 - Added TaxID field    
-- Modified 06/03/2009 - Gail Mangaroo - Added ChannelPartnerName field    
-- Modified 06/30/2010 - Gail Mangaroo - Added ContractTypeDesc field.    
-- Modified 05/10/2011 - Ryan Russon - Added ContactDate, formatted DateTime fields, and minor cleanup    
-- Modified 04/13/2012 - Eric Hernandez/Ryan Russon - Updated Account Renewal section to use new Account structure (shortening execution time by over 30 seconds)    
-- Modified 06/15/2012 - Ryan Russon - Added Sales Channel info for printing templates in Deal Capture, now available since we added sales_channel_role field to lp_deal_capture..deal_contract_print    
-- Modified 03/31/2014 - Andre Damasceno - Added a self join from AccountContractRate to get a newest data and change a lp_account views(account_name,account_address and account_contact) for tables 
-- Modified 06/13/2014 - Andre Damasceno - Increased the size of the BillingAddress1 column in #addressInfo(varchar(50) to varchar(70))  
-- Modified 01/16/2015 - Satchi Jena- Added the logic for fetching the customer DunsNumber and Promocodes.
-- ==========================================================================    
ALTER PROCEDURE [dbo].[usp_document_print_template_table_address_sel] (    
 @contract_number varchar(12) = NULL    
)    
    
AS    
    
BEGIN    
 SET NOCOUNT ON;    
    
 --ALL SELECT STATEMENTS SHOULD HAVE SAME COLUMNS      
 -- ======================================================    
 CREATE TABLE  #addressInfo (    
  CustomerName varchar(100)    
  ,BusinessType varchar (35)    
  ,BusinessActivity varchar(35)    
  ,ContactFirstName varchar(50)    
  ,ContactLastName varchar(50)    
  ,ContactTitle varchar(20)    
  ,ContactPhone varchar(20)    
  ,ContactFax varchar(20)    
  ,ContactEmail varchar(256)    
  ,ContactBirthday varchar(10)    
  ,ContractType varchar(25)     
  ,ContractNumber varchar(20)    
  --,Term int    
  --,TermInWords varchar (35)    
  ,BillingAddressLink int    
  ,BillingAddress1 varchar(70)    
  ,BillingAddress2 varchar(30)    
  ,BillingCity varchar(30)    
  ,BillingCounty varchar(10)    
  ,BillingState varchar(5)    
  ,BillingZip varchar(10)    
  ,SSN varchar(50)    
  ,SalesRep varchar(50)    
  --Term varchar(10)  -- Do Not Use term Here. All Term fields in template will use this value !!!    
  ,TaxID varchar(50)    
  ,ChannelPartnerName varchar(50)     
  ,ContractTypeDescp Varchar(25)     
 )    
    
 IF @contract_number IS NULL      --If no ContractNumber was specified, return structure only    
  GOTO DummyRow    
    
 -- CHECK ACCOUNT RENEWAL TABLES    
 -- ========================================================    
 IF EXISTS( select 1     
    --from lp_account..account_renewal a  WITH (NOLOCK)     
    from LibertyPower..[Contract] c WITH (NOLOCK)    
    where c.Number =  @contract_number    
    and c.ContractDealTypeID = 2  )    
  BEGIN     
   -- Get Data from Account Renewal Tables     
   INSERT INTO #addressInfo    
   SELECT DISTINCT    
    rtrim(N.Name)        AS CustomerName,    
    left(UPPER(isnull(BT.[Type],'NONE')),35)  AS BusinessType,    
    left(UPPER(isnull(BA.Activity,'NONE')),35)  AS BusinessActivity,    
    rtrim(C.firstname)        AS ContactFirstName,     
    rtrim(C.lastname)        AS ContactLastName,     
    rtrim(C.title)         AS ContactTitle,    
    rtrim(C.phone)         AS ContactPhone,     
    rtrim(C.fax)         AS ContactFax,    
    rtrim(C.email)         AS ContactEmail,     
    rtrim(CONVERT(char(2), MONTH(C.Birthdate)) + '/' + CONVERT(char(2), DAY(C.Birthdate)))        AS ContactBirthday,     
    LibertyPower.dbo.ufn_GetLegacyContractTypeByID ( con.ContractTypeID, con.ContractTemplateID, con.ContractDealTypeID )    
                AS ContractType,    
    rtrim(con.number)        AS ContractNumber,    
    AD.AddressID         AS BillingAddressLink,    
    rtrim(AD.Address1)        AS BillingAddress1,    
    rtrim(AD.Address2)         AS BillingAddress2,     
    rtrim(AD.city)         AS BillingCity,     
    rtrim(AD.county)         AS BillingCounty,    
    rtrim(AD.[state])        AS BillingState,     
    rtrim(AD.zip)         AS BillingZip,    
    cust.SSNClear         AS SSN,    
    con.SalesRep         AS salesrep,    
    cust.TaxID          AS TaxID,    
    sc.ChannelDescription       AS ChannelPartnerName,    
    ''            AS ContractTypeDescp    
    
   FROM LibertyPower..Account     a WITH (NOLOCK)    
   JOIN LibertyPower..[Contract]    con WITH (NOLOCK) ON a.CurrentRenewalContractID = con.ContractID AND con.ContractDealTypeID = 2    
   JOIN LibertyPower..AccountContract   ac WITH (NOLOCK) ON ac.ContractID = con.ContractID AND ac.AccountID = a.AccountID    
   JOIN LibertyPower..AccountContractRate  acr WITH (NOLOCK) ON acr.AccountContractID = ac.AccountContractID   
   -- Andre Damasceno [03/31/2014] Begin [1]    
    JOIN (Select AccountContractID,MAX(RateEnd) as MaxRateEndDate from LibertyPower..AccountContractRate  with(nolock) Group By AccountContractID) AS ACR1    
         ON (ACR.AccountContractID = ACR1.AccountContractID AND ACR.RateEnd = ACR1.MaxRateEndDate)  
   -- Andre Damasceno [03/31/2014] End [1]   
   JOIN LibertyPower..SalesChannel    sc WITH (NOLOCK) ON con.SalesChannelID = sc.ChannelID    
   LEFT JOIN LibertyPower..Customer   cust WITH (NOLOCK) ON a.CustomerID = cust.CustomerID    
   LEFT JOIN LibertyPower..BusinessType  BT WITH (NOLOCK) ON cust.BusinessTypeID = BT.BusinessTypeID      
   LEFT JOIN LibertyPower..BusinessActivity BA WITH (NOLOCK) ON cust.BusinessActivityID = BA.BusinessActivityID     
   -- Andre Damasceno [03/31/2014] Begin [2]    
   LEFT JOIN LibertyPower.dbo.Name AS N WITH (NOLOCK) ON a.AccountNameID = N.NameID   
   LEFT JOIN LibertyPower.dbo.Address AS AD WITH (NOLOCK) ON a.BillingAddressID = AD.AddressID  
   LEFT JOIN LibertyPower.dbo.Contact AS C WITH (NOLOCK) ON a.BillingContactID = C.ContactID  
   -- Andre Damasceno [03/31/2014] End [2]        
   WHERE con.Number = @contract_number    
   --GROUP BY z.full_name, BT.[Type], BA.Activity, d.first_name, d.last_name, d.title, d.phone,    
   --  d.fax, d.email, d.birthday, con.ContractTypeID, con.ContractTemplateID, con.ContractDealTypeID, con.Number, c.address_link, [address],    
   --  c.suite, c.city, c.county, c.[state], c.zip, acr.Term,    
   --  cust.SSNClear, con.SalesRep, cust.TaxID, sc.ChannelName    
       
   IF @@ROWCOUNT > 0     
    GOTO FINAL    
        
  END -- GET DATA FROM ACCOUNT RENEWAL TABLES     
    
    
 -- Check Contract Renewal Deal Contract Accounts    
 -- ========================================================    
 IF EXISTS( select 1    
    from lp_contract_renewal..deal_contract_account a  WITH (NOLOCK)     
    where a.contract_nbr =  @contract_number )    
        
  BEGIN     
   -- Get data from Contract Renewal     
   INSERT INTO #addressInfo    
   SELECT DISTINCT    
    rtrim(z.full_name)    AS CustomerName    
    ,rtrim(a.business_type)   AS BusinessType    
    ,rtrim(a.business_activity)  AS BusinessActivity    
                              
    ,rtrim(d.first_name)   AS ContactFirstName    
    ,rtrim(d.last_name)    AS ContactLastName    
    ,rtrim(d.title)     AS ContactTitle    
    ,rtrim(d.phone)     AS ContactPhone    
    ,rtrim(d.fax)     AS ContactFax                            
    ,rtrim(d.email)     AS ContactEmail    
    ,rtrim(d.birthday)    AS ContactBirthday    
    
    ,rtrim(a.contract_type)   AS ContractType    
    ,rtrim(a.contract_nbr)   AS ContractNumber    
    --,rtrim(a.term_months)   AS Term    
    --,rtrim(dbo.ufn_convert_number_to_words(a.term_months))   AS TermInWords    
        
    ,a.billing_address_link   AS BillingAddressLink    
    ,rtrim(c.address)    AS BillingAddress1    
    ,rtrim(c.suite)     AS BillingAddress2    
    ,rtrim(c.city)     AS BillingCity    
    ,rtrim(c.county)    AS BillingCounty    
    ,rtrim(c.state)     AS BillingState    
    ,rtrim(c.zip)     AS BillingZip    
    
    ,max(rtrim(case when additional_id_nbr_type = 'SSN' then additional_id_nbr else '' end ))    
            AS SSN    
    ,max(sales_rep)     AS salesrep    
    --,case when a.term_months = 0 then '' else  a.term_months end     
    ,max(rtrim(case when additional_id_nbr_type = 'TAX ID' then additional_id_nbr else '' end ))    
            AS TaxID    
    ,max(s.ChannelDescription)  AS ChannelPartnerName    
    ,''        AS ContractTypeDescp    
    
   FROM lp_contract_renewal..deal_contract_account   a WITH (NOLOCK)    
   LEFT JOIN libertypower..saleschannel     s WITH (NOLOCK)  ON replace(a.sales_channel_role, 'sales channel/','') = s.ChannelName    
   LEFT JOIN lp_contract_renewal..deal_account_name  z WITH (NOLOCK)  ON z.account_id = a.account_id AND z.name_link = a.customer_name_link     
   LEFT JOIN lp_contract_renewal..deal_account_address  c WITH (NOLOCK)  ON c.account_id = a.account_id AND c.address_link = a.billing_address_link       
   LEFT JOIN lp_contract_renewal..deal_account_contact  d WITH (NOLOCK)  ON d.account_id = a.account_id AND d.contact_link = a.customer_contact_link    
    
   WHERE a.contract_nbr = @contract_number    
   GROUP BY z.full_name, a.business_type, a.business_activity, d.first_name , d.last_name , d.title , d.phone    
     , d.fax , d.email , d.birthday , a.contract_type , a.contract_nbr , a.billing_address_link, c.[address]    
     , c.suite , c.city , c.county , c.[state] , c.zip  , a.term_months    
       
   IF @@ROWCOUNT > 0     
    GOTO FINAL     
  END -- Get data from Contract Renewal     
    
 -- Check Contract Renewal Deal Contract     
 -- ========================================================    
 IF EXISTS( select 1    
    from lp_contract_renewal..deal_contract a  WITH (NOLOCK)     
    where a.contract_nbr =  @contract_number )    
  BEGIN    
   -- Get data from Contract Renewal     
   INSERT INTO #addressInfo    
   SELECT DISTINCT     
    rtrim(z.full_name)    AS CustomerName    
    ,rtrim(a.business_type)   AS BusinessType    
    ,rtrim(a.business_activity)  AS BusinessActivity    
                              
    ,rtrim(d.first_name)   AS ContactFirstName    
    ,rtrim(d.last_name)    AS ContactLastName    
    ,rtrim(d.title)     AS ContactTitle    
    ,rtrim(d.phone)     AS ContactPhone    
    ,rtrim(d.fax)     AS ContactFax                            
    ,rtrim(d.email)     AS ContactEmail    
    ,rtrim(d.birthday)    AS ContactBirthday    
    
    ,rtrim(a.contract_type)   AS ContractType     
    ,rtrim(a.contract_nbr)   AS ContractNumber                           
    --,rtrim(a.term_months)   AS Term,     
    --,rtrim(dbo.ufn_convert_number_to_words(a.term_months))   AS TermInWords,    
        
    ,a.billing_address_link   AS BillingAddressLink    
    ,rtrim(c.address)    AS BillingAddress1    
    ,rtrim(c.suite)     AS BillingAddress2    
    ,rtrim(c.city)     AS BillingCity    
    ,rtrim(c.county)    AS BillingCounty    
    ,rtrim(c.state)     AS BillingState    
    ,rtrim(c.zip)     AS BillingZip    
        
    ,max(rtrim(case when additional_id_nbr_type = 'SSN' then additional_id_nbr else '' end ))    
            AS SSN    
    ,max(sales_rep)     AS salesrep    
    --,case when a.term_months = 0 then '' else  a.term_months end     
    ,max(rtrim(case when additional_id_nbr_type = 'TAX ID' then additional_id_nbr else '' end ))    
            AS TaxID    
    ,max(s.ChannelDescription)  AS ChannelPartnerName    
    ,''        AS ContractTypeDescp    
    
   FROM lp_contract_renewal..deal_contract     a WITH (NOLOCK)    
   LEFT JOIN libertypower..saleschannel     s WITH (NOLOCK)  ON replace(a.sales_channel_role, 'sales channel/','') = s.ChannelName    
   LEFT OUTER JOIN lp_contract_renewal..deal_name   z WITH (NOLOCK)  ON z.contract_nbr = a.contract_nbr AND z.name_link = a.customer_name_link     
   LEFT OUTER JOIN lp_contract_renewal..deal_address  c WITH (NOLOCK)  ON c.contract_nbr = a.contract_nbr AND c.address_link = a.billing_address_link       
   LEFT OUTER JOIN lp_contract_renewal..deal_contact  d WITH (NOLOCK)  ON d.contract_nbr = a.contract_nbr AND d.contact_link = a.customer_contact_link    
       
   WHERE a.contract_nbr = @contract_number    
   GROUP BY z.full_name, a.business_type, a.business_activity, d.first_name , d.last_name , d.title , d.phone    
     , d.fax , d.email , d.birthday , a.contract_type , a.contract_nbr , a.billing_address_link, c.[address]    
     , c.suite , c.city , c.county , c.[state] , c.zip  , a.term_months    
       
   IF @@ROWCOUNT > 0     
    GOTO FINAL       
  END -- Get data from Contract Renewal     
    
    
 -- Get data from Account table    
 -- ===========================================================    
 IF EXISTS( select 1    
    from Libertypower..Account a  WITH (NOLOCK)     
    JOIN Libertypower..[Contract] CON WITH (NOLOCK) ON a.CurrentContractID = CON.ContractID  
    where CON.Number =  @contract_number )     
  BEGIN     
    
   INSERT INTO #addressInfo    
   SELECT DISTINCT    
    rtrim(N.Name)    AS CustomerName,     
    rtrim(LEFT(UPPER(ISNULL(BT.Type, 'NONE')), 35))   AS BusinessType,     
    rtrim(LEFT(UPPER(ISNULL(BA.Activity, 'NONE')), 35))  AS BusinessActivity,     
                              
    rtrim(C.firstname)    AS ContactFirstName,     
    rtrim(C.lastname)    AS ContactLastName,     
    rtrim(C.title)     AS ContactTitle,     
    rtrim(C.phone)     AS ContactPhone,     
    rtrim(C.fax)     AS ContactFax,                             
    rtrim(C.email)     AS ContactEmail,     
    rtrim(CONVERT(char(2), MONTH(C.Birthdate)) + '/' + CONVERT(char(2), DAY(C.Birthdate)))    AS ContactBirthday,     
    
    rtrim(LibertyPower.dbo.ufn_GetLegacyContractType(CT.Type,CTT.ContractTemplateTypeID, CDT.DealType))   AS ContractType,     
    rtrim(Con.Number)   AS ContractNumber,                             
    --rtrim(a.term_months)   AS Term,     
    --rtrim(dbo.ufn_convert_number_to_words(a.term_months))   AS TermInWords,    
    
    AD.AddressID   AS BillingAddressLink,    
    rtrim(AD.Address1)    AS BillingAddress1,     
    rtrim(AD.Address2)     AS BillingAddress2,     
    rtrim(AD.city)     AS BillingCity,     
    rtrim(AD.county)     AS BillingCounty,                          
    rtrim(AD.state)     AS BillingState,     
    rtrim(AD.zip)     AS BillingZip    
        
    ,max(rtrim(case when LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbrType(CUST.Duns, CUST.EmployerId,CUST.TaxId, CUST.SsnEncrypted) = 'SSN' then LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbr(CUST.Duns, CUST.EmployerId, CUST.TaxId,CUST.SsnEncrypted)  else
 '' end ))    
            AS  SSN    
    ,max(Con.SalesRep)     AS salesrep    
    --,case when a.term_months = 0 then '' else  a.term_months end     
    ,max(rtrim(case when LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbrType(CUST.Duns, CUST.EmployerId,CUST.TaxId, CUST.SsnEncrypted) = 'TAX ID' then LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbr(CUST.Duns, CUST.EmployerId, CUST.TaxId,CUST.SsnEncrypted)  else '' end ))    
            AS TaxID    
    ,max(s.ChannelDescription)  AS ChannelPartnerName    
    ,''        AS ContractTypeDescp    
    -- Andre Damasceno [03/31/2014] Begin [2]  
   FROM LibertyPower.dbo.Account AS A WITH (NOLOCK)  
   JOIN LibertyPower.dbo.Contract AS Con WITH (NOLOCK) ON A.CurrentContractID = Con.ContractID  
   JOIN LibertyPower.dbo.ContractType AS CT WITH (NOLOCK) ON Con.ContractTypeID = CT.ContractTypeID  
   JOIN LibertyPower.dbo.ContractTemplateType AS CTT WITH (NOLOCK) ON Con.ContractTemplateID = CTT.ContractTemplateTypeID  
   JOIN LibertyPower.dbo.Customer AS CUST WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID        
   JOIN LibertyPower.dbo.SalesChannel AS SC WITH (NOLOCK) ON Con.SalesChannelID = SC.ChannelID                   
   LEFT JOIN LibertyPower.dbo.ContractDealType AS CDT WITH (NOLOCK) ON Con.ContractDealTypeID = CDT.ContractDealTypeID  
   LEFT JOIN LibertyPower.dbo.BusinessType AS BT WITH (NOLOCK) ON CUST.BusinessTypeID = BT.BusinessTypeID   
   LEFT JOIN LibertyPower.dbo.BusinessActivity AS BA WITH (NOLOCK) ON CUST.BusinessActivityID = BA.BusinessActivityID    
   -- Andre Damasceno [03/31/2014] End [2]  
   LEFT JOIN libertypower..saleschannel  s WITH (NOLOCK)  ON SC.ChannelName = s.ChannelName    
   -- Andre Damasceno [03/31/2014] Begin [2]  
   JOIN LibertyPower.dbo.Name AS N WITH (NOLOCK) ON a.AccountNameID = N.NameID   
   JOIN LibertyPower.dbo.Address AS AD WITH (NOLOCK) ON a.BillingAddressID = AD.AddressID  
   JOIN LibertyPower.dbo.Contact AS C WITH (NOLOCK) ON a.BillingContactID = C.ContactID   
   -- Andre Damasceno [03/31/2014] End [2]      
    
   WHERE Con.Number = @contract_number    
   GROUP BY N.Name, BT.Type, BA.Activity, C.firstname , C.lastname , C.title , C.phone    
     , C.fax , C.email, C.Birthdate , CT.Type,CTT.ContractTemplateTypeID, CDT.DealType , Con.Number , AD.AddressID, AD.Address1   
     , AD.Address2 , AD.city , AD.county , AD.[state] , AD.zip    
       
   IF @@ROWCOUNT > 0     
   GOTO FINAL    
  END -- get data from accounts    
    
 -- Check new Contract tables     
 -- ========================================================    
 IF EXISTS( select 1    
    from lp_deal_capture..deal_contract_account a  WITH (NOLOCK)     
    where a.contract_nbr =  @contract_number )    
  BEGIN    
   -- Get data from new Contract     
   INSERT INTO #addressInfo    
   SELECT DISTINCT     
    rtrim(z.full_name)    AS CustomerName,     
    rtrim(a.business_type)   AS BusinessType,     
    rtrim(a.business_activity)  AS BusinessActivity,     
    
    rtrim(d.first_name)    AS ContactFirstName,     
    rtrim(d.last_name)    AS ContactLastName,     
    rtrim(d.title)     AS ContactTitle,     
    rtrim(d.phone)     AS ContactPhone,     
    rtrim(d.fax)     AS ContactFax,                      
    rtrim(d.email)     AS ContactEmail,     
    rtrim(d.birthday)    AS ContactBirthday,     
    
    rtrim(a.contract_type)   AS ContractType,     
    rtrim(a.contract_nbr)   AS ContractNumber,                             
    --rtrim(a.term_months)   AS Term,     
    --rtrim(dbo.ufn_convert_number_to_words(a.term_months))   AS TermInWords,    
    
    a.billing_address_link   AS BillingAddressLink,    
    rtrim(c.address)    AS BillingAddress1,     
    rtrim(c.suite)     AS BillingAddress2,     
    rtrim(c.city)     AS BillingCity,     
    rtrim(c.county)     AS BillingCounty,                          
    rtrim(c.state)     AS BillingState,     
    rtrim(c.zip)     AS BillingZip    
    
    ,max(rtrim(case when additional_id_nbr_type = 'SSN' then additional_id_nbr else '' end ))    
            AS SSN    
    ,max(sales_rep)     AS salesrep    
    --,case when a.term_months = 0 then '' else  a.term_months end     
    ,max(rtrim(case when additional_id_nbr_type = 'TAX ID' then additional_id_nbr else '' end ))    
            AS TaxID    
    ,max(s.ChannelDescription)  AS ChannelPartnerName    
    ,''        AS ContractTypeDescp    
    
   FROM lp_deal_capture..deal_contract_account   a WITH (NOLOCK)     
   LEFT JOIN libertypower..saleschannel    s WITH (NOLOCK)  ON replace(a.sales_channel_role, 'sales channel/','') = s.ChannelName    
   LEFT JOIN lp_deal_capture..deal_name    z WITH (NOLOCK)  ON z.contract_nbr = a.contract_nbr AND z.name_link = a.customer_name_link     
   LEFT JOIN lp_deal_capture..deal_address    c WITH (NOLOCK)  ON c.contract_nbr = a.contract_nbr AND c.address_link = a.billing_address_link       
   LEFT JOIN lp_deal_capture..deal_contact    d WITH (NOLOCK)  ON d.contract_nbr = a.contract_nbr AND d.contact_link = a.customer_contact_link    
    
   WHERE a.contract_nbr = @contract_number    
   GROUP BY z.full_name, a.business_type, a.business_activity, d.first_name , d.last_name , d.title , d.phone    
     , d.fax , d.email , d.birthday , a.contract_type , a.contract_nbr , a.billing_address_link, c.[address]    
     , c.suite , c.city , c.county , c.[state] , c.zip , a.term_months    
    
   IF @@ROWCOUNT > 0     
    GOTO FINAL    
  END -- Get data from new Contract      
    
    
 -- Check new Contract tables     
 -- ========================================================    
 IF EXISTS( select 1    
    from lp_deal_capture..deal_contract a  WITH (NOLOCK)     
    where a.contract_nbr =  @contract_number )    
  BEGIN     
   -- Get data from new Contract     
    
   INSERT INTO #addressInfo    
   SELECT DISTINCT    
    rtrim(z.full_name)    AS CustomerName,     
    rtrim(a.business_type)   AS BusinessType,     
    rtrim(a.business_activity)  AS BusinessActivity,     
    
    rtrim(d.first_name)    AS ContactFirstName,     
    rtrim(d.last_name)    AS ContactLastName,     
    rtrim(d.title)     AS ContactTitle,     
    rtrim(d.phone)     AS ContactPhone,     
    rtrim(d.fax)     AS ContactFax,                             
    rtrim(d.email)     AS ContactEmail,     
    rtrim(d.birthday)    AS ContactBirthday,     
    
    rtrim(a.contract_type)   AS ContractType,     
    rtrim(a.contract_nbr)   AS ContractNumber,                             
    --rtrim(a.term_months)   AS Term,     
    --rtrim(dbo.ufn_convert_number_to_words(a.term_months))   AS TermInWords,    
    
    a.billing_address_link   AS BillingAddressLink,    
    rtrim(c.address)    AS BillingAddress1,     
    rtrim(c.suite)     AS BillingAddress2,     
    rtrim(c.city)     AS BillingCity,     
    rtrim(c.county)     AS BillingCounty,                          
    rtrim(c.state)     AS BillingState,     
    rtrim(c.zip)     AS BillingZip    
    
    ,max(rtrim(case when additional_id_nbr_type = 'SSN' then additional_id_nbr else '' end ))    
            AS SSN    
    ,max(sales_rep)     AS salesrep    
    --,case when a.term_months = 0 then '' else  a.term_months end     
    ,max(rtrim(case when additional_id_nbr_type = 'TAX ID' then additional_id_nbr else '' end ))    
            AS TaxID    
    ,max(s.ChannelDescription)  AS ChannelPartnerName    
    ,''        AS ContractTypeDescp    
    
   FROM lp_deal_capture..deal_contract    a WITH (NOLOCK)    
   LEFT JOIN libertypower..saleschannel   s WITH (NOLOCK)  ON replace(a.sales_channel_role, 'sales channel/','') = s.ChannelName    
   LEFT JOIN lp_deal_capture..deal_name   z WITH (NOLOCK)  ON z.contract_nbr = a.contract_nbr AND z.name_link = a.customer_name_link     
   LEFT JOIN lp_deal_capture..deal_address   c WITH (NOLOCK)  ON c.contract_nbr = a.contract_nbr AND c.address_link = a.billing_address_link       
   LEFT JOIN lp_deal_capture..deal_contact   d WITH (NOLOCK)  ON d.contract_nbr = a.contract_nbr AND d.contact_link = a.customer_contact_link    
    
   WHERE a.contract_nbr = @contract_number    
   GROUP BY z.full_name, a.business_type, a.business_activity, d.first_name , d.last_name , d.title , d.phone    
     , d.fax , d.email , d.birthday , a.contract_type , a.contract_nbr , a.billing_address_link, c.[address]    
     , c.suite , c.city , c.county , c.[state] , c.zip , a.term_months    
    
   IF @@ROWCOUNT > 0     
    GOTO FINAL       
  END -- Get data from new Contract      
    
  -- no need to check lp_deal_capture..deal_contract_print and lp_deal_capture..muti_rates because     
  -- no address info can be obtained from joining on these tables    
    
DummyRow:    
  -- If nothing else works return blank row    
  -- =======================================    
  BEGIN    
   --new deal    
   -- Return mostly blanks    
   INSERT INTO #addressInfo    
   SELECT TOP 1    
    ''          AS CustomerName,     
    ''          AS BusinessType,     
    ''          AS BusinessActivity,     
                                       
    ''          AS ContactFirstName,     
    ''          AS ContactLastName,     
    ''          AS ContactTitle,     
    ''          AS ContactPhone,     
    ''          AS ContactFax,                             
    ''          AS ContactEmail,     
    ''          AS ContactBirthday,     
    
    ''          AS ContractType,     
    @contract_number     AS ContractNumber,                             
    --'' AS Term,    
    --'' AS TermInWords,     
        
    0           AS BillingAddressLink,    
    ''          AS BillingAddress1,     
    ''          AS BillingAddress2,     
    ''          AS BillingCity,     
    ''          AS BillingCounty,                          
    ''          AS BillingState,     
    ''          AS BillingZip    
    ,''         AS SSN    
    ,''         AS SalesRep     
    --,'' as Term -- Do Not Use term Here. All Term fields in template will use this value !!!    
    , ''        AS TAXID    
--    , ''   AS ChannelPartnerName     
    ,s.ChannelDescription    AS ChannelPartnerName    
    , ''        AS ContractTypeDescp    
   FROM lp_deal_capture..deal_contract_print  a WITH (NOLOCK)     
   LEFT JOIN libertypower..saleschannel   s WITH (NOLOCK)  ON replace(a.sales_channel_role, 'sales channel/','') = s.channelname    
   WHERE a.contract_nbr = @contract_number    
    
   IF @@ROWCOUNT > 0     
    GOTO FINAL    
    
  END  -- return blanks     
    
FINAL:    
 UPDATE #addressInfo SET     
  CustomerName =  case when ltrim(rtrim(CustomerName))  = 'NONE' then '' else CustomerName end     
  ,BusinessType =  case when ltrim(rtrim(BusinessType))  = 'NONE' then '' else BusinessType end     
  ,BusinessActivity = case when ltrim(rtrim(BusinessActivity)) = 'NONE' then '' else BusinessActivity end      
  ,ContactFirstName = case when ltrim(rtrim(ContactFirstName)) = 'NONE' then '' else ContactFirstName end     
  ,ContactLastName = case when ltrim(rtrim(ContactLastName))  = 'NONE' then '' else ContactLastName end     
  ,ContactTitle =  case when ltrim(rtrim(ContactTitle))  = 'NONE' then '' else ContactTitle end     
  ,ContactPhone =  case when ltrim(rtrim(ContactPhone))  = 'NONE' then '' else ContactPhone end     
  ,ContactFax =  case when ltrim(rtrim(ContactFax))   = 'NONE' then '' else ContactFax end                             
  ,ContactEmail =  case when ltrim(rtrim(ContactEmail))  = 'NONE' then '' else ContactEmail end     
  ,ContactBirthday = case when ltrim(rtrim(ContactBirthday))  = 'NONE' then '' else ContactBirthday end     
  ,ContractTypeDescp = ContractType    
  ,ContractType =  case when ltrim(rtrim(ContractType)) = 'NONE' then ''    
        when ContractType like '%renew%' then 'RENEWAL'    
        when ContractType like '%Paper%' then 'NEW'    
        else ContractType    
       end    
  --,@contract_number   AS ContractNumber,                             
  --,Term = case when (ltrim(rtrim(Term)) = 'NONE' then '' else Term end     
  --,TermInWords = case when ltrim(rtrim(TermInWords)) = 'NONE' then '' else TermInWords end     
  --,BillingAddressLink = case when (ltrim(rtrim(CustomerName)) = 'NONE' then '' else CustomerName end     
  ,BillingAddress1 = case when ltrim(rtrim(BillingAddress1))  = 'NONE' then '' else BillingAddress1 end     
  ,BillingAddress2 = case when ltrim(rtrim(BillingAddress2))  = 'NONE' then '' else BillingAddress2 end     
  ,BillingCity =  case when ltrim(rtrim(BillingCity))   = 'NONE' then '' else BillingCity end     
  ,BillingCounty = case when ltrim(rtrim(BillingCounty))  = 'NONE' then '' else BillingCounty end     
  ,BillingState =  case when ltrim(rtrim(BillingState))  = 'NONE' then '' else BillingState end     
  ,BillingZip =  case when ltrim(rtrim(BillingZip))   = 'NONE' then '' else BillingZip end     
    
    
----------------Return Data    
 SELECT TOP 1    
  *,    
  CONVERT(VARCHAR(10), GETDATE(), 101)     as 'GeneratedDate',    
  CONVERT(VARCHAR(10), DateAdd(DAY, 14, getdate()), 101) as 'ContactDate',
  (Select top 1 cu.Duns as DunsNumber from libertypower..Customer cu (nolock) 
    join libertypower..Account a (nolock) on cu.CustomerID=a.CustomerID    
    join libertypower..AccountContract ac (nolock) on ac.AccountID=a.AccountID 
    JOIN LIBERTYPOWER..Contract c (nolock) ON ac.ContractID=c.ContractID AND c.Number=@contract_number) AS CustomerDunsNumber,   
  (select STUFF((Select ',' + RTRIM(LTRIM(aa.Code)) from --Logic to combine all promocodes and return as comma separated.
    (Select distinct P.Code from Libertypower..ContractQualifier CQ (nolock)  
	   join Libertypower..contract C (nolock) on  CQ.ContractId = C.ContractID
	   join Libertypower..Qualifier Q (nolock) on CQ.QualifierId= Q.QualifierId
	   Join Libertypower..PromotionCode P (nolock) on P.PromotionCodeId = Q.PromotionCodeId
	   where C.Number=@contract_number) as aa 
    for XML PATH ('')),1,1,''))  as PromoCodes 
     
 FROM #addressInfo (nolock)        
 ORDER BY 1 DESC    
    
END    
    