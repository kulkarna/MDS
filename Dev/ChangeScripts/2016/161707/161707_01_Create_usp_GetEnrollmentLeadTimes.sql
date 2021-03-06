USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetEnrollmentLeadTimes]    Script Date: 02/09/2017 13:17:49 ******/
if OBJECT_ID('usp_GetEnrollmentLeadTimes') is not null
begin 
DROP PROCEDURE [dbo].[usp_GetEnrollmentLeadTimes]
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetEnrollmentLeadTimes]    Script Date: 02/09/2017 13:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
-- ====================================================================================================================================================================================  
-- Stored Procedure: [usp_GetEnrollmentLeadTimes]  
-- Created: Anjibabu Maddineni 02/03/2017          
-- Description: Selects the records from the Utility   
-- EXEC [usp_GetEnrollmentLeadTimes] @utilityCode = 'CONED', @driver = 'Rate Class'  
-- ====================================================================================================================================================================================  
*/  
  
CREATE PROCEDURE [dbo].[usp_GetEnrollmentLeadTimes]  
@utilityCode VARCHAR(50), @driver VARCHAR(100) = NULL  
AS  
BEGIN  
  
 IF (@driver IS NOT NULL)  
 BEGIN  
  SELECT  
   UC.lpc_utility_id AS UtilityId,  
   UC.lpc_UtilityCode AS UtilityCode,  
   SM.Value As lpc_Utility_Account_Type,  
   ELE.lpc_enrollment_lead_time,  
   CASE WHEN ELE.lpc_Business_day = 0 THEN 'No' WHEN ELE.lpc_Business_day = 1 THEN 'Yes' ELSE 'No' END BusinessDay,  
   'No' AS EnrollmentLeadTImeDefault  
  FROM  
   LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK)  
   INNER JOIN LibertyCrm_MSCRM.dbo.lpc_enrollment_lead_time_exception ELE WITH (NOLOCK) ON UC.lpc_utilityId= ELE.lpc_utility  
   INNER JOIN LIBERTYCRM_MSCRM.dbo.StringMap SM WITH (NOLOCK) ON ELE.lpc_Utility_Account_Type = SM.AttributeValue AND ObjectTypeCode = 10069 AND SM.AttributeName = 'lpc_utility_account_type'  
   INNER JOIN LIBERTYCRM_MSCRM.dbo.StringMap SMDriver WITH (NOLOCK) ON ELE.lpc_driver = SMDriver.AttributeValue AND SMDriver.ObjectTypeCode = 10069 AND SM.AttributeName = 'lpc_driver'  
  WHERE  
   UC.lpc_UtilityCode = @utilityCode  
   AND UPPER(SMDriver.Value) = UPPER(@driver)  
 END  
 ELSE  
 BEGIN  
  SELECT  
   UC.lpc_utility_id AS UtilityId,  
   UC.lpc_UtilityCode AS UtilityCode,  
   SM.Value As lpc_Utility_Account_Type,  
   ELD.lpc_enrollment_lead_time,  
   CASE WHEN ELD.lpc_Business_day = 0 THEN 'No' WHEN ELD.lpc_Business_day = 1 THEN 'Yes' ELSE 'No' END BusinessDay,  
   'Yes' AS EnrollmentLeadTImeDefault  
  FROM  
   LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK)  
   INNER JOIN LibertyCrm_MSCRM.dbo.lpc_enrollment_lead_time_default ELD WITH (NOLOCK) ON UC.lpc_utilityId= ELD.lpc_utility  
   INNER JOIN LIBERTYCRM_MSCRM.dbo.StringMap SM WITH (NOLOCK) ON ELD.lpc_Utility_Account_Type = SM.AttributeValue AND ObjectTypeCode = 10068 AND SM.AttributeName = 'lpc_utility_account_type'  
  WHERE  
   UC.lpc_UtilityCode = @utilityCode  
 END  
END  
  
  
GO
