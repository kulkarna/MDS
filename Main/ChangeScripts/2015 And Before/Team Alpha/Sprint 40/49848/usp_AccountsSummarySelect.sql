---------------------------------------------------------------------------------------------------
-- Added			: Fernando ML Alves
-- PBI          : 49848
-- Date			: 09/24/2014
-- Description	: Proc to select all accounts summary in the scope of a given zip codes list. 
--				  Summary fields per account are AccountNumbers, AccountStatus, ContractEndDate, 
--				  ProductCode, UtilitID and sales channel.
-- Modification : Previous implementation of the SP was returning "duplicated entries" for the same 
--				  account number. If we had the same account with previous non-contracted rate. 
--                It would also show up in the result set.
-- Format:		: DECLARE @zipCodes StringList;
--				  INSERT @zipCodes (Item) VALUES ('11220');
--				  INSERT @zipCodes (Item) VALUES ('11221');
--				  EXEC usp_AccountsSummarySelect @zipCodes;
---------------------------------------------------------------------------------------------------

USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountsSummarySelect]    Script Date: 09/23/2014 15:33:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_AccountsSummarySelect] (
	 @p_zipCodes StringList READONLY) AS 
BEGIN 
	SET NOCOUNT ON;

	SELECT 
		T1.AccountNumber, T1.AccStatus AS AccountStatus, T2.MaxRateEnd AS ContractEndDate, T1.LegacyProductID AS ProductCode, 
		T1.UtilityID, T1.ChannelName AS SalesChannel, T1.IsDefault, T1.AccountLatestServiceEndDate, T1.is_flexible AS IsFlex
	FROM (
		SELECT 
			A.AccountNumber, A.AccountIdLegacy, A.AccountID, A.AccountNameID, A.UtilityID
			,ISNULL(AC_DefaultRate.IsContractedRate, ACR2.IsContractedRate) AS IsContractedRate
			,ALS.StartDate, Als.EndDate AccountLatestServiceEndDate
			,CASE WHEN AC.AccountContractStatusID=2 THEN 'Approved' ELSE 'Pending' End AS AccStatus
			,AC.AccountContractStatusID 
			,ISNULL(AC_DefaultRate.LegacyProductID, ACR2.LegacyProductID) AS LegacyProductID
			,ISNULL(cp1.IsDefault, cp2.IsDefault) AS IsDefault
			,S.ChannelName
			,ISNULL(cp1.is_flexible, cp2.is_flexible) AS is_flexible
		FROM Libertypower..Address Ad WITH (NOLOCK)
		INNER JOIN Libertypower..Account A (NOLOCK)
		ON A.ServiceAddressID			= Ad.AddressID
		
		INNER JOIN Libertypower..AccountContract AC (NOLOCK)
		ON AC.AccountID							= A.AccountID
		AND ISNULL(A.CurrentRenewalContractID, A.CurrentContractID)=AC.ContractID
		
		INNER JOIN Libertypower..Contract C (NOLOCK)
		ON C.ContractID					= AC.ContractID
		INNER JOIN LibertyPower..SalesChannel S (NOLOCK)
		ON S.ChannelID					= C.SalesChannelID 
		
		JOIN LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK) 
		ON ACR2.AccountContractID		= AC.AccountContractID --AND ACR2.IsContractedRate = 1    

		---- NEW DEFAULT RATE JOIN:    
		LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID     
					FROM LibertyPower.dbo.AccountContractRate ACRR WITH (NOLOCK)    
		WHERE ACRR.IsContractedRate = 0     
		GROUP BY ACRR.AccountContractID    
			) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID    
		LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate WITH (NOLOCK)      
		ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID     
		---- END NEW DEFAULT RATE JOIN:    

		INNER JOIN LibertyPower..AccountStatus Ast (NOLOCK)
		ON AST.AccountContractID		= AC.AccountContractID

		INNER JOIN Libertypower..AccountLatestService ALS (NOLOCK) 
		ON ALS.AccountID				= A.AccountID
		
		LEFT JOIN lp_common..common_product cp1 (NOLOCK) 
		ON cp1.product_id				= AC_DefaultRate.LegacyProductID 
		LEFT JOIN lp_common..common_product cp2 (NOLOCK) 				 
		ON cp2.product_id				= ACR2.LegacyProductID 
		
		WHERE Ad.Zip					IN (SELECT Item FROM @p_zipCodes)
		and AC.AccountContractStatusID NOT IN (3) 
		GROUP BY 
			A.AccountNumber, A.AccountIdLegacy, A.AccountID, A.AccountNameID, A.UtilityID, 
			ISNULL(AC_DefaultRate.IsContractedRate, ACR2.IsContractedRate), 
			ALS.StartDate, Als.EndDate, AC.AccountContractStatusID, ASt.SubStatus, 
			ISNULL(AC_DefaultRate.LegacyProductID, ACR2.LegacyProductID), 
			ISNULL(cp1.IsDefault, cp2.IsDefault), S.ChannelName, ISNULL(cp1.is_flexible, cp2.is_flexible)
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
