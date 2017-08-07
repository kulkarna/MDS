USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAccountsByContractNumber]    Script Date: 10/01/2013 14:24:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	6/11/2013																		*
 *	Descp:		Get the list of the accounts for the contract number passed						*
 *	Modified:																					*
	EXEC	usp_GetAccountsByContractNumber '2009-0311927'										*
 ********************************************************************************************** */
 
ALTER PROCEDURE [dbo].[usp_GetAccountsByContractNumber]
@ContractNumber varchar(50)

AS

BEGIN
	SET NOCOUNT ON;

	-- Save the data needed into a temp table so the query runs faster
	--Get the Contract info
	SELECT	ContractID, Number as ContractNumber, SignedDate, StartDate
	INTO	#Contract
	FROM	LibertyPower..Contract (NOLOCK)
	WHERE	Number = @ContractNumber
	
	--Get the Account Contract info
	SELECT	AC.AccountContractID, AC.ContractID, C.ContractNumber, C.SignedDate, StartDate, AC.AccountID
	INTO	#AC
	FROM	LibertyPower..AccountContract AC WITH (NOLOCK) 	
	JOIN	#Contract C WITH (NOLOCK) 
	ON		AC.ContractID = C.ContractID

	-- Get the Account Info
	SELECT	AC.ContractID, AC.ContractNumber, AC.SignedDate, AC.StartDate, 
			A.AccountID, A.AccountNumber, A.Zone, A.LoadProfile, A.ServiceRateClass, A.StratumVariable, A.UtilityID, A.BillingGroup, A.DeliveryLocationRefID, A.LoadProfileRefID, A.ServiceClassRefID,
			AC.AccountContractID, AccountNameID
	INTO	#Account
	FROM	LibertyPower..Account A WITH (NOLOCK)
	
	JOIN	#AC AC WITH (NOLOCK) 
	ON		A.AccountID = AC.AccountID 
	AND		(A.CurrentContractID = AC.ContractID OR A.CurrentRenewalContractID = AC.ContractID )
	
	ORDER	BY AC.ContractID, A.AccountID

	--Select all the data together
	SELECT	DISTINCT
			A.ContractID, 
			A.ContractNumber, 
			A.SignedDate,
			A.AccountID,
			A.AccountNumber,
			U.UtilityCode, 
			A.BillingGroup,
			LTRIM(RTRIM(A.Zone)) AS Zone,
			LTRIM(RTRIM(A.LoadProfile)) AS LoadProfile, 
			AName.Name As BusinessName,
			A.ServiceRateClass AS RateClass, 
			A.StratumVariable,
			A.DeliveryLocationRefID, 
			A.LoadProfileRefID, 
			A.ServiceClassRefID,
			ACR.LegacyProductID AS ProductId,
			dbo.ufn_GetLegacyFlowStartDate(ACS.[Status], ACS.[SubStatus], ASERVICE.StartDate ) FlowStartDate,
			ACR.RateStart AS ContractStartDate,
			ACR.Term AS Term,
			ACR.RateEnd AS ContractEndDate,
			ACR.RateCode,
			ACR.RateId

	FROM	#Account A (NOLOCK)
	JOIN	Utility U (NOLOCK) ON A.UtilityID = U.ID	JOIN	LibertyPower.dbo.AccountStatus ACS (NOLOCK) ON A.AccountContractID = ACS.AccountContractID
	JOIN	vw_AccountContractRate ACR (NOLOCK) ON A.AccountContractID = ACR.AccountContractID --AND ACR2.IsContractedRate = 1
	LEFT	JOIN AccountLatestService ASERVICE (NOLOCK) ON A.AccountID = ASERVICE.AccountID
	LEFT	JOIN LibertyPower.dbo.Name AName (NOLOCK)	ON A.AccountNameID = AName.NameID

	SET NOCOUNT OFF;
END
