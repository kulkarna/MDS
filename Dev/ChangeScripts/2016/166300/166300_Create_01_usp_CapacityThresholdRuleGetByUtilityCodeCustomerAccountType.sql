USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType]    Script Date: 03/06/2017 14:25:02 ******/
DROP PROCEDURE [dbo].[usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType]
GO
/****** Object:  StoredProcedure [dbo].[usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType]    Script Date: 03/06/2017 14:25:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
-- ====================================================================================================================================================================================  
-- Stored Procedure: [usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType]  
-- Created: Anjibabu Maddineni 02/17/2017          
-- Description: Selects the records from the Utility   
-- EXEC [usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType] @UtilityCode = 'ACE' , @AccountType = 'LCI'
-- ====================================================================================================================================================================================  
*/

CREATE PROCEDURE [dbo].[usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType]
(
	@UtilityCode VARCHAR(50),
	@AccountType VARCHAR(50)
)
AS
BEGIN
	
	SET NOCOUNT ON
	
	SELECT 
		U.lpc_utility_id As UtilityID,
		CT.lpc_account_typeName As AccountType,
		CT.lpc_threshold_min AS CapacityThreshold,
		CT.lpc_threshold_max AS CapacityThresholdMax,
		CASE WHEN CT.lpc_use_capacity_threshold = 1 THEN 'True' ELSE 'False' END UseCapacityThreshold
	FROM 
		LIBERTYCRM_MSCRM.DBO.lpc_utility U WITH (NOLOCK) 
		INNER JOIN LIBERTYCRM_MSCRM.DBo.lpc_capacity_threshold CT WITH (NOLOCK) ON CT.lpc_utility = U.lpc_utilityId
		INNER JOIN LIBERTYCRM_MSCRM.DBo. lpc_support_data_account_type SDAT WITH (NOLOCK) ON SDAT.lpc_support_data_account_typeId = CT.lpc_account_type
	WHERE
		U.lpc_UtilityCode = @UtilityCode
		AND UPPER(SDAT.lpc_LibertyAccountTypeCode) = UPPER(@AccountType)
		AND U.statecode = 0
		AND CT.statecode = 0
		AND SDAT.statecode = 0
		
	SET NOCOUNT OFF
END
GO
