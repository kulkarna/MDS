USE [DataSync]
GO

/****** Object:  StoredProcedure [dbo].[usp_DataSync_ServiceAccount_Updates__Collect_and_Apply]    Script Date: 10/26/2016 9:38:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[usp_DataSync_ServiceAccount_Updates__Collect_and_Apply]
	
/*        
 * PROCEDURE/FUNCTION/VIEW/TRIGGER:   usp_DataSync_ServiceAccount_Updates__Collect_and_Apply
 *        
 * DEFINITION:  
 *		This procedure collects via remote call the AccountPropertyHistory data from INT1\PROD.Libertypower DB
 *		and applies them to CRM lpc_Serviceaccount table saving previous values into a table in DB workspace.
 *
 *	 NOTE: on INT1\PROD: Grant execute on usp_DataSync_ServiceAccount_Updates to ENTAPP_DataSync_LS
 *        
 *        
 * REVISIONS:   2014-01-22  Luca Fagetti 	New
 *				2016-10-26	Abhi Kulkarni	Update only active accounts in CRM
 */
 
AS
 BEGIN
 
	Set NOCOUNT ON
	Set transaction isolation level read uncommitted

--	Collect/determine dates to be used as parameters for remote call

	Declare @FromUpdateDate datetime
	Declare @ToUpdateDate	datetime
	
	Select	@FromUpdateDate = LastReqEndDate
		,	@ToUpdateDate	= getdate()
	from 	datasync.dbo.dsSystem with (nolock)
	where 	SystemName = 'RepoMan'
	
	
	--drop table #usp_DataSync_ServiceAccount_Updates_output

	Create table #usp_DataSync_ServiceAccount_Updates_output  
	  (  
	   seqid int identity(1,1) primary key,  
	   [Key] VARCHAR(80) ,  
	   UtilityID VARCHAR(80) ,  
	   AccountNumber VARCHAR(50) ,  
	   FieldName VARCHAR(60) ,  
	   FieldValue VARCHAR(60) ,  
	   EffectiveDate DATETIME ,  
	   DateCreated DATETIME ,  
	   LockStatus VARCHAR(60)  
	  )


	--drop table #APH_to_CRM

	CREATE TABLE #APH_to_CRM
	(
		[CRMServiceAccountID] [uniqueidentifier] NULL,
		[UtilityID] [varchar](80) NULL,
		[AccountNumber] [varchar](50) NULL,
		[Zone] [varchar](60) NULL,
		[AccountType] [varchar](60) NULL,
		[Grid] [varchar](60) NULL,
		[Icap] [varchar](60) NULL,
		[LbmpZone] [varchar](60) NULL,
		[LoadProfile] [varchar](60) NULL,
		[LoadShapeId] [varchar](60) NULL,
		[LossFactor] [varchar](60) NULL,
		[MeterType] [varchar](60) NULL,
		[RateClass] [varchar](60) NULL,
		[ServiceClass] [varchar](60) NULL,
		[TariffCode] [varchar](60) NULL,
		[TCap] [varchar](60) NULL,
		[Utility] [varchar](60) NULL,
		[Voltage] [varchar](60) NULL
	) 


	
-- Execute remote call to collect the data

	insert into  #usp_DataSync_ServiceAccount_Updates_output
	exec ENTAPP_DataSync.libertypower.dbo.usp_DataSync_ServiceAccount_Updates  @FromUpdateDate = @FromUpdateDate, @ToUpdateDate = @ToUpdateDate

-- Process/pivot output

	Insert into #APH_to_CRM
	Select 
		null as CRMServiceAccountID,
		UtilityID as UtilityID,
		AccountNumber as AccountNumber,
		[Zone],
		[AccountType],
		[Grid],
		[Icap],
		[LbmpZone],
		[LoadProfile],
		[LoadShapeId],
		[LossFactor],
		[MeterType],
		[RateClass],
		[ServiceClass],
		[TariffCode],
		[TCap],
		[Utility],
		[Voltage]
	from
	(
		  select 
		  			UtilityID
		  		,	AccountNumber
		  		,	FieldName
		  		,	FieldValue 
		  from #usp_DataSync_ServiceAccount_Updates_output
		  where 1=1
		  and FieldName in 	(	'zone','Accounttype','Grid','Icap','LbmpZone','LoadProfile','LoadShapeId'
		  					,	'LossFactor','MeterType','RateClass','ServiceClass','TariffCode','TCap','Utility','Voltage'
		  					)
	) as SourceTbl
	PIVOT
	(
		  MAX(FieldValue)
		  for FieldName in 	(	[zone],[AccountType],[Grid],[Icap],[LbmpZone],[LoadProfile],[LoadShapeId]
		  					,	[LossFactor],[MeterType],[RateClass],[ServiceClass],[TariffCode],[TCap],[Utility],[Voltage]
		  					)
	) as pivottable;



-- Transform NULLs to ''

	UPDATE #APH_to_CRM 
	SET Grid		= case when ltrim(rtrim(Grid)) = ''			then null else Grid end
	, ICAP			= case when ltrim(rtrim(ICAP)) = ''			then null else ICAP end
	, LBMPZone		= case when ltrim(rtrim(LBMPZone)) = ''		then null else LBMPZone end
	, LoadProfile	= case when ltrim(rtrim(LoadProfile)) = ''	then null else LoadProfile end
	, LoadShapeId	= case when ltrim(rtrim(LoadShapeId)) = ''	then null else LoadShapeId end
	, LossFactor	= case when ltrim(rtrim(LossFactor)) = ''	then null else LossFactor end
	, RateClass		= case when ltrim(rtrim(RateClass)) = ''	then null else RateClass end
	, ServiceClass	= case when ltrim(rtrim(ServiceClass)) = '' then null else ServiceClass end
	, TariffCode	= case when ltrim(rtrim(TariffCode)) = ''	then null else TariffCode end
	, TCap			= case when ltrim(rtrim(TCap)) = ''			then null else TCap end
	, Voltage		= case when ltrim(rtrim(Voltage)) = ''		then null else TariffCode end
	, Zone			= case when ltrim(rtrim(Zone)) = ''			then null else Zone end


	Create clustered index cidx1 on  #APH_to_CRM (Utility, AccountNumber) with (fillfactor = 100, data_compression=page)

-- 	Add lpc_serviceaccountId 

	UPDATE 	aph
	SET 	CRMServiceAccountID = sab.lpc_serviceaccountId
	FROM 
			LIBERTYCRM_MSCRM..lpc_serviceaccountBase 	sab with (nolock)
	JOIN 	LIBERTYCRM_MSCRM..lpc_utility 						u  	with (nolock) 	ON sab.lpc_UtilityId = u.lpc_UtilityId
	JOIN 	#APH_to_CRM 										aph 				ON sab.lpc_AccountNumber COLLATE SQL_Latin1_General_CP1_CI_AS = aph.AccountNumber 
																					and aph.Utility = u.lpc_UtilityCode COLLATE SQL_Latin1_General_CP1_CI_AS

	Drop index #APH_to_CRM.cidx1

	Create clustered index cidx1 on  #APH_to_CRM (CRMServiceAccountID) with (fillfactor = 100, data_compression=page)

	Declare @BatchUTCDateTime datetime = getUTCDate()

-- workspace.dbo.SAbe_APH_update_audit is the table that will substitute the CRM audit to host previous values

	if not exists (select top 1 1 from workspace.sys.tables where name = 'SAbe_APH_update_audit')
		Create table workspace.dbo.SAbe_APH_update_audit
			(
					SAbeAPHupdateauditID 			int identity (1,1)
				,	BatchUTCDateTime	 			datetime not null
				,	lpc_serviceaccountId 			uniqueidentifier
				,	lpc_grid 						nvarchar(200)	NULL
				, 	lpc_icap 						decimal(23,10)	NULL
				, 	lpc_lbmp_zone 					nvarchar(510)	NULL
				, 	lpc_loadprofile 				nvarchar(200)	NULL
				, 	lpc_loadshapeid 				nvarchar(200)	NULL
				, 	lpc_lossfactor 					decimal(23,10)	NULL
				, 	lpc_rateclass 					nvarchar(200)	NULL
				, 	lpc_serviceclass 				nvarchar(200)	NULL
				, 	lpc_tariffcode 					nvarchar(200)	NULL
				, 	lpc_tcap						decimal(23,10)	NULL
				, 	lpc_voltage_text 				nvarchar(200)	NULL
				, 	lpc_zone 						nvarchar(100)	NULL
				CONSTRAINT PK_SAbe_APH_update_audit
							   PRIMARY KEY CLUSTERED (SAbeAPHupdateauditID)
							   WITH (Fillfactor = 100, data_compression = PAGE)
			)

-- Within same transaction
--	1. Update LIBERTYCRM_MSCRM..lpc_serviceaccountBase table
--	2. Save previous values to workspace.dbo.SAbe_APH_update_audit
--	3. Save new value for LastReqEndDate in datasync.dbo.dsSystem where SystemName = 'RepoMan'

	Begin Transaction

	Begin try

		UPDATE sab
		SET   	 lpc_grid = isnull(aph.Grid, lpc_grid)
			   , lpc_icap = isnull(aph.ICAP, lpc_icap)
			   , lpc_lbmp_zone = isnull(aph.LBMPZone, lpc_lbmp_zone)
			   , lpc_loadprofile = isnull(aph.LoadProfile, lpc_loadprofile)
			   , lpc_loadshapeid = isnull(aph.LoadShapeId, lpc_loadshapeid)
			   , lpc_lossfactor = isnull(aph.LossFactor, lpc_lossfactor)
			   , lpc_rateclass = isnull(aph.RateClass, lpc_rateclass)
			   , lpc_serviceclass = isnull(aph.ServiceClass, lpc_serviceclass)
			   , lpc_tariffcode = isnull(aph.TariffCode, lpc_tariffcode)
			   , lpc_tcap = isnull(aph.TCap,lpc_tcap)
			   , lpc_voltage_text = isnull(aph.Voltage, lpc_voltage_text)
			   , lpc_zone = isnull(aph.Zone, lpc_zone)
		OUTPUT	@BatchUTCDateTime 
			,	DELETED.lpc_serviceaccountId
			,	DELETED.lpc_grid
			,	DELETED.lpc_icap
			,	DELETED.lpc_lbmp_zone
			,	DELETED.lpc_loadprofile
			,	DELETED.lpc_loadshapeid
			,	DELETED.lpc_lossfactor
			,	DELETED.lpc_rateclass
			,	DELETED.lpc_serviceclass
			,	DELETED.lpc_tariffcode
			,	DELETED.lpc_tcap
			,	DELETED.lpc_voltage_text
			,	DELETED.lpc_zone
		INTO 
			workspace.dbo.SAbe_APH_update_audit
		FROM 
				LIBERTYCRM_MSCRM..lpc_serviceaccountBase 	sab 
		JOIN 	#APH_to_CRM 										aph ON sab.lpc_serviceaccountId = aph.CRMServiceAccountID		
		where sab.statuscode = 1 -- Update active accounts only --10/26/2016, Abhi Kulkarni


		Update 	DataSync.dbo.dsSystem
		SET		LastReqEndDate = @ToUpdateDate
		where 	SystemName = 'RepoMan'

	End Try
	Begin Catch

		DECLARE @ErrorMessage NVARCHAR(1000),
				@ErrorMessageText NVARCHAR(1000),
				@ErrorSeverity INT,
				@ErrorState INT,	
				@ErrorNumber int;

		SELECT  @ErrorNumber = ERROR_NUMBER(),
				@ErrorMessage = ERROR_MESSAGE(), 
				@ErrorMessageText = Case 
									  when ERROR_PROCEDURE() is  null then 'SQLError#: ' + convert(varchar,@ErrorNumber) + ', "' + ERROR_MESSAGE() + '"' + ', Sql in Procedure: ' + isnull(OBJECT_NAME(@@PROCID),'') + ', Line#: ' + convert(varchar,ERROR_LINE())
									  else 'SQLError#: ' + convert(varchar,@ErrorNumber) + ', "' + ERROR_MESSAGE() + '"' + ', Procedure: ' + isnull(ERROR_PROCEDURE(),'') + ', Line#: ' + convert(varchar,ERROR_LINE())
								   end,
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();


		if XACT_state() <> 0
			ROLLBACK TRANSACTION

    	RAISERROR (@ErrorMessageText, @ErrorSeverity, @ErrorState);
		
	End Catch

	if XACT_state() > 0
		Commit

	Set NOCOUNT OFF
 
 END 


GO


