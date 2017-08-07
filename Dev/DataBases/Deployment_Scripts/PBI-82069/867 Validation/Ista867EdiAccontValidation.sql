USE [Workspace]
GO

/****** Object:  StoredProcedure [dbo].[usp_Ista867EdiAccontValidation]    Script Date: 8/21/2015 11:56:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_Ista867EdiAccontValidation
 * Stored procedure to populate the table AuditEdiAccountHistory867tbl
 *
 * History

 *******************************************************************************
 * 08/21/2015 - Santosh Rao
 * Created.
 *******************************************************************************

 */
Create Procedure [dbo].[usp_Ista867EdiAccontValidation]
AS
BEGIN
BEGIN TRY
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @AuditRunId NVARCHAR(100)
DECLARE @FromDate Datetime
DECLARE @ToDate Datetime

Select top 1 @AuditRunId=ID,@FromDate=FromDate, @ToDate=Todate
from Workspace.dbo.AuditRunEdiAccount with(nolock)
order by Id desc

IF OBJECT_ID('tempdb..#ISTARecordFor867') IS NOT NULL
       DROP TABLE #ISTARecordFor867


CREATE TABLE #ISTARecordFor867 
(
       Id INT IDENTITY(1,1) NOT NULL,
       EsiId Varchar(100) NOT NULL,
       [867_Key] INT,
       TdspDuns VARCHAR(100) NULL,
       CapacityObligation VARCHAR(100) NULL,
       LDC_Rate_Class VARCHAR(100) NULL,
       Load_Profile VARCHAR(100) NULL,
       TransmissionObligation VARCHAR(100) NULL,
       Zone VARCHAR(100) NULL,
       ProcessDate datetime NOT NULL,
       ActionCode VARCHAR(100) NULL
	  
)

Insert into #ISTARecordFor867 ( EsiId,[867_Key],TdspDuns,CapacityObligation,LDC_Rate_Class,Load_Profile,TransmissionObligation,Zone,ProcessDate,ActionCode)
SELECT 
       H.EsiId,H.[867_Key],H.TdspDuns,D.Capacity_Obligation,D.LDC_Rate_Class,D.Load_Profile,D.Transmission_Obligation,D.Zone,H.ProcessDate,H.ActionCode
	  
FROM
       ISTA.dbo.tbl_867_Header (NOLOCK) H
       LEFT JOIN ISTA.dbo.tbl_867_ScheduleDeterminants (NOLOCK) D
              ON H.[867_Key] = D.[867_Key]
    
WHERE
      ISNULL(H.EsiId,'')<>'' AND 
	  H.ProcessDate between @FromDate and @ToDate
	  and not exists (select 1 from Workspace.dbo.AuditEdiAccountHistory867tbl (nolock) au where au.AuditRunEdiAccountId = @AuditRunId 
					   and au.IstaAccountNumber= H.EsiId )
	  
	  -- For tbl_867_header.ActionCode @AuditRunId
       Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_header','ActionCode',Isr.ActionCode,'[867_Key]',Isr.[867_Key],Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,ActionCode,[867_Key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc) RecordCode
				FROM #ISTARecordFor867 (nolock)
				where ISNULL(ActionCode,'')<>''
		) Isr where Isr.RecordCode =1 
              
	  -- For tbl_867_Header.[TdspDuns]  @AuditRunId
       Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_header','TdspDuns',Isr.TdspDuns,'[867_Key]',Isr.[867_Key],Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,TdspDuns,[867_Key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc) RecordCode
				FROM #ISTARecordFor867 (nolock)
				where ISNULL(TdspDuns,'')<>''
		) Isr where Isr.RecordCode =1 

		-- For tbl_867_ScheduleDeterminants.Capacity_Obligation  @AuditRunId
       Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_ScheduleDeterminants','Capacity_Obligation',Isr.CapacityObligation,'[867_Key]',Isr.[867_Key],Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,CapacityObligation,[867_Key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc) RecordCode
				FROM #ISTARecordFor867 (nolock)
				where ISNULL(CapacityObligation,'')<>''
		) Isr where Isr.RecordCode =1 

		-- For tbl_867_ScheduleDeterminants.LDC_Rate_Class  @AuditRunId
       Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_ScheduleDeterminants','LDC_Rate_Class',Isr.LDC_Rate_Class,'[867_Key]',Isr.[867_Key],Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,LDC_Rate_Class,[867_Key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc) RecordCode
				FROM #ISTARecordFor867 (nolock)
				where ISNULL(LDC_Rate_Class,'')<>''
		) Isr where Isr.RecordCode =1 

		
		-- For tbl_867_ScheduleDeterminants.Load_Profile  @AuditRunId
       Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_ScheduleDeterminants','Load_Profile',Isr.Load_Profile,'[867_Key]',Isr.[867_Key],Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,Load_Profile,[867_Key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc) RecordCode
				FROM #ISTARecordFor867 (nolock)
				where ISNULL(Load_Profile,'')<>''
		) Isr where Isr.RecordCode =1 

		-- For tbl_867_ScheduleDeterminants.TransmissionObligation  @AuditRunId
       Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_ScheduleDeterminants','TransmissionObligation',Isr.TransmissionObligation,'[867_Key]',Isr.[867_Key],Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,TransmissionObligation ,[867_Key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc) RecordCode
				FROM #ISTARecordFor867 (nolock)
				where ISNULL(TransmissionObligation,'')<>''
		) Isr where Isr.RecordCode =1 

		-- For tbl_867_ScheduleDeterminants.Zone  @AuditRunId
       Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_ScheduleDeterminants','Zone',Isr.Zone,'[867_Key]',Isr.[867_Key],Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,Zone ,[867_Key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc) RecordCode
				FROM #ISTARecordFor867 (nolock)
				where ISNULL(Zone,'')<>''
		) Isr where Isr.RecordCode =1 


-- Data Prepration for tbl_867_NonIntervalDetail,tbl_867_NonIntervalDetail_Qty

IF OBJECT_ID('tempdb..#ISTANonIntervalDetail') IS NOT NULL
       DROP TABLE #ISTANonIntervalDetail

Select T1.[867_Key],t1.EsiId,t1.ProcessDate,NID.NonIntervalDetail_Key,
CAST(NID.ServicePeriodStart as datetime) as 'ServicePeriodStart' ,
CAST(NID.ServicePeriodEnd as datetime) as 'ServicePeriodEnd', Q.MeterMultiplier,Q.TransformerLossFactor,
Q.NonIntervalDetailQty_Key --,NID.MeterNumber 
Into #ISTANonIntervalDetail
from #ISTARecordFor867 t1 (Nolock)
LEFT JOIN ISTA.dbo.tbl_867_NonIntervalDetail (NOLOCK) NID
              ON T1.[867_Key] = NID.[867_Key]
LEFT JOIN ISTA.dbo.tbl_867_NonIntervalDetail_Qty (NOLOCK) Q
              ON NID.NonIntervalDetail_key = q.NonIntervalDetail_key 
Where NID.NonIntervalDetail_key Is not Null

	-- For ISTA.dbo.tbl_867_NonIntervalDetail.ServicePeriodStart  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_NonIntervalDetail','ServicePeriodStart',Isr.ServicePeriodStart,'[NonIntervalDetail_key]',Isr.[NonIntervalDetail_key],Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,ServicePeriodStart ,[867_Key],[NonIntervalDetail_key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,NonIntervalDetail_key desc) RecordCode
				FROM #ISTANonIntervalDetail (nolock)
				where ISNULL(ServicePeriodStart,'01/01/1900')<>'01/01/1900'
		) Isr where Isr.RecordCode =1 

		-- For ISTA.dbo.tbl_867_NonIntervalDetail.ServicePeriodEnd  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_NonIntervalDetail','ServicePeriodEnd',Isr.ServicePeriodEnd,'NonIntervalDetail_key',Isr.[NonIntervalDetail_key],Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,ServicePeriodEnd ,[867_Key],[NonIntervalDetail_key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,NonIntervalDetail_key desc) RecordCode
				FROM #ISTANonIntervalDetail (nolock)
				where ISNULL(ServicePeriodEnd,'01/01/1900')<>'01/01/1900'
		) Isr where Isr.RecordCode =1 

/* MeterNumber need to get from Meter table  - As discussed with Paul

	-- For ISTA.dbo.tbl_867_NonIntervalDetail.MeterNumber  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_NonIntervalDetail','MeterNumber',Isr.MeterNumber,'NonIntervalDetail_key',Isr.[NonIntervalDetail_key],Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,MeterNumber ,[867_Key],[NonIntervalDetail_key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,NonIntervalDetail_key desc) RecordCode
				FROM #ISTANonIntervalDetail (nolock)
				where ISNULL(MeterNumber,'')<>''
		) Isr where Isr.RecordCode =1 
*/

		-- For ISTA.dbo.tbl_867_NonIntervalDetail_Qty.TransformerLossFactor  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_NonIntervalDetail_Qty','TransformerLossFactor',Isr.TransformerLossFactor,'NonIntervalDetailQty_Key',Isr.NonIntervalDetailQty_Key,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,TransformerLossFactor ,[867_Key],[NonIntervalDetail_key],NonIntervalDetailQty_Key,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,NonIntervalDetail_key desc,NonIntervalDetailQty_Key desc) RecordCode
				FROM #ISTANonIntervalDetail (nolock)
				where ISNULL(TransformerLossFactor,'')<>'' and NonIntervalDetailQty_Key is not null
		) Isr where Isr.RecordCode =1 

		-- For ISTA.dbo.tbl_867_NonIntervalDetail_Qty.MeterMultiplier  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_NonIntervalDetail_Qty','MeterMultiplier',Isr.MeterMultiplier,'NonIntervalDetailQty_Key',Isr.NonIntervalDetailQty_Key,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,MeterMultiplier ,[867_Key],[NonIntervalDetail_key],NonIntervalDetailQty_Key,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,NonIntervalDetail_key desc,NonIntervalDetailQty_Key desc) RecordCode
				FROM #ISTANonIntervalDetail (nolock)
				where ISNULL(MeterMultiplier,'')<>'' and NonIntervalDetailQty_Key is not null
		) Isr where Isr.RecordCode =1 


-- LDC Data
IF OBJECT_ID('tempdb..#ISTALDC') IS NOT NULL
       DROP TABLE #ISTALDC

Select  T1.[867_Key],t1.EsiId,t1.ProcessDate,L.LDCID,L.MarketCode,L.LDCShortName   
Into #ISTALDC
from #ISTARecordFor867 t1 (Nolock)
LEFT JOIN ISTA.dbo.tbl_867_NonIntervalDetail (NOLOCK) NID
              ON t1.[867_Key] = NID.[867_Key]
LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
              ON NID.MeterNumber = M.MeterNo
LEFT JOIN ISTA.dbo.Premise (NOLOCK) P
              ON M.PremId = P.PremId
LEFT JOIN ISTA.dbo.LDC (NOLOCK) L
              ON P.LDCID = L.LDCID
Where L.LDCID is not null


-- For ISTA.dbo.LDC.MarketCode  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'LDC','MarketCode',Isr.MarketCode,'LDCID',Isr.LDCID,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,MarketCode ,[867_Key],LDCID,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,LDCID desc) RecordCode
				FROM #ISTALDC (nolock)
				where ISNULL(MarketCode,'')<>'' 
		) Isr where Isr.RecordCode =1 


-- For ISTA.dbo.LDC.LDCShortName  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'LDC','LDCShortName',Isr.LDCShortName,'LDCID',Isr.LDCID,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,LDCShortName ,[867_Key],LDCID,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,LDCID desc) RecordCode
				FROM #ISTALDC (nolock)
				where ISNULL(LDCShortName,'')<>'' 
		) Isr where Isr.RecordCode =1 


-- Address Data
IF OBJECT_ID('tempdb..#ISTAAddress') IS NOT NULL
       DROP TABLE #ISTAAddress

Select  T1.[867_Key],t1.EsiId,t1.ProcessDate,A.AddrId,A.Email,A.HomePhone,A.WorkPhone,A.FaxPhone    
Into #ISTAAddress
from #ISTARecordFor867 t1 (Nolock)
	   LEFT JOIN ISTA.dbo.tbl_867_NonIntervalDetail (NOLOCK) NID
              ON T1.[867_Key] = NID.[867_Key]
       LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
              ON NID.MeterNumber = M.MeterNo
       LEFT JOIN ISTA.dbo.Premise (NOLOCK) P
              ON M.PremId = P.PremId
	LEFT JOIN ISTA.dbo.Address (NOLOCK) A
              ON M.AddrId = A.AddrId AND P.AddrId = A.AddrId
Where A.AddrId is not null

-- For ISTA.dbo.Address.Email  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'Address','Email',Isr.Email,'AddrId',Isr.AddrId,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,Email ,[867_Key],AddrId,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,AddrId desc) RecordCode
				FROM #ISTAAddress (nolock)
				where ISNULL(Email,'')<>'' 
		) Isr where Isr.RecordCode =1 

-- For ISTA.dbo.Address.HomePhone  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'Address','HomePhone',Isr.HomePhone,'AddrId',Isr.AddrId,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,HomePhone ,[867_Key],AddrId,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,AddrId desc) RecordCode
				FROM #ISTAAddress (nolock)
				where ISNULL(HomePhone,'')<>'' 
		) Isr where Isr.RecordCode =1 


-- For ISTA.dbo.Address.WorkPhone  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'Address','WorkPhone',Isr.WorkPhone,'AddrId',Isr.AddrId,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,WorkPhone ,[867_Key],AddrId,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,AddrId desc) RecordCode
				FROM #ISTAAddress (nolock)
				where ISNULL(WorkPhone,'')<>'' 
		) Isr where Isr.RecordCode =1 

-- For ISTA.dbo.Address.FaxPhone  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'Address','FaxPhone',Isr.FaxPhone,'AddrId',Isr.AddrId,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,FaxPhone ,[867_Key],AddrId,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,AddrId desc) RecordCode
				FROM #ISTAAddress (nolock)
				where ISNULL(FaxPhone,'')<>'' 
		) Isr where Isr.RecordCode =1 



-- Premise Data
IF OBJECT_ID('tempdb..#ISTAPremise') IS NOT NULL
       DROP TABLE #ISTAPremise

Select  T1.[867_Key],t1.EsiId,t1.ProcessDate,P.NameKey,P.ServiceDeliveryPoint,P.PremID
Into #ISTAPremise
from #ISTARecordFor867 t1 (Nolock)
	   LEFT JOIN ISTA.dbo.tbl_867_NonIntervalDetail (NOLOCK) NID
              ON T1.[867_Key] = NID.[867_Key]
       LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
              ON NID.MeterNumber = M.MeterNo
       LEFT JOIN ISTA.dbo.Premise (NOLOCK) P
              ON M.PremId = P.PremId
Where P.PremID is not null

-- For ISTA.dbo.ISTA.dbo.Premise.NameKey  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'Premise','NameKey',Isr.NameKey,'PremID',Isr.PremID,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,NameKey ,[867_Key],PremID,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,PremID desc) RecordCode
				FROM #ISTAPremise (nolock)
				where ISNULL(NameKey,'')<>'' 
		) Isr where Isr.RecordCode =1 

-- For ISTA.dbo.ISTA.dbo.Premise.ServiceDeliveryPoint  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'Premise','ServiceDeliveryPoint',Isr.ServiceDeliveryPoint,'PremID',Isr.PremID,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,ServiceDeliveryPoint ,[867_Key],PremID,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,PremID desc) RecordCode
				FROM #ISTAPremise (nolock)
				where ISNULL(ServiceDeliveryPoint,'')<>'' 
		) Isr where Isr.RecordCode =1 

-- tbl_867_UnmeterDetail
IF OBJECT_ID('tempdb..#ISTAUnmeterDetail') IS NOT NULL
       DROP TABLE #ISTAUnmeterDetail

Select T1.[867_Key],t1.EsiId,t1.ProcessDate,UM.UnmeterDetail_Key,UM.ServiceType 
Into #ISTAUnmeterDetail
from #ISTARecordFor867 t1 (Nolock)
LEFT JOIN ISTA.dbo.tbl_867_UnMeterDetail (NOLOCK) UM
              ON t1.[867_Key] = UM.[867_Key]
Where UM.UnmeterDetail_Key is not null

-- For ISTA.dbo.tbl_867_UnMeterDetail.ServiceType  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'tbl_867_UnMeterDetail','ServiceType',Isr.ServiceType,'UnmeterDetail_Key',Isr.UnmeterDetail_Key,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,ServiceType ,[867_Key],UnmeterDetail_Key,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,UnmeterDetail_Key desc) RecordCode
				FROM #ISTAUnmeterDetail (nolock)
				where ISNULL(ServiceType,'')<>'' 
		) Isr where Isr.RecordCode =1 


--- AnnualUsage_EFL

IF OBJECT_ID('tempdb..#ISTAAnnualUsage') IS NOT NULL
       DROP TABLE #ISTAAnnualUsage

Select T1.[867_Key],t1.EsiId,t1.ProcessDate,AUE.AnnualUsage
Into #ISTAAnnualUsage
from #ISTARecordFor867 t1 (Nolock)
LEFT JOIN ISTA.dbo.AnnualUsage_EFL (NOLOCK) AUE
              ON t1.EsiId = AUE.EsiId
Where AUE.ESiID is not null

-- For ISTA.dbo.tbl_867_UnMeterDetail.ServiceType  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'AnnualUsage_EFL','AnnualUsage',Isr.AnnualUsage,'EsiId',Isr.EsiId,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,AnnualUsage ,[867_Key],ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc) RecordCode
				FROM #ISTAAnnualUsage (nolock)
				where ISNULL(convert(varchar(200),AnnualUsage),'')<>'' 
		) Isr where Isr.RecordCode =1 

-- Meter.MeterNo
IF OBJECT_ID('tempdb..#ISTAMeter') IS NOT NULL
       DROP TABLE #ISTAMeter

Select  T1.[867_Key],t1.EsiId,t1.ProcessDate,M.MeterID,M.MeterNo
Into #ISTAMeter
from #ISTARecordFor867 t1 (Nolock)
	   LEFT JOIN ISTA.dbo.tbl_867_NonIntervalDetail (NOLOCK) NID
              ON T1.[867_Key] = NID.[867_Key]
       LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
              ON NID.MeterNumber = M.MeterNo
Where M.MeterID is not null

-- For ISTA.dbo.ISTA.dbo.Premise.NameKey  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'Meter','MeterNo',Isr.MeterNo,'MeterID',Isr.MeterID,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,MeterNo ,[867_Key],MeterID,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,MeterID desc) RecordCode
				FROM #ISTAMeter (nolock)
				where ISNULL(MeterNo,'')<>'' 
		) Isr where Isr.RecordCode =1 


-- Usage.LoadShapedId
IF OBJECT_ID('tempdb..#ISTAUsage') IS NOT NULL
       DROP TABLE #ISTAUsage

Select  T1.[867_Key],t1.EsiId,t1.ProcessDate,U.AccountNumber,U.[867_Key] as'Usage867_key',U.LoadShapeID  
Into #ISTAUsage
from #ISTARecordFor867 t1 (Nolock)
	   LEFT JOIN ISTA.dbo.Usage (NOLOCK) U
              ON T1.[867_Key] =U.[867_Key] and t1.EsiId=U.AccountNumber
Where U.[867_Key] is not null

-- For ISTA.dbo.ISTA.dbo.Premise.NameKey  @AuditRunId
	   Insert into Workspace.dbo.AuditEdiAccountHistory867tbl (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
	   Select @AuditRunId,Isr.EsiId,'Usage','LoadShapeID',Isr.LoadShapeID,'[867_key]',Isr.Usage867_key,Isr.ProcessDate,SUSER_NAME() 
	   From (
				Select   EsiId,LoadShapeID ,[867_Key],Usage867_key,ProcessDate,ROW_NUMBER() over(PARTITION BY EsiId ORDER BY [867_Key] Desc,Usage867_key desc) RecordCode
				FROM #ISTAUsage (nolock)
				where ISNULL(LoadShapeID,'')<>'' 
		) Isr where Isr.RecordCode =1 


/* Validation Logic Start */

			IF OBJECT_ID('tempdb..#EDIAccount') IS NOT NULL
               DROP TABLE #EDIAccount

              Select  distinct EA.ID, EA.AccountNumber, EA.BillingAccountNumber, EA.CustomerName, EA.DunsNumber, EA.Icap, EA.NameKey, EA.PreviousAccountNumber,
              EA.RateClass, EA.LoadProfile, EA.BillGroup, EA.RetailMarketCode, EA.Tcap, EA.UtilityCode, EA.ZoneCode, EA.TimeStampInsert, EA.TimeStampUpdate,
              EA.TransactionType, EA.ServiceType, EA.ProductType, EA.ProductAltType, EA.EspAccountNumber, EA.AccountStatus, EA.BillingType,
              EA.BillCalculation, EA.ServicePeriodStart, EA.ServicePeriodEnd, EA.AnuualUsage, EA.MonthsToComputeKwh, EA.MeterType, EA.MeterMultiplier,
              EA.ContactName, EA.EmailAddress, EA.Telephone, EA.HomePhone, EA.Workphone, EA.Fax, EA.ServiceDeliveryPoint, EA.MeterNumber,
              EA.LossFactor, EA.Voltage, EA.LoadShapeId, EA.AccountType, EA.EffectiveDate, EA.NetMeterType, EA.IcapEffectiveDate, EA.TcapEffectiveDate,
              EA.DaysInArrears
             into #EDIAccount
              from lp_transactions.dbo.EdiAccount (nolock) EA 
              Inner Join lp_transactions.dbo.EdiFileLog (nolock) EdL On EA.EDiFileLogID = EdL.ID and FileType=1
              Inner Join Workspace.dbo.AuditEdiAccountHistory867tbl (nolock) AED on EA.AccountNumber=AED.IStaAccountNumber
              where AED.AuditRunEdiAccountId = @AuditRunId 
			  and EA.TimeStampInsert >= AED.ISTARecordCreation and EA.TimeStampInsert <= DATEADD (DD,2,AED.ISTARecordCreation )    

-- Validation For TdspDuns -->DunsNumber
/*Match Value Record Updation*/
-- Select  * from Workspace.dbo.AuditEdiAccountHistory867tbl where IstaFieldName='TdspDuns' and LpEaSourceValue is null

DECLARE @UpdateRecordDateTime datetime
DECLARE @USERMODIFIED Varchar(200)
Select @UpdateRecordDateTime=getdate(), @USERMODIFIED=SUSER_NAME(); 


UPDATE A
SET A.LpEaSourceFieldName	=	'TdspDuns',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.DunsNumber,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.DunsNumber
,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='TdspDuns' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.DunsNumber
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'TdspDuns',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.DunsNumber,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,EDIA.DunsNumber,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='TdspDuns' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.DunsNumber,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'TdspDuns',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.DunsNumber,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,EDIA.DunsNumber,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='TdspDuns' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.DunsNumber,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*LDCShortName --> UtilityCode*/

UPDATE A
SET A.LpEaSourceFieldName	=	'UtilityCode',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.UtilityCode,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.UtilityCode
,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='LDCShortName' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.UtilityCode
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'UtilityCode',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.UtilityCode,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.UtilityCode
,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='LDCShortName' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.UtilityCode,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'UtilityCode',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.UtilityCode,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,
EDIA.AccountNumber,EDIA.ID,EDIA.UtilityCode,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='LDCShortName' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.UtilityCode,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Premise.NameKey --> NameKey*/


UPDATE A
SET A.LpEaSourceFieldName	=	'NameKey',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.NameKey,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.NameKey
,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='NameKey' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.NameKey
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'NameKey',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.NameKey,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.NameKey
,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='NameKey' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.NameKey,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'NameKey',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.NameKey,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,
EDIA.AccountNumber,EDIA.ID,EDIA.NameKey,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='NameKey' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.NameKey,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1


/*tbl_867_ScheduleDeterminants.LDC_Rate_Class --> RateClass*/

UPDATE A
SET A.LpEaSourceFieldName	=	'RateClass',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.RateClass,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.RateClass
,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='LDC_Rate_Class' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.RateClass
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'RateClass',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.RateClass,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.RateClass
,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='LDC_Rate_Class' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.RateClass,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'RateClass',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.RateClass,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,
EDIA.AccountNumber,EDIA.ID,
EDIA.RateClass
,EDIA.TimeStampInsert
,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='LDC_Rate_Class' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.RateClass,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*tbl_867_ScheduleDeterminants.Load_Profile --> LoadProfile */

UPDATE A
SET A.LpEaSourceFieldName	=	'LoadProfile',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.LoadProfile,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.LoadProfile ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='Load_Profile' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.LoadProfile
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'LoadProfile',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.LoadProfile,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.LoadProfile,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Load_Profile' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.LoadProfile,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'LoadProfile',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.LoadProfile,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.LoadProfile ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Load_Profile' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.LoadProfile,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*LDC.[MarketCode]  --> RetailMarketCode*/

UPDATE A
SET A.LpEaSourceFieldName	=	'RetailMarketCode',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.RetailMarketCode,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.RetailMarketCode ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='MarketCode' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.RetailMarketCode
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/

UPDATE A
SET A.LpEaSourceFieldName	=	'RetailMarketCode',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.RetailMarketCode,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.RetailMarketCode,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='MarketCode' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.RetailMarketCode,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'RetailMarketCode',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.RetailMarketCode,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.RetailMarketCode,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='MarketCode' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.RetailMarketCode,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*tbl_867_ScheduleDeterminants.Zone  --> ZoneCode*/

UPDATE A
SET A.LpEaSourceFieldName	=	'ZoneCode',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ZoneCode,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ZoneCode ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='Zone' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.ZoneCode
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'ZoneCode',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ZoneCode,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ZoneCode,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Zone' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.ZoneCode,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'ZoneCode',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ZoneCode,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ZoneCode ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Zone' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.ZoneCode,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*tbl_867_header.ActionCode  --> TransactionType*/

UPDATE A
SET A.LpEaSourceFieldName	=	'TransactionType',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.TransactionType,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.TransactionType ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='ActionCode' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.TransactionType
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'TransactionType',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.TransactionType,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.TransactionType,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='ActionCode' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.TransactionType,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'TransactionType',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.TransactionType,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.TransactionType ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='ActionCode' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.TransactionType,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1


/*tbl_867_UnmeterDetail.ServiceType  --> ServiceType*/

UPDATE A
SET A.LpEaSourceFieldName	=	'ServiceType',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServiceType,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServiceType ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='ServiceType' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.ServiceType
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'ServiceType',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServiceType,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServiceType,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='ServiceType' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.ServiceType,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'ServiceType',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServiceType,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServiceType ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='ServiceType' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.ServiceType,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Address.Email  --> EmailAddress*/

UPDATE A
SET A.LpEaSourceFieldName	=	'EmailAddress',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.EmailAddress,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.EmailAddress ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='Email' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.EmailAddress
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'EmailAddress',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.EmailAddress,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.EmailAddress,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Email' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.EmailAddress,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'EmailAddress',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.EmailAddress,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.EmailAddress ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Email' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.EmailAddress,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Address.HomePhone  --> HomePhone*/

UPDATE A
SET A.LpEaSourceFieldName	=	'HomePhone',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.HomePhone,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.HomePhone ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='HomePhone' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.HomePhone
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'HomePhone',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.HomePhone,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.HomePhone,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='HomePhone' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.HomePhone,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'HomePhone',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.HomePhone,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.HomePhone ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='HomePhone' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.HomePhone,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Address.WorkPhone  --> Workphone*/

UPDATE A
SET A.LpEaSourceFieldName	=	'Workphone',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Workphone,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Workphone ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='Workphone' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.Workphone
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/

UPDATE A
SET A.LpEaSourceFieldName	=	'Workphone',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Workphone,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Workphone,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Workphone' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.Workphone,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'Workphone',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Workphone,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Workphone ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Workphone' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.Workphone,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/* Address.FaxPhone --> Fax */

UPDATE A
SET A.LpEaSourceFieldName	=	'Fax',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Fax,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Fax ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='FaxPhone' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.Fax
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'Fax',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Fax,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Fax,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='FaxPhone' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.Fax,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'Fax',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Fax,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Fax ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='FaxPhone' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.Fax,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Premise.ServiceDeliveryPoint --> ServiceDeliveryPoint */

UPDATE A
SET A.LpEaSourceFieldName	=	'ServiceDeliveryPoint',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServiceDeliveryPoint,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServiceDeliveryPoint ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='ServiceDeliveryPoint' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.ServiceDeliveryPoint
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'ServiceDeliveryPoint',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServiceDeliveryPoint,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServiceDeliveryPoint,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='ServiceDeliveryPoint' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.ServiceDeliveryPoint,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'ServiceDeliveryPoint',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServiceDeliveryPoint,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServiceDeliveryPoint ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='ServiceDeliveryPoint' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.ServiceDeliveryPoint,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Meter.MeterNo  --> MeterNumber */
UPDATE A
SET A.LpEaSourceFieldName	=	'MeterNumber',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.MeterNumber,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.MeterNumber ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='MeterNo' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.MeterNumber
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'MeterNumber',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.MeterNumber,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.MeterNumber,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='MeterNo' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.MeterNumber,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'MeterNumber',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.MeterNumber,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.MeterNumber ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='MeterNo' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.MeterNumber,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Usage.LoadShapeId  ---> LoadShapeId*/

UPDATE A
SET A.LpEaSourceFieldName	=	'LoadShapeId',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.LoadShapeId,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.LoadShapeId ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='LoadShapeId' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=EDIA.LoadShapeId
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'LoadShapeId',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.LoadShapeId,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.LoadShapeId,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='LoadShapeId' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.LoadShapeId,'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'LoadShapeId',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.LoadShapeId,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.LoadShapeId ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='LoadShapeId' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.LoadShapeId,'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*tbl_867_NonIntervalDetail_Qty.TransformerLossFactor  --->LossFactor*/

UPDATE A
SET A.LpEaSourceFieldName	=	'LossFactor',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.LossFactor,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.LossFactor ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='TransformerLossFactor' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=Convert(varchar(200),EDIA.LossFactor)
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'LossFactor',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.LossFactor,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.LossFactor,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='TransformerLossFactor' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(200),EDIA.LossFactor),'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'LossFactor',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.LossFactor,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.LossFactor ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='TransformerLossFactor' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(100),EDIA.LossFactor),'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*tbl_867_NonIntervalDetail_Qty.MeterMultiplier ---> MeterMultiplier*/
UPDATE A
SET A.LpEaSourceFieldName	=	'MeterMultiplier',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.MeterMultiplier,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.MeterMultiplier ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='MeterMultiplier' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=Convert(varchar(200),EDIA.MeterMultiplier)
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'MeterMultiplier',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.MeterMultiplier,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.MeterMultiplier,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='MeterMultiplier' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(200),EDIA.MeterMultiplier),'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'MeterMultiplier',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.MeterMultiplier,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.MeterMultiplier ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='MeterMultiplier' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(100),EDIA.MeterMultiplier),'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1


/*AnnualUsage_EFL.AnnualUsage ---> AnuualUsage*/
UPDATE A
SET A.LpEaSourceFieldName	=	'AnuualUsage',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.AnuualUsage,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.AnuualUsage ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='AnuualUsage' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=Convert(varchar(100),EDIA.AnuualUsage)
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'AnuualUsage',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.AnuualUsage,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.AnuualUsage,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='AnuualUsage' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(100),EDIA.AnuualUsage),'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'AnuualUsage',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.AnuualUsage,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.AnuualUsage ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='AnuualUsage' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(100),EDIA.AnuualUsage),'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*tbl_867_ScheduleDeterminants.Capacity_Obligation ---> Icap*/

UPDATE A
SET A.LpEaSourceFieldName	=	'Icap',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Icap,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Icap ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='Capacity_Obligation' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=Convert(varchar(100),EDIA.Icap)
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'Icap',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Icap,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Icap,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Capacity_Obligation' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(100),EDIA.Icap),'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'Icap',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Icap,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Icap ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Capacity_Obligation' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(100),EDIA.Icap),'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*tbl_867_ScheduleDeterminants.Transmission_Obligation  --> Tcap*/

UPDATE A
SET A.LpEaSourceFieldName	=	'Tcap',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Tcap,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Tcap ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='Transmission_Obligation' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=Convert(varchar(100),EDIA.Tcap)
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'Tcap',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Tcap,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Tcap,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Transmission_Obligation' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(100),EDIA.Tcap),'')<>''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'Tcap',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.Tcap,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.Tcap ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='Transmission_Obligation' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(100),EDIA.Tcap),'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*tbl_867_NonIntervalDetail.ServicePeriodStart  --> ServicePeriodStart*/

UPDATE A
SET A.LpEaSourceFieldName	=	'ServicePeriodStart',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServicePeriodStart,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServicePeriodStart ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='ServicePeriodStart' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=Convert(varchar(100),EDIA.ServicePeriodStart)
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'ServicePeriodStart',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServicePeriodStart,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServicePeriodStart,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='ServicePeriodStart' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.ServicePeriodStart,'01/01/1900')<>'01/01/1900'
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/


UPDATE A
SET A.LpEaSourceFieldName	=	'ServicePeriodStart',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServicePeriodStart,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServicePeriodStart ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='ServicePeriodStart' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(100),EDIA.ServicePeriodStart),'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*tbl_867_NonIntervalDetail.ServicePeriodEnd  --> ServicePeriodEnd*/

UPDATE A
SET A.LpEaSourceFieldName	=	'ServicePeriodEnd',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServicePeriodEnd,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'EDIAccount Record Matched With ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime

From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(
Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServicePeriodEnd ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM   
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.IstaFieldName='ServicePeriodEnd' and Au.AuditRunEdiAccountId = @AuditRunId  
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD(DD,2,Au.ISTARecordCreation )  
and au.IstaValue=Convert(varchar(100),EDIA.ServicePeriodEnd)
) t1   On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1

/*Value not match but Record Exists with Different Value*/

UPDATE A
SET A.LpEaSourceFieldName	=	'ServicePeriodEnd',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServicePeriodEnd,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with Different value than ISTA table',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServicePeriodEnd,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='ServicePeriodEnd' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(EDIA.ServicePeriodEnd,'01/01/1900')<>'01/01/1900'
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
		
/*Value not match but Record Exists with Null And Blank Value*/
UPDATE A
SET A.LpEaSourceFieldName	=	'ServicePeriodEnd',
A.LpEaSourceRecordId		=	t1.ID,
A.LpEaSourceTableName		=	'EDIACCOUNT',
A.LpEaSourceValue			=	t1.ServicePeriodEnd,
A.LpESAccountNumber			=	t1.AccountNumber,
A.Comment					=	'Record Exits in EDIAccount Table with NULL or Blank Value',
A.LastModifiedBy			=	@USERMODIFIED,
A.LastModifiedDate			=	@UpdateRecordDateTime
From Workspace.dbo.AuditEdiAccountHistory867tbl  A
Inner Join
(	Select Au.IstaAccountNumber,Au.Id as 'AuditRecordId',Au.IstaValue,Au.ISTARecordCreation,EDIA.AccountNumber,EDIA.ID,
EDIA.ServicePeriodEnd ,ROW_NUMBER () OVER(Partition By Au.IstaAccountNumber order By EDIA.ID asc) RowNUM    
From Workspace.dbo.AuditEdiAccountHistory867tbl (Nolock) Au
LEFT JOIN #EDIAccount (Nolock) EDIA ON Au.IstaAccountNumber =EDIA.AccountNumber
Where  Au.AuditRunEdiAccountId = @AuditRunId 
and Au.IstaFieldName='ServicePeriodEnd' and au.LpEaSourceRecordId IS NULL 
and EDIA.TimeStampInsert Between Au.ISTARecordCreation and DATEADD (DD,2,Au.ISTARecordCreation )  
and ISNULL(Convert(varchar(100),EDIA.ServicePeriodEnd),'')=''
) t1 On t1.AccountNumber = A.IstaAccountNumber  and A.AuditRunEdiAccountId = @AuditRunId 
and A.id=t1.AuditRecordId  and t1.RowNUM=1
END TRY
BEGIN CATCH
SELECT ERROR_NUMBER() AS ErrorNumber
                     ,ERROR_SEVERITY() AS ErrorSeverity
                     ,ERROR_STATE() AS ErrorState
                     ,ERROR_PROCEDURE() AS ErrorProcedure
                     ,ERROR_LINE() AS ErrorLine
                     ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
SET NOCOUNT OFF;
END




GO


