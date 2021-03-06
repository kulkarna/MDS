USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAccountContractDetailsForFulfillment]    Script Date: 02/25/2014 14:27:17 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-------------------------------------------------------------------------
--Added on Feb 12 2014 Sara Lakshmanan
-- Created to show the account details in the fulfillment page for a given contractID
----------------------------------------------------------------------
-------------------------------------------------------------------------
--Modified Feb 25 2014 Sara Lakshmanan
-- Added Account Status Description
----------------------------------------------------------------------


ALTER PROCEDURE dbo.usp_GetAccountContractDetailsForFulfillment(@p_ContractID varchar(15))
AS
BEGIN

    SET NOCOUNT ON;


    SELECT A.AccountID, 
           A.AccountNumber, 
           AccSt.Status + '-' + ES.status_descp AS AccountStatus, 
           Ct.Phone AS ContactPhone, 
           CT.Email AS EmailAddress, 
           Add1.Address1 AS BillingStreet, 
           Add1.Address2 AS BillingStreet2, 
           Add1.City AS BillingCity, 
           Add1.State AS BillingState
      FROM LIbertypower..AccountContract Ac WITH (NoLock)
           INNER JOIN Libertypower..Account A WITH (NoLock)
           ON AC.AccountID = A.AccountID
          AND (AC.Contractid = A.CurrentContractID
            OR AC.ContractID = A.CurrentRenewalContractID)
           INNER JOIN AccountStatus AccSt WITH (NoLock)
           ON Ac.AccountContractID = AccSt.AccountContractID
           INNER JOIN Lp_Account..enrollment_status ES WITH (NoLock)
           ON ES.status = AccSt.Status
           INNER JOIN Libertypower..Contact Ct WITH (NoLock)
           ON Ct.ContactID = A.BillingContactID
           INNER JOIN Libertypower..Address Add1 WITH (NoLock)
           ON Add1.AddressID = A.BillingAddressID
      WHERE Ac.ContractID = @p_ContractID;

    SET NOCOUNT OFF;
END;
GO


