USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[USP_GetIDRRequestModeData]    Script Date: 03/28/2017 14:14:09 ******/
if object_id('USP_GetIDRRequestModeData') is not null
begin
DROP PROCEDURE [dbo].[USP_GetIDRRequestModeData]
end
GO
/****** Object:  StoredProcedure [dbo].[USP_GetIDRRequestModeData]    Script Date: 03/28/2017 14:14:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*    
-- ====================================================================================================================================================================================    
-- Stored Procedure: [USP_GetIDRRequestModeData]    
-- Created: Anjibabu Maddineni 02/21/2017            
-- Description: Selects the records from the Utility     
   EXEC [USP_GetIDRRequestModeData]  
    @utilityId = 9,   
    @enrollmentType = 'Pre Enrollment' ,   
    @RateClass = NULL,   
    @LoadProfile = '13V1',   
    @TariffCode = NULL ,  
    @Eligibility = 0,   
    @Hia = 0,  
    @Usage = 0  
       
-- ====================================================================================================================================================================================    
*/    
    
CREATE PROCEDURE [dbo].[USP_GetIDRRequestModeData]  
(    
 @utilityId INT,   
 @enrollmentType VARCHAR(100) ,  
 @RateClass VARCHAR(255)=null ,  
 @LoadProfile VARCHAR(255) =null,  
 @TariffCode VARCHAR(255)=null ,  
 @Eligibility AS BIT,  
 @Hia AS BIT,  
 @Usage AS INT   
)  
AS    
BEGIN    
    
 SET NOCOUNT ON  
    
 DECLARE @GuaranteedFactorNotMet INT  
 DECLARE @TotalRuleCount INT  
 DECLARE @BusinessFactorNotMet INT  
 DECLARE @MatchCount INT  
 DECLARE @InsufficientInfoCount INT  
 DECLARE @GuaranteedFactorNotMetTable TABLE (IdrId NVARCHAR(90))  
 DECLARE @TotalRuleCountTable TABLE (IdrId NVARCHAR(90))  
    
 DECLARE @enrollmentTypeVal INT  
 SET @enrollmentTypeVal = CASE   
        WHEN UPPER(@enrollmentType) = UPPER('Pre Enrollment') THEN 924030001    
        WHEN UPPER(@enrollmentType) = UPPER('PreEnrollment') THEN 924030001    
        WHEN UPPER(@enrollmentType) = UPPER('Post Enrollment') THEN 924030000  
        WHEN UPPER(@enrollmentType) = UPPER('PostEnrollment') THEN 924030000 END  
   
 -- Calculate @MatchCount By using the below code.  
 SELECT   
  @MatchCount = COUNT(IDRR.lpc_idrruleId)  
 FROM   
  LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
  INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId    
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK) ON IDRR.lpc_RateClassId= RC.lpc_rate_classId  
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK) ON IDRR.lpc_LoadProfileId = LP.lpc_load_profileId  
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK) ON IDRR.lpc_TariffCodeId= TC.lpc_tariff_codeId  
 WHERE   
  UC.lpc_utility_id = @UtilityId  
  AND RM.lpc_EnrollmentType = @enrollmentTypeVal  
  AND (  
    RC.lpc_rate_class_code_value IS NULL   
    OR (  
     RC.lpc_rate_class_code_value IS NOT NULL AND @RateClass IS NOT NULL AND RC.lpc_rate_class_code_value <> @RateClass  
        )  
   )  
  AND (   
    LP.lpc_load_profile_code_value IS NULL    
    OR (  
      LP.lpc_load_profile_code_value IS NOT NULL AND @LoadProfile IS NOT NULL AND LP.lpc_load_profile_code_value <> @LoadProfile  
     )  
   )  
  AND  
   (  
    TC.lpc_tariff_code_value IS NOT NULL  
    OR (  
      TC.lpc_tariff_code_value IS NOT NULL AND @TariffCode IS NOT NULL AND TC.lpc_tariff_code_value <> @TariffCode  
     )  
   )  
  AND   
   (   
    IDRR.lpc_IsEligible = 0  
    OR (  
      IDRR.lpc_IsEligible = 1 AND @Eligibility = 1  
     )  
   )  
  AND   
   (  
    IDRR.lpc_IsHIA=0  OR  IDRR.lpc_IsHIA IS NULL  
    OR (  
      IDRR.lpc_IsHIA=1 AND @Hia = 1  
     )  
   )  
  AND  
   (  
    (  
     IDRR.lpc_MaxUsageMWh IS NULL  
     OR (  
       IDRR.lpc_MaxUsageMWh IS NOT NULL AND @Usage IS NOT NULL AND IDRR.lpc_MaxUsageMWh >= @Usage  
      )  
       
    )  
    AND  
    (  
     IDRR.lpc_MinUsageMWh IS NULL  
     OR (  
       IDRR.lpc_MinUsageMWh IS NOT NULL AND @Usage IS NOT NULL AND IDRR.lpc_MinUsageMWh <= @Usage  
      )  
    )  
   )  
   
   
 -- Calculate @InsufficientInfoCount By using the below code.  
   
 SELECT   
  @InsufficientInfoCount = COUNT(IDRR.lpc_idrruleId)  
 FROM   
  LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
  INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId    
 WHERE   
  UC.lpc_utility_id = @UtilityId  
  AND RM.lpc_EnrollmentType = @enrollmentTypeVal  
  AND IDRR.lpc_idrruleId NOT IN (  
          SELECT DISTINCT   
           IDRR.lpc_idrruleId  
          FROM   
           LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
           INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId AND UC.lpc_utility_id = @UtilityId    
           LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK) ON IDRR.lpc_RateClassId= RC.lpc_rate_classId  
          WHERE   
           RC.lpc_rate_class_code_value IS NOT NULL AND @RateClass IS NOT NULL AND RC.lpc_rate_class_code_value <> @RateClass  
            
          UNION  
            
          SELECT DISTINCT   
           IDRR.lpc_idrruleId  
          FROM   
           LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
           INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId AND UC.lpc_utility_id = @UtilityId    
           LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK) ON IDRR.lpc_LoadProfileId = LP.lpc_load_profileId  
          WHERE   
           LP.lpc_load_profile_code_value IS NOT NULL AND @LoadProfile IS NOT NULL AND LP.lpc_load_profile_code_value <> @LoadProfile  
             
          UNION  
            
          SELECT DISTINCT   
           IDRR.lpc_idrruleId  
          FROM   
           LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
           INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId AND UC.lpc_utility_id = @UtilityId    
           LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK) ON IDRR.lpc_TariffCodeId= TC.lpc_tariff_codeId  
          WHERE   
           TC.lpc_tariff_code_value IS NOT NULL AND @TariffCode IS NOT NULL AND TC.lpc_tariff_code_value <> @TariffCode  
             
          UNION  
            
          SELECT DISTINCT   
           IDRR.lpc_idrruleId  
          FROM   
           LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
           INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId AND UC.lpc_utility_id = @UtilityId    
          WHERE   
           IDRR.lpc_MaxUsageMWh IS NOT NULL AND @Usage IS NOT NULL AND IDRR.lpc_MaxUsageMWh < @Usage  
  
            
          UNION   
            
          SELECT DISTINCT   
           IDRR.lpc_idrruleId  
          FROM   
           LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
           INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId AND UC.lpc_utility_id = @UtilityId    
          WHERE   
           IDRR.lpc_MinUsageMWh IS NOT NULL AND @Usage IS NOT NULL AND IDRR.lpc_MinUsageMWh > @Usage  
            
          UNION  
            
          SELECT DISTINCT   
           IDRR.lpc_idrruleId  
          FROM   
           LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
           INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId AND UC.lpc_utility_id = @UtilityId    
          WHERE   
           IDRR.lpc_IsEligible IS NOT NULL  
           AND @Eligibility IS NOT NULL  
           AND IDRR.lpc_IsEligible <> @Eligibility  
           AND IDRR.lpc_IsEligible = 1   
                
          --UNION  
            
          --SELECT DISTINCT   
          -- IDRR.lpc_idrruleId  
          --FROM   
          -- LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
          -- INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
          -- INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
          -- INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId AND UC.lpc_utility_id = @UtilityId    
          --WHERE   
          -- IDRR.lpc_IsHIA IS NOT NULL  
          -- AND @Hia IS NOT NULL  
          -- AND IDRR.lpc_IsHIA <> @Hia  
          -- AND @Hia = 1   
           
          UNION  
            
          SELECT DISTINCT  
           IDRR.lpc_idrruleId  
          FROM   
           LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
           INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId    
           LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK) ON IDRR.lpc_RateClassId= RC.lpc_rate_classId  
           LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK) ON IDRR.lpc_LoadProfileId = LP.lpc_load_profileId  
           LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK) ON IDRR.lpc_TariffCodeId= TC.lpc_tariff_codeId  
          WHERE   
           UC.lpc_utility_id = @UtilityId  
           --AND RM.lpc_EnrollmentType = @enrollmentTypeVal  
           AND   
            (  
             (  
              (  
               @RateClass IS NULL  
               OR RTRIM(LTRIM(@RateClass)) = ''  
              )  
             AND RC.lpc_rate_class_code_value IS NULL   
             )  
            OR RC.lpc_rate_class_code_value IS NULL  
            OR RC.lpc_rate_class_code_value = @RateClass  
            )  
           AND   
            (   
             (  
              (  
               @LoadProfile IS NULL  
               OR RTRIM(LTRIM(@LoadProfile)) = ''  
              )  
             AND LP.lpc_load_profile_code_value IS NULL   
             )  
            OR LP.lpc_load_profile_code_value IS NULL  
            OR LP.lpc_load_profile_code_value = @LoadProfile  
            )  
           AND   
            (   
             (  
              (  
               @TariffCode IS NULL  
               OR RTRIM(LTRIM(@TariffCode)) = ''  
              )  
             AND TC.lpc_tariff_code_value IS NULL   
             )  
            OR TC.lpc_tariff_code_value IS NULL  
            OR TC.lpc_tariff_code_value = @TariffCode  
            )  
           AND   
            (  
             (  
              @Hia IS NULL  
              AND IDRR.lpc_IsHIA IS NULL  
             )  
             OR (  
               IDRR.lpc_IsHIA=1 AND IDRR.lpc_IsHIA = @Hia  
              )  
            )  
           AND  
            (  
             (  
              @Usage IS NULL  
              AND IDRR.lpc_MinUsageMWh IS NULL  
             )  
             OR IDRR.lpc_MinUsageMWh IS NULL  
             OR IDRR.lpc_MinUsageMWh  <= @Usage  
            )  
           AND  
            (  
             (  
              @Usage IS NULL  
              AND IDRR.lpc_MaxUsageMWh IS NULL  
             )  
             OR IDRR.lpc_MaxUsageMWh IS NULL  
             OR IDRR.lpc_MaxUsageMWh  >= @Usage  
            )  
            
          UNION  
            
          SELECT DISTINCT  
           IDRR.lpc_idrruleId  
          FROM   
           LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
           INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
           INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId    
           LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK) ON IDRR.lpc_RateClassId= RC.lpc_rate_classId  
           LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK) ON IDRR.lpc_LoadProfileId = LP.lpc_load_profileId  
           LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK) ON IDRR.lpc_TariffCodeId= TC.lpc_tariff_codeId  
          WHERE   
           UC.lpc_utility_id = @UtilityId  
           --AND RM.lpc_EnrollmentType = @enrollmentTypeVal  
           AND   
            (  
             (  
              (  
               @RateClass IS NULL  
               OR RTRIM(LTRIM(@RateClass)) = ''  
              )  
             AND RC.lpc_rate_class_code_value IS NULL   
             )  
            OR RC.lpc_rate_class_code_value IS NULL  
            OR RC.lpc_rate_class_code_value = @RateClass  
            )  
           AND   
            (   
             (  
              (  
               @LoadProfile IS NULL  
               OR RTRIM(LTRIM(@LoadProfile)) = ''  
              )  
             AND LP.lpc_load_profile_code_value IS NULL   
             )  
            OR LP.lpc_load_profile_code_value IS NULL  
            OR LP.lpc_load_profile_code_value = @LoadProfile  
            )  
           AND   
            (   
             (  
              (  
               @TariffCode IS NULL  
               OR RTRIM(LTRIM(@TariffCode)) = ''  
              )  
             AND TC.lpc_tariff_code_value IS NULL   
             )  
            OR TC.lpc_tariff_code_value IS NULL  
            OR TC.lpc_tariff_code_value = @TariffCode  
            )  
           AND   
            (  
             (  
              @Hia IS NULL  
              AND IDRR.lpc_IsHIA IS NULL  
             )  
             OR (  
               IDRR.lpc_IsHIA=1 AND IDRR.lpc_IsHIA <> @Hia  
              )  
            )  
           AND  
            (  
             (  
              @Usage IS NULL  
              AND IDRR.lpc_MinUsageMWh IS NULL  
             )  
             OR IDRR.lpc_MinUsageMWh IS NULL  
             OR IDRR.lpc_MinUsageMWh  <= @Usage  
            )  
           AND  
            (  
             (  
              @Usage IS NULL  
              AND IDRR.lpc_MaxUsageMWh IS NULL  
             )  
             OR IDRR.lpc_MaxUsageMWh IS NULL  
             OR IDRR.lpc_MaxUsageMWh  >= @Usage  
            )  
             
         )  
   
   
 -- INSERT THE DATA INTO @GuaranteedFactorNotMetTable  
 INSERT INTO @GuaranteedFactorNotMetTable  
 SELECT   
  IDRR.lpc_idrruleId  
 FROM   
  LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
  INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId    
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK) ON IDRR.lpc_RateClassId= RC.lpc_rate_classId  
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK) ON IDRR.lpc_LoadProfileId = LP.lpc_load_profileId  
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK) ON IDRR.lpc_TariffCodeId= TC.lpc_tariff_codeId  
 WHERE   
  UC.lpc_utility_id = @UtilityId  
  AND RM.lpc_EnrollmentType = @enrollmentTypeVal  
  AND (  
    (  
     RC.lpc_rate_class_code_value IS NOT NULL AND @RateClass IS NOT NULL AND RC.lpc_rate_class_code_value <> @RateClass  
    )  
   OR (  
     LP.lpc_load_profile_code_value IS NOT NULL AND @LoadProfile IS NOT NULL AND LP.lpc_load_profile_code_value <> @LoadProfile  
    )  
   OR (  
     TC.lpc_tariff_code_value IS NOT NULL AND @TariffCode IS NOT NULL AND TC.lpc_tariff_code_value <> @TariffCode  
    )  
   OR (  
     IDRR.lpc_IsEligible = 1 AND @Eligibility = 0  
    )  
   OR (  
     IDRR.lpc_IsHIA=1 AND IDRR.lpc_IsHIA <> @Hia  
    )  
   )  
   
   
 INSERT INTO @TotalRuleCountTable  
 SELECT   
  IDRR.lpc_idrruleId  
 FROM   
  LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
  INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId    
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK) ON IDRR.lpc_RateClassId= RC.lpc_rate_classId  
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK) ON IDRR.lpc_LoadProfileId = LP.lpc_load_profileId  
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK) ON IDRR.lpc_TariffCodeId= TC.lpc_tariff_codeId  
 WHERE   
  UC.lpc_utility_id = @UtilityId  
  AND RM.lpc_EnrollmentType = @enrollmentTypeVal  
   
 SELECT   
  @GuaranteedFactorNotMet = COUNT(IdrId)  
 FROM  
  @GuaranteedFactorNotMetTable  
   
 SELECT   
  @TotalRuleCount = COUNT(IdrId)  
 FROM   
  @TotalRuleCountTable  
   
 --SELECT @GuaranteedFactorNotMet = COUNT(IDRR.lpc_idrruleId)  
 --FROM   
 -- LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
 -- INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
 -- INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
 -- INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId    
 -- LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK) ON IDRR.lpc_RateClassId= RC.lpc_rate_classId  
 -- LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK) ON IDRR.lpc_LoadProfileId = LP.lpc_load_profileId  
 -- LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK) ON IDRR.lpc_TariffCodeId= TC.lpc_tariff_codeId  
 --WHERE   
 -- UC.lpc_utility_id = @UtilityId  
 -- AND RM.lpc_EnrollmentType = @enrollmentTypeVal  
 -- AND (  
 --   (  
 --    RC.lpc_rate_class_code_value IS NOT NULL AND @RateClass IS NOT NULL AND RC.lpc_rate_class_code_value <> @RateClass  
 --   )  
 --  OR (  
 --    LP.lpc_load_profile_code_value IS NOT NULL AND @LoadProfile IS NOT NULL AND LP.lpc_load_profile_code_value <> @LoadProfile  
 --   )  
 --  OR (  
 --    TC.lpc_tariff_code_value IS NOT NULL AND @TariffCode IS NOT NULL AND TC.lpc_tariff_code_value <> @TariffCode  
 --   )  
 --  OR (  
 --    IDRR.lpc_IsEligible = 1 AND @Eligibility = 0  
 --   )  
 --  OR (  
 --    IDRR.lpc_IsHIA=1 AND IDRR.lpc_IsHIA <> @Hia  
 --   )  
 --  )  
   
 SELECT   
  @BusinessFactorNotMet = COUNT(IDRR.lpc_idrruleId)  
 FROM LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
  INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
 WHERE   
  IDRR.lpc_idrruleId IN (  
        SELECT IdrId  
        FROM @TotalRuleCountTable TRCT  
        WHERE TRCT.IdrId NOT IN (  
               SELECT IdrId  
               FROM @GuaranteedFactorNotMetTable  
               )  
        )  
  AND RM.lpc_EnrollmentType = @enrollmentTypeVal  
  AND (  
    (  
     @Usage IS NULL  
     AND (  
      IDRR.lpc_MinUsageMWh IS NOT NULL  
      AND IDRR.lpc_MaxUsageMWh IS NOT NULL  
      )  
    )  
    OR   
    (  
     @Usage IS NOT NULL  
     AND (  
       (  
        IDRR.lpc_MinUsageMWh IS NOT NULL  
        AND @Usage < IDRR.lpc_MinUsageMWh  
       )  
       OR   
       (  
        IDRR.lpc_MaxUsageMWh IS NOT NULL  
        AND @Usage > IDRR.lpc_MaxUsageMWh  
       )  
      )  
    )  
   )  
   
   
 DECLARE @IsEligibilitySet AS INT  
 DECLARE @IsAlwaysRequestSet AS INT  
  
 SELECT   
  @IsAlwaysRequestSet = ISNULL(IDRR.lpc_AlwaysRequest, 0)  
 FROM   
  LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
  INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId    
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK) ON IDRR.lpc_RateClassId= RC.lpc_rate_classId  
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK) ON IDRR.lpc_LoadProfileId = LP.lpc_load_profileId  
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK) ON IDRR.lpc_TariffCodeId= TC.lpc_tariff_codeId  
 WHERE   
  UC.lpc_utility_id = @UtilityId  
  AND RM.lpc_EnrollmentType = @enrollmentTypeVal  
  AND (  
    (  
     RC.lpc_rate_class_code_value IS NOT NULL AND @RateClass IS NOT NULL AND RC.lpc_rate_class_code_value = @RateClass  
    )  
   OR (  
     LP.lpc_load_profile_code_value IS NOT NULL AND @LoadProfile IS NOT NULL AND LP.lpc_load_profile_code_value = @LoadProfile  
    )  
   OR (  
     TC.lpc_tariff_code_value IS NOT NULL AND @TariffCode IS NOT NULL AND TC.lpc_tariff_code_value = @TariffCode  
    )  
   )  
   
 SELECT   
  @IsEligibilitySet = ISNULL(COUNT(IDRR.lpc_idrruleId), 0)  
 FROM   
  LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK)   
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId  
  INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'    
  INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId    
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK) ON IDRR.lpc_RateClassId= RC.lpc_rate_classId  
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK) ON IDRR.lpc_LoadProfileId = LP.lpc_load_profileId  
  LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK) ON IDRR.lpc_TariffCodeId= TC.lpc_tariff_codeId  
 WHERE   
  UC.lpc_utility_id = @UtilityId  
  AND RM.lpc_EnrollmentType = @enrollmentTypeVal  
  AND (  
    (  
     RC.lpc_rate_class_code_value IS NOT NULL AND @RateClass IS NOT NULL AND RC.lpc_rate_class_code_value = @RateClass  
    )  
   OR (  
     LP.lpc_load_profile_code_value IS NOT NULL AND @LoadProfile IS NOT NULL AND LP.lpc_load_profile_code_value = @LoadProfile  
    )  
   OR (  
     TC.lpc_tariff_code_value IS NOT NULL AND @TariffCode IS NOT NULL AND TC.lpc_tariff_code_value = @TariffCode  
    )  
   )  
  AND IDRR.lpc_IsEligible = 1  
  AND @Eligibility = 1  
     
 PRINT '@IsEligibilitySet=' + cast(@IsEligibilitySet AS NVARCHAR(2))  
 PRINT '@IsAlwaysRequestSet=' + cast(@IsAlwaysRequestSet AS NVARCHAR(2))  
 PRINT '@UtilityIdInt=' + cast(@UtilityId AS NVARCHAR(2))  
 PRINT '@RequestModeEnrollmentTypeId=' + cast(@enrollmentTypeVal AS NVARCHAR(20))  
 PRINT '@MatchCount=' + cast(@MatchCount AS NVARCHAR(20))  
 PRINT '@InsufficientInfoCount=' + cast (@InsufficientInfoCount AS NVARCHAR(20))  
 PRINT '@TotalRuleCount=' + cast(@TotalRuleCount AS NVARCHAR(20))  
  
 SELECT @MatchCount = ISNULL(@MatchCount, 0) --+ @IsAlwaysRequestSet  
    
 SELECT CASE   
   WHEN (ISNULL(@IsAlwaysRequestSet, 0) + ISNULL(@IsEligibilitySet, 0)) > 0  
    THEN 1  
   ELSE 0  
   END AS IsAlwaysRequestSet  
  ,CASE   
   WHEN @MatchCount > 0  
    THEN 1  
   ELSE 0  
   END AS Match  
  ,CASE   
   WHEN @MatchCount = 0  
    AND @InsufficientInfoCount > 0  
    THEN 1  
   ELSE 0  
   END AS InsufficientInfo  
  ,CASE   
   WHEN @MatchCount > 0  
    OR @TotalRuleCount > @GuaranteedFactorNotMet  
    THEN 0  
    ELSE CASE WHEN  @INSUFFICIENTINFOCOUNT>0 THEN 0   
   ELSE   
    1 END  
   END AS GuaranteedFactorNotMet  
  ,CASE   
   WHEN @MatchCount = 0  
    AND @InsufficientInfoCount = 0  
    AND @BusinessFactorNotMet > 0  
    THEN 1  
   ELSE 0  
   END AS BusinessFactorNotMet  
   
   
   
 SET NOCOUNT OFF  
   
END
GO
