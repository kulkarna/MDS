USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_PORAssuranceForWCF]    Script Date: 03/24/2017 13:46:05 ******/
if OBJECT_ID('usp_PORAssuranceForWCF') is not null
begin
DROP PROCEDURE [dbo].[usp_PORAssuranceForWCF]
end
GO
/****** Object:  StoredProcedure [dbo].[usp_PORAssuranceForWCF]    Script Date: 03/24/2017 13:46:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

Created By : Ravi
Created Date : 03/23/2017


*/



/*

exec usp_PORAssuranceForWCF
 @UtilityIdInt =37,
 @EffectiveDate ='2015-03-24 07:38:03.080',
 @LoadProfile =NULL,  
 @RateClass ='MT2',  
 @TariffCode =NULL

*/ 

 
CREATE PROC [dbo].[usp_PORAssuranceForWCF]  
 @UtilityIdInt AS INT,  
 @EffectiveDate AS DATETIME,  
 @LoadProfile AS NVARCHAR(255)=NULL,  
 @RateClass AS NVARCHAR(255)=NULL,  
 @TariffCode AS NVARCHAR(255)=NULL  
AS  
BEGIN  
  
 SET NOCOUNT ON  
  
  
Select   
  
 lpc_purchase_of_receivableID as [ID]  
,por.lpc_Utility as UtilityCompanyID  
,uc.lpc_UtilityCode   
,por.lpc_por_driver as PorDriverId  
, Case When por.lpc_por_driver = '924030000' then 'Load Profile'   
       When por.lpc_por_driver = '924030001' then 'Rate Class'  
    When por.lpc_por_driver = '924030002' then 'Tariff Code' END as PorDriverName  
,rc.lpc_rate_class_code_value as RateClassCode  
,'' as RateClassID --,lpc_rate_Class as RateClassID  
,lp.lpc_load_profile_code_value as LoadProfileCode  
,lpc_load_profile as LoadProfileID  
,tc.lpc_tariff_code_value as TariffCodeCode   
,por.lpc_Tariff_Code as TariffCodeID  
,lpc_is_por_offered as IsPOROffered  
,lpc_is_por_participated as IsPORParticipated  
,lpc_por_recourse as PORRecourseID  
,Case when lpc_por_recourse = '924030000' then 'Non-Recourse'  
      when lpc_por_recourse = '924030001' then 'Recourse' END as PorRecourseName  
,lpc_is_por_eligible as IsPORAssurance  
,lpc_por_discount_rate as PorDiscountRate  
,lpc_por_flat_fee as PorFlatFee  
,lpc_por_discount_effective_date as PorDiscountEffectiveDate  
,lpc_por_discount_expiration_date as PorDiscountExpirationDate  
,'' as Inactive  
,por.CreatedByName as CreatedBy  
,'' as CreateDate  
,por.ModifiedByName as LastModifiedBy   
,'' as LastModifiedDate  
From Libertycrm_mscrm.dbo.lpc_purchase_of_receivable por  
inner JOIN Libertycrm_mscrm..lpc_Utility uc (nolock) ON por.lpc_utility = uc.lpc_utilityId  
left JOIN Libertycrm_mscrm..lpc_load_profile lp (nolock) ON por.lpc_load_profile = lp.lpc_load_profileId  
left JOIN Libertycrm_mscrm..lpc_rate_class rc (nolock) ON por.lpc_rate_class = rc.lpc_rate_classId  
left JOIN Libertycrm_mscrm..lpc_tariff_code tc (nolock) ON por.lpc_tariff_code = tc.lpc_tariff_codeId  
 WHERE  
  POR.lpc_por_discount_effective_date IS NOT NULL   
  AND POR.lpc_por_discount_effective_date <= @EffectiveDate  
  AND (POR.lpc_por_discount_expiration_date IS NULL OR POR.lpc_por_discount_expiration_date > @EffectiveDate)  
  AND UC.lpc_utility_id = @UtilityIdInt  
  AND  
  (  
   (  
    RTRIM(LTRIM(por.lpc_por_driver)) = '924030000' AND  
    -- RTRIM(LTRIM(PD.EnumValue)) = 0  
     LP.lpc_load_profile_code_value = @LoadProfile  
    AND @LoadProfile IS NOT NULL  
    AND LP.lpc_load_profile_code_value IS NOT NULL  
   )  
   OR   
   (  
    RTRIM(LTRIM(por.lpc_por_driver)) = '924030002' AND  
    -- RTRIM(LTRIM(PD.EnumValue)) = 1  
     TC.lpc_tariff_code_value = @TariffCode  
    AND @TariffCode IS NOT NULL  
    AND TC.lpc_tariff_code_value IS NOT NULL  
   )  
   OR   
   (  
    RTRIM(LTRIM(por.lpc_por_driver)) = '924030001' AND  
    -- RTRIM(LTRIM(PD.EnumValue)) = 2  
      RC.lpc_rate_class_code_value = @RateClass  
    AND @RateClass IS NOT NULL  
    AND RC.lpc_rate_class_code_value IS NOT NULL  
   )  
  )  
  
union all  
  
Select   
  
 lpc_purchase_of_receivableID as [ID]  
,por.lpc_Utility as UtilityCompanyID  
,uc.lpc_UtilityCode   
,por.lpc_por_driver as PorDriverId  
, Case When por.lpc_por_driver = '924030000' then 'Load Profile'   
       When por.lpc_por_driver = '924030001' then 'Rate Class'  
    When por.lpc_por_driver = '924030002' then 'Tariff Code' END as PorDriverName  
,rc.lpc_rate_class_code_value as RateClassCode  
,'' as RateClassID --,lpc_rate_Class as RateClassID  
,lp.lpc_load_profile_code_value as LoadProfileCode  
,lpc_load_profile as LoadProfileID  
,tc.lpc_tariff_code_value as TariffCodeCode   
,por.lpc_Tariff_Code as TariffCodeID  
,lpc_is_por_offered as IsPOROffered  
,lpc_is_por_participated as IsPORParticipated  
,lpc_por_recourse as PORRecourseID  
,Case when lpc_por_recourse = '924030000' then 'Non-Recourse'  
      when lpc_por_recourse = '924030001' then 'Recourse' END as PorRecourseName  
,lpc_is_por_eligible as IsPORAssurance  
,lpc_por_discount_rate as PorDiscountRate  
,lpc_por_flat_fee as PorFlatFee  
,lpc_por_discount_effective_date as PorDiscountEffectiveDate  
,lpc_por_discount_expiration_date as PorDiscountExpirationDate  
,'' as Inactive  
,por.CreatedByName as CreatedBy  
,'' as CreateDate  
,por.ModifiedByName as LastModifiedBy   
,'' as LastModifiedDate  
From Libertycrm_mscrm.dbo.lpc_purchase_of_receivable por  
inner JOIN Libertycrm_mscrm..lpc_Utility uc (nolock) ON por.lpc_utility = uc.lpc_utilityId  
left JOIN Libertycrm_mscrm..lpc_load_profile lp (nolock) ON por.lpc_load_profile = lp.lpc_load_profileId  
left JOIN Libertycrm_mscrm..lpc_rate_class rc (nolock) ON por.lpc_rate_class = rc.lpc_rate_classId  
left JOIN Libertycrm_mscrm..lpc_tariff_code tc (nolock) ON por.lpc_tariff_code = tc.lpc_tariff_codeId  
 WHERE  
  POR.lpc_por_discount_effective_date IS NOT NULL   
  AND POR.lpc_por_discount_effective_date <= @EffectiveDate  
  AND (POR.lpc_por_discount_expiration_date IS NULL OR POR.lpc_por_discount_expiration_date > @EffectiveDate)  
  AND UC.lpc_utility_id = @UtilityIdInt  
  AND  
  (  
   (  
    RTRIM(LTRIM(por.lpc_por_driver)) = '924030000' AND  
    -- RTRIM(LTRIM(PD.EnumValue)) = 0  
     LP.lpc_load_profile_code_value = @LoadProfile  
    AND @LoadProfile IS NOT NULL  
    AND LP.lpc_load_profile_code_value IS NOT NULL  
   )  
   OR   
   (  
    RTRIM(LTRIM(por.lpc_por_driver)) = '924030002' AND  
    -- RTRIM(LTRIM(PD.EnumValue)) = 1  
     TC.lpc_tariff_code_value = @TariffCode  
    AND @TariffCode IS NOT NULL  
    AND TC.lpc_tariff_code_value IS NOT NULL  
   )  
   OR   
   (  
    RTRIM(LTRIM(por.lpc_por_driver)) = '924030001' AND  
    -- RTRIM(LTRIM(PD.EnumValue)) = 2  
      RC.lpc_rate_class_code_value = @RateClass  
    AND @RateClass IS NOT NULL  
    AND RC.lpc_rate_class_code_value IS NOT NULL  
   )  
  )  
  
  
  
END
GO
