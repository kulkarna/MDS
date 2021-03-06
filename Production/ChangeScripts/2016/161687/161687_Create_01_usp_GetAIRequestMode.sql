USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAIRequestMode]    Script Date: 02/16/2017 09:14:10 ******/
if object_id('usp_GetAIRequestMode') is not null
begin
DROP PROCEDURE [dbo].[usp_GetAIRequestMode]
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAIRequestMode]    Script Date: 02/16/2017 09:14:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
-- ====================================================================================================================================================================================  
-- Stored Procedure: [usp_GetAIRequestMode]  
-- Created: Anjibabu Maddineni 02/09/2017          
-- Description: Selects the records from the Utility   
-- EXEC [usp_GetAIRequestMode] 10, 'Pre Enrollment'  
-- ====================================================================================================================================================================================  
*/  
  
CREATE PROCEDURE [dbo].[usp_GetAIRequestMode]  
@utilityId int, @enrollmentType VARCHAR(100)  
AS  
BEGIN  
  
 SELECT  
  UC.lpc_utility_id AS UtilityId,  
  UC.lpc_UtilityCode AS UtilityCode,  
  RM.lpc_AddressForPreEnrollment As Address,  
  RM.lpc_EmailTemplate AS  EmailTemplate,  
  SM.Value AS EnrollmentType,  
  RM.lpc_Instructions As  Instructions,  
  CASE WHEN RM.lpc_IsLOARequired = 1 THEN 'True' ELSE 'False' END IsLOARequired,  
  RM.lpc_LibertyPowerSLA As LibertyPowerSLAResponse,  
  SMR.Value AS RequestModeType,  
  RM.lpc_UtilitySLA As UtilitySLAResponse  
 FROM  
  LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK)  
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId  
  INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND RT.lpc_name = 'I-Cap'  
  INNER JOIN LIBERTYCRM_MSCRM.dbo.StringMap SM WITH (NOLOCK) ON  RM.lpc_EnrollmentType = SM.AttributeValue AND SM.ObjectTypeCode = 10080 AND SM.AttributeName = 'lpc_enrollmenttype'  
  INNER JOIN LIBERTYCRM_MSCRM.dbo.StringMap SMR WITH (NOLOCK) ON  RM.lpc_RequestModeType = SMR.AttributeValue AND SM.ObjectTypeCode = 10080 AND SMR.AttributeName = 'lpc_requestmodetype'  
 WHERE  
  UC.lpc_utility_id = @utilityId  
  AND REPLACE((SM.Value),' ','') = REPLACE(UPPER(@enrollmentType),' ','' )  
END
GO
