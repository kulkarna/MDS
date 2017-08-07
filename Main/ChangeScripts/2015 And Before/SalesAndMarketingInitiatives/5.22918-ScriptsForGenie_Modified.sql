--Scripts for Genie Database
--//22918:Create a new web service to send a list of valid promo codes for the day to the tablet --Oct 25 2013
--3 new Tables created in Genie Database
--1. LK_PromotionCode
--2. ST_Qualifier
--3. T_Qualifier
--4. MOdify existing SP GetCompleteMasterData
--5.new stored Procedure  SPGenie_UpdateQualifiers
/********************************/
--Scripts for LibertyPower Database
--LibertyPowerDatabase
--1. usp_GetAllValidPromotionCodesforToday
--2. usp_GetAllValidQualifiersforToday
/****************************/
--Lp_Deal_Capture Database
--1. spGenie_GetQualifiersforToday
---------------------------------------------------------------------------------------------
--1.LK_PromotionCode
--------------------------------------------------------------------------------------------
USE [GENIE]
GO


--IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_AccountType]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
--ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_AccountType]
--GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_Brand]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_Brand]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_Market]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_Market]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_Partner]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_Partner]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_PromotionCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_PromotionCode]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_Utility]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_Utility]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_T_Qualifier_AutoApply]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [DF_T_Qualifier_AutoApply]
END

GO


/****** Object:  Table [dbo].[LK_PromotionCode]    Script Date: 10/25/2013 15:14:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LK_PromotionCode]') AND type in (N'U'))
DROP TABLE [dbo].[LK_PromotionCode]
GO

USE [GENIE]
GO

/****** Object:  Table [dbo].[LK_PromotionCode]    Script Date: 10/25/2013 15:14:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[LK_PromotionCode](
	[PromotionCodeID] [int] NOT NULL,
	[Code] [char](20) NOT NULL,
	[Description] [varchar](1000) NOT NULL,
	[MarketingDescription] [varchar](1000) NULL,
	[LegalDescription] [varchar](1000) NULL,
 CONSTRAINT [PK_LK_PromotionCode] PRIMARY KEY CLUSTERED 
(
	[PromotionCodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON,DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
----------------------------------------------------------------------------------------------------------
--2.ST_Qualifier
---------------------------------------------------------------------------------------------------------------
USE [GENIE]
GO

/****** Object:  Table [dbo].[ST_Qualifier]    Script Date: 10/25/2013 15:19:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ST_Qualifier]') AND type in (N'U'))
DROP TABLE [dbo].[ST_Qualifier]
GO

USE [GENIE]
GO

/****** Object:  Table [dbo].[ST_Qualifier]    Script Date: 10/25/2013 15:19:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ST_Qualifier](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionCodeID] [int] NOT NULL,
	[PartnerName] [varchar](50) NULL,
	[MarketName] [varchar](50) NULL,
	[UtilityName] [varchar](50) NULL,
	[AccountTypeDesc] [varchar](50) NULL,
	[ContractTerm] [int] NULL,
	[BrandDescription] [varchar](100) NULL,
	[SignStartDate] [datetime] NOT NULL,
	[SignEndDate] [datetime] NOT NULL,
	[ContractEffecStartPeriodStartDate] [datetime] NULL,
	[ContractEffecStartPeriodLastDate] [datetime] NULL,
	[PriceTierDescription] [varchar](100) NULL,
	[AutoApply] [bit] NULL,
 CONSTRAINT [PK_ST_Qualifier_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[PromotionCodeID] ASC,
	[SignStartDate] ASC,
	[SignEndDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON,DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
--------------------------------------------------------------------------------------------------------
--3.22918 T_Qualifier 
-----------------------------------------------------------------------------------------------------------
USE [GENIE]
GO
--Removed this key as it had conflicts
--IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_AccountType]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
--ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_AccountType]
--GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_Brand]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_Brand]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_Market]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_Market]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_Partner]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_Partner]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_PromotionCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_PromotionCode]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_Utility]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_Utility]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_T_Qualifier_AutoApply]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [DF_T_Qualifier_AutoApply]
END

GO

USE [GENIE]
GO

/****** Object:  Table [dbo].[T_Qualifier]    Script Date: 10/25/2013 15:20:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_Qualifier]') AND type in (N'U'))
DROP TABLE [dbo].[T_Qualifier]
GO

USE [GENIE]
GO

/****** Object:  Table [dbo].[T_Qualifier]    Script Date: 10/25/2013 15:20:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[T_Qualifier](
	[QualifierID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionCodeID] [int] NOT NULL,
	[PartnerID] [int] NULL,
	[MarketID] [int] NULL,
	[UtilityID] [int] NULL,
	[AccountTypeID] [int] NULL,
	[ContractTerm] [int] NULL,
	[BrandID] [int] NULL,
	[SignStartDate] [datetime] NOT NULL,
	[SignEndDate] [datetime] NOT NULL,
	[ContractEffecStartPeriodStartDate] [datetime] NULL,
	[ContractEffecStartPeriodLastDate] [datetime] NULL,
	[ServiceClassID] [int] NULL,
	[AutoApply] [bit] NULL,
 CONSTRAINT [PK_T_Qualifier] PRIMARY KEY CLUSTERED 
(
	[QualifierID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON,DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
--REmoved this Key as it had conflicts
--ALTER TABLE [dbo].[T_Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_T_Qualifier_LK_AccountType] FOREIGN KEY([AccountTypeID])
--REFERENCES [dbo].[LK_AccountType] ([AccountTypeID])
--GO

--ALTER TABLE [dbo].[T_Qualifier] CHECK CONSTRAINT [FK_T_Qualifier_LK_AccountType]
--GO

ALTER TABLE [dbo].[T_Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_T_Qualifier_LK_Brand] FOREIGN KEY([BrandID])
REFERENCES [dbo].[LK_Brand] ([BrandID])
GO

ALTER TABLE [dbo].[T_Qualifier] CHECK CONSTRAINT [FK_T_Qualifier_LK_Brand]
GO

ALTER TABLE [dbo].[T_Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_T_Qualifier_LK_Market] FOREIGN KEY([MarketID])
REFERENCES [dbo].[LK_Market] ([MarketID])
GO

ALTER TABLE [dbo].[T_Qualifier] CHECK CONSTRAINT [FK_T_Qualifier_LK_Market]
GO

ALTER TABLE [dbo].[T_Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_T_Qualifier_LK_Partner] FOREIGN KEY([PartnerID])
REFERENCES [dbo].[LK_Partner] ([PartnerID])
GO

ALTER TABLE [dbo].[T_Qualifier] CHECK CONSTRAINT [FK_T_Qualifier_LK_Partner]
GO

ALTER TABLE [dbo].[T_Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_T_Qualifier_LK_PromotionCode] FOREIGN KEY([PromotionCodeID])
REFERENCES [dbo].[LK_PromotionCode] ([PromotionCodeID])
GO

ALTER TABLE [dbo].[T_Qualifier] CHECK CONSTRAINT [FK_T_Qualifier_LK_PromotionCode]
GO

ALTER TABLE [dbo].[T_Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_T_Qualifier_LK_Utility] FOREIGN KEY([UtilityID])
REFERENCES [dbo].[LK_Utility] ([UtilityID])
GO

ALTER TABLE [dbo].[T_Qualifier] CHECK CONSTRAINT [FK_T_Qualifier_LK_Utility]
GO

ALTER TABLE [dbo].[T_Qualifier] ADD  CONSTRAINT [DF_T_Qualifier_AutoApply]  DEFAULT ((0)) FOR [AutoApply]
GO

--------------------------------------------------------------------------------------------------------------
--4. GetCompletemasterData
--------------------------------------------------------------------------------------------------------------
USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetCompleteMasterData]    Script Date: 10/25/2013 15:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompleteMasterData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompleteMasterData]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetCompleteMasterData]    Script Date: 10/25/2013 15:22:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =====================================================================================================================
-- Changes Log:
-- =====================================================================================================================

--Author: Jaime Forero
--Date: 8/13/2013
--Comments: Added Flex product changes

--Oct 21 2013 Sara Lakshmanan
--Added with no Lock to all the select  statements
--Added fetching data from LK_PromotionCode and T_Qualifier tables


/*
-- TEST CASES 
exec [GetCompleteMasterData] 'e5d48e51d53a2d21', '1900-01-01', '1900-01-01'
exec [GetCompleteMasterData_JFORERO] 'e5d48e51d53a2d21', '1900-01-01', '1900-01-01'


exec [GetCompleteMasterData] '7830fc4f8262f7a0', '1900-01-01', '1900-01-01'


exec [GetCompleteMasterData_JFORERO] '821b0b4e75d09e45', '1900-01-01', '1900-01-01'

*/
CREATE PROCEDURE [dbo].[GetCompleteMasterData] (@DeviceID VARCHAR(50), @TimestampAtDevice Date, @LastRateExpiryDate Date) AS                                  
                                
                                  
BEGIN                               
SET NOCOUNT ON;

	declare @Valid int

  Select @Valid=Count(1) from LK_PartnerAgent with (noLock)  where DeviceID=@DeviceID and [Enabled] = 1
                            
  Declare @PartnerID int                    
  set @PartnerID=(select PartnerID from LK_PartnerAgent with (noLock) where DeviceID=@DeviceID)                         
                    
                     
  select MarketID,MarketCode,MarketDescription,ISOID,TaxRate from LK_Market with (noLock),LK_DataChangeTracker DT with (noLock)                            
  where @Valid>0                         
                           
  select AccountTypeID,AccountType,AccountTypeDescription,AccountGroup from LK_AccountType with (noLock),LK_DataChangeTracker DT with (noLock)                            
  where @Valid>0                            
                            
  select ContractTypeID,ContractType from LK_ContractType with (noLock), LK_DataChangeTracker DT with (noLock)                            
  where @Valid>0                            
                            
  select BrandID,Brand,BrandDescription from LK_Brand with (noLock),LK_DataChangeTracker DT with (noLock)                             
  where @Valid>0                            
                            
  select BrandID,UtilityID,AccountTypeID from M_Brand with (noLock),LK_DataChangeTracker DT with (noLock)                            
  where @Valid>0                            
                            
  select UtilityID,ISOID,UtilityCode,UtilityName,UtilityDescription,                            
  SALength,isnull(SAPrefix,'') as SAPrefix,EnrollmentLeadDays,isnull(EnrollmentProcessDays,0) as EnrollmentProcessDays   ,
  ISNULL(UtilityTaxRate,0) as UtilityTaxRate                           
  from LK_Utility with (noLock),LK_DataChangeTracker DT  with (noLock)                           
  where @Valid>0                            
                            
  select ServiceClassID,ServiceClassCode,UtilityID  from LK_ServiceClass with (noLock),LK_DataChangeTracker DT with (noLock)                            
  where @Valid>0                            
                            
  select ZoneID,ISOID,ZoneCode from LK_Zone with (noLock),LK_DataChangeTracker DT with (noLock)                            
  where @Valid>0                            
                            
  select ISOID,ISOCode, ISODescription from LK_ISO with (noLock),LK_DataChangeTracker DT with (noLock)                             
  where @Valid>0                            
                            
  select UtilityID,MarketID from M_UtilityMarket with (noLock),LK_DataChangeTracker DT with (noLock)                            
  where @Valid>0                            
                            
  select BusinessTypeID,BusinessType from LK_BusinessType with (noLock),LK_DataChangeTracker DT  with (noLock)                           
  where @Valid>0                       
                     
  /*It will fetch DeviceID corresponding partner details*/                          
  select PartnerID,PartnerName,PartnerDescription,isnull(MarginLimit,0) as MarginLimit,EmailAddress, EnableTemplateType  from LK_Partner with (noLock)                    
  where  PartnerID= @PartnerID                            
    and @Valid>0 

  /*It will fetch DeviceID corresponding partner agent details*/                                
  select AgentID,PartnerID,AgentName,DeviceID,[Enabled],LoginID,[Password] from LK_PartnerAgent with (noLock)                    
  where  DeviceID=@DeviceID                    
    and @Valid>0 
                          
  select MeterTypeID,MeterType from LK_MeterType with (noLock),LK_DataChangeTracker DT   with (noLock)                     
  where @Valid>0                           
                      
  select AttachmentTypeID,AttachmentType from LK_AttachmentType with (noLock), LK_DataChangeTracker DT with (noLock)                        
  where @Valid>0                         
                    
	
	-- OLD PRICING DATA 
	--SELECT	RateID, RateSelection, ProductSelection,PartnerID, AccountTypeID,                            
	--		T.MarketID, UtilityID, T.BrandID, ZoneID, ISNULL(ServiceClassID,0) as ServiceClassID, FlowStartMonth, ContractTerm, 
	--		CASE WHEN B.IsFlex = 0 THEN TransferRate  ELSE M.FlexRate END AS TransferRate
	 --  FROM	T_TransferPrice T, LK_DataChangeTracker DT , LK_Market M,LK_Brand B 
	 --  WHERE PartnerID=@PartnerID 
	 --  AND DT.RateExpirationDate > @LastRateExpiryDate   
	 --  AND M.MarketID = T.MarketID
	 --  AND B.BrandID = T.BrandID   
	 --  AND @Valid>0         
	
	
	
	DECLARE @RateExpirationDate DATETIME;
	
	SELECT @RateExpirationDate = dt.RateExpirationDate
	FROM LK_DataChangeTracker dt with (NOLOCK);
	
	--SELECT @RateExpirationDate;
  
   -- ==============================================================================================================================
  	SELECT RateID, RateSelection, ProductSelection, T.PartnerID, T.AccountTypeID,                            
	T.MarketID, T.UtilityID, T.BrandID, T.ZoneID, isnull(ServiceClassID,0) AS ServiceClassID, FlowStartMonth, ContractTerm, 
	CASE WHEN B.IsFlex = 0 THEN TransferRate  ELSE 
		CASE	WHEN FR_UZ.FlexRateID IS NOT NULL	THEN FR_UZ.FlexRate
				WHEN FR_U.FlexRateID IS NOT NULL	THEN FR_U.FlexRate
				ELSE CAST(999.99 AS DECIMAL(18,5))
		END
	END AS TransferRate
	--,z.ZoneCode
	FROM T_TransferPrice T WITH (NOLOCK) 
	JOIN LK_Market M WITH (NOLOCK) ON T.MarketID = M.MarketID
	JOIN LK_Brand B  WITH (NOLOCK) ON T.BrandID = B.BrandID
	JOIN LK_Zone  Z  WITH (NOLOCK) ON T.ZoneID = Z.ZoneID
	JOIN LK_PartnerMarket PA WITH (NOLOCK) ON T.PartnerID = PA.PartnerID AND M.MarketID = PA.MarketID
	LEFT JOIN LK_FlexRate FR_UZ WITH (NOLOCK) ON T.UtilityID = FR_UZ.UtilityID AND T.ZoneID = FR_UZ.ZoneID 
	LEFT JOIN LK_FlexRate FR_U WITH (NOLOCK) ON T.UtilityID = FR_U.UtilityID AND FR_U.ZoneID IS NULL
	-- LEFT JOIN LK_FlexRate FR_U WITH (NOLOCK) ON T.UtilityID = FR_U.UtilityID AND FR_U.AccountTypeID IS NULL AND FR_U.ZoneID IS NULL
	WHERE T.PartnerID = @PartnerID 
	AND @RateExpirationDate > @LastRateExpiryDate
	AND @Valid>0 
	;
	-- ==============================================================================================================================
	

  select modifiedby,ModifiedDate,Reason,RateExpirationDate from LK_DataChangeTracker with (noLock) where @Valid>0                   
                      
  select LanguageID,[Language] from LK_Language with (noLock),LK_DataChangeTracker DT with (noLock)                        
  where @Valid>0                      
                      
  select DocumentTypeID,DocumentType,Sequence,MaxRecords from lk_documenttype with (noLock),LK_DataChangeTracker DT with (noLock)                       
  where @Valid>0                         
                    
  select FieldID, FieldName, ColumnName,isnull(Prompt1,'') as Prompt1, isnull(Prompt2,'') as Prompt2,isnull(FieldTypeID,0) as FieldTypeID from lk_documentfield with (noLock),LK_DataChangeTracker DT  with (noLock)                      
  where @Valid>0                     
                           
  --select DocumentID,[FileName],DocumentTypeID,DocOrientation,TD.ModifiedDate AS ModifiedDate, DocumentVersion, LanguageID  from t_documents TD,LK_DataChangeTracker DT                          
  --where @Valid>0  
                         
Select distinct a.DocumentID,[FileName],DocumentTypeID,DocOrientation,a.ModifiedDate , DocumentVersion, LanguageID  from T_Documents a with (noLock)
inner join M_DocumentMap b with (noLock)
on (a.DocumentID=b.DocumentID or a.DocumentTypeID>3)
inner join
(Select distinct MarketID from T_TransferPrice with (noLock) where PartnerID=@PartnerID)c
on ((b.MarketID=0) or (b.MarketID=c.MarketID))
  where @Valid>0                     

                      
  select DocumentID,FieldID,LocationX,LocationY from T_DocumentFieldLocation with (noLock),LK_DataChangeTracker DT  with (noLock)                         
  where @Valid>0                         
                  
  select DocumentMapID,MarketID,BrandID,AccountTypeID,TemplateTypeID,DocumentID from M_DocumentMap with (noLock),LK_DataChangeTracker DT with (noLock)                          
  where @Valid>0     
  
    select PromotionCodeID,Code,Description,MarketingDescription,LegalDescription from LK_PromotionCode  with (noLock)                        
  where @Valid>0  
  
      select QualifierId,PromotionCodeID,PartnerID,MarketId,UtilityID,AccountTypeId,ContractTerm,BrandID,SignStartDate,SignEndDate,ContractEffecStartPeriodStartDate,
      ContractEffecStartPeriodLastDate,ServiceClassID,AutoApply from T_Qualifier  with (noLock)                        
  where @Valid>0 
   
   SET NOCOUNT OFF                     
END

GO

--------------------------------------------------------------------------------------------------------------------
--5. New SP spGenie_UpdateQualifiers
---------------------------------------------------------------------------------------------------------------------
USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[spGenie_UpdateQualifiers]    Script Date: 10/25/2013 15:28:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenie_UpdateQualifiers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGenie_UpdateQualifiers]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[spGenie_UpdateQualifiers]    Script Date: 10/25/2013 15:28:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Date:     10/24/2013
-- Description: Moving the records from ST_Qualifier to T_Qualifier 
-- =============================================

CREATE proc [dbo].[spGenie_UpdateQualifiers] as
begin


SET NOCOUNT ON

DECLARE @DestCount INT 
DECLARE @result INT =0

Truncate Table T_Qualifier

--Since the AccountType in Libertypower is RES and in Genie Database is RESIDENTIAL
Update ST_Qualifier set AccountTypeDesc='RESIDENTIAL' where AccountTypeDesc='RES'

Insert into T_Qualifier     
Select Q.PromotionCodeID,P.PartnerID,M.MarketID,U.UtilityID,A.AccountTypeID,Q.ContractTerm,B.BrandID,Q.SignStartDate,Q.SignEndDate,
Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,S.ServiceClassID,AutoApply
 from Genie..ST_Qualifier Q  With (NoLock)
Inner  join Genie..LK_Partner P  With (NoLock) on  Q.partnerName=P.PartnerName 
LEFT join Genie..LK_Market M  With (NoLock) on Q.MarketName=M.MarketCode
LEFT join Genie..LK_Utility U  With (NoLock) on Q.UtilityName=U.UtilityCode
LEFT Join Genie..LK_AccountType A   With (NoLock) on Q.AccountTypeDesc =A.AccountType   
LEFT Join GENIE..LK_Brand B  With (NoLock) on Q.BrandDescription =B.BrandDescription
LEFT Join Genie..LK_ServiceClass S  With (NoLock) on S.ServiceClassCode like '%'+ Q.PriceTierDescription +'%' and S.UtilityID=U.UtilityID

	Set @DestCount=@@RowCount
	
	if (@DestCount>0)
	Set @result=1
	else
	Set @result=0

Select @result as result

SET NOCOUNT OFF
end




GO


---------------------------------------------------------------------------------
--LibertyPowerDatabase
--1. usp_GetAllValidPromotionCodesforToday
--2. usp_GetAllValidQualifiersforToday
-------------------------------------------------------------------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidPromotionCodesforToday]    Script Date: 10/25/2013 15:32:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAllValidPromotionCodesforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllValidPromotionCodesforToday]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidPromotionCodesforToday]    Script Date: 10/25/2013 15:32:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[usp_GetAllValidPromotionCodesforToday]
*
* DEFINITION:  Selects the list of PromotionCodes records that are valid as of today
*
* RETURN CODE: Returns the PromotionCodes Information 
*
* REVISIONS:	Sara lakshmanan 10/18/2013
*/

CREATE PROCEDURE [dbo].[usp_GetAllValidPromotionCodesforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
                                                                                                                                       
Select Distinct Q.PromotionCodeId,P.PromotionTypeId,P.Code,P.Description,P.MarketingDescription,P.LegalDescription,P.CreatedBy,P.CreatedDate
 from LibertyPower..Qualifier  Q with (NoLock) inner Join LIbertypower..PromotionCode P with (NoLock)
on Q.PromotionCodeId=P.PromotionCodeId  
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
Set NOCOUNT OFF;
END
      
GO

------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersforToday]    Script Date: 10/25/2013 15:48:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAllValidQualifiersforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllValidQualifiersforToday]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersforToday]    Script Date: 10/25/2013 15:48:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[[usp_GetAllValidQualifiersforToday]]
*
* DEFINITION:  Selects the list of Qualifier records that are valid as of today
*
* RETURN CODE: Returns the Qualifier Information 
*
* REVISIONS:	Sara lakshmanan 10/18/2013
*/

CREATE PROCEDURE [dbo].[usp_GetAllValidQualifiersforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
                                                                                                                                       
Select Q.QualifierId,Q.CampaignId, Q.PromotionCodeId, Q.SalesChannelId, Q.MarketId, Q.UtilityId,Q.AccountTypeId, Q.Term,
Q.ProductTypeId,Q.SignStartDate,Q.SignEndDate,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,
Q.PriceTierId,Q.AutoApply from LibertyPower..Qualifier  Q with (NoLock)
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
Set NOCOUNT OFF;
END

GO


  
---------------------------------------------------------------------------
--Lp_Deal_Capture Database
--1. spGenie_GetQualifiersforToday
----------------------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

SET ANSI_PADDING ON

--/****** Object:  StoredProcedure [dbo].[spGenie_GetQualifiersforToday]    Script Date: 10/25/2013 15:38:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenie_GetQualifiersforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGenie_GetQualifiersforToday]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[spGenie_GetQualifiersforToday]    Script Date: 10/25/2013 15:38:19 ******/
SET ANSI_NULLS ON
GO
SET ANSI_PADDING ON

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Date:     10/24/2013
-- Description:	Getting the details from Libertypower Qualifier table and mapping them to the Genie database Qualifier Table requirements  
-- =============================================
Create proc [dbo].[spGenie_GetQualifiersforToday] as
begin

SET NOCOUNT ON

SET ANSI_PADDING ON

Select  Q.PromotionCodeId as PromotionCodeID, S.ChannelName as PartnerName,M.MarketCode as MarketName,
U.UtilityCode as UtilityName,A.AccountType as AccountTypeDesc,Q.Term as ContractTerm,
PB.Name as BrandDescription,Q.SignStartDate,Q.SignEndDate,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,
DPT.Description as PriceTierDescription,Q.AutoApply from LibertyPower..Qualifier  Q with (NoLock)

LEft  Join LibertyPower..SalesChannel S With (noLock) on Q.SalesChannelId=S.ChannelID
LEft  Join LibertyPower..Market M with (noLock) on Q.MarketId=M.ID 
LEft  Join Libertypower..Utility U with (noLock) on Q.UtilityId= U.ID
LEft  Join LibertyPower..AccountType A with (NoLock) on Q.AccountTypeId=A.ID
LEft  Join Libertypower..ProductType PT with (noLock) on Q.ProductTypeId=PT.ProductTypeID
LEft  Join Libertypower..ProductBrand PB with (noLock) on PT.ProductTypeID=PB.ProductTypeID
LEft  Join Libertypower..DailyPricingPriceTier DPT with (NOLock) on Q.PriceTierId=DPT.ID
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()


SET NOCOUNT OFF
end


GO


-----------------------------------------------------------------------------------------------------------------------------------------
      

