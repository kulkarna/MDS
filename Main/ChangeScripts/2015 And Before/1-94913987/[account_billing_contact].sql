USE [lp_account]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[account_billing_contact]  
AS  
SELECT   
   C.ContactID as AccountContactID,   
   A.AccountIdLegacy AS account_id,   
   C.ContactID   AS contact_link,   
   FirstName AS first_name,   
   LastName AS last_name,   
   Title,   
   Phone,   
   Fax,   
   Email,   
   CONVERT(char(2), MONTH(Birthdate)) + '/' + CONVERT(char(2), DAY(Birthdate)) AS birthday,   
   0 AS chgstamp  
FROM  LibertyPower.dbo.Contact C WITH (NOLOCK)  
JOIN  LibertyPower.dbo.Account  A WITH (NOLOCK)   ON A.BillingContactID = C.ContactID 




GO


