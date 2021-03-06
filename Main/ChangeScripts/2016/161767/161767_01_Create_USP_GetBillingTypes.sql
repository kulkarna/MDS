USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[USP_GetBillingTypes]    Script Date: 02/20/2017 12:36:48 ******/

if OBJECT_ID('USP_GetBillingTypes') is not null
begin
DROP PROCEDURE [dbo].[USP_GetBillingTypes]
End
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
-- ====================================================================================================================================================================================  
-- Stored Procedure: [USP_GetBillingTypes]  
-- Created: Anjibabu Maddineni 02/07/2017          
-- Description: Selects the records from the Utility   
-- EXEC [USP_GetBillingTypes] @utilityId = 9 , @RateClass = ''  , @LoadProfile = '12V1', @TariffCode= ''
-- EXEC [USP_GetBillingTypes] @utilityId = 9 , @RateClass = ''  , @LoadProfile = '05V1', @TariffCode= ''
-- EXEC [USP_GetBillingTypes] @utilityId = 9 , @RateClass = 'AGSPRIMARYONE'  , @LoadProfile = '', @TariffCode= ''
-- EXEC [USP_GetBillingTypes] @utilityId = 9 , @RateClass = ''  , @LoadProfile = '', @TariffCode= ''
-- ====================================================================================================================================================================================  
*/

CREATE PROCEDURE [dbo].[USP_GetBillingTypes]
(
	@utilityId INT,  
	@RateClass AS NVARCHAR(255)= NULL,  
	@LoadProfile AS NVARCHAR(255)= NULL,  
	@TariffCode AS NVARCHAR(255)= NULL 
)
AS
BEGIN

	CREATE TABLE #TEMPUtilityBillingTypes
	(
		UtilityId INT,
		UtilityOfferedBillingType NVARCHAR(255),
		UtilityAccountType NVARCHAR(255)
    )

	IF ((@RateClass IS NOT NULL AND @RateClass <> '')  OR 
		 (@LoadProfile IS NOT NULL AND @LoadProfile<> '') OR 
		 (@TariffCode IS NOT NULL AND @TariffCode<> '')
		 )  
	BEGIN
	
		TRUNCATE TAbLE #TEMPUtilityBillingTypes
		INSERT INTO #TEMPUtilityBillingTypes (UtilityId, UtilityOfferedBillingType, UtilityAccountType)
		SELECT  
		   UC.lpc_utility_id AS UtilityId,  
		   CASE 
				WHEN BTP.lpc_UtilityOfferedBillingType = '924030000' THEN 'Bill Ready'
				WHEN BTP.lpc_UtilityOfferedBillingType = '924030001' THEN 'Dual'
				WHEN BTP.lpc_UtilityOfferedBillingType = '924030002' THEN 'Rate Ready'
				WHEN BTP.lpc_UtilityOfferedBillingType = '924030003' THEN 'Supplier Consolidated' END UtilityOfferedBillingType,
		   CASE WHEN BT.lpc_Utility_Account_Type = '924030000' THEN 'Residential'
				WHEN BT.lpc_Utility_Account_Type = '924030001' THEN 'Commercial'
				WHEN BT.lpc_Utility_Account_Type = '924030002' THEN 'Undetermined' END UtilityAccountType
		FROM  
		   LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK)  
		   INNER JOIN LibertyCrm_MSCRM.dbo.lpc_billingtype BT WITH (NOLOCK) ON UC.lpc_utilityId= BT.lpc_UtilityId  
		   INNER JOIN LibertyCrm_MSCRM.dbo.lpc_billingtypesprovided BTP WITH (NOLOCK) ON BT.lpc_billingtypeId =BTP.lpc_BillingTypeId 
		   LEFT JOIN LibertyCrm_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK)  ON BT.lpc_RateClassId = RC.lpc_rate_classId 
							AND RC.lpc_utility = UC.lpc_utilityId
							AND BT.lpc_Utility_Account_Type = RC.lpc_Utility_Account_Type
		   LEFT JOIN LibertyCrm_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK)  ON BT.lpc_LoadProfileId = LP.lpc_load_profileId
							AND LP.lpc_utility = UC.lpc_utilityId
							AND BT.lpc_Utility_Account_Type = LP.lpc_Utility_Account_Type					
		   LEFT JOIN LibertyCrm_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK)  ON BT.lpc_TariffCodeId = TC.lpc_tariff_codeId
							AND TC.lpc_utility = UC.lpc_utilityId
							AND BT.lpc_Utility_Account_Type = TC.lpc_Utility_Account_Type					
		WHERE  
			UC.lpc_utility_id = @utilityId 
			AND 
				(
					 (
						RC.lpc_rate_class_code_value = @RateClass AND @RateClass IS NOT NULL AND @RateClass <> '' 
					 )
				 OR 
					(
						LP.lpc_load_profile_code_value = @LoadProfile AND @LoadProfile IS NOT NULL AND @LoadProfile<> ''
					)
				 OR 
					(
						TC.lpc_tariff_code_value = @TariffCode AND @TariffCode IS NOT NULL AND @TariffCode<> ''
					)
				)
		
		
		DECLARE @COUNT INT = 0
		SELECT @COUNT = COUNT(0) FROM #TEMPUtilityBillingTypes
		IF(@COUNT = 0)
		BEGIN	
		
			TRUNCATE TAbLE #TEMPUtilityBillingTypes
			INSERT INTO #TEMPUtilityBillingTypes (UtilityId, UtilityOfferedBillingType, UtilityAccountType)
			SELECT DISTINCT 
			   UC.lpc_utility_id AS UtilityId,  
			   CASE 
					WHEN BTD.lpc_Utility_Offered_BillingType = '924030000' THEN 'Bill Ready'
					WHEN BTD.lpc_Utility_Offered_BillingType = '924030001' THEN 'Dual'
					WHEN BTD.lpc_Utility_Offered_BillingType = '924030002' THEN 'Rate Ready'
					WHEN BTD.lpc_Utility_Offered_BillingType = '924030003' THEN 'Supplier Consolidated' END UtilityOfferedBillingType,
			   
			   CASE 
					WHEN BTD.lpc_Utility_Account_Type = '924030000' THEN 'Residential'
					WHEN BTD.lpc_Utility_Account_Type = '924030001' THEN 'Commercial'
					WHEN BTD.lpc_Utility_Account_Type = '924030002' THEN 'Undetermined' END UtilityAccountType
			FROM  
			   LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK)  
			   INNER JOIN LibertyCrm_MSCRM.dbo.lpc_billingtypedefault BTD WITH (NOLOCK) ON UC.lpc_utilityId= BTD.lpc_UtilityId  
			   LEFT JOIN LibertyCrm_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK)  ON 
								RC.lpc_utility = UC.lpc_utilityId
								AND BTD.lpc_Utility_Account_Type = RC.lpc_Utility_Account_Type
			   LEFT JOIN LibertyCrm_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK)  ON 
								LP.lpc_utility = UC.lpc_utilityId
								AND BTD.lpc_Utility_Account_Type = LP.lpc_Utility_Account_Type					
			   LEFT JOIN LibertyCrm_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK)  ON 
								TC.lpc_utility = UC.lpc_utilityId
								AND BTD.lpc_Utility_Account_Type = TC.lpc_Utility_Account_Type
			WHERE  
				UC.lpc_utility_id = @utilityId 
				AND 
						(
							 (
								RC.lpc_rate_class_code_value = @RateClass AND @RateClass IS NOT NULL AND @RateClass <> '' 
							 )
						 OR 
							(
								LP.lpc_load_profile_code_value = @LoadProfile AND @LoadProfile IS NOT NULL AND @LoadProfile<> ''
							)
						 OR 
							(
								TC.lpc_tariff_code_value = @TariffCode AND @TariffCode IS NOT NULL AND @TariffCode<> ''
							)
						)
		
			
			DECLARE @COUNTONE INT = 0
		    SELECT @COUNTONE = COUNT(0) FROM #TEMPUtilityBillingTypes
			IF(@COUNTONE=0)
			BEGIN	
			
				TRUNCATE TAbLE #TEMPUtilityBillingTypes
				INSERT INTO #TEMPUtilityBillingTypes (UtilityId, UtilityOfferedBillingType, UtilityAccountType)
				SELECT DISTINCT
				   UC.lpc_utility_id AS UtilityId,  
				   CASE 
						WHEN BTD.lpc_Utility_Offered_BillingType = '924030000' THEN 'Bill Ready'
						WHEN BTD.lpc_Utility_Offered_BillingType = '924030001' THEN 'Dual'
						WHEN BTD.lpc_Utility_Offered_BillingType = '924030002' THEN 'Rate Ready'
						WHEN BTD.lpc_Utility_Offered_BillingType = '924030003' THEN 'Supplier Consolidated' END UtilityOfferedBillingType,
				   
				   CASE 
						WHEN BTD.lpc_Utility_Account_Type = '924030000' THEN 'Residential'
						WHEN BTD.lpc_Utility_Account_Type = '924030001' THEN 'Commercial'
						WHEN BTD.lpc_Utility_Account_Type = '924030002' THEN 'Undetermined' END UtilityAccountType
				FROM  
				   LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK)  
				   INNER JOIN LibertyCrm_MSCRM.dbo.lpc_billingtypedefault BTD WITH (NOLOCK) ON UC.lpc_utilityId= BTD.lpc_UtilityId  
				WHERE  
					UC.lpc_utility_id = @utilityId 
				
			END
		
		END
		
		SELECT * FROM #TEMPUtilityBillingTypes
		RETURN
		
	END
	ELSE
	BEGIN
			TRUNCATE TAbLE #TEMPUtilityBillingTypes
			INSERT INTO #TEMPUtilityBillingTypes (UtilityId, UtilityOfferedBillingType, UtilityAccountType)
			SELECT DISTINCT
			   UC.lpc_utility_id AS UtilityId,  
			   CASE 
					WHEN BTD.lpc_Utility_Offered_BillingType = '924030000' THEN 'Bill Ready'
					WHEN BTD.lpc_Utility_Offered_BillingType = '924030001' THEN 'Dual'
					WHEN BTD.lpc_Utility_Offered_BillingType = '924030002' THEN 'Rate Ready'
					WHEN BTD.lpc_Utility_Offered_BillingType = '924030003' THEN 'Supplier Consolidated' END UtilityOfferedBillingType,
			   
			   CASE 
					WHEN BTD.lpc_Utility_Account_Type = '924030000' THEN 'Residential'
					WHEN BTD.lpc_Utility_Account_Type = '924030001' THEN 'Commercial'
					WHEN BTD.lpc_Utility_Account_Type = '924030002' THEN 'Undetermined' END UtilityAccountType
			FROM  
			   LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK)  
			   INNER JOIN LibertyCrm_MSCRM.dbo.lpc_billingtypedefault BTD WITH (NOLOCK) ON UC.lpc_utilityId= BTD.lpc_UtilityId  
			WHERE  
				UC.lpc_utility_id = @utilityId 
	
	
			SELECT * FROM #TEMPUtilityBillingTypes
			RETURN
		
	END

	
END
GO
