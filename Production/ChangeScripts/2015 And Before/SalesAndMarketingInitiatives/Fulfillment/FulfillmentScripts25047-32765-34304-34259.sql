----------------------------------------------------------------------------
--Script to update the PromotionStatus
--Status	Description
--Pending	Contract is waiting for fullfillment criteria
--Inneligible	Contract could not meet fullfillment criteria
--Eligible	Contract is eligible for fullfillment
--Vendor Submitted	Sent to vendor for fullfillment
--Shipped	Vendor acknowledged shipped
--Fullfilled	Vendor confirmed fullfilled status

--1         	Pending
--2         	Fulfilled
--3         	Rejected
--4         	Cancelled
--5         	SendtoVendor
--6         	Completed
--7         	InValid
------------------------------------------------------------------------------------

IF EXISTS(SELECT *
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'PromotionStatus'
              AND COLUMN_NAME = 'Code')
    BEGIN
        ALTER TABLE PromotionStatus ALTER COLUMN Code nchar(20)NOT NULL;
    END;
GO



If exists (Select * from Libertypower..PromotionStatus P with (NoLock) where PromotionStatusId=1)
Begin
UPdate  Libertypower..PromotionStatus  Set Code='Pending', Description='Contract is waiting for fullfillment criteria' where PromotionStatusId=1
END

If exists (Select * from Libertypower..PromotionStatus P with (NoLock) where PromotionStatusId=2 )
Begin
UPdate  Libertypower..PromotionStatus  Set Code='InEligible', Description='Contract could not meet fullfillment criteria' where PromotionStatusId=2 
END

If exists (Select * from Libertypower..PromotionStatus P with (NoLock) where PromotionStatusId=3 )
Begin
UPdate  Libertypower..PromotionStatus  Set CODE='Eligible', Description='Contract is eligible for fullfillment'  where PromotionStatusId=3
END

If exists (Select * from Libertypower..PromotionStatus P with (NoLock) where PromotionStatusId=4)
Begin
UPdate  Libertypower..PromotionStatus  Set Code='VendorSubmitted', Description='Sent to vendor for fullfillment' where PromotionStatusId=4
END

If exists (Select * from Libertypower..PromotionStatus P with (NoLock) where PromotionStatusId=5)
Begin
UPdate  Libertypower..PromotionStatus  Set Code='Shipped' , Description='Vendor acknowledged shipped' where PromotionStatusId=5
END

If exists (Select * from Libertypower..PromotionStatus P with (NoLock) where PromotionStatusId=6)
Begin
UPdate  Libertypower..PromotionStatus  Set Code='Fulfilled', Description='Vendor confirmed fullfilled status' where PromotionStatusId=6
END

If exists (Select * from Libertypower..PromotionStatus P with (NoLock) where PromotionStatusId=7)
Begin
Delete from Libertypower..PromotionStatus  where PromotionStatusId=7
END
GO



-----------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_FulfillmentStatusSelect]    Script Date: 02/12/2014 16:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_FulfillmentStatusSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_FulfillmentStatusSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_FulfillmentStatusSelect]    Script Date: 02/12/2014 16:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	[usp_FulfillmentStatusSelect]
 * PURPOSE:	Selects all fulfillment Statuses
 * HISTORY:	 

  * 2/11/2014 - Sara Lakshmanan

 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_FulfillmentStatusSelect] 
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF
	Select  *
	from  LibertyPower..PromotionStatus C with (NOLock)	
Set NOCOUNT OFF;
END

GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_CampaignCodeSelect]    Script Date: 02/12/2014 16:22:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CampaignCodeSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CampaignCodeSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_CampaignCodeSelect]    Script Date: 02/12/2014 16:22:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************

 * PROCEDURE:	[usp_CampaignCodeSelect]
 * PURPOSE:	Selects all valid CampaignCodes 
 * HISTORY:	 

  * 2/11/2014 - Sara Lakshmanan
 *Added Active Flag
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_CampaignCodeSelect] 
	(@Active bit=null)
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

If (@Active is not null)
Begin

	Select  *
	from  LibertyPower..Campaign C with (NOLock)
	where isnull(C.InActive,0)<>1 
	order by C.Code 
		

END
Else
BEGIN
	Select  *
	from  LibertyPower..Campaign C with (NOLock)
	order by C.Code 
END
Set NOCOUNT OFF;
END
-- Copyright 12/18/2013 Liberty Power


GO


USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AllPromotionCodelist]    Script Date: 02/12/2014 16:23:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AllPromotionCodelist]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AllPromotionCodelist]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AllPromotionCodelist]    Script Date: 02/12/2014 16:23:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************

 * PROCEDURE:	[usp_AllPromotionCodelist]
 * PURPOSE:		Selects all valid Promotion Codes
 * HISTORY:		 
 *******************************************************************************
 * 12/18/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************
  * 2/11/2014 - Sara Lakshmanan
 *Added Active Flag
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_AllPromotionCodelist] 
	(@Active bit=1)
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

If (@Active=1)
Begin
Select  pc.PromotionCodeId,pc.Code,*
	from  LibertyPower..PromotionCode pc with (NOLock)
	where isnull(pc.InActive,0)<>1 
	order by pc.Code 
		

END
Else
BEGIN
Select  pc.PromotionCodeId,pc.Code,*
	from  LibertyPower..PromotionCode pc with (NOLock)
	order by pc.Code 
END
Set NOCOUNT OFF;
END
-- Copyright 12/18/2013 Liberty Power


GO



-------------------------------

USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetContractQualifierFulfillmentDetails]    Script Date: 02/18/2014 15:59:34 ******/

IF EXISTS(SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetContractQualifierFulfillmentDetails]')
              AND type IN(N'P', N'PC'))
    BEGIN
        DROP PROCEDURE dbo.usp_GetContractQualifierFulfillmentDetails
    END;
GO

USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetContractQualifierFulfillmentDetails]    Script Date: 02/19/2014 15:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------
--Added on Feb 5 2014 Sara Lakshmanan
-- Created to get the contract fulfillment details to show in fulfillment Page
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
          WHERE RowNumber >= CAST(@RowStart AS nvarchar)
            AND RowNumber <= CAST(@RowEnd AS nvarchar)
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
GO



---------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateContractQualifierFulfillmentStatus]    Script Date: 02/18/2014 15:56:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UpdateContractQualifierFulfillmentStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_UpdateContractQualifierFulfillmentStatus]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateContractQualifierFulfillmentStatus]    Script Date: 02/18/2014 15:56:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------
--Added on Feb 18 2014 Sara Lakshmanan
-- Created to update the fulfillment status in ContractQualifier Table from the Fulfillment page
----------------------------------------------------------------------


CREATE PROCEDURE [dbo].[usp_UpdateContractQualifierFulfillmentStatus]
(
	@p_ContractIDList varchar(500), @p_StatusId int, @p_Comments varchar(2000)
)
As
BEGIN

SET NOCOUNT ON

Update ContractQualifier Set PromotionStatusId=@p_StatusId, Comment= isNull(Comment,'')+ @p_Comments+cast(GETDATE() as varchar) + ':== '
Where ContractID in (Select * from dbo.split(@p_ContractIDList,','))

Select * from ContractQualifier Where ContractID in (Select * from dbo.split(@p_ContractIDList,','))

SET NOCOUNT OFF;
END


GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAccountContractDetailsForFulfillment]    Script Date: 02/18/2014 15:57:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAccountContractDetailsForFulfillment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAccountContractDetailsForFulfillment]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAccountContractDetailsForFulfillment]    Script Date: 02/18/2014 15:57:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------
--Added on Feb 12 2014 Sara Lakshmanan
-- Created to show the account details in the fulfillment page for a given contractID
----------------------------------------------------------------------


CREATE PROCEDURE [dbo].[usp_GetAccountContractDetailsForFulfillment]
(
	@p_ContractID varchar(15)
)
As
BEGIN

SET NOCOUNT ON


Select A.AccountID, A.AccountNumber, AccSt.Status as AccountStatus, Ct.Phone as ContactPhone,
CT.Email as EmailAddress,Add1.Address1 as BillingStreet, Add1.Address2 as BillingStreet2,Add1.City as BillingCity, Add1.[State] as BillingState from  LIbertypower..AccountContract Ac With (NoLock) Inner Join Libertypower..Account A With (NoLock)
on AC.AccountID=A.AccountID 
                   INNER JOIN AccountStatus AccSt WITH (NoLock)
                   ON Ac.AccountContractID = AccSt.AccountContractID
                   Inner Join Libertypower..Contact Ct WITH (NoLock) on
                   Ct.ContactID=A.BillingContactID
                   Inner Join Libertypower..Address Add1 WITH (NoLock) on
                   Add1.AddressID=A.BillingAddressID                              
Where Ac.ContractID=@p_ContractID

SET NOCOUNT OFF;
END

GO



---------------------------------------------------------------------------

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
                        AccSt.Status As AccountStatus,
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
               INNER JOIN LibertyPower..SalesChannel Sc WITH (NoLock)
               ON Sc.ChannelID=c.SalesChannelID
               INNER JOIN LibertyPower..PromotionType Pt WITH (NoLock)
               ON Pt.PromotionTypeId=P.PromotionTypeId
               INNER JOIN LibertyPower..Address Ad WITH (NoLock)
               ON Ad.AddressID=A.BillingAddressID
               INNER JOIN LibertyPower..PromotionStatus Ps WITH (NoLock)
               ON Ps.PromotionStatusId=CQ.PromotionStatusId
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

GO

------------------------------------------------------------------------------------------

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


-----------------------------------------------------------

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
GO



