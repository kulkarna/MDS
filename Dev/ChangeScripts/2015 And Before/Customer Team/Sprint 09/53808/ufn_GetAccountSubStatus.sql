USE [Libertypower]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetAccountSubStatus]    Script Date: 04/14/2015 10:48:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Diogo Lima
-- Create date: 8/21/2014
-- Description:	Returns the substatus of account
-- =============================================
-- Modified by:	Agata Studzinska
-- Modified date: 9/4/2014
-- Changed logic for ReEnroll ASQ Type 
-- Added new status - Enrollment Cancellation 
-- TFS 47892
--
-- Modified by:    Bhavana Bakshi
-- Modified date:  04/14/2015
-- TFS 53808:      RCR: Draft status
-- =============================================
ALTER FUNCTION [dbo].[ufn_GetAccountSubStatus]
(
	@p_AccountIdLegacy CHAR(12)
)
RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @w_status VARCHAR(15);

	SELECT @w_status	 = 	
		CASE	WHEN (AC.AccountContractStatusID = 1) THEN '10'
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 1 and asq.EdiStatus = 4 and AC.AccountContractStatusReasonID = 3) THEN '10' --999998 10
		WHEN (AC.AccountContractStatusID = 2 and asq.Type IN (1,5) and asq.EdiStatus = 3 and ASERVICE.StartDate  < GETDATE()) THEN '10' --905000 10
		
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 1 and asq.EdiStatus = 1) THEN '10'
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 1 and asq.EdiStatus = 2) THEN '20'
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 1 and asq.EdiStatus = 3) THEN '30'
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 1 and asq.EdiStatus = 4) THEN '25'
									
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 5 and asq.EdiStatus = 1 ) THEN '60' --13000 60 TFS 47892
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 5 and asq.EdiStatus = 2 ) THEN '70' --13000 70 TFS 47892
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 5 and asq.EdiStatus = 3) THEN '80' --13000 80  TFS 47892
		
    	WHEN (AC.AccountContractStatusID = 2 and asq.Type = 2 and asq.EdiStatus = 1 and ASERVICE.StartDate IS NOT NULL ) THEN '30' --11000 30 --TFS 53808		
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 2 and asq.EdiStatus = 2 and ASERVICE.StartDate IS NOT NULL ) THEN '40' --11000 40--TFS 53808		
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 2 and asq.EdiStatus = 3 and ASERVICE.EndDate <= GETDATE()) THEN '10'
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 2 and asq.EdiStatus = 3 and ASERVICE.StartDate IS NOT NULL  ) THEN '50' --11000 50	--TFS 53808						
		
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 2 and asq.EdiStatus in (1)) THEN '10' --12000 10 --TFS 47892
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 2 and asq.EdiStatus in (2)) THEN '20' --12000 20 --TFS 47892
		
		WHEN (AC.AccountContractStatusID = 3) THEN '10'
  END
  FROM LibertyPower.dbo.Account A WITH (NOLOCK)  
	JOIN LibertyPower.dbo.AccountContract AC WITH (NOLOCK)  ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID     
	JOIN LibertyPower.dbo.[Contract] C WITH (NOLOCK)    ON A.CurrentContractID = C.ContractID  
	JOIN LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID
	LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID  
	left join libertypower..AccountSubmissionQueue asq with(nolock) on asq.AccountContractRateID = acr2.AccountContractRateID and asq.Category = 1      
	WHERE A.AccountIdLegacy = @p_AccountIdLegacy
		
	RETURN @w_status;
END

