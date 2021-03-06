/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_SelectAfter]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_SelectAfter
 * Collect the result data for EDI, Enrollment Fixed and Enrollment Variable Process. 
 *  
 * History
 *******************************************************************************
 * 2014/04/01 - William Vilchez
 * Created.
 *******************************************************************************
 * <Date Modified,date,> - <Developer Name,,>
 * <Modification Description,,>
 *******************************************************************************
 */
CREATE procedure [dbo].[usp_RECONEDI_SelectAfter]
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_AsOfDate                                       date,
 @p_ProcessDate                                    datetime,
 @p_Process                                        char(01) = 'T')
as

set nocount on

begin try 

   select ReconID,
          ProcessType,
          ISO,
          AccountID,
          AccountType,
          Utility,
          AccountNumber,
          ContractID,
          ContractNumber,
          Term,
          Status,
          SubStatus,
          BeginDate,
          EndDate,
          ContractStartDate,
          ContractEndDate,
          ContractRateStart,
          ContractRateEnd,
          LastServiceStartDate,
          LastServiceEndDate,
          ServiceStartDate,
          ServiceEndDate,
          CriteriaStartDate,
          CriteriaEndDate,
          CriteriaStatus,
          SubmitDate,
          Zone,
          ContractStatusID,
          ProductID,
          ProductCategory,
          ProductSubCategory,
          RateID,
          Rate,
          IsContractedRate,
          PricingRequestID,
          BackToBack,
          AnnualUsage,
          InvoiceID,
          InvoiceFromDate,
          InvoiceToDate,
          OverlapType,
          OverlapDays,
          AsOfDate,
          ForecastType,
          ParentEnrollmentID
   from dbo.RECONEDI_EnrollmentFixed with (nolock)
   where ReconID                                   = @p_ReconID

   select ReconID,
          ProcessType,
          ISO,
          AccountID,
          AccountType,
          Utility,
          AccountNumber,
          ContractID,
          ContractNumber,
          Term,
          Status,
          SubStatus,
          BeginDate,
          EndDate,
          ContractStartDate,
          ContractEndDate,
          ContractRateStart,
          ContractRateEnd,
          LastServiceStartDate,
          LastServiceEndDate,
          ServiceStartDate,
          ServiceEndDate,
          CriteriaStartDate,
          CriteriaEndDate,
          CriteriaStatus,
          SubmitDate,
          Zone,
          ContractStatusID,
          ProductID,
          ProductCategory,
          ProductSubCategory,
          RateID,
          Rate,
          IsContractedRate,
          PricingRequestID,
          BackToBack,
          AnnualUsage,
          InvoiceID,
          InvoiceFromDate,
          InvoiceToDate,
          OverlapType,
          OverlapDays,
          AsOfDate,
          ProcessDate,
          ForecastType,
          ParentEnrollmentID
   from dbo.RECONEDI_EnrollmentVariable with (nolock)
   where ReconID                                   = @p_ReconID

   select ISO,
          [814_Key],
          LastEDI,
          LastAccountChanges
   from RECONEDI_ISOControl (nolock)
   where (ISO                                      = @p_ISO
   or     len(ltrim(rtrim(ISO)))                   = 0)

   select [814_Key],
          ISO,
          Esiid,
          UtilityCode,
          TdspDuns,
          TdspName,
          TransactionType,
          TransactionStatus,
          Direction,
          ChangeReason,
          ChangeDescription,
          TransactionDate,
          TransactionEffectiveDate,
          EsiIdStartDate,
          EsiIdEndDate,
          SpecialReadSwitchDate,
          EntityName,
          MeterNumber,
          PreviousESiId,
          LDCBillingCycle,
          TransactionSetId,
          TransactionSetControlNbr,
          TransactionSetPurposeCode,
          TransactionNbr,
          ReferenceNbr,
          CrDuns,
          CrName,
          ProcessFlag,
          ProcessDate,
          ServiceTypeCode1,
          ServiceType1,
          ServiceTypeCode2,
          ServiceType2,
          ServiceTypeCode3,
          ServiceType3,
          ServiceTypeCode4,
          ServiceType4,
          MaintenanceTypeCode,
          RejectCode,
          RejectReason,
          StatusCode,
          StatusReason,
          StatusType,
          CapacityObligation,
          TransmissionObligation,
          LBMPZone,
          PowerRegion,
          stationid,
          AssignId,
          Origin,
          AsOfDate,
          ReconProcessDate,
	      ReconID
   from dbo.RECONEDI_EDIPending with (nolock)

   select ISO,
          UtilityCode,
          Esiid,
          EsiidOld,
          ReconID
   from dbo.RECONEDI_AccountChangePending (nolock)
   where ReconID                                   = @p_ReconID

   select 0
   return 0

end try

begin catch

   declare @w_ErrorMessage                         varchar(200)

   select @w_ErrorMessage                          = substring(error_message(), 1, 200)

   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      99,
								      0

   exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                                  @p_ISO,
                                  @p_Utility,
                                  99,
			                      0,
							      'Error',
							      @w_ErrorMessage

   select -1
   return -1
end catch

set nocount off

GO
