CREATE TABLE [dbo].[vw_Utility] (
    [ID]                      INT           IDENTITY (1, 1) NOT NULL,
    [UtilityCode]             VARCHAR (50)  NOT NULL,
    [FullName]                VARCHAR (100) NOT NULL,
    [ShortName]               VARCHAR (50)  NOT NULL,
    [MarketID]                INT           NOT NULL,
    [DunsNumber]              VARCHAR (30)  NULL,
    [EntityId]                VARCHAR (15)  NULL,
    [EnrollmentLeadDays]      INT           NULL,
    [BillingType]             VARCHAR (15)  NULL,
    [AccountLength]           INT           NULL,
    [AccountNumberPrefix]     VARCHAR (10)  NULL,
    [LeadScreenProcess]       VARCHAR (15)  NULL,
    [DealScreenProcess]       VARCHAR (15)  NULL,
    [PorOption]               VARCHAR (3)   NULL,
    [Field01Label]            VARCHAR (20)  NULL,
    [Field01Type]             VARCHAR (30)  NULL,
    [Field02Label]            VARCHAR (20)  NULL,
    [Field02Type]             VARCHAR (30)  NULL,
    [Field03Label]            VARCHAR (20)  NULL,
    [Field03Type]             VARCHAR (30)  NULL,
    [Field04Label]            VARCHAR (20)  NULL,
    [Field04Type]             VARCHAR (30)  NULL,
    [Field05Label]            VARCHAR (20)  NULL,
    [Field05Type]             VARCHAR (30)  NULL,
    [Field06Label]            VARCHAR (20)  NULL,
    [Field06Type]             VARCHAR (30)  NULL,
    [Field07Label]            VARCHAR (20)  NULL,
    [Field07Type]             VARCHAR (30)  NULL,
    [Field08Label]            VARCHAR (20)  NULL,
    [Field08Type]             VARCHAR (30)  NULL,
    [Field09Label]            VARCHAR (20)  NULL,
    [Field09Type]             VARCHAR (30)  NULL,
    [Field10Label]            VARCHAR (20)  NULL,
    [Field10Type]             VARCHAR (30)  NULL,
    [DateCreated]             DATETIME      NULL,
    [UserName]                NCHAR (200)   NULL,
    [InactiveInd]             CHAR (1)      NULL,
    [ActiveDate]              DATETIME      NULL,
    [ChgStamp]                SMALLINT      NULL,
    [MeterNumberRequired]     SMALLINT      NULL,
    [MeterNumberLength]       SMALLINT      NULL,
    [AnnualUsageMin]          INT           NULL,
    [Qualifier]               VARCHAR (50)  NULL,
    [EdiCapable]              SMALLINT      NULL,
    [WholeSaleMktID]          VARCHAR (50)  NULL,
    [Phone]                   VARCHAR (30)  NULL,
    [RateCodeRequired]        TINYINT       NULL,
    [HasZones]                TINYINT       NULL,
    [ZoneDefault]             INT           NULL,
    [Field11Label]            VARCHAR (20)  NULL,
    [Field11Type]             VARCHAR (30)  NULL,
    [Field12Label]            VARCHAR (20)  NULL,
    [Field12Type]             VARCHAR (30)  NULL,
    [Field13Label]            VARCHAR (20)  NULL,
    [Field13Type]             VARCHAR (30)  NULL,
    [Field14Label]            VARCHAR (20)  NULL,
    [Field14Type]             VARCHAR (30)  NULL,
    [Field15Label]            VARCHAR (20)  NULL,
    [Field15Type]             VARCHAR (30)  NULL,
    [RateCodeFormat]          VARCHAR (20)  CONSTRAINT [DF_Utility_RateCodeFormat] DEFAULT ((0)) NOT NULL,
    [RateCodeFields]          VARCHAR (50)  CONSTRAINT [DF_Utility_RateCodeFields] DEFAULT ((0)) NOT NULL,
    [LegacyName]              VARCHAR (100) NOT NULL,
    [SSNIsRequired]           BIT           NULL,
    [PricingModeID]           INT           CONSTRAINT [DF_Utility_PricingModeID] DEFAULT ((1)) NULL,
    [isIDR_EDI_Capable]       BIT           NULL,
    [HU_RequestType]          NCHAR (10)    NULL,
    [MultipleMeters]          BIT           NULL,
    [MeterReadOverlap]        BIT           NULL,
    [AutoApproval]            BIT           NULL,
    [DeliveryLocationRefID]   INT           NULL,
    [DefaultProfileRefID]     INT           NULL,
    [SettlementLocationRefID] INT           NULL,
    CONSTRAINT [PK_EftUtility] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ndx_UtilityCodeMarketID]
    ON [dbo].[vw_Utility]([UtilityCode] ASC, [MarketID] ASC) WITH (FILLFACTOR = 90);


GO

-- =============================================================
-- Author		: Sheri Scott
-- Create date	: 06/25/2012
-- Description	: Insert audit row into audit table zAuditUtility
--					(Derived from zAuditAccountDelete)
-- =============================================================
CREATE TRIGGER [dbo].[zAuditUtilityDelete]
	ON  [dbo].[vw_Utility]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditUtility] (
		 [UtilityCode]	 		
		,[FullName]	 			
		,[ShortName]	 			
		,[MarketID]	 			
		,[DunsNumber]	 		
		,[EntityId]	 			
		,[EnrollmentLeadDays]	
		,[BillingType]	 		
		,[AccountLength]	 		
		,[AccountNumberPrefix]	
		,[LeadScreenProcess]	 	
		,[DealScreenProcess]	 	
		,[PorOption]	 			
		,[DateCreated]	 		
		,[UserName]	 			
		,[InactiveInd]	 		
		,[ActiveDate]	 		
		,[ChgStamp]	 			
		,[MeterNumberRequired]	
		,[MeterNumberLength]	 	
		,[AnnualUsageMin]	 	
		,[Qualifier]	 			
		,[EdiCapable]	 		
		,[WholeSaleMktID]	 	
		,[Phone]	 				
		,[RateCodeRequired]	 	
		,[HasZones]	 			
		,[ZoneDefault]	 		
		,[RateCodeFormat]	 	
		,[RateCodeFields]	 	
		,[LegacyName]	 		
		,[SSNIsRequired]	 		
		,[PricingModeID]	 		
		,[isIDR_EDI_Capable]	 	
		,[HU_RequestType]	 	
		,[MultipleMeters]	 	
		,[AuditChangeType]	 	
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		 [UtilityCode]	 		
		,[FullName]	 			
		,[ShortName]	 			
		,[MarketID]	 			
		,[DunsNumber]	 		
		,[EntityId]	 			
		,[EnrollmentLeadDays]	
		,[BillingType]	 		
		,[AccountLength]	 		
		,[AccountNumberPrefix]	
		,[LeadScreenProcess]	 	
		,[DealScreenProcess]	 	
		,[PorOption]	 			
		,[DateCreated]	 		
		,[UserName]	 			
		,[InactiveInd]	 		
		,[ActiveDate]	 		
		,[ChgStamp]	 			
		,[MeterNumberRequired]	
		,[MeterNumberLength]	 	
		,[AnnualUsageMin]	 	
		,[Qualifier]	 			
		,[EdiCapable]	 		
		,[WholeSaleMktID]	 	
		,[Phone]	 				
		,[RateCodeRequired]	 	
		,[HasZones]	 			
		,[ZoneDefault]	 		
		,[RateCodeFormat]	 	
		,[RateCodeFields]	 	
		,[LegacyName]	 		
		,[SSNIsRequired]	 		
		,[PricingModeID]	 		
		,[isIDR_EDI_Capable]	 	
		,[HU_RequestType]	 	
		,[MultipleMeters]	 	
		,'DEL'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM deleted
	
	SET NOCOUNT OFF;
END


GO

-- =============================================================
-- Author		: Sheri Scott
-- Create date	: 06/25/2012
-- Description	: Insert audit row into audit table zAuditUtility
--					(Derived from zAuditAccountInsert)
-- =============================================================
CREATE TRIGGER [dbo].[zAuditUtilityInsert]
	ON  [dbo].[vw_Utility]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditUtility] (
		 [UtilityCode]	 		
		,[FullName]	 			
		,[ShortName]	 			
		,[MarketID]	 			
		,[DunsNumber]	 		
		,[EntityId]	 			
		,[EnrollmentLeadDays]	
		,[BillingType]	 		
		,[AccountLength]	 		
		,[AccountNumberPrefix]	
		,[LeadScreenProcess]	 	
		,[DealScreenProcess]	 	
		,[PorOption]	 			
		,[DateCreated]	 		
		,[UserName]	 			
		,[InactiveInd]	 		
		,[ActiveDate]	 		
		,[ChgStamp]	 			
		,[MeterNumberRequired]	
		,[MeterNumberLength]	 	
		,[AnnualUsageMin]	 	
		,[Qualifier]	 			
		,[EdiCapable]	 		
		,[WholeSaleMktID]	 	
		,[Phone]	 				
		,[RateCodeRequired]	 	
		,[HasZones]	 			
		,[ZoneDefault]	 		
		,[RateCodeFormat]	 	
		,[RateCodeFields]	 	
		,[LegacyName]	 		
		,[SSNIsRequired]	 		
		,[PricingModeID]	 		
		,[isIDR_EDI_Capable]	 	
		,[HU_RequestType]	 	
		,[MultipleMeters]	 	
		,[AuditChangeType]	 	
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		 [UtilityCode]	 		
		,[FullName]	 			
		,[ShortName]	 			
		,[MarketID]	 			
		,[DunsNumber]	 		
		,[EntityId]	 			
		,[EnrollmentLeadDays]	
		,[BillingType]	 		
		,[AccountLength]	 		
		,[AccountNumberPrefix]	
		,[LeadScreenProcess]	 	
		,[DealScreenProcess]	 	
		,[PorOption]	 			
		,[DateCreated]	 		
		,[UserName]	 			
		,[InactiveInd]	 		
		,[ActiveDate]	 		
		,[ChgStamp]	 			
		,[MeterNumberRequired]	
		,[MeterNumberLength]	 	
		,[AnnualUsageMin]	 	
		,[Qualifier]	 			
		,[EdiCapable]	 		
		,[WholeSaleMktID]	 	
		,[Phone]	 				
		,[RateCodeRequired]	 	
		,[HasZones]	 			
		,[ZoneDefault]	 		
		,[RateCodeFormat]	 	
		,[RateCodeFields]	 	
		,[LegacyName]	 		
		,[SSNIsRequired]	 		
		,[PricingModeID]	 		
		,[isIDR_EDI_Capable]	 	
		,[HU_RequestType]	 	
		,[MultipleMeters]	 	
		,'INS'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM inserted
	
	SET NOCOUNT OFF;
END


GO

-- =============================================================
-- Author		: Sheri Scott
-- Create date	: 06/25/2012
-- Description	: Insert audit row into audit table zAuditUtility
--					(Derived from zAuditAccountUpdate)
--				: Made some modifications to the AccountUpdate 
--				: trigger to make it more efficient.
--    NOTE: The Paper Contract Only data element is stored in the 
--			UtilityPermission table so it would be audited in  
--			triggers on that table.
-- =============================================================
--Modified	: Added logic to set @UpdatedColumns to '' if it's null.
--By		: Sheri Scott
--Date		: 07/16/2012
-- =============================================================
--Modified	: Added AutoApproval column.
--By		: Sheri Scott
--Date		: 12/3/2012
-- =============================================================
--Modified	: Added check for no changed columns.
--By		: Jikku John
--Date		: 3/14/2013
-- =============================================================

CREATE TRIGGER [dbo].[zAuditUtilityUpdate]
	ON  [dbo].[vw_Utility]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @ColumnID			INT
	DECLARE @Columns			NVARCHAR(max)
	DECLARE @ObjectID			INT
	DECLARE @LastColumnID		INT
	DECLARE @ColumnsUpdated		VARCHAR(max)
	DECLARE @strColsUpdtd		VARBINARY
	DECLARE @ColumnsChanged		NVARCHAR(max)
					
	SET @ColumnID		= 1
	SET @ColumnsUpdated	= ''
	SET @ObjectID		= (SELECT id FROM sysobjects with (nolock) WHERE name='Utility')
	SET @LastColumnID	= (SELECT MAX(colid) FROM syscolumns with (nolock) WHERE id=@ObjectID)
	SET @strColsUpdtd	= COLUMNS_UPDATED();
	
	WHILE @ColumnID <= @LastColumnID
	BEGIN
		
		IF (SUBSTRING(@strColsUpdtd,(@ColumnID - 1) / 8 + 1, 1)) &
            POWER(2, (@ColumnID - 1) % 8) = POWER(2, (@ColumnID - 1) % 8)
		begin
			if @Columns is null
				SET @Columns = COL_NAME(@ObjectID, @ColumnID)
			else
				set @Columns = @Columns + ',' + COL_NAME(@ObjectID, @ColumnID)
		end
		set @ColumnID = @ColumnID + 1
	END

	IF @Columns IS NULL
		SET @ColumnsUpdated = ''
	ELSE
		SET @ColumnsUpdated = SUBSTRING(@Columns,1,LEN(@Columns)-1)
		
	
	SET @ColumnsChanged = 
	  (SELECT CASE WHEN isnull(a.[UtilityCode],0) <> isnull(b.[UtilityCode],0) 
			THEN 'UtilityCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[FullName],'') <> isnull(b.[FullName],'') 
			THEN 'FullName' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ShortName],'') <> isnull(b.[ShortName],'') 
			THEN 'ShortName' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MarketID],0) <> isnull(b.[MarketID],0) 
			THEN 'MarketID' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[DunsNumber],0) <> isnull(b.[DunsNumber],0) 
			THEN 'DunsNumber' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[EntityId],'') <> isnull(b.[EntityId],'') 
			THEN 'EntityId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[EntityID],'') <> isnull(b.[EntityID],'') 
			THEN 'EntityID' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[EnrollmentLeadDays],0) <> isnull(b.[EnrollmentLeadDays],0)
			THEN 'EnrollmentLeadDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[BillingType],0) <> isnull(b.[BillingType],0) 
			THEN 'BillingType' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountLength],0) <> isnull(b.[AccountLength],0) 
			THEN 'AccountLength' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountNumberPrefix],0) <> isnull(b.[AccountNumberPrefix],0) 
			THEN 'AccountNumberPrefix' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LeadScreenProcess],0) <> isnull(b.[LeadScreenProcess],0)
			THEN 'LeadScreenProcess' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[DealScreenProcess],0) <> isnull(b.[DealScreenProcess],0)
			THEN 'DealScreenProcess' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorOption],'') <> isnull(b.[PorOption],'') 
			THEN 'PorOption' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[DateCreated],0) <> isnull(b.[DateCreated],0) 
			THEN 'DateCreated' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserName],0) <> isnull(b.[UserName],0) 
			THEN 'UserName' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[InactiveInd],0) <> isnull(b.[InactiveInd],0) 
			THEN 'InactiveInd' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ActiveDate],'') <> isnull(b.[ActiveDate],'') 
			THEN 'ActiveDate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ChgStamp],'') <> isnull(b.[ChgStamp],'') 
			THEN 'ChgStamp' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterNumberRequired],'') <> isnull(b.[MeterNumberRequired],'') 
			THEN 'MeterNumberRequired' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterNumberLength],'') <> isnull(b.[MeterNumberLength],'') 
			THEN 'MeterNumberLength' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AnnualUsageMin],'') <> isnull(b.[AnnualUsageMin],'') 
			THEN 'AnnualUsageMin' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Qualifier],'') <> isnull(b.[Qualifier],'') 
			THEN 'Qualifier' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[EdiCapable],'') <> isnull(b.[EdiCapable],'') 
			THEN 'EdiCapable' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[WholeSaleMktID],'') <> isnull(b.[WholeSaleMktID],'') 
			THEN 'WholeSaleMktID' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Phone],0) <> isnull(b.[Phone],0) 
			THEN 'Phone' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateCodeRequired],0) <> isnull(b.[RateCodeRequired],0) 
			THEN 'RateCodeRequired' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[HasZones],'') <> isnull(b.[HasZones],'') 
			THEN 'HasZones' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ZoneDefault],0) <> isnull(b.[ZoneDefault],0) 
			THEN 'ZoneDefault' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateCodeFormat],'') <> isnull(b.[RateCodeFormat],'') 
			THEN 'RateCodeFormat' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateCodeFields],0) <> isnull(b.[RateCodeFields],0) 
			THEN 'RateCodeFields' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LegacyName],0) <> isnull(b.[LegacyName],0) 
			THEN 'LegacyName' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[SSNIsRequired],0) <> isnull(b.[SSNIsRequired],0) 
			THEN 'SSNIsRequired' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PricingModeID],0) <> isnull(b.[PricingModeID],0) 
			THEN 'PricingModeID' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[isIDR_EDI_Capable],0) <> isnull(b.[isIDR_EDI_Capable],0) 
			THEN 'isIDR_EDI_Capable' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[HU_RequestType],0) <> isnull(b.[HU_RequestType],0) 
			THEN 'HU_RequestType' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MultipleMeters],0) <> isnull(b.[MultipleMeters],0) 
			THEN 'MultipleMeters' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AutoApproval],0) <> isnull(b.[AutoApproval],0) 
			THEN 'AutoApproval' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	on b.[ID] = a.[ID])
	
	IF len(@ColumnsChanged) = 0
	BEGIN
		RETURN
	END
	
	SET @ColumnsChanged = SUBSTRING(@ColumnsChanged,1,LEN(@ColumnsChanged)-1)
 	
 INSERT INTO [dbo].[zAuditUtility] (
		 [UtilityCode]	 		
		,[FullName]	 			
		,[ShortName]	 			
		,[MarketID]	 			
		,[DunsNumber]	 		
		,[EntityId]	 			
		,[EnrollmentLeadDays]	
		,[BillingType]	 		
		,[AccountLength]	 		
		,[AccountNumberPrefix]	
		,[LeadScreenProcess]	 	
		,[DealScreenProcess]	 	
		,[PorOption]	 			
		,[DateCreated]	 		
		,[UserName]	 			
		,[InactiveInd]	 		
		,[ActiveDate]	 		
		,[ChgStamp]	 			
		,[MeterNumberRequired]	
		,[MeterNumberLength]	 	
		,[AnnualUsageMin]	 	
		,[Qualifier]	 			
		,[EdiCapable]	 		
		,[WholeSaleMktID]	 	
		,[Phone]	 				
		,[RateCodeRequired]	 	
		,[HasZones]	 			
		,[ZoneDefault]	 		
		,[RateCodeFormat]	 	
		,[RateCodeFields]	 	
		,[LegacyName]	 		
		,[SSNIsRequired]	 		
		,[PricingModeID]	 		
		,[isIDR_EDI_Capable]	 	
		,[HU_RequestType]	 	
		,[MultipleMeters]
		,[AutoApproval]	 	
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged]
		)
	SELECT 
		 a.[UtilityCode]	 		
		,a.[FullName]	 			
		,a.[ShortName]	 			
		,a.[MarketID]	 			
		,a.[DunsNumber]	 		
		,a.[EntityId]	 			
		,a.[EnrollmentLeadDays]	
		,a.[BillingType]	 		
		,a.[AccountLength]	 		
		,a.[AccountNumberPrefix]	
		,a.[LeadScreenProcess]	 	
		,a.[DealScreenProcess]	 	
		,a.[PorOption]	 			
		,a.[DateCreated]	 		
		,a.[UserName]	 			
		,a.[InactiveInd]	 		
		,a.[ActiveDate]	 		
		,a.[ChgStamp]	 			
		,a.[MeterNumberRequired]	
		,a.[MeterNumberLength]	 	
		,a.[AnnualUsageMin]	 	
		,a.[Qualifier]	 			
		,a.[EdiCapable]	 		
		,a.[WholeSaleMktID]	 	
		,a.[Phone]	 				
		,a.[RateCodeRequired]	 	
		,a.[HasZones]	 			
		,a.[ZoneDefault]	 		
		,a.[RateCodeFormat]	 	
		,a.[RateCodeFields]	 	
		,a.[LegacyName]	 		
		,a.[SSNIsRequired]	 		
		,a.[PricingModeID]	 		
		,a.[isIDR_EDI_Capable]	 	
		,a.[HU_RequestType]	 	
		,a.[MultipleMeters]	
		,a.[AutoApproval] 	
		,'UPD' --[AuditChangeType]
		,@ColumnsUpdated
		,@ColumnsChanged
		FROM inserted a
	INNER JOIN deleted b
	on b.[ID] = a.[ID]
	SET NOCOUNT OFF;
	
END


