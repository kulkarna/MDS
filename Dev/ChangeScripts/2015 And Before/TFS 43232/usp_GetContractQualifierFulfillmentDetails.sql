USE [LibertyPower]
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_GetContractQualifierFulfillmentDetails' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_GetContractQualifierFulfillmentDetails];
GO

--Added on Feb 5 2014 Sara Lakshmanan
-- Created to get the contract fulfillment details to show in fulfillment Page
-- Modify : Pradeep Katiyar
-- Date : 7/21/2014 
-- Ticket: TFS 43232
-- Removed the where condition for records selection for the particular page in order to remove the page level sorting.
----------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_GetContractQualifierFulfillmentDetails](@p_camapaign_id_filter varchar(15), 
                                                                @p_market_id_filter varchar(04), 
                                                                @p_contract_nbr_filter varchar(30), 
                                                                @p_account_number_filter varchar(30), 
                                                                @p_promotioncode_id_filter varchar(15), 
                                                                @p_customername_filter varchar(30), 
                                                                @p_fulfillment_status_id_filter varchar(15), 
                                                                @p_account_status_id_filter varchar(30), 
                                                                @p_order_by varchar(20), 
                                                                @p_pagesize int, 
                                                                @p_currentpageIndex int)
AS
BEGIN
    -- set nocount on and default isolation level
    SET NOCOUNT ON;

    DECLARE @totalnoofpages int;
    DECLARE @PageNumber int=0;
    --For pagination 
    DECLARE @RowStart int;
    DECLARE @RowEnd int;
    DECLARE @PageSize int;
    SET @PageNumber=@p_currentpageIndex - 1;
    SET @PageSize=@p_pagesize;
    SET @RowStart=@PageSize * @PageNumber + 1;
    SET @RowEnd=@RowStart + @PageSize - 1;



    --DECLARE @p_account_number_filter varchar(30);
    --DECLARE @p_contract_nbr_filter char(12);
    --DECLARE @p_customername_filter varchar(30);
    --DECLARE @p_fulfillment_status_id_filter varchar(15);
    --DECLARE @p_camapaign_id_filter varchar(15);
    --DECLARE @p_promotioncode_id_filter varchar(15);
    --DECLARE @p_market_id_filter varchar(04);
    --Declare @p_account_status_id_filter varchar(30);
    --DECLARE @p_order_by varchar(20); --ContractNumber, Customer,SignedDate,StartDate,DaystoQualify


    IF @p_account_number_filter IN('NONE', '', 'ALL')
        BEGIN
            SET @p_account_number_filter=NULL;
        END;
    IF @p_contract_nbr_filter IN('NONE', '', 'ALL')
        BEGIN
            SET @p_contract_nbr_filter=NULL;
        END;
    IF @p_camapaign_id_filter IN('NONE', '', 'ALL')
        BEGIN
            SET @p_camapaign_id_filter=NULL;
        END;
    IF @p_customername_filter IN('NONE', '', 'ALL')
        BEGIN
            SET @p_customername_filter=NULL;
        END;
    IF @p_market_id_filter IN('NONE', '', 'ALL')
        BEGIN
            SET @p_market_id_filter=NULL;
        END;
    IF @p_promotioncode_id_filter IN('NONE', '', 'ALL')
        BEGIN
            SET @p_promotioncode_id_filter=NULL;
        END;
    IF @p_fulfillment_status_id_filter IN('NONE', '', 'ALL')
        BEGIN
            SET @p_fulfillment_status_id_filter=NULL;
        END;
    IF @p_account_status_id_filter IN('NONE', '', 'ALL')
        BEGIN
            SET @p_account_status_id_filter=NULL;
        END;

    IF @p_order_by IN('NONE', '', 'ALL')
        BEGIN
            SET @p_order_by='ContractNumber';
        END;


    WITH MYResultTable
        AS (
          
        SELECT *, 
              ROW_NUMBER()OVER(ORDER BY(SELECT 0)) as RowNumber from 
                      
        (SELECT DISTINCT  C.ContractID,Cg.Code AS PromoCampaignCode, 
                            P.Code AS PromotionCode, 
                            PT.Code AS GiftType, 
                            S.ChannelName AS SalesChannel, 
                            M.MarketCode,                            
             CAST(C.Number AS nvarchar)AS ContractNumber, 
                            N.Name AS Customer, 
                            CT.LastName + ', ' + Ct.FirstName AS ContactName, 
                            C.SignedDate, 
                            C.StartDate, 
                            CASE
                            WHEN CF.TriggerTypeId = 1 THEN DATEDIFF(DD, GETDATE(), DATEADD(DD, CF.EligibilityPeriod, C.SignedDate))
                                ELSE DATEDIFF(DD, GETDATE(), DATEADD(DD, CF.EligibilityPeriod, C.StartDate))
                            END AS DaystoQualify, 
                            CASE
                            WHEN CF.TriggerTypeId = 1 THEN CONVERT(varchar(10), DATEADD(DD, CF.EligibilityPeriod, C.SignedDate), 101)
                                ELSE CONVERT(varchar(10), DATEADD(DD, CF.EligibilityPeriod, C.StartDate), 101)
                            END AS QualifyDate, 
                            Ps.Code, 
                            Ps.Description
                            --, 
                            --AccSt.Status
                            --, 
                          --  RowNumber=ROW_NUMBER()OVER(ORDER BY(SELECT 1))
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
                   INNER JOIN LibertyPower..Account A WITH (NoLock)
                   ON A.AccountID = AC.AccountID
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
                   INNER JOIN LibertyPower..PromotionStatus Ps WITH (NoLock)
                   ON Ps.PromotionStatusId = CQ.PromotionStatusId
                   INNER JOIN Libertypower..PromotionType PT WITH (NoLock)
                   ON P.PromotionTypeId = PT.PromotionTypeId
                   INNER JOIN LIbertypower..SalesChannel S WITH (NoLock)
                   ON S.ChannelID = C.SalesChannelID
              WHERE(cg.CampaignId = @p_camapaign_id_filter
                 OR @p_camapaign_id_filter IS NULL)
               AND (M.ID = @p_market_id_filter
                 OR @p_market_id_filter IS NULL)
               AND (A.AccountNumber = @p_account_number_filter
                 OR @p_account_number_filter IS NULL)
               AND (CAST(C.Number AS nvarchar) = CAST(@p_contract_nbr_filter AS nvarchar)--@p_contract_nbr_filter
                 OR @p_contract_nbr_filter IS NULL)
               AND (N.Name LIKE '%' + @p_customername_filter + '%'
                 OR @p_customername_filter IS NULL)
               AND (P.PromotionCodeId = @p_promotioncode_id_filter
                 OR @p_promotioncode_id_filter IS NULL)
               AND (AccSt.Status = @p_account_status_id_filter
      OR @p_account_status_id_filter IS NULL)
               AND (CQ.PromotionStatusId = @p_fulfillment_status_id_filter
                 OR @p_fulfillment_status_id_filter IS NULL)  ) AS Result)
                 
                 
                 
        SELECT ContractID,
				PromoCampaignCode, 
               PromotionCode, 
               GiftType, 
               SalesChannel, 
               MarketCode, 
                
               CAST(ContractNumber AS nvarchar)AS ContractNumber, 
               Customer, 
               ContactName, 
               SignedDate, 
               StartDate, 
               Case When DaystoQualify <0  Then 0 Else DaystoQualify END AS DaystoQualify, 
               QualifyDate, 
               Code, 
               Description, 
             --  Status, 
              RowNumber, 
               (SELECT COUNT(1)
                  FROM MYResultTable)AS TotalRecords, 
               (SELECT COUNT(1)
                  FROM MYResultTable) / @PageSize + CASE
                                                    WHEN(SELECT COUNT(1)
                                                           FROM MYResultTable) % @PageSize > 0 THEN 1
                                                        ELSE 0
                                                    END AS TotalPages
          FROM MYResultTable
          --Commented by Pradeep for the PBI 43232 in order to remove the page level sorting.
          --WHERE RowNumber >= CAST(@RowStart AS nvarchar)
          --  AND RowNumber <= CAST(@RowEnd AS nvarchar)
          ORDER BY CASE @p_order_by
                   WHEN 'ContractNumber' THEN ContractNumber
                   END, CASE
                        WHEN @p_order_by = 'Customer' THEN Customer
                        END, CASE
                             WHEN @p_order_by = 'SignedDate' THEN SignedDate
                             END, CASE
                                  WHEN @p_order_by = 'StartDate' THEN StartDate
                                      ELSE DaystoQualify
                                  END;


Set NOCOUNT OFF;
END;

--EXEC usp_GetContractQualifierFulfillmentDetails '', '', '', '', '', '', '', '', '', 15,1;

