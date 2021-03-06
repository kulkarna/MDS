USE [Libertypower]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetAccountStatus]    Script Date: 04/14/2015 10:48:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Diogo Lima
-- Create date: 8/21/2014
-- Description:	Returns the status of account
-- =============================================
-- Modified by:	Agata Studzinska
-- Modified date: 9/4/2014
-- Changed logic for ReEnroll ASQ Type 
-- Added new status - Enrollment Cancellation 
-- TFS 47892
--
-- Modified by:   Bhavana Bakshi
-- Modified date: 04/14/2015
-- TFS 53808:     RCR: Draft status fix
--                including contractStatusID filter for 999999 
-- =============================================
ALTER FUNCTION [dbo].[ufn_GetAccountStatus]
(
	@p_AccountIdLegacy CHAR(12)
)
RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @w_status VARCHAR(15);

	SELECT @w_status	 = 	
		CASE	WHEN (AC.AccountContractStatusID = 1) THEN '01000'
		WHEN (AC.AccountContractStatusID = 2 and asq.Type IN (1,5) and asq.EdiStatus in (3) and ASERVICE.StartDate  <= GETDATE()) THEN '905000'	
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 1 and asq.EdiStatus in (4) and AC.AccountContractStatusReasonID = 3) THEN '999998'		
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 1 and asq.EdiStatus in (1,2,3,4)) THEN '05000'	
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 5 and asq.EdiStatus in (1,2,3))  THEN '13000' --TFS 47892			
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 2 and asq.EdiStatus in (3) and ASERVICE.EndDate <= GETDATE()) THEN '911000'			
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 2 and asq.EdiStatus in (1,2,3) and ASERVICE.StartDate is Not NULL ) THEN '11000'	--TFS 53808		
		WHEN (AC.AccountContractStatusID = 2 and asq.Type = 2 and asq.EdiStatus in (1,2)) THEN '12000' --TFS 47892										
		WHEN (AC.AccountContractStatusID = 3 and c.ContractStatusID = 2) THEN '999999' --TFS 53808	
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

