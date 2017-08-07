USE [ISTA]

GO  
-- =============================================  
-- Author:  Isabelle Tamanini  
-- Create date: 02/15/2011  
-- Description: Retrieves the CustId of an Account  
-- SD20695  
-- =============================================  
-- Modified by: Agata Studzinska
-- Date: 11/7/2013
-- Description: Changed the ORDER BY statement, 
-- since we need CustomerID with the most current end service date
-- replaced account view by legacy tables
-- SR: 1-275559421 TFS: 24021
-- =============================================
  
ALTER PROCEDURE [dbo].[usp_GetCustIDByAccountNumberAndUtility]  
(  
 @AccountNumber varchar(100),  
 @UtilityId char(15)  
)  
AS  
BEGIN  
  
 SET NOCOUNT ON;  

 DECLARE @Now DATETIME

 SET @Now = GETDATE()
  
 --SELECT custid  
 -- FROM premise p  
 -- JOIN lp_account..account a on p.premno = a.account_number  
 -- WHERE premno = @AccountNumber   
 --   and a.utility_id = @UtilityId  
 -- ORDER BY EndServiceDate, premid DESC  
 
  SELECT p.CustID  
  FROM Premise P WITH (NOLOCK) 
  JOIN Libertypower..Account A WITH (NOLOCK) ON A.AccountNumber = P.PremNo
  JOIN Libertypower..Utility U WITH (NOLOCK) ON U.ID = A.UtilityID
  WHERE PremNo = @AccountNumber   
    AND U.UtilityCode = @UtilityId  
  ORDER BY ISNULL(P.EndServiceDate,@Now) DESC, PremID DESC
  
 SET NOCOUNT OFF;  
  
END