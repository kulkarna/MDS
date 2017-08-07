USE LibertyPower;
GO
-----------------------------
--1. Script to remove the qualifiers added on 5/5/2014 
--These are not the valid ones
----------------------
IF EXISTS(SELECT DISTINCT groupBY
            FROM LIbertyPower..Qualifier WITH (NoLock)
            WHERE PromotionCodeId = 1
              AND CampaignId = 1
              AND GroupBy <> 1)
    BEGIN

        DELETE FROM LIbertyPower..Qualifier
          WHERE PromotionCodeId = 1
            AND CampaignId = 1
            AND GroupBy <> 1;

    END;
GO

-----------------------
--2. Script to Insert the right Qualifiers for Reward50
-----------------------------
usp_qualifier_ins 1, 1, '475,1186,1010,1168,27,1201,821,62,1190,66,1197,1175,1194,1199,357,1152,1195,1166,619,1193,591,1187', '3,8,9,10,13,14', '11,13,15,17,20,21,22,33,35,37,38,45,49,50,55,56', '1,2', 24, '18,21,22,23,', '10/23/2013', '12/31/2013', NULL, NULL, NULL, 1982;



--------------------------------------
--3. Script to Insert qualifiers for Illinois marketID -14, Since there are contracts with marketId=14
------------------------------------------------------
INSERT INTO LIbertypower..Qualifier(CampaignId, 
                                    PromotionCodeId, 
                                    SalesChannelId, 
                                    MarketId, 
                                    UtilityId, 
                                    AccountTypeId, 
                                    Term, 
                                    ProductBrandId, 
                                    SignStartDate, 
                                    SignEndDate, 
                                    ContractEffecStartPeriodStartDate, 
                                    ContractEffecStartPeriodLastDate, 
                                    PriceTierId, 
                                    AutoApply, 
                                    CreatedBy, 
                                    CreatedDate, 
                                    GroupBy)
SELECT CampaignId, 
       PromotionCodeId, 
       SalesChannelId, 
       14, 
       UtilityId, 
       AccountTypeId, 
       Term, 
       ProductBrandId, 
       SignStartDate, 
       SignEndDate, 
       ContractEffecStartPeriodStartDate, 
       ContractEffecStartPeriodLastDate, 
       PriceTierId, 
       AutoApply, 
       1982, 
       GETDATE(), 
       1
  FROM LIbertyPower..Qualifier Q WITH (NoLock)
  WHERE Q.PromotionCodeId = 1
    AND Q.CampaignId = 1
    AND GroupBy = 1
    AND MarketId = 13;




----------------------------------------------------
--4. Script to Insert records to the Fulfillment page
-----------------------------------------------------------------------


INSERT INTO Libertypower..ContractQualifier(ContractId, 
                                            AccountID, 
                                            QualifierID, 
                                            PromotionStatusID, 
                                            Comment, 
                                            CreatedBY, 
                                            CreatedDate, 
                                            ModifiedBy, 
                                            ModifiedDate)
SELECT *, 
       1, 
       NULL, 
       1982, 
       GETDATE(), 
       1982, 
       GETDATE()
  FROM((SELECT DISTINCT C.ContractID, 
                        A.AccountID, 
                        Q.QualifierId
          FROM LIbertypower..Contract C WITH (NoLock)
               INNER JOIN LIbertyPower..AccountContract AC WITH (NoLock)
               ON C.ContractID = AC.ContractID
               INNER JOIN Libertypower..Account A WITH (NoLock)
               ON AC.AccountID = A.AccountID
               INNER JOIN LibertyPower..AccountContractRate ACR WITH (NoLock)
               ON ACR.AccountContractID = Ac.AccountContractID
               INNER JOIN Lp_common..common_product cp WITH (NOLock)
               ON Cp.product_id = ACR.LegacyProductID
               INNER JOIN Libertypower..AccountType AT WITH (NoLock)
               ON A.AccountTypeID = AT.ID
               INNER JOIN LibertyPower..Qualifier Q
               ON C.SalesChannelID = Q.SalesChannelId
                  -- AND A.RetailMktID = Q.MarketId
                  --and A.UtilityID=Q.UtilityId
              AND AT.ProductAccountTypeID = Q.AccountTypeId
              AND CP.ProductBrandID = Q.ProductBrandId
          WHERE ACR.Term >= Q.Term
            AND C.SignedDate >= Q.SignStartDate
            AND C.SignedDate <= Q.SignEndDate
            AND (A.UtilityID = Q.UtilityId
              OR Q.UtilityId IS NULL)
            AND (A.RetailMktID = Q.MarketId
              OR Q.MarketID IS NULL))
       EXCEPT
       (SELECT ContractId, 
               AccountID, 
               QualifierID
          FROM LIbertypower..ContractQualifier WITH (NOLOCK)))AS Result;

-----------------------------------------------------------------------------------
