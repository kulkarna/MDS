USE [WORKSPACE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetPendingAccounts]    Script Date: 5/9/2017 10:49:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************************************
-- Author:		Jose Munoz
-- Create date: 02/23/2015
-- Description:	Get the information to analysis of the PR's open. 
-- =============================================

EXEC Workspace..usp_GetPendingAccounts

*****************************************************************************************/

ALTER PROCEDURE [dbo].[usp_GetPendingAccounts]
	(@p_ProcessDate			DATETIME = NULL)
AS
BEGIN
	SET NOCOUNT ON;

	IF @p_ProcessDate IS NULL 
		SET @p_ProcessDate = CONVERT(DATE,GETDATE())
	ELSE
		SET @p_ProcessDate = CONVERT(DATE, @p_ProcessDate)

	DECLARE @DataRequestTable AS TABLE
	(
		   ServiceAccountId UNIQUEIDENTIFIER,
		   DataRequestDate DATETIME,
		   Segment	BIT
	)

	DECLARE @DataRequestTableMaxDataRequestDate AS TABLE
	(
		   ServiceAccountId UNIQUEIDENTIFIER,
		   Segment	BIT,
		   DataRequestDate DATETIME
	)

	DECLARE @TableA AS TABLE
	(
		   ServiceAccountId UNIQUEIDENTIFIER,
		   DataRequestDate DATETIME,
		   CustomerName NVARCHAR(100),
		   AccountNumber NVARCHAR(100),
		   lpc_utilityid UNIQUEIDENTIFIER,
		   Segment Bit
	)

	DECLARE @TableB AS TABLE
	(
		   ServiceAccountId UNIQUEIDENTIFIER,
		   DataRequestDate DATETIME,
		   CustomerName NVARCHAR(100),
		   AccountNumber NVARCHAR(100),
		   Utilityid UNIQUEIDENTIFIER,
		   UtilityCompany NVARCHAR(100),
		   Segment Bit
	)

	DECLARE @TableC AS TABLE
	(
		   ServiceAccountId UNIQUEIDENTIFIER,
		   DataRequestDate DATETIME,
		   CustomerName NVARCHAR(100),
		   AccountNumber NVARCHAR(100),
		   Utilityid UNIQUEIDENTIFIER,
		   UtilityCompany NVARCHAR(100),
		   lpc_pricerequestproductid UNIQUEIDENTIFIER,
		   Segment Bit
	)

	DECLARE @TableD AS TABLE
	(
		   ServiceAccountId UNIQUEIDENTIFIER,
		   DataRequestDate DATETIME,
		   CustomerName NVARCHAR(100),
		   AccountNumber NVARCHAR(100),
		   UtilityCompany NVARCHAR(100),
		   lpc_productsid UNIQUEIDENTIFIER,
		   Segment Bit
	)

	DECLARE @TableE AS TABLE
	(
		   ServiceAccountId UNIQUEIDENTIFIER,
		   DataRequestDate DATETIME,
		   CustomerName NVARCHAR(100),
		   AccountNumber NVARCHAR(100),
		   UtilityCompany NVARCHAR(100),
		   lpc_productsid UNIQUEIDENTIFIER,
		   lpc_opportunityid UNIQUEIDENTIFIER,
		   RequestID NVARCHAR(100),
		   PriceDueDate DATETIME,
		   Segment Bit
	)

	DECLARE @TableF TABLE
	(
		   ServiceAccountId UNIQUEIDENTIFIER,
		   DataRequestDate DATETIME,
		   CustomerName NVARCHAR(100),
		   AccountNumber NVARCHAR(100),
		   UtilityCompany NVARCHAR(100),
		   RequestID NVARCHAR(100),
		   PriceDueDate DATETIME,
		   lpc_productsid UNIQUEIDENTIFIER,
		   lpc_opportunityid UNIQUEIDENTIFIER,
		   lpc_saleschannel UNIQUEIDENTIFIER,
		   Segment Bit
	)

	DECLARE @TableG TABLE
	(
		   SalesChannel NVARCHAR(100),
		   SalesChannelManager NVARCHAR(100),
		   RequestID NVARCHAR(100),
		   PriceDueDate DATETIME,
		   CustomerName NVARCHAR(100),
		   UtilityCompany NVARCHAR(100),
		   AccountNumber NVARCHAR(100),
		   DataRequestDate DATETIME,
		   Status NVARCHAR(100),
		   ServiceAccountId UNIQUEIDENTIFIER,
		   lpc_productsid UNIQUEIDENTIFIER,
		   lpc_opportunityid UNIQUEIDENTIFIER,
		   lpc_saleschannel UNIQUEIDENTIFIER,
		   Segment Bit
	)

	DECLARE @Utility TABLE (UtilityId UNIQUEIDENTIFIER, UtilityCode NVARCHAR(100))

	INSERT INTO @DataRequestTable (ServiceAccountId, DataRequestDate, Segment)
	SELECT DISTINCT
		   fldr.lpc_serviceaccountid,
		   fldr.createdon,
		   CASE WHEN CONVERT(DATE,fldr.createdon) <= DATEADD(DD,-4,@p_ProcessDate) THEN 0 ELSE 1 END
	FROM 
		   LIBERTYCRM_MSCRM.dbo.Filteredlpc_datarequest (NOLOCK)fldr
	WHERE  CONVERT(DATE, fldr.createdon)	>= DATEADD(DD,-7,@p_ProcessDate)
	AND CONVERT(DATE,fldr.createdon)		<= @p_ProcessDate
	AND fldr.lpc_requeststatusname			= 'pending'
	AND fldr.lpc_request_mode				= 'edi'
	AND fldr.lpc_request_typename			= 'hu'

	INSERT INTO @DataRequestTableMaxDataRequestDate (ServiceAccountId, Segment, DataRequestDate)
	SELECT 
		   ServiceAccountId,
		   Segment,
		   MAX(DataRequestDate) DataRequestDate 
	FROM 
		   @DataRequestTable DRT
	GROUP BY 
		   ServiceAccountId, Segment

	INSERT INTO @TableA (ServiceAccountId, DataRequestDate, CustomerName, AccountNumber, lpc_utilityid, Segment)
	SELECT
		   fldr.ServiceAccountId,
		   fldr.DataRequestDate,
		   flsa.lpc_customername CustomerName,
		   flsa.lpc_accountnumber AccountNumber,
		   flsa.lpc_utilityid,
		   fldr.Segment
	FROM
		   @DataRequestTableMaxDataRequestDate fldr
		   INNER JOIN LIBERTYCRM_MSCRM.dbo.filteredlpc_serviceaccount (NOLOCK) flsa
						 ON fldr.ServiceAccountId = flsa.lpc_serviceaccountid

	INSERT INTO @Utility (UtilityId) SELECT DISTINCT lpc_utilityid from @TableA

	UPDATE U SET UtilityCode = flu.lpc_utilitycode 
	FROM 
		   @Utility U 
		   INNER JOIN LIBERTYCRM_MSCRM.dbo.filteredlpc_utility (NOLOCK) flu
				  ON U.utilityid = flu.lpc_utilityid

	INSERT INTO @TableB 
	(
		   ServiceAccountId, 
		   DataRequestDate, 
		   CustomerName, 
		   AccountNumber, 
		   UtilityId, 
		   UtilityCompany,
		   Segment
		   
	)
	SELECT 
		   A.ServiceAccountId,  A.DataRequestDate, A.CustomerName, A.AccountNumber, U.UtilityId, U.UtilityCode, A.Segment
	FROM
		   @TableA A INNER JOIN @Utility U ON A.lpc_utilityid = U.UtilityId

	INSERT INTO @TableC 
	(
		   ServiceAccountId,
		   DataRequestDate,
		   CustomerName,
		   AccountNumber,
		   Utilityid,
		   UtilityCompany,
		   lpc_pricerequestproductid,
		   Segment
	)
	SELECT 
		   B.ServiceAccountId,
		   B.DataRequestDate,
		   B.CustomerName,
		   B.AccountNumber,
		   B.Utilityid,
		   B.UtilityCompany,
		   flprpsa.lpc_serviceaccountsid,
		   B.Segment
	FROM
		   @TableB B
		   INNER JOIN LIBERTYCRM_MSCRM.dbo.Filteredlpc_pricerequestproductsa (NOLOCK) flprpsa
						 ON B.ServiceAccountId = flprpsa.lpc_sa

	INSERT INTO @TableD 
	(
		   ServiceAccountId,
		   DataRequestDate,
		   CustomerName,
		   AccountNumber,
		   UtilityCompany,
		   lpc_productsid,
		   Segment
	)
	SELECT DISTINCT
		   C.ServiceAccountId,
		   C.DataRequestDate,
		   C.CustomerName,
		   C.AccountNumber,
		   C.UtilityCompany,
		   flprp.lpc_productsid,
		   C.Segment	
	FROM
		   @TableC C
		   INNER JOIN LIBERTYCRM_MSCRM.dbo.filteredlpc_pricerequestproduct (NOLOCK) flprp
				  ON flprp.lpc_pricerequestproductid = C.lpc_pricerequestproductid


	INSERT INTO @TableE 
		   (RequestID,PriceDueDate,CustomerName,UtilityCompany,ServiceAccountId,AccountNumber,DataRequestDate,lpc_productsid,lpc_opportunityid, Segment)
	SELECT DISTINCT
		   flpr.lpc_pricerequestnumber RequestID,
		   flpr.lpc_pricingduedate PriceDueDate,
		   C.CustomerName,
		   C.UtilityCompany,
		   C.ServiceAccountId,
		   C.AccountNumber,
		   C.DataRequestDate,
		   C.lpc_productsid,
		   flpr.lpc_opportunityid,
		   C.Segment
	FROM
		   @TableD C
		   LEFT OUTER JOIN LIBERTYCRM_MSCRM.dbo.filteredlpc_pricerequest (NOLOCK) flpr
						 ON flpr.lpc_pricerequestid = C.lpc_productsid
	WHERE 
		   flpr.lpc_pricingduedate > C.DataRequestDate


	INSERT INTO @TableF 
	(
		   ServiceAccountId,
		   DataRequestDate,
		   CustomerName,
		   AccountNumber,
		   UtilityCompany,
		   RequestID,
		   PriceDueDate,
		   lpc_productsid,
		   lpc_opportunityid,
		   lpc_saleschannel,
		   Segment
	)
	SELECT DISTINCT
		   ServiceAccountId,
		   DataRequestDate,
		   CustomerName,
		   AccountNumber,
		   UtilityCompany,
		   RequestID,
		   PriceDueDate,
		   lpc_productsid,
		   lpc_opportunityid,
		   fo.lpc_saleschannel,
		   E.Segment
	FROM
		   @TableE E
		   LEFT OUTER JOIN LIBERTYCRM_MSCRM.dbo.FilteredOpportunity (NOLOCK) fo
						 ON E.lpc_opportunityid = fo.opportunityid

	INSERT INTO @TableG 
	(
		   ServiceAccountId,DataRequestDate,CustomerName,AccountNumber,UtilityCompany,
		   RequestID,PriceDueDate,lpc_productsid,lpc_opportunityid,lpc_saleschannel,
		   SalesChannel,SalesChannelManager,Status, Segment
	)
	SELECT ServiceAccountId,DataRequestDate,CustomerName,AccountNumber,UtilityCompany,
		   RequestID,PriceDueDate,lpc_productsid,lpc_opportunityid,lpc_saleschannel,
		   fls.lpc_name,
		   fls.owneridname,'Pending', F.Segment
	FROM
		   @TableF F
		   LEFT OUTER JOIN LIBERTYCRM_MSCRM.dbo.filteredlpc_saleschannel (NOLOCK) fls
		   ON F.lpc_saleschannel = fls.lpc_saleschannelid

	SELECT
		   CONVERT(VARCHAR(100), SalesChannel) AS SalesChannel
		   ,CONVERT(VARCHAR(300), SalesChannelManager) AS SalesChannelManager
		   ,CONVERT(VARCHAR(100), RequestID) AS RequestID
		   ,PriceDueDate
		   ,CONVERT(VARCHAR(100), CustomerName) AS CustomerName
		   ,CONVERT(VARCHAR(15), UtilityCompany) AS Utility
		   ,CONVERT(VARCHAR(30), AccountNumber) AS AccountNumber
		   ,DataRequestDate
		   ,CONVERT(VARCHAR(30), [Status]) AS [Status]
		   --,G.Segment
	FROM
		   @TableG G
	WHERE G.Segment		= 0
	UNION 
	SELECT
		   CONVERT(VARCHAR(100), SalesChannel) AS SalesChannel
		   ,CONVERT(VARCHAR(300), SalesChannelManager) AS SalesChannelManager
		   ,CONVERT(VARCHAR(100), RequestID) AS RequestID
		   ,PriceDueDate
		   ,CONVERT(VARCHAR(100), CustomerName) AS CustomerName
		   ,CONVERT(VARCHAR(15), UtilityCompany) AS Utility
		   ,CONVERT(VARCHAR(30), AccountNumber) AS AccountNumber
		   ,DataRequestDate
		   ,CONVERT(VARCHAR(30), [Status]) AS [Status]
		   --,G1.Segment
	FROM
		   @TableG G1
	WHERE G1.Segment	= 1
	AND EXISTS (SELECT NULL FROM @TableG G2
					WHERE G2.RequestID			= G1.RequestID
					AND G2.Segment				= 0)
	AND NOT EXISTS(SELECT NULL FROM @TableG G2
					WHERE G2.RequestID			= G1.RequestID
					AND G2.UtilityCompany		= G1.UtilityCompany
					AND G2.AccountNumber		= G1.AccountNumber
					AND G2.Segment				= 0)
	ORDER BY 4, 3, 6, 7
	SET NOCOUNT OFF;
END
