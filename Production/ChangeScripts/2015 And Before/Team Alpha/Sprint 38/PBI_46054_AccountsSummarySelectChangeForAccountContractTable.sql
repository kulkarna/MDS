USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountsSummarySelect]    Script Date: 08/15/2014 13:08:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountsSummarySelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountsSummarySelect]
GO

IF  EXISTS (SELECT * FROM sys.objects where type in (N'TT') and name like 'TT_StringList_%') 
DROP TYPE [dbo].[StringList]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountsSummarySelect]    Script Date: 08/15/2014 13:08:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------
-- Added		: Fernando ML Alves
-- Date			: 08/15/2014
-- Description	: Proc to select all accounts summary in the scope of a given zip codes list.
--                Summary fields per account are AccountNumbers, AccountStatus, ContractEndDate, 
--				  ProductCode, UtilitID and sales channel.
-- Format:		: DECLARE @zipCodes StringList;
--				  INSERT @zipCodes (Item) VALUES ('11220');
--				  INSERT @zipCodes (Item) VALUES ('11221');
--				  EXEC usp_AccountsSummarySelect @zipCodes;
---------------------------------------------------------------------------------------------------

CREATE TYPE [dbo].[StringList] AS TABLE(
    [Item] [NVARCHAR](10) NULL
);

CREATE PROCEDURE [dbo].[usp_AccountsSummarySelect] (
	 @p_zipCodes StringList READONLY) AS 
BEGIN 
	SET NOCOUNT ON;

	SELECT 
		T1.AccountNumber, T1.AccStatus AS AccountStatus, T2.MaxRateEnd AS ContractEndDate, T1.LegacyProductID AS ProductCode, 
		T1.UtilityID, T1.ChannelName AS SalesChannel, T1.IsDefault 
	FROM (
		SELECT 
			A.AccountNumber, A.AccountIdLegacy, A.AccountID, A.AccountNameID, A.UtilityID, 
			IsContractedRate, ALS.StartDate, Als.EndDate AccountLatestServiceEndDate, 
			CASE WHEN AC.AccountContractStatusID=2 THEN 'Approved' ELSE 'Pending' End AS AccStatus, 
			AC.AccountContractStatusID, ACR.LegacyProductID, cp.IsDefault, S.ChannelName 
		FROM 
			Libertypower..Account A (NOLOCK), 
			Libertypower..Address Ad (NOLOCK), 
			Libertypower..AccountContract AC (NOLOCK), 
			Libertypower..Contract C (NOLOCK), 
			Libertypower..AccountContractRate ACR (NOLOCK), 
			Libertypower..AccountLatestService ALS (NOLOCK), 
			LibertyPower..AccountStatus Ast (NOLOCK), 
			LibertyPower..SalesChannel S (NOLOCK),
			lp_common..common_product cp (NOLOCK) 
		WHERE 
			A.ServiceAddressID=Ad.AddressID AND AC.AccountID=A.AccountID AND AC.ContractID=C.ContractID 
		AND 
			ISNULL(A.CurrentRenewalContractID, A.CurrentContractID)=AC.ContractID AND ACR.AccountContractID=AC.AccountContractID 
		AND 
			ALS.AccountID=A.AccountID AND ASt.AccountContractID=AC.AccountContractID AND cp.product_id=ACR.LegacyProductID 
		AND 
			S.ChannelID=C.SalesChannelID AND Ad.Zip IN (SELECT Item FROM @p_zipCodes) AND AC.AccountContractStatusID NOT IN (3) 
		GROUP BY 
			A.AccountNumber, A.AccountIdLegacy, A.AccountID, A.AccountNameID, A.UtilityID, IsContractedRate, ALS.StartDate, 
			Als.EndDate, AC.AccountContractStatusID, ASt.SubStatus, ACR.LegacyProductID, cp.IsDefault, S.ChannelName 
	) T1 FULL OUTER JOIN (
		SELECT 
			A.AccountNumber, MIn(acr.RateStart) MinRateStart, Max(ACR.RateEnd) MaxRateEnd
		FROM  
			Libertypower..Account A (NOLOCK), 
			Libertypower..Address Ad (NOLOCK), 
			Libertypower..AccountContract AC (NOLOCK), 
			Libertypower..Contract C (NOLOCK), 
			Libertypower..AccountContractRate ACR (NOLOCK), 
			Libertypower..AccountLatestService ALS (NOLOCK), 
			Libertypower..AccountStatus Ast (NOLOCK), 
			lp_common..common_product cp (NOLOCK)
		WHERE  
			A.ServiceAddressID=Ad.AddressID AND AC.AccountID=A.AccountID AND AC.ContractID=C.ContractID 
		AND 
			ISNULL(A.CurrentRenewalContractID, A.CurrentContractID)=AC.ContractID AND ACR.AccountContractID=AC.AccountContractID 
		AND 
			ALS.AccountID=A.AccountID AND ASt.AccountContractID=AC.AccountContractID AND cp.product_id=ACR.LegacyProductID 
		AND 
			Ad.Zip IN (SELECT Item FROM @p_zipCodes) AND ACR.IsContractedRate=1 AND AC.AccountContractStatusID NOT IN (3) 
		GROUP BY 
			A.AccountNumber
	) T2 ON T1.AccountNumber=T2.AccountNumber;

	SET NOCOUNT OFF;	
END;
