USE [Workspace]
GO
/****** Object:  StoredProcedure [dbo].[usp_ISTA814EDIValidation_V1]    Script Date: 8/24/2015 8:32:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Procedure [dbo].[usp_ISTA814EDIValidation_V1]  --'02310423537001'
(
	@AccountNumber NVARCHAR(100),
	@AuditRunId NVARCHAR(100),
	@FromDate Datetime,
	@ToDate Datetime
)
AS
BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
-----Truncate table Workspace.dbo.AuditEdiAccountHistory;

------DECLARE @AccountNumber NVARCHAR(100) 
----------Declare @AuditRunId Int
----------DECLARE @FromDate Datetime
----------DECLARE @ToDate Datetime

------SET @AccountNumber = '02310423537001'


------Select top 1 @AuditRunId=ID,@FromDate=FromDate, @ToDate=Todate
------from Workspace.dbo.AuditRunEdiAccount with(nolock)
------order by Id desc

IF OBJECT_ID('tempdb..#ISTARecordForProcess') IS NOT NULL
	DROP TABLE #ISTARecordForProcess


CREATE TABLE #ISTARecordForProcess 
(
       Id INT IDENTITY(1,1) NOT NULL,
       EsiId Varchar(100) NOT NULL,
       [814_Key] INT,
       Service_Key INT,
       Name_Key INT,
       EntityName VARCHAR(100) NULL,
       TdspDuns VARCHAR(100) NULL,
       CapacityObligation VARCHAR(100) NULL,
       PreviousESiId VARCHAR(100) NULL,
       LDCBillingCycle VARCHAR(100) NULL,
       TransmissionObligation VARCHAR(100) NULL,
       LBMPZone VARCHAR(100) NULL,
       ProcessDate datetime NOT NULL,
       ActionCode VARCHAR(100) NULL,
       ServiceTypeCode1 VARCHAR(100) NULL,
       ServiceType1 VARCHAR(100) NULL,
       ServiceTypeCode2 VARCHAR(100) NULL,
       ServiceType2 VARCHAR(100) NULL,
       ServiceTypeCode3 Varchar(100) Null,
       ServiceType3 Varchar(100) Null,
	   ESPAccountNumber Varchar(100) Null,
	   BillType  Varchar(100) Null,
	   BillCalculator Varchar(100) Null,
	   ContactName  Varchar(100) Null,
	   ContactPhoneNbr1  Varchar(100) Null,
	   DistributionLossFactorCode    Varchar(100) Null,
	   SpecialReadSwitchDate  Datetime
) 
 


Insert Into #ISTARecordForProcess (EsiId,[814_Key],Service_Key,Name_Key,EntityName,TdspDuns,CapacityObligation ,PreviousESiId ,LDCBillingCycle ,TransmissionObligation ,
       LBMPZone ,ProcessDate , ActionCode ,ServiceTypeCode1 ,ServiceType1 ,ServiceTypeCode2 ,ServiceType2 ,ServiceTypeCode3 ,ServiceType3 ,ESPAccountNumber ,
	   BillType ,BillCalculator ,ContactName ,ContactPhoneNbr1 ,DistributionLossFactorCode ,SpecialReadSwitchDate )

SELECT  S.EsiId,h.[814_Key],S.Service_Key, N.Name_Key,N.EntityName,H.TdspDuns,S.CapacityObligation, S.PreviousEsiId,S.LDCBillingCycle,S.TransmissionObligation,
       S.LBMPZone,h.ProcessDate, H.ActionCode,S.ServiceTypeCode1,S.ServiceType1,S.ServiceTypeCode2,S.ServiceType2,S.ServiceTypeCode3,S.ServiceType3,S.EspAccountNumber,
       S.BillType,S.BillCalculator,N.ContactName,N.ContactPhoneNbr1,S.DistributionLossFactorCode,S.SpecialReadSwitchDate
FROM
       ISTA.dbo.tbl_814_Header (NOLOCK) H
       INNER JOIN ISTA.dbo.tbl_814_Name (NOLOCK) N
              ON H.[814_Key] = N.[814_Key]
       INNER JOIN ISTA.dbo.tbl_814_Service (NOLOCK) S
              ON S.[814_Key] = H.[814_Key]
WHERE
      S.EsiId=@AccountNumber  and 
	  H.ProcessDate between @FromDate and @ToDate
	  and not exists (select 1 from Workspace.dbo.AuditEdiAccountHistory (nolock) au where au.AuditRunEdiAccountId=@AuditRunId and au.IstaAccountNumber =S.EsiId)


		-- For EntityName
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Name','EntityName',EntityName,'Name_Key',Name_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(EntityName,'') <>''
		order by Name_Key Desc


		-- For TdspDuns
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Header','TdspDuns',TdspDuns,'[814_Key]',[814_Key],ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(TdspDuns,'')<>''
		order by [814_Key] Desc

		-- For CapacityObligation
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','CapacityObligation',CapacityObligation,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(CapacityObligation,'')<>''
		order by Service_Key Desc

		-- FOR Premise.Name_Key
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  
		top 1 @AuditRunId,IRP.EsiId,'Premise','NameKey',p.NameKey ,'PremId',P.PremID,IRP.ProcessDate,SUSER_NAME() 
		FROM  #ISTARecordForProcess (nolock) IRP
			   LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IRP.Service_Key = SM.Service_Key
			   LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
					  ON SM.MeterNumber = M.MeterNo
			   LEFT JOIN ISTA.dbo.Premise (NOLOCK) P
					  ON M.PremId = P.PremId
		Where  ISNULL(P.NameKey,'')<> ''
		order by IRP.ProcessDate desc,P.PremID desc
 

		-- For tbl_814_Service.PreviousESiId
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','PreviousESiId',PreviousEsiId ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(PreviousEsiId,'')<>''
		order by Service_Key Desc


		--tbl_814_Service_Meter.RateClass
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IRP.EsiId,'tbl_814_Service_Meter','RateClass',SM.RateClass ,'Meter_Key',SM.Meter_Key ,IRP.ProcessDate,SUSER_NAME() 
		FROM  #ISTARecordForProcess (nolock) IRP
		LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IRP.Service_Key = SM.Service_Key
		Where ISNULL(SM.RateClass,'')<> ''
		order by ProcessDate desc, SM.Meter_Key desc

		--tbl_814_Service_Meter.LoadProfile

		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IRP.EsiId,'tbl_814_Service_Meter','LoadProfile',SM.LoadProfile  ,'Meter_Key',SM.Meter_Key ,IRP.ProcessDate,SUSER_NAME() 
		FROM  #ISTARecordForProcess (nolock) IRP
		LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IRP.Service_Key = SM.Service_Key
		Where ISNULL(SM.LoadProfile,'')<> ''
		order by IRP.ProcessDate desc, SM.Meter_Key desc

		--tbl_814_Service_Meter.MeterNumber
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IRP.EsiId,'tbl_814_Service_Meter','MeterNumber',SM.MeterNumber   ,'Meter_Key',SM.Meter_Key ,IRP.ProcessDate,SUSER_NAME() 
		FROM  #ISTARecordForProcess (nolock) IRP
		LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IRP.Service_Key = SM.Service_Key
		Where ISNULL(SM.MeterNumber,'')<> ''
		order by IRP.ProcessDate desc, SM.Meter_Key desc


		--For tbl_814_Service_Meter.MeterType
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IRP.EsiId,'tbl_814_Service_Meter','MeterType',SM.MeterType   ,'Meter_Key',SM.Meter_Key ,IRP.ProcessDate,SUSER_NAME() 
		FROM  #ISTARecordForProcess (nolock) IRP
		LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IRP.Service_Key = SM.Service_Key
		Where ISNULL(SM.MeterType,'')<> ''
		order by IRP.ProcessDate desc, SM.Meter_Key desc



		-- For tbl_814_Service_Service.[LDCBillingCycle]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','LDCBillingCycle',LDCBillingCycle  ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(LDCBillingCycle,'')<>''
		order by Service_Key Desc


		-- For tbl_814_Service.[TransmissionObligation]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','TransmissionObligation',TransmissionObligation   ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(TransmissionObligation,'')<>''
		order by Service_Key Desc

		-- For tbl_814_Service.LBMPZone
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','LBMPZone',LBMPZone   ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(LBMPZone,'')<>''
		order by Service_Key Desc


		-- For tbl_814_Service.[ESPAccountNumber]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','ESPAccountNumber',ESPAccountNumber   ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(ESPAccountNumber,'')<>''
		order by Service_Key Desc


		-- For tbl_814_Service.[BillType]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','BillType',BillType ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(BillType,'')<>''
		order by Service_Key Desc



		-- For tbl_814_Service.[BillCalculator]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','BillCalculator',BillCalculator,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(BillCalculator,'')<>''
		order by Service_Key Desc



		-- For tbl_814_Service.DistributionLossFactorCode
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','DistributionLossFactorCode',DistributionLossFactorCode ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(DistributionLossFactorCode,'') <>''
		order by Service_Key Desc


		-- For tbl_814_Service.SpecialReadSwitchDate
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','SpecialReadSwitchDate',SpecialReadSwitchDate ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where SpecialReadSwitchDate is not Null and SpecialReadSwitchDate !='01/01/1900'
		order by Service_Key Desc

		-- For tbl_814_Service.SpecialReadSwitchDate for ICAP
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','SpecialReadSwitchDateIcap',SpecialReadSwitchDate ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where SpecialReadSwitchDate is not Null and SpecialReadSwitchDate !='01/01/1900'
		order by Service_Key Desc

		-- For tbl_814_Service.SpecialReadSwitchDate for TCAP
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','SpecialReadSwitchDateTcap',SpecialReadSwitchDate ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where SpecialReadSwitchDate is not Null and SpecialReadSwitchDate !='01/01/1900'
		order by Service_Key Desc

		--tbl_814_header.ActionCode
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Header','ActionCode',ActionCode ,'[814_Key]',[814_Key],ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(ActionCode,'')<> ''
		order by [814_Key] Desc

		-- tbl_814_Name.[ContactName]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Name','ContactName',ContactName ,'[Name_Key]',Name_Key ,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ISNULL(ContactName,'')<> ''
		order by Name_Key Desc

		-- tbl_814_Name.ContactPhoneNbr1
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Name','ContactPhoneNbr1',ContactPhoneNbr1 ,'[Name_Key]',Name_Key,ProcessDate,SUSER_NAME() 
		From #ISTARecordForProcess (nolock)
		where ContactPhoneNbr1 is not Null and ContactPhoneNbr1 <> ''
		order by Name_Key Desc


		-- Address.Email
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IPR.EsiId,'Address','Email',A.Email ,'AddrID',A.AddrID ,IPR.ProcessDate,SUSER_NAME() 
		FROM   #ISTARecordForProcess (nolock) IPR
			   LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IPR.Service_Key = SM.Service_Key
			   LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
					  ON SM.MeterNumber = M.MeterNo
			   LEFT JOIN ISTA.dbo.Premise (NOLOCK) P
					  ON M.PremId = P.PremId
			   LEFT JOIN ISTA.dbo.Address (NOLOCK) A
					  ON M.AddrId = A.AddrId AND P.AddrId = A.AddrId
		Where ISNULL(A.Email,'')<> ''
		order by IPR.ProcessDate desc,A.AddrID desc


		-- Address.HomePhone
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IPR.EsiId,'Address','HomePhone',A.HomePhone ,'AddrID',A.AddrID ,IPR.ProcessDate,SUSER_NAME() 
		FROM   #ISTARecordForProcess (nolock) IPR
			   LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IPR.Service_Key = SM.Service_Key
			   LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
					  ON SM.MeterNumber = M.MeterNo
			   LEFT JOIN ISTA.dbo.Premise (NOLOCK) P
					  ON M.PremId = P.PremId
			   LEFT JOIN ISTA.dbo.Address (NOLOCK) A
					  ON M.AddrId = A.AddrId AND P.AddrId = A.AddrId
		Where ISNULL(A.HomePhone,'')<> ''
		order by IPR.ProcessDate desc,A.AddrID desc



		-- Address.WorkPhone
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IPR.EsiId,'Address','WorkPhone',A.WorkPhone ,'AddrID',A.AddrID ,IPR.ProcessDate,SUSER_NAME() 
		FROM   #ISTARecordForProcess (nolock) IPR
			   LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IPR.Service_Key = SM.Service_Key
			   LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
					  ON SM.MeterNumber = M.MeterNo
			   LEFT JOIN ISTA.dbo.Premise (NOLOCK) P
					  ON M.PremId = P.PremId
			   LEFT JOIN ISTA.dbo.Address (NOLOCK) A
					  ON M.AddrId = A.AddrId AND P.AddrId = A.AddrId
		Where ISNULL(A.WorkPhone,'')<> ''
		order by IPR.ProcessDate desc,A.AddrID desc

		-- Address.FaxPhone
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IPR.EsiId,'Address','FaxPhone',A.FaxPhone ,'AddrID',A.AddrID ,IPR.ProcessDate,SUSER_NAME() 
		FROM   #ISTARecordForProcess (nolock) IPR
			   LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IPR.Service_Key = SM.Service_Key
			   LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
					  ON SM.MeterNumber = M.MeterNo
			   LEFT JOIN ISTA.dbo.Premise (NOLOCK) P
					  ON M.PremId = P.PremId
			   LEFT JOIN ISTA.dbo.Address (NOLOCK) A
					  ON M.AddrId = A.AddrId AND P.AddrId = A.AddrId
		Where ISNULL(A.FaxPhone,'')<> ''
		order by IPR.ProcessDate desc,A.AddrID desc

		--AnnualUsage_EFL.AnnualUsage

		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IPR.EsiId,'AnnualUsage_EFL','AnnualUsage',AUE.AnnualUsage ,'EsiId',AUE.esiid ,IPR.ProcessDate,SUSER_NAME() 
		FROM
			   #ISTARecordForProcess (nolock) IPR
			   LEFT JOIN ISTA.dbo.AnnualUsage_EFL (NOLOCK) AUE
					  ON IPR.EsiId = AUE.EsiId
       
		Where ISNULL(AUE.AnnualUsage,'')<> ''
		order by IPR.ProcessDate desc

		-- tbl_814_Service_Status.[StatusCode]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IPR.EsiId,'tbl_814_Service_Status','StatusCode',SS.StatusCode ,'Status_Key',SS.Status_Key,IPR.ProcessDate,SUSER_NAME() 
		FROM #ISTARecordForProcess (nolock) IPR
			 LEFT JOIN ISTA.dbo.tbl_814_Service_Status (NOLOCK) SS ON IPR.Service_Key = SS.Service_Key
		Where ISNULL(SS.StatusCode,'')<> ''
		order by IPR.ProcessDate desc,SS.Status_Key desc


		-- LDC.[MarketCode]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IPR.EsiId,'LDC','MarketCode',L.MarketCode ,'LDCID',L.LDCID ,IPR.ProcessDate,SUSER_NAME() 
		FROM   #ISTARecordForProcess (nolock) IPR
			   LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IPR.Service_Key = SM.Service_Key
			   LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
					  ON SM.MeterNumber = M.MeterNo
			   LEFT JOIN ISTA.dbo.Premise (NOLOCK) P
					  ON M.PremId = P.PremId
			   LEFT JOIN ISTA.dbo.LDC (NOLOCK) L
					  ON P.LDCID = L.LDCID
		Where ISNULL(L.MarketCode,'')<> ''
		order by IPR.ProcessDate desc, L.LDCID desc



		-- LDC.[LDCShortName]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,IPR.EsiId,'LDC','LDCShortName',L.LDCShortName ,'LDCID',L.LDCID ,IPR.ProcessDate,SUSER_NAME() 
		FROM   #ISTARecordForProcess (nolock) IPR
			   LEFT JOIN ISTA.dbo.tbl_814_Service_Meter (NOLOCK) SM
					  ON IPR.Service_Key = SM.Service_Key
			   LEFT JOIN ISTA.dbo.Meter (NOLOCK) M
					  ON SM.MeterNumber = M.MeterNo
			   LEFT JOIN ISTA.dbo.Premise (NOLOCK) P
					  ON M.PremId = P.PremId
			   LEFT JOIN ISTA.dbo.LDC (NOLOCK) L
					  ON P.LDCID = L.LDCID
		Where ISNULL(L.LDCShortName,'') <> ''
		order by IPR.ProcessDate desc, L.LDCID desc

		---tbl_814_Service.[ServiceTypeCode1] + tbl_814_Service.[ServiceType1]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','ServiceTypeCode1_ServiceType1',RTRIM(LTRIM(IsNull(ServiceTypeCode1,'') + ISnull(ServiceType1,''))) ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		FROM  #ISTARecordForProcess (nolock) 
		Where ((ServiceTypeCode1 is not null and ServiceTypeCode1 <> '') or (ServiceType1 is not null and ServiceType1 <> ''))
		order by ProcessDate desc,Service_Key desc


		---tbl_814_Service.[ServiceTypeCode2] + tbl_814_Service.[ServiceType2]
		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','ServiceTypeCode2_ServiceType2',RTRIM(LTRIM(IsNull(ServiceTypeCode2,'') + ISnull(ServiceType2,''))),'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		FROM  #ISTARecordForProcess (nolock) 
		Where ((ServiceTypeCode2 is not null and ServiceTypeCode2 <> '') or (ServiceType2 is not null and ServiceType2 <> ''))
		order by ProcessDate desc,Service_Key desc


		--tbl_814_Service.[ServiceTypeCode3] + tbl_814_Service.[ServiceType3]

		Insert into Workspace.dbo.AuditEdiAccountHistory (AuditRunEdiAccountId,IstaAccountNumber,IstaTableName,IstaFieldName,IstaValue,IstaRecordFieldName,IstaRecordFieldValue,IstaRecordCreation,CreatedBy )
		Select  top 1 @AuditRunId,EsiId,'tbl_814_Service','ServiceTypeCode3_ServiceType3',RTRIM(LTRIM(IsNull(ServiceTypeCode3,'') + ISnull(ServiceType3,''))) ,'Service_Key',Service_Key,ProcessDate,SUSER_NAME() 
		FROM  #ISTARecordForProcess (nolock) 
		Where ((ServiceTypeCode3 is not null and ServiceTypeCode3 <> '') or (ServiceType3 is not null and ServiceType3 <> ''))
		order by ProcessDate desc,Service_Key desc


  
  
		IF OBJECT_ID('tempdb..#t1') IS NOT NULL
			DROP TABLE #t1

		Select  distinct EA.ID, EA.EdiFileLogID, EA.AccountNumber, EA.BillingAccountNumber, EA.CustomerName, EA.DunsNumber, EA.Icap, EA.NameKey, EA.PreviousAccountNumber,
		EA.RateClass, EA.LoadProfile, EA.BillGroup, EA.RetailMarketCode, EA.Tcap, EA.UtilityCode, EA.ZoneCode, EA.TimeStampInsert, EA.TimeStampUpdate,
		EA.TransactionType, EA.ServiceType, EA.ProductType, EA.ProductAltType, EA.EspAccountNumber, EA.AccountStatus, EA.BillingType,
		EA.BillCalculation, EA.ServicePeriodStart, EA.ServicePeriodEnd, EA.AnuualUsage, EA.MonthsToComputeKwh, EA.MeterType, EA.MeterMultiplier,
		EA.ContactName, EA.EmailAddress, EA.Telephone, EA.HomePhone, EA.Workphone, EA.Fax, EA.ServiceDeliveryPoint, EA.MeterNumber,
		EA.LossFactor, EA.Voltage, EA.LoadShapeId, EA.AccountType, EA.EffectiveDate, EA.NetMeterType, EA.IcapEffectiveDate, EA.TcapEffectiveDate,
		EA.DaysInArrears
		into #t1
		from lp_transactions.dbo.EdiAccount (nolock) EA 
		Inner Join lp_transactions.dbo.EdiFileLog (nolock) EdL On EA.EDiFileLogID = EdL.ID and FileType=0
		Inner Join Workspace.dbo.AuditEdiAccountHistory (nolock) AED on EA.AccountNumber=AED.IStaAccountNumber
		where --EA.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) 
		AED.IstaAccountNumber =@AccountNumber and AED.AuditRunEdiAccountId =@AuditRunId and
		EA.TimeStampInsert >= AED.ISTARecordCreation and EA.TimeStampInsert <= DATEADD (DD,2,AED.ISTARecordCreation ) 	

		
		--- EDIAccount Validation Logic for Each Field
		-- Cursor for validation Process



		Declare @ISTAFIELDNAME VARCHAR(200)
		Declare @EDIFIELDNAME VARCHAR(200)

		DECLARE Db_Cursor CURSOR FAST_FORWARD FOR
			Select ISTA814FieldName,EDIFieldName 
			from IstaEdiMapping (nolock)
			where Ista814FieldName NOT in('EsiId','SpecialReadSwitchDate')
		--	where Ista814FieldName NOT in('EsiId','SpecialReadSwitchDate','DistributionLossFactorCode')
			and Ista814FieldName IS not Null


		OPEN db_Cursor
		FETCH NEXT From db_Cursor INTO @ISTAFIELDNAME,@EDIFIELDNAME
		WHILE @@FETCH_STATUS =0
		BEGIN
		--Print @ISTAFIELDNAME
		--Print @EDIFIELDNAME
		DECLARE @QUERYPRINT VARCHAR(MAX)
		SET  @QUERYPRINT ='If Exists( Select 1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  and AED.IstaFieldName= '''+@ISTAFIELDNAME +''' and Convert(varchar,#t1.'+@EDIFIELDNAME+') = AED.ISTAVALUE
					where AED.AuditRunEdiAccountId = '+@AuditRunId+' and AED.IStaAccountNumber= '''+@AccountNumber+''' and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) ) Begin  Update AEAH  SET AEAH.LPEaSourceValue = #t1.'+@EDIFIELDNAME+', AEAH.LpESAccountNumber = #t1.AccountNumber, AEAH.LpEaSourceTableName = ''EdiAccount'', AEAH.LPEASourceFieldName =	'''+@EDIFIELDNAME+''', AEAH.LPEASourceRecordId = #t1.ID,
						AEAH.Comment = ''Matched'', AEAH.LastModifiedBy = SUSER_NAME()  From Workspace.dbo.AuditEdiAccountHistory  AEAH Left Join #t1 (nolock) on #t1.AccountNumber=AEAH.IStaAccountNumber  and AEAH.IstaFieldName= '''+@ISTAFIELDNAME +''' and Convert(varchar,#t1.'+@EDIFIELDNAME+') = AEAH.ISTAVALUE
						where AEAH.AuditRunEdiAccountId = '+@AuditRunId+' and AEAH.IStaAccountNumber='''+@AccountNumber+''' and #t1.TimeStampInsert Between AEAH.ISTARecordCreation and DATEADD (DD,2,AEAH.ISTARecordCreation )  END  Else If exists (Select  1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED  Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  and AED.IstaFieldName= '''+@ISTAFIELDNAME +'''
					where AED.AuditRunEdiAccountId = '+@AuditRunId+' and AED.IStaAccountNumber='''+@AccountNumber+''' and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) and ISNULL(Convert(varchar(200),#t1.'+@EDIFIELDNAME+'),'''')<>'''')	BEGIN  Declare @LPEaAccount varchar(200) , @LPEaFieldValue varchar(200) , @LPEaSourceRecordId varchar(200)
					Select  top 1 @LPEaAccount =#t1.AccountNumber , @LPEaFieldValue=#t1.'+@EDIFIELDNAME+', @LPEaSourceRecordId=#t1.ID  from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  and AED.IstaFieldName= '''+@ISTAFIELDNAME +'''
					where AED.AuditRunEdiAccountId = '+@AuditRunId+' and AED.IStaAccountNumber='''+@AccountNumber+''' and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation) and ISNULL(Convert(varchar(200),#t1.'+@EDIFIELDNAME+'),'''')<>''''
					Order By #t1.TimeStampInsert asc,#t1.ID asc Update Workspace.dbo.AuditEdiAccountHistory  SET LPEaSourceValue=@LPEaFieldValue, LpESAccountNumber = @LPEaAccount, LpEaSourceTableName= ''EdiAccount'', LPEASourceFieldName=	'''+@EDIFIELDNAME+''', LPEASourceRecordId=	@LPEaSourceRecordId,
				    Comment = ''Different Value in EdiAccount table than ISTA account'', LastModifiedBy = SUSER_NAME()  Where AuditRunEdiAccountId = '+@AuditRunId+' and IStaAccountNumber='''+@AccountNumber+''' and IstaFieldName='''+@ISTAFIELDNAME +''' END
					ELSE  BEGIN Declare @LPEaAccount1 varchar(200) , @LPEaFieldValue1 varchar(200) , @LPEaSourceRecordId1 varchar(200) ; Select  top 1 @LPEaAccount1 =#t1.AccountNumber , @LPEaFieldValue1=#t1.'+@EDIFIELDNAME+', @LPEaSourceRecordId1=#t1.ID  from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Inner Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  and AED.IstaFieldName= '''+@ISTAFIELDNAME +'''
					where AED.AuditRunEdiAccountId = '+@AuditRunId+' and AED.IStaAccountNumber='''+@AccountNumber+''' and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) and ISNULL(Convert(varchar(200),#t1.'+@EDIFIELDNAME+'),'''')=''''  Order By #t1.TimeStampInsert asc,#t1.ID asc 
					IF ISNULL(@LPEaSourceRecordId1 ,'''') != '''' BEGIN Update Workspace.dbo.AuditEdiAccountHistory  SET	LPEaSourceValue=@LPEaFieldValue1, LpESAccountNumber = @LPEaAccount1,LpEaSourceTableName= ''EdiAccount'',LPEASourceFieldName=	'''+@EDIFIELDNAME+''', LPEASourceRecordId=	@LPEaSourceRecordId1, Comment = ''EdiAccount record either have null or blank value'', LastModifiedBy = SUSER_NAME() Where AuditRunEdiAccountId = '+@AuditRunId+' and IStaAccountNumber='''+@AccountNumber+''' and IstaFieldName='''+@ISTAFIELDNAME +''' END END'

		EXECUTE(@QUERYPRINT)
		--print @QUERYPRINT
		FETCH NEXT from db_Cursor INTO @ISTAFIELDNAME,@EDIFIELDNAME

		END

		CLOSE db_cursor
		DEALLOCATE db_cursor	

/*Validation Logic for [ServiceType]*/

			If Exists( Select 1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
						and AED.IstaFieldName= 'ServiceTypeCode1_ServiceType1' and Convert(varchar,#t1.ServiceType) = AED.ISTAVALUE 
						where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber= @AccountNumber 
						and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) ) 
					Begin  
						Update AEAH  SET AEAH.LPEaSourceValue = #t1.ServiceType, AEAH.LpESAccountNumber = #t1.AccountNumber, AEAH.LpEaSourceTableName = 'EdiAccount', 
						AEAH.LPEASourceFieldName =	'ServiceType', AEAH.LPEASourceRecordId = #t1.ID,AEAH.Comment = 'Matched', AEAH.LastModifiedBy = SUSER_NAME()  
						From Workspace.dbo.AuditEdiAccountHistory  AEAH 
						Left Join #t1 (nolock) on #t1.AccountNumber=AEAH.IStaAccountNumber and AEAH.IstaFieldName= 'ServiceTypeCode1_ServiceType1' 
						and Convert(varchar,#t1.ServiceType) = AEAH.ISTAVALUE						
						where AEAH.AuditRunEdiAccountId = @AuditRunId and AEAH.IStaAccountNumber=@AccountNumber 
						and #t1.TimeStampInsert Between AEAH.ISTARecordCreation and DATEADD (DD,2,AEAH.ISTARecordCreation ) 
					END
				 Else If exists (Select  1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED  Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  and AED.IstaFieldName= 'ServiceTypeCode1_ServiceType1' 
					where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
					and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) and ISNULL(Convert(varchar(200),#t1.ServiceType),'')<>'')	
					BEGIN  
							Declare @LPEaAccount varchar(200) , @LPEaFieldValue varchar(200) , @LPEaSourceRecordId varchar(200)
							Select  top 1 @LPEaAccount =#t1.AccountNumber , @LPEaFieldValue=#t1.ServiceType, @LPEaSourceRecordId=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
							and AED.IstaFieldName= 'ServiceTypeCode1_ServiceType1'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation) 
							and ISNULL(Convert(varchar(200),#t1.ServiceType),'')<>''		
							Order By #t1.TimeStampInsert asc,#t1.ID asc 

							Update Workspace.dbo.AuditEdiAccountHistory  
							SET LPEaSourceValue=@LPEaFieldValue, LpESAccountNumber = @LPEaAccount, LpEaSourceTableName= 'EdiAccount', LPEASourceFieldName=	'ServiceType', 
							LPEASourceRecordId=	@LPEaSourceRecordId,Comment = 'Different Value in EdiAccount table than ISTA account', LastModifiedBy = SUSER_NAME()  
							Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='ServiceTypeCode1_ServiceType1' 
					END
					ELSE  
					BEGIN 
							Declare @LPEaAccount1 varchar(200) , @LPEaFieldValue1 varchar(200) , @LPEaSourceRecordId1 varchar(200)
							Select  top 1 @LPEaAccount1 =#t1.AccountNumber , @LPEaFieldValue1=#t1.ServiceType, @LPEaSourceRecordId1=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Inner Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
							and AED.IstaFieldName= 'ServiceTypeCode1_ServiceType1'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) 
							and ISNULL(Convert(varchar(200),#t1.ServiceType),'')=''	 
							Order By #t1.TimeStampInsert asc,#t1.ID asc 
							IF ISNULL(@LPEaSourceRecordId1 ,'') != ''  
							BEGIN 
								Update Workspace.dbo.AuditEdiAccountHistory  SET	LPEaSourceValue=@LPEaFieldValue1, LpESAccountNumber = @LPEaAccount1,
								LpEaSourceTableName= 'EdiAccount',LPEASourceFieldName=	'ServiceType',LPEASourceRecordId=	@LPEaSourceRecordId1, 
								Comment = 'EdiAccount record either have null or blank value', LastModifiedBy = SUSER_NAME() 
								Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='ServiceTypeCode1_ServiceType1' 
							END 
					END



/*Validation Logic for [ProductType]*/
					If Exists( Select 1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
						and AED.IstaFieldName= 'ServiceTypeCode2_ServiceType2' and Convert(varchar,#t1.ProductType) = AED.ISTAVALUE 
						where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber= @AccountNumber 
						and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) ) 
					Begin  
						Update AEAH  SET AEAH.LPEaSourceValue = #t1.ProductType, AEAH.LpESAccountNumber = #t1.AccountNumber, AEAH.LpEaSourceTableName = 'EdiAccount', 
						AEAH.LPEASourceFieldName =	'ProductType', AEAH.LPEASourceRecordId = #t1.ID,AEAH.Comment = 'Matched', AEAH.LastModifiedBy = SUSER_NAME()  
						From Workspace.dbo.AuditEdiAccountHistory  AEAH 
						Left Join #t1 (nolock) on #t1.AccountNumber=AEAH.IStaAccountNumber and AEAH.IstaFieldName= 'ServiceTypeCode2_ServiceType2' 
						and Convert(varchar,#t1.ProductType) = AEAH.ISTAVALUE						
						where AEAH.AuditRunEdiAccountId = @AuditRunId and AEAH.IStaAccountNumber=@AccountNumber 
						and #t1.TimeStampInsert Between AEAH.ISTARecordCreation and DATEADD (DD,2,AEAH.ISTARecordCreation ) 
					END
				 Else If exists (Select  1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED  Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
						and AED.IstaFieldName= 'ServiceTypeCode2_ServiceType2' 
					where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
					and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) and ISNULL(Convert(varchar(200),#t1.ProductType),'')<>'')	
					BEGIN  
							Declare @LPEaAccount3 varchar(200) , @LPEaFieldValue3 varchar(200) , @LPEaSourceRecordId3 varchar(200);
							Select  top 1 @LPEaAccount3 =#t1.AccountNumber , @LPEaFieldValue3=#t1.ProductType, @LPEaSourceRecordId3=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
							and AED.IstaFieldName= 'ServiceTypeCode2_ServiceType2'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation) 
							and ISNULL(Convert(varchar(200),#t1.ProductType),'')<>''		
							Order By #t1.TimeStampInsert asc,#t1.ID asc 

							Update Workspace.dbo.AuditEdiAccountHistory  
							SET LPEaSourceValue=@LPEaFieldValue3, LpESAccountNumber = @LPEaAccount3, LpEaSourceTableName= 'EdiAccount', LPEASourceFieldName=	'ProductType', 
							LPEASourceRecordId=	@LPEaSourceRecordId3,Comment = 'Different Value in EdiAccount table than ISTA account', LastModifiedBy = SUSER_NAME()  
							Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='ServiceTypeCode2_ServiceType2' 
					END
					ELSE  
					BEGIN 
							Declare @LPEaAccount4 varchar(200) , @LPEaFieldValue4 varchar(200) , @LPEaSourceRecordId4 varchar(200);
							Select  top 1 @LPEaAccount4 =#t1.AccountNumber , @LPEaFieldValue4=#t1.ProductType, @LPEaSourceRecordId4=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Inner Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
							and AED.IstaFieldName= 'ServiceTypeCode2_ServiceType2'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation )  
							and ISNULL(Convert(varchar(200),#t1.ProductType),'')=''	
							Order By #t1.TimeStampInsert asc,#t1.ID asc 
							IF ISNULL(@LPEaSourceRecordId4 ,'') != ''  
							BEGIN 
								Update Workspace.dbo.AuditEdiAccountHistory  SET	LPEaSourceValue=@LPEaFieldValue4, LpESAccountNumber = @LPEaAccount4,
								LpEaSourceTableName= 'EdiAccount',LPEASourceFieldName=	'ProductType',LPEASourceRecordId=	@LPEaSourceRecordId4, 
								Comment = 'EdiAccount record either have null or blank value', LastModifiedBy = SUSER_NAME() 
								Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='ServiceTypeCode2_ServiceType2' 
							END 
					END

/*Validation Logic for [ProductAltType]*/

If Exists( Select 1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
						and AED.IstaFieldName= 'ServiceTypeCode3_ServiceType3' and Convert(varchar,#t1.ProductAltType) = AED.ISTAVALUE 
						where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber= @AccountNumber 
						and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) ) 
					Begin  
						Update AEAH  SET AEAH.LPEaSourceValue = #t1.ProductAltType, AEAH.LpESAccountNumber = #t1.AccountNumber, AEAH.LpEaSourceTableName = 'EdiAccount', 
						AEAH.LPEASourceFieldName =	'ProductAltType', AEAH.LPEASourceRecordId = #t1.ID,AEAH.Comment = 'Matched', AEAH.LastModifiedBy = SUSER_NAME()  
						From Workspace.dbo.AuditEdiAccountHistory  AEAH 
						Left Join #t1 (nolock) on #t1.AccountNumber=AEAH.IStaAccountNumber and AEAH.IstaFieldName= 'ServiceTypeCode3_ServiceType3' 
						and Convert(varchar,#t1.ProductAltType) = AEAH.ISTAVALUE						
						where AEAH.AuditRunEdiAccountId = @AuditRunId and AEAH.IStaAccountNumber=@AccountNumber 
						and #t1.TimeStampInsert Between AEAH.ISTARecordCreation and DATEADD (DD,2,AEAH.ISTARecordCreation ) 
					END
				 Else If exists (Select  1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED  Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
						and AED.IstaFieldName= 'ServiceTypeCode3_ServiceType3' 
					where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
					and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) and ISNULL(Convert(varchar(200),#t1.ProductAltType),'')<>'')	
					BEGIN  
							Declare @LPEaAccount5 varchar(200) , @LPEaFieldValue5 varchar(200) , @LPEaSourceRecordId5 varchar(200);
							Select  top 1 @LPEaAccount5 =#t1.AccountNumber , @LPEaFieldValue5=#t1.ProductAltType, @LPEaSourceRecordId5=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
							and AED.IstaFieldName= 'ServiceTypeCode3_ServiceType3'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation) 
							and ISNULL(Convert(varchar(200),#t1.ProductAltType),'')<>''		
							Order By #t1.TimeStampInsert asc,#t1.ID asc 

							Update Workspace.dbo.AuditEdiAccountHistory  
							SET LPEaSourceValue=@LPEaFieldValue5, LpESAccountNumber = @LPEaAccount5, LpEaSourceTableName= 'EdiAccount', LPEASourceFieldName=	'ProductAltType', 
							LPEASourceRecordId=	@LPEaSourceRecordId5,Comment = 'Different Value in EdiAccount table than ISTA account', LastModifiedBy = SUSER_NAME()  
							Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='ServiceTypeCode3_ServiceType3' 
					END
					ELSE  
					BEGIN 
							Declare @LPEaAccount6 varchar(200) , @LPEaFieldValue6 varchar(200) , @LPEaSourceRecordId6 varchar(200);
							Select  top 1 @LPEaAccount6 =#t1.AccountNumber , @LPEaFieldValue6=#t1.ProductAltType, @LPEaSourceRecordId6=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Inner Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
							and AED.IstaFieldName= 'ServiceTypeCode3_ServiceType3'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) 
							and ISNULL(Convert(varchar(200),#t1.ProductAltType),'')='' 
							Order By #t1.TimeStampInsert asc,#t1.ID asc 
							IF ISNULL(@LPEaSourceRecordId6 ,'') != ''  
							BEGIN 
								Update Workspace.dbo.AuditEdiAccountHistory  SET	LPEaSourceValue=@LPEaFieldValue6, LpESAccountNumber = @LPEaAccount6,
								LpEaSourceTableName= 'EdiAccount',LPEASourceFieldName=	'ProductAltType',LPEASourceRecordId=	@LPEaSourceRecordId6, 
								Comment = 'EdiAccount record either have null or blank value', LastModifiedBy = SUSER_NAME() 
								Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='ServiceTypeCode3_ServiceType3' 
							END 
					END

/*Validation Logic for [EffectiveDate]*/

If Exists( Select 1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
						and AED.IstaFieldName= 'SpecialReadSwitchDate' and Convert(varchar,#t1.EffectiveDate) = AED.ISTAVALUE 
						where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber= @AccountNumber 
						and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) ) 
					Begin  
						Update AEAH  SET AEAH.LPEaSourceValue = #t1.EffectiveDate, AEAH.LpESAccountNumber = #t1.AccountNumber, AEAH.LpEaSourceTableName = 'EdiAccount', 
						AEAH.LPEASourceFieldName =	'EffectiveDate', AEAH.LPEASourceRecordId = #t1.ID,AEAH.Comment = 'Matched', AEAH.LastModifiedBy = SUSER_NAME()  
						From Workspace.dbo.AuditEdiAccountHistory  AEAH 
						Left Join #t1 (nolock) on #t1.AccountNumber=AEAH.IStaAccountNumber and AEAH.IstaFieldName= 'SpecialReadSwitchDate' 
						and Convert(varchar,#t1.EffectiveDate) = AEAH.ISTAVALUE						
						where AEAH.AuditRunEdiAccountId = @AuditRunId and AEAH.IStaAccountNumber=@AccountNumber 
						and #t1.TimeStampInsert Between AEAH.ISTARecordCreation and DATEADD (DD,2,AEAH.ISTARecordCreation ) 
					END
				 Else If exists (Select  1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED  Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
						and AED.IstaFieldName= 'SpecialReadSwitchDate' 
					where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
					and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) and ISNULL(Convert(varchar(200),#t1.EffectiveDate),'01/01/1900')<>'01/01/1900')	
					BEGIN  
							Declare @LPEaAccount7 varchar(200) , @LPEaFieldValue7 varchar(200) , @LPEaSourceRecordId7 varchar(200);
							Select  top 1 @LPEaAccount7 =#t1.AccountNumber , @LPEaFieldValue7=#t1.EffectiveDate, @LPEaSourceRecordId7=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
							and AED.IstaFieldName= 'SpecialReadSwitchDate'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation) 
							and ISNULL(Convert(varchar(200),#t1.EffectiveDate),'01/01/1900')<>'01/01/1900'	
							Order By #t1.TimeStampInsert asc,#t1.ID asc 

							Update Workspace.dbo.AuditEdiAccountHistory  
							SET LPEaSourceValue=@LPEaFieldValue7, LpESAccountNumber = @LPEaAccount7, LpEaSourceTableName= 'EdiAccount', LPEASourceFieldName=	'EffectiveDate', 
							LPEASourceRecordId=	@LPEaSourceRecordId7,Comment = 'Different Value in EdiAccount table than ISTA account', LastModifiedBy = SUSER_NAME()  
							Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='SpecialReadSwitchDate' 
					END
					ELSE  
					BEGIN 
							Declare @LPEaAccount8 varchar(200) , @LPEaFieldValue8 varchar(200) , @LPEaSourceRecordId8 varchar(200);
							Select  top 1 @LPEaAccount8 =#t1.AccountNumber , @LPEaFieldValue8=#t1.EffectiveDate, @LPEaSourceRecordId8=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Inner Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
							and AED.IstaFieldName= 'SpecialReadSwitchDate'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) 
							and ISNULL(Convert(varchar(200),#t1.EffectiveDate),'01/01/1900')<>'01/01/1900'
							Order By #t1.TimeStampInsert asc,#t1.ID asc 
							IF ISNULL(@LPEaSourceRecordId8 ,'') != ''  
							BEGIN 
								Update Workspace.dbo.AuditEdiAccountHistory  SET	LPEaSourceValue=@LPEaFieldValue8, LpESAccountNumber = @LPEaAccount8,
								LpEaSourceTableName= 'EdiAccount',LPEASourceFieldName=	'EffectiveDate',LPEASourceRecordId=	@LPEaSourceRecordId8, 
								Comment = 'EdiAccount record either have null or blank value', LastModifiedBy = SUSER_NAME() 
								Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='SpecialReadSwitchDate' 
							END 
					END
/*Validation Logic for [ICapEffectiveDate]*/
If Exists( Select 1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
						and AED.IstaFieldName= 'SpecialReadSwitchDateIcap' and Convert(varchar,#t1.IcapEffectiveDate) = AED.ISTAVALUE 
						where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber= @AccountNumber 
						and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) ) 
					Begin  
						Update AEAH  SET AEAH.LPEaSourceValue = #t1.IcapEffectiveDate, AEAH.LpESAccountNumber = #t1.AccountNumber, AEAH.LpEaSourceTableName = 'EdiAccount', 
						AEAH.LPEASourceFieldName =	'IcapEffectiveDate', AEAH.LPEASourceRecordId = #t1.ID,AEAH.Comment = 'Matched', AEAH.LastModifiedBy = SUSER_NAME()  
						From Workspace.dbo.AuditEdiAccountHistory  AEAH 
						Left Join #t1 (nolock) on #t1.AccountNumber=AEAH.IStaAccountNumber and AEAH.IstaFieldName= 'SpecialReadSwitchDateIcap' 
						and Convert(varchar,#t1.IcapEffectiveDate) = AEAH.ISTAVALUE						
						where AEAH.AuditRunEdiAccountId = @AuditRunId and AEAH.IStaAccountNumber=@AccountNumber 
						and #t1.TimeStampInsert Between AEAH.ISTARecordCreation and DATEADD (DD,2,AEAH.ISTARecordCreation ) 
					END
				 Else If exists (Select  1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED  Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
						and AED.IstaFieldName= 'SpecialReadSwitchDateIcap' 
					where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
					and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) and ISNULL(Convert(varchar(200),#t1.IcapEffectiveDate),'01/01/1900')<>'01/01/1900')	
					BEGIN  
							Declare @LPEaAccount9 varchar(200) , @LPEaFieldValue9 varchar(200) , @LPEaSourceRecordId9 varchar(200);
							Select  top 1 @LPEaAccount9 =#t1.AccountNumber , @LPEaFieldValue9=#t1.ProductAltType, @LPEaSourceRecordId9=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
							and AED.IstaFieldName= 'SpecialReadSwitchDateIcap'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation) 
							and ISNULL(Convert(varchar(200),#t1.IcapEffectiveDate),'01/01/1900')<>'01/01/1900'	
							Order By #t1.TimeStampInsert asc,#t1.ID asc 

							Update Workspace.dbo.AuditEdiAccountHistory  
							SET LPEaSourceValue=@LPEaFieldValue7, LpESAccountNumber = @LPEaAccount7, LpEaSourceTableName= 'EdiAccount', LPEASourceFieldName=	'IcapEffectiveDate', 
							LPEASourceRecordId=	@LPEaSourceRecordId7,Comment = 'Different Value in EdiAccount table than ISTA account', LastModifiedBy = SUSER_NAME()  
							Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='SpecialReadSwitchDateIcap' 
					END
					ELSE  
					BEGIN 
							Declare @LPEaAccount10 varchar(200) , @LPEaFieldValue10 varchar(200) , @LPEaSourceRecordId10 varchar(200);
							Select  top 1 @LPEaAccount10 =#t1.AccountNumber , @LPEaFieldValue10=#t1.IcapEffectiveDate, @LPEaSourceRecordId10=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Inner Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
							and AED.IstaFieldName= 'SpecialReadSwitchDateIcap'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) 
							and ISNULL(Convert(varchar(200),#t1.IcapEffectiveDate),'01/01/1900')<>'01/01/1900'
							Order By #t1.TimeStampInsert asc,#t1.ID asc 
							IF ISNULL(@LPEaSourceRecordId10 ,'') != ''  
							BEGIN 
								Update Workspace.dbo.AuditEdiAccountHistory  SET	LPEaSourceValue=@LPEaFieldValue10, LpESAccountNumber = @LPEaAccount10,
								LpEaSourceTableName= 'EdiAccount',LPEASourceFieldName=	'IcapEffectiveDate',LPEASourceRecordId=	@LPEaSourceRecordId10, 
								Comment = 'EdiAccount record either have null or blank value', LastModifiedBy = SUSER_NAME() 
								Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='SpecialReadSwitchDateIcap' 
							END 
					END
/*Validation Logic for [TCapEffectiveDate]*/
If Exists( Select 1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
						and AED.IstaFieldName= 'SpecialReadSwitchDateTcap' and Convert(varchar,#t1.TcapEffectiveDate) = AED.ISTAVALUE 
						where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber= @AccountNumber 
						and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) ) 
					Begin  
						Update AEAH  SET AEAH.LPEaSourceValue = #t1.TcapEffectiveDate, AEAH.LpESAccountNumber = #t1.AccountNumber, AEAH.LpEaSourceTableName = 'EdiAccount', 
						AEAH.LPEASourceFieldName =	'TcapEffectiveDate', AEAH.LPEASourceRecordId = #t1.ID,AEAH.Comment = 'Matched', AEAH.LastModifiedBy = SUSER_NAME()  
						From Workspace.dbo.AuditEdiAccountHistory  AEAH 
						Left Join #t1 (nolock) on #t1.AccountNumber=AEAH.IStaAccountNumber and AEAH.IstaFieldName= 'SpecialReadSwitchDateTcap' 
						and Convert(varchar,#t1.TcapEffectiveDate) = AEAH.ISTAVALUE						
						where AEAH.AuditRunEdiAccountId = @AuditRunId and AEAH.IStaAccountNumber=@AccountNumber 
						and #t1.TimeStampInsert Between AEAH.ISTARecordCreation and DATEADD (DD,2,AEAH.ISTARecordCreation ) 
					END
				 Else If exists (Select  1 from Workspace.dbo.AuditEdiAccountHistory (nolock) AED  Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
						and AED.IstaFieldName= 'SpecialReadSwitchDateTcap' 
					where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
					and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) and ISNULL(Convert(varchar(200),#t1.TcapEffectiveDate),'01/01/1900')<>'01/01/1900')	
					BEGIN  
							Declare @LPEaAccount11 varchar(200) , @LPEaFieldValue11 varchar(200) , @LPEaSourceRecordId11 varchar(200);
							Select  top 1 @LPEaAccount11 =#t1.AccountNumber , @LPEaFieldValue11=#t1.TcapEffectiveDate, @LPEaSourceRecordId11=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Left Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber  
							and AED.IstaFieldName= 'SpecialReadSwitchDateTcap'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation) 
							and ISNULL(Convert(varchar(200),#t1.TcapEffectiveDate),'01/01/1900')<>'01/01/1900'	
							Order By #t1.TimeStampInsert asc,#t1.ID asc 

							Update Workspace.dbo.AuditEdiAccountHistory  
							SET LPEaSourceValue=@LPEaFieldValue11, LpESAccountNumber = @LPEaAccount11, LpEaSourceTableName= 'EdiAccount', LPEASourceFieldName=	'TcapEffectiveDate', 
							LPEASourceRecordId=	@LPEaSourceRecordId11,Comment = 'Different Value in EdiAccount table than ISTA account', LastModifiedBy = SUSER_NAME()  
							Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='SpecialReadSwitchDateTcap' 
					END
					ELSE  
					BEGIN 
							Declare @LPEaAccount12 varchar(200) , @LPEaFieldValue12 varchar(200) , @LPEaSourceRecordId12 varchar(200);
							Select  top 1 @LPEaAccount12 =#t1.AccountNumber , @LPEaFieldValue12=#t1.TcapEffectiveDate, @LPEaSourceRecordId12=#t1.ID  
							from Workspace.dbo.AuditEdiAccountHistory (nolock) AED Inner Join #t1 (nolock) on #t1.AccountNumber=AED.IStaAccountNumber 
							and AED.IstaFieldName= 'SpecialReadSwitchDateTcap'
							where AED.AuditRunEdiAccountId = @AuditRunId and AED.IStaAccountNumber=@AccountNumber 
							and #t1.TimeStampInsert Between AED.ISTARecordCreation and DATEADD (DD,2,AED.ISTARecordCreation ) 
							and ISNULL(Convert(varchar(200),#t1.TcapEffectiveDate),'01/01/1900')<>'01/01/1900'
							Order By #t1.TimeStampInsert asc,#t1.ID asc 
							IF ISNULL(@LPEaSourceRecordId12 ,'') != ''  
							BEGIN 
								Update Workspace.dbo.AuditEdiAccountHistory  SET	LPEaSourceValue=@LPEaFieldValue12, LpESAccountNumber = @LPEaAccount12,
								LpEaSourceTableName= 'EdiAccount',LPEASourceFieldName=	'TcapEffectiveDate',LPEASourceRecordId=	@LPEaSourceRecordId12, 
								Comment = 'EdiAccount record either have null or blank value', LastModifiedBy = SUSER_NAME() 
								Where AuditRunEdiAccountId = @AuditRunId and IStaAccountNumber=@AccountNumber and IstaFieldName='SpecialReadSwitchDateTcap' 
							END 
					END 
SET NOCOUNT ON;
END






