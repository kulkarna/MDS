USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetHURequestMode]    Script Date: 03/28/2017 14:33:07 ******/

if object_id('usp_GetHURequestMode') is not null
begin

DROP PROCEDURE [dbo].[usp_GetHURequestMode]
end

GO
/****** Object:  StoredProcedure [dbo].[usp_GetHURequestMode]    Script Date: 03/28/2017 14:33:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
-- ====================================================================================================================================================================================  
-- Stored Procedure: [usp_GetHURequestMode]  
-- Created: Anjibabu Maddineni 02/21/2017          
-- Description: Selects the records from the Utility   
-- EXEC [usp_GetHURequestMode] 1, 'Pre Enrollment'  
-- ====================================================================================================================================================================================  
*/  
  
CREATE PROCEDURE [dbo].[usp_GetHURequestMode]
(  
	@utilityId INT, 
	@enrollmentType VARCHAR(100)  
)
AS  
BEGIN  
  
	SET NOCOUNT ON
	
	DECLARE @enrollmentTypeVal INT
	SET @enrollmentTypeVal = CASE 
								WHEN UPPER(@enrollmentType) = UPPER('Pre Enrollment') THEN 924030001  
								WHEN UPPER(@enrollmentType) = UPPER('PreEnrollment') THEN 924030001  
								WHEN UPPER(@enrollmentType) = UPPER('Post Enrollment') THEN 924030000
								WHEN UPPER(@enrollmentType) = UPPER('PostEnrollment') THEN 924030000 END
	
	SELECT  
		UC.lpc_utility_id AS UtilityId,  
		UC.lpc_UtilityCode AS UtilityCode,  
		RM.lpc_AddressForPreEnrollment As Address,  
		RM.lpc_EmailTemplate AS  EmailTemplate,  
		CASE 
			WHEN RM.lpc_EnrollmentType  = 924030000 THEN 'Post Enrollment' 
			WHEN RM.lpc_EnrollmentType  = 924030001 THEN 'Pre Enrollment' 
			ELSE '' END EnrollmentType,
		RM.lpc_Instructions As  Instructions,  
		CASE WHEN RM.lpc_IsLOARequired = 1 THEN 'True' ELSE 'False' END IsLOARequired,  
		RM.lpc_LibertyPowerSLA As LibertyPowerSLAResponse,  
		CASE 
			WHEN RM.lpc_RequestModeType = 924030000 THEN 'EDI'
			WHEN RM.lpc_RequestModeType = 924030001 THEN 'E-Mail'
			WHEN RM.lpc_RequestModeType = 924030002 THEN 'Scraper'
			WHEN RM.lpc_RequestModeType = 924030003 THEN 'Website'
			WHEN RM.lpc_RequestModeType = 279640000 THEN 'Unknown'
			ELSE '' END RequestModeType,
		RM.lpc_UtilitySLA As UtilitySLAResponse  
	FROM  
		LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK)  
		INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId  
		INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'HU'  
	WHERE  
		UC.lpc_utility_id = @utilityId
		AND RM.lpc_EnrollmentType = @enrollmentTypeVal
	
	SET NOCOUNT OFF
	
END
GO
