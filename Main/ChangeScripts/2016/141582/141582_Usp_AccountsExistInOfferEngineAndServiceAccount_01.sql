 use LibertyPower
 Go
-- =============================================  
-- Author:  vikas sharma  
-- Create date: 09/28/2016  
-- Description: Checks if account exists in offer engine and service account table 
-- =============================================  
CREATE PROCEDURE [dbo].[usp_AccountsExistsInOfferEngineAndServiceAccount]  
 -- Add the parameters for the stored procedure here  
 @AccountNumber VARCHAR(50),   
 @UtilityCode VARCHAR(50)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 IF (EXISTS(SELECT ID FROM OfferEngineDB..OE_ACCOUNT (NOLOCK) WHERE ACCOUNT_NUMBER = @AccountNumber AND UTILITY=@UtilityCode) Or
   EXISTS(SELECT 1 
    from [LPCNOCCRMSQL].LIBERTYCRM_MSCRM.dbo.lpc_serviceaccount A
 inner join [LPCNOCCRMSQL].LIBERTYCRM_MSCRM.dbo.lpc_utility B on A.lpc_utilityid=b.lpc_utilityid
   WHERE lpc_accountnumber = @AccountNumber AND b.lpc_utilitycode=@UtilityCode)
 )  
  SELECT 1 AS 'Exists'  
 ELSE  
  SELECT 0 AS 'Exists'  
END  
  