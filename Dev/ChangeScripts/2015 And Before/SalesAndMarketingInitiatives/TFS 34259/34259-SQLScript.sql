USE [LibertyPower]

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_QualifyingContractAccountFulfillmentList' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_QualifyingContractAccountFulfillmentList;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_QualifyingContractAccountFulfillmentList]
 * PURPOSE:		Get the list of contract accounts details which fulfill the criteria
 * HISTORY:		
 *******************************************************************************
 * 2/12/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_QualifyingContractAccountFulfillmentList] 
	@p_account_number_filter varchar(30)=null,
	@p_contract_nbr_filter char(12)=null,
	@p_customername_filter varchar(30)=null,
	@p_fulfillment_status_id_filter int=null,
	@p_account_status_id_filter varchar(12)=null,
	@p_camapaign_id_filter int=null,
	@p_promotioncode_id_filter int=null,
	@p_market_id_filter int=null,
	@p_order_by varchar(20)='ContractNumber'
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

WITH MYResultTable
    AS (SELECT DISTINCT Cg.Code AS PromoCampaignCode, 
                        P.Code AS PromotionCode,
                        Pt.[Description] AS PromotionType,
                        Sc.ChannelName AS SalesChannel,
                        C.SalesRep,
                        M.MarketCode As Market, 
                        C.Number AS ContractNumber, 
                        A.AccountNumber,
                        N.Name AS Customer, 
                        CT.LastName + ', ' + Ct.FirstName AS ContactName, 
                        CT.Phone AS ContactPhone,
                        CT.Email AS EmailAddress,
                        Ad.Address1 AS BillingStreet,
                        Ad.Address2 As BillingStreet2,
                        Ad.State As BillingState,
                        Ad.Zip As BillingZip,
                        C.SignedDate As SignDate, 
                        C.StartDate As ContractStartDate, 
                        AccSt.Status + '-' + Es.status_descp As AccountStatus,
                        CASE
                        WHEN CF.TriggerTypeId = 1 THEN 
								CASE 
								WHEN DATEDIFF(DD, GETDATE(), DATEADD(DD, CF.EligibilityPeriod, C.SignedDate)) >0  
								Then DATEDIFF(DD, GETDATE(), DATEADD(DD, CF.EligibilityPeriod, C.SignedDate)) 
								ELSE 0 END
                            ELSE CASE 
								WHEN DATEDIFF(DD, GETDATE(), DATEADD(DD, CF.EligibilityPeriod, C.StartDate)) >0  
								Then DATEDIFF(DD, GETDATE(), DATEADD(DD, CF.EligibilityPeriod, C.StartDate)) 
								ELSE 0 END
                        END AS DaystoQualify, 
                        CASE
                        WHEN CF.TriggerTypeId = 1 THEN DATEADD(DD, CF.EligibilityPeriod, C.SignedDate)
                            ELSE DATEADD(DD, CF.EligibilityPeriod, C.StartDate)
                        END AS QualifyDate,
                        Ps.Code As FulfillmentStatus,
                        CQ.Comment As Comments
          FROM Libertypower..ContractQualifier CQ WITH (NoLock)
               INNER JOIN Libertypower..Contract C WITH (NoLock)
               ON CQ.ContractId = C.ContractID
               INNER JOIN Libertypower..Qualifier Q WITH (NoLock)
               ON Q.QualifierId = CQ.QualifierId
               INNER JOIN LIbertyPower..PromotionCode P WITH (NoLock)
               ON Q.PromotionCodeId = P.PromotionCodeId
               INNER JOIN Libertypower..CampaignFulfillment CF WITH (NoLock)
               ON Q.CampaignId = CF.CampaignID
               INNER JOIN Libertypower..Campaign Cg WITH (NoLock)
               ON CF.CampaignId = Cg.CampaignId
               INNER JOIN Libertypower..AccountContract AC WITH (NoLock)
               ON C.ContractID = AC.ContractID
               INNER JOIN Libertypower..Account A WITH (NoLock)
				ON AC.AccountID = A.AccountID
				AND (AC.Contractid = A.CurrentContractID
				OR AC.ContractID = A.CurrentRenewalContractID)
               INNER JOIN AccountStatus AccSt WITH (NoLock)
               ON Ac.AccountContractID = AccSt.AccountContractID
               INNER JOIN Libertypower..Customer Cs WITH (NoLock)
               ON A.CustomerID = Cs.CustomerID
               INNER JOIN Libertypower..Name N WITH (NoLock)
               ON Cs.NameID = N.NameID
               INNER JOIN Libertypower..Contact Ct WITH (NoLock)
               ON Cs.ContactId = Ct.ContactID
               INNER JOIN Libertypower..Market M WITH (NoLock)
               ON M.ID = A.RetailMktID
               INNER JOIN LibertyPower..SalesChannel Sc WITH (NoLock)
               ON Sc.ChannelID=c.SalesChannelID
               INNER JOIN LibertyPower..PromotionType Pt WITH (NoLock)
               ON Pt.PromotionTypeId=P.PromotionTypeId
               INNER JOIN LibertyPower..Address Ad WITH (NoLock)
               ON Ad.AddressID=A.BillingAddressID
               INNER JOIN LibertyPower..PromotionStatus Ps WITH (NoLock)
               ON Ps.PromotionStatusId=CQ.PromotionStatusId
               INNER JOIN Lp_Account..enrollment_status ES WITH (NoLock)
				ON ES.status = AccSt.Status

          WHERE (cg.CampaignId = @p_camapaign_id_filter
              OR @p_camapaign_id_filter IS NULL)
            AND (M.ID = @p_market_id_filter
              OR @p_market_id_filter IS NULL)
            AND (A.AccountNumber = rtrim(ltrim(@p_account_number_filter))
              OR nullif(rtrim(ltrim(@p_account_number_filter)),'') IS NULL)
            AND (C.Number = @p_contract_nbr_filter
              OR nullif(rtrim(ltrim(@p_contract_nbr_filter)),'') IS NULL)
            AND (N.Name LIKE '%' + rtrim(ltrim(@p_customername_filter)) + '%'
              OR  nullif(rtrim(ltrim(@p_customername_filter)),'') IS NULL)
            AND (P.PromotionCodeId = @p_promotioncode_id_filter
              OR @p_promotioncode_id_filter IS NULL)
            AND (Ps.PromotionStatusId = @p_promotioncode_id_filter
              OR @p_promotioncode_id_filter IS NULL)
             AND (AccSt.Status=rtrim(ltrim(@p_account_status_id_filter))
              OR nullif(rtrim(ltrim(@p_account_status_id_filter)),'') IS NULL))
              
              
              
              
		 SELECT *
      FROM MYResultTable
      ORDER BY CASE @p_order_by
                   WHEN 'ContractNumber' THEN ContractNumber
                   END, CASE
                        WHEN @p_order_by = 'Customer' THEN Customer
                        END, CASE
                             WHEN @p_order_by = 'SignedDate' THEN SignDate
                             END, CASE
                                  WHEN @p_order_by = 'StartDate' THEN ContractStartDate
                                      ELSE DaystoQualify
                                  END;
		
Set NOCOUNT OFF;
END
-- Copyright 2/12/2013 Liberty Power
