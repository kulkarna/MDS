USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_IdrRuleAndRequestMode_SelectByParams]    Script Date: 03/28/2017 14:10:57 ******/
if object_id('usp_IdrRuleAndRequestMode_SelectByParams') is not null
begin
DROP PROCEDURE [dbo].[usp_IdrRuleAndRequestMode_SelectByParams]
end

GO
/****** Object:  StoredProcedure [dbo].[usp_IdrRuleAndRequestMode_SelectByParams]    Script Date: 03/28/2017 14:10:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec usp_IdrRuleAndRequestMode_SelectByParams
@UtilityIdInt = 9,   
    @EnrollmentType = 'Pre Enrollment' ,   
    @RateClassCode = NULL,   
    @LoadProfileCode = '35V1',    
    @Hia = 0,
    @AnnualUsage=699
    


*/


 CREATE PROC [dbo].[usp_IdrRuleAndRequestMode_SelectByParams]
    @RateClassCode AS NVARCHAR(250)=NULL,
	@LoadProfileCode AS NVARCHAR(250)=NULL,
	@UtilityIdInt INT,
	@AnnualUsage INT,
	@EnrollmentType NVARCHAR(250),
	@Hia BIT
AS
BEGIN

DECLARE @enrollmentTypeVal INT  
 SET @enrollmentTypeVal = CASE   
        WHEN UPPER(@EnrollmentType) = UPPER('Pre Enrollment') THEN 924030001    
        WHEN UPPER(@EnrollmentType) = UPPER('PreEnrollment') THEN 924030001    
        WHEN UPPER(@EnrollmentType) = UPPER('Post Enrollment') THEN 924030000  
        WHEN UPPER(@EnrollmentType) = UPPER('PostEnrollment') THEN 924030000 END
        
        

      SELECT 
            IDRR.lpc_idrruleId as [Id],
            IDRR.[lpc_RateClassId] AS RateClassIdGuid,
            IDRR.[lpc_LoadProfileId] AS LoadProfileIdGuid,
            IDRR.[lpc_MinUsageMWh],
            IDRR.[lpc_MaxUsageMWh],
            IDRR.lpc_IsEligible [IsOnEligibleCustomerList],
            IDRR.lpc_IsHIA [IsHistoricalArchiveAvailable],
            IDRR.[CreatedBy],
            IDRR.CreatedOn [CreatedDate],
            IDRR.ModifiedBy [LastModifiedBy],
            IDRR.ModifiedOn [LastModifiedDate],
            UC.lpc_utilityId AS UtilityCompanyId,
            UC.lpc_UtilityCode UtilityCode,
            UC.lpc_utility_id UtilityIdInt,
            LP.lpc_load_profileId LoadProfileId,
            LP.lpc_load_profile_code LoadProfileCode,
            RC.lpc_rate_class_code RateClassCode,
            RM.lpc_requestmodeId AS RequestModeIdrId,
            RM.lpc_RequestTypeId RequestModeTypeId,
            case when RM.lpc_EnrollmentType=924030001   then 'PREENROLLMENT'  when RM.lpc_EnrollmentType=924030000  then 
            'POSTENROLLMENT' end  as   RequestModeEnrollmentTypeId,
            RM.lpc_AddressForPreEnrollment as  AddressForPreEnrollment,
            RM.lpc_EmailTemplate EmailTemplate,
            RM.lpc_Instructions Instructions,
            RM.lpc_UtilitySLA UtilitysSlaIdrResponseInDays,
            RM.lpc_LibertyPowerSLA LibertyPowersSlaFollowUpIdrResponseInDays,
            RM.lpc_IsLOARequired IsLoaRequired,
            RM.lpc_RequestCostAccount RequestCostAccount,
            CASE 
			WHEN RM.lpc_RequestModeType = 924030000 THEN 'EDI'
			WHEN RM.lpc_RequestModeType = 924030001 THEN 'E-Mail'
			WHEN RM.lpc_RequestModeType = 924030002 THEN 'Scraper'
			WHEN RM.lpc_RequestModeType = 924030003 THEN 'Website'
			WHEN RM.lpc_RequestModeType = 279640000 THEN 'Unknown'
			ELSE '' END RequestModeTypeName
            
      FROM
            LIBERTYCRM_MSCRM.dbo.lpc_idrrule IDRR WITH (NOLOCK) 
            INNER JOIN LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK) ON RM.lpc_requestmodeId = IDRR.lpc_RequestModeId
            INNER JOIN LIBERTYCRM_MSCRM.dbo.lpc_requesttype RT WITH (NOLOCK) ON RM.lpc_RequestTypeId = RT.lpc_requesttypeId AND UPPER(RT.lpc_name) = 'IDR'  
            INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON UC.lpc_utilityId= RM.lpc_UtilityId  
            LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_rate_class RC WITH (NOLOCK) ON IDRR.lpc_RateClassId= RC.lpc_rate_classId
            LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_load_profile LP WITH (NOLOCK) ON IDRR.lpc_LoadProfileId = LP.lpc_load_profileId
            LEFT JOIN LIBERTYCRM_MSCRM.dbo.lpc_tariff_code TC WITH (NOLOCK) ON IDRR.lpc_TariffCodeId= TC.lpc_tariff_codeId
      WHERE
            (((@RateClassCode IS NULL OR RTRIM(LTRIM(@RateClassCode)) = '') AND RC.lpc_rate_class_code IS NULL) OR RC.lpc_rate_class_code IS NULL OR RC.lpc_rate_class_code = @RateClassCode)
             And (((@LoadProfileCode IS NULL OR RTRIM(LTRIM(@LoadProfileCode)) = '') AND LP.lpc_load_profile_code IS NULL) 
             OR LP.lpc_load_profile_code IS NULL OR Upper(isnull(LP.lpc_load_profile_code,'') COLLATE  Latin1_General_CI_AS) = Upper(isnull(uc.lpc_UtilityCode,''))+'-'+ Upper(isnull(@LoadProfileCode,'')))
             And UC.lpc_utility_Id = @UtilityIdInt
             AND ((@AnnualUsage IS NULL AND IDRR.lpc_MaxUsageMWh IS NULL) OR IDRR.lpc_MinUsageMWh IS NULL OR IDRR.lpc_MinUsageMWh <= @AnnualUsage)
             AND ((IDRR.lpc_MaxUsageMWh IS NULL AND @AnnualUsage IS NULL) OR IDRR.lpc_MaxUsageMWh IS NULL OR IDRR.lpc_MaxUsageMWh >= @AnnualUsage)
             AND (@EnrollmentType IS NOT NULL AND Upper(RM.lpc_EnrollmentType) =@enrollmentTypeVal)
             AND ((@Hia IS NULL AND IDRR.lpc_IsHIA IS NULL) OR IDRR.lpc_IsHIA = @Hia)


END
GO
