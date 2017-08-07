USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CampaignFulfillment_Campaign]') AND parent_object_id = OBJECT_ID(N'[dbo].[CampaignFulfillment]'))
ALTER TABLE [dbo].[CampaignFulfillment] DROP CONSTRAINT [FK_CampaignFulfillment_Campaign]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CampaignFulfillment_TriggerType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CampaignFulfillment]'))
ALTER TABLE [dbo].[CampaignFulfillment] DROP CONSTRAINT [FK_CampaignFulfillment_TriggerType]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_CampaignFulfillment_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CampaignFulfillment] DROP CONSTRAINT [DF_CampaignFulfillment_CreatedDate]
END



IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'TriggerType' AND type_desc = 'USER_TABLE')
DROP table TriggerType;
GO

/*******************************************************************************

 * Table:	[TriggerType]
 * PURPOSE: Trigger type master table
 * HISTORY:		 
 *******************************************************************************
 * 1/29/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */
CREATE TABLE [dbo].[TriggerType](
	[TriggerTypeId][int] IDENTITY(1,1) NOT NULL,
	[TriggerType] Varchar(50)  NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_TriggerType] PRIMARY KEY CLUSTERED 
(
	[TriggerTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
if not exists (select 1 from LibertyPower..TriggerType WITH (NOLOCK) where TriggerType='Contract Sign Date' )
insert into LibertyPower..TriggerType(TriggerType,CreatedBy,CreatedDate) values('Contract Sign Date',2103,GETDATE())
go
if not exists (select 1 from LibertyPower..TriggerType WITH (NOLOCK) where TriggerType='Contract Start Date' )
insert into LibertyPower..TriggerType(TriggerType,CreatedBy,CreatedDate) values('Contract Start Date',2103,GETDATE())
Go


USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CampaignFulfillment_Campaign]') AND parent_object_id = OBJECT_ID(N'[dbo].[CampaignFulfillment]'))
ALTER TABLE [dbo].[CampaignFulfillment] DROP CONSTRAINT [FK_CampaignFulfillment_Campaign]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CampaignFulfillment_TriggerType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CampaignFulfillment]'))
ALTER TABLE [dbo].[CampaignFulfillment] DROP CONSTRAINT [FK_CampaignFulfillment_TriggerType]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_CampaignFulfillment_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CampaignFulfillment] DROP CONSTRAINT [DF_CampaignFulfillment_CreatedDate]
END



IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'CampaignFulfillment' AND type_desc = 'USER_TABLE')
DROP table CampaignFulfillment;
GO

/*******************************************************************************

 * Table:	[CampaignFulfillment]
 * PURPOSE: specify the conditions for CampaignFulfillment on a given Promo Campaign
 * HISTORY:		 
 *******************************************************************************
 * 1/27/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */
CREATE TABLE [dbo].[CampaignFulfillment](
	[CampaignFulfillmentId][int] IDENTITY(1,1) NOT NULL,
	[CampaignId][int]  NOT NULL,
	[TriggerTypeId] [int]   NULL,
	[EligibilityPeriod] [int]   NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_CampaignFulfillment] PRIMARY KEY CLUSTERED 
(
	[CampaignFulfillmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


ALTER TABLE [dbo].[CampaignFulfillment] ADD  CONSTRAINT [DF_CampaignFulfillment_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CampaignFulfillment]  WITH CHECK ADD  CONSTRAINT [FK_CampaignFulfillment_Campaign] FOREIGN KEY([CampaignId])
REFERENCES [dbo].[Campaign] ([CampaignId])
GO

ALTER TABLE [dbo].[CampaignFulfillment] CHECK CONSTRAINT [FK_CampaignFulfillment_Campaign]
GO
ALTER TABLE [dbo].[CampaignFulfillment]  WITH CHECK ADD  CONSTRAINT [FK_CampaignFulfillment_TriggerType] FOREIGN KEY(TriggerTypeId)
REFERENCES [dbo].[TriggerType] ([TriggerTypeId])
GO

ALTER TABLE [dbo].[CampaignFulfillment] CHECK CONSTRAINT [FK_CampaignFulfillment_TriggerType]
GO
if not exists (select 1 from LibertyPower..CampaignFulfillment WITH (NOLOCK) where CampaignId=1 )
 insert into LibertyPower..CampaignFulfillment(CampaignId,TriggerTypeId,EligibilityPeriod, CreatedBy, CreatedDate)
			values(1,2,120, 1982, getdate())	
GO

IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_CampaignFulfillment_list' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_CampaignFulfillment_list;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_CampaignFulfillment_list]
 * PURPOSE:		Selects the CampaignFulfillment list
 * HISTORY:		To display the CampaignFulfillment list 
 *******************************************************************************
 * 1/27/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

--exec [usp_CampaignFulfillment_list] 43

CREATE PROCEDURE [dbo].[usp_CampaignFulfillment_list]
	@p_CampaignId int= NULL
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

		Select fl.*,tt.TriggerType, uc.Firstname + ' ' + uc.Lastname as CreatedByName,um.Firstname + ' ' + um.Lastname as ModifiedByName 
			from LibertyPower..CampaignFulfillment fl with (NOLock)
					Left outer join LibertyPower..TriggerType tt with (NOLock) on fl.TriggerTypeId=tt.TriggerTypeId
					Left outer join LibertyPower..[User] uc with (NOLock) on FL.CreatedBy=uc.UserID 
					Left outer join LibertyPower..[User] um with (NOLock) on FL.ModifiedBy=um.UserID
		where fl.CampaignId=@p_CampaignId	or @p_CampaignId is NULL
	
Set NOCOUNT OFF;
END
-- Copyright 01/27/2014 Liberty Power    

Go

IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_CampaignFulfillment_InsertUpdate' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_CampaignFulfillment_InsertUpdate;
GO



/*******************************************************************************

 * PROCEDURE:	[usp_CampaignFulfillment_InsertUpdate]
 * PURPOSE:		Add/update  CampaignFulfillment details
 * HISTORY:		Add/update  CampaignFulfillment details
 *******************************************************************************
 * 1/27/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */
create proc dbo.[usp_CampaignFulfillment_InsertUpdate]
(
	
	@p_CampaignId		int,
	@p_TriggerTypeId int=null,
	@p_EligibilityPeriod int=null,
	@p_CreatedOrModifiedBy		int	
)
as
Begin
SET NOCOUNT ON
	if not exists(select Top 1 1 from LibertyPower..CampaignFulfillment with (NOLock) where CampaignId=@p_CampaignId)
		Begin
		 insert into LibertyPower..CampaignFulfillment(CampaignId,TriggerTypeId,EligibilityPeriod, CreatedBy, CreatedDate)
			values(@p_CampaignId,@p_TriggerTypeId,@p_EligibilityPeriod, @p_CreatedOrModifiedBy, getdate())	
			select F.* from LibertyPower..CampaignFulfillment F with (NOLock) where F.CampaignFulfillmentId=SCOPE_IDENTITY()
		end
	else
		Begin
			update LibertyPower..CampaignFulfillment set CampaignId=@p_CampaignId, TriggerTypeId=@p_TriggerTypeId,
				EligibilityPeriod= @p_EligibilityPeriod, ModifiedBy=@p_CreatedOrModifiedBy, ModifiedDate=getdate()
			where CampaignId=@p_CampaignId	
			select F.* from LibertyPower..CampaignFulfillment F with (NOLock) where F.CampaignFulfillmentId=@p_CampaignId
		End
	
Set NOCOUNT OFF;
End
 
-- Copyright 1/27/2014 Liberty Power
 
GO

IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_TriggerType_list' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_TriggerType_list;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_TriggerType_list]
 * PURPOSE:		Selects the Trigger Type list
 * HISTORY:		Selects the Trigger Type list
 *******************************************************************************
 * 1/29/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_TriggerType_list]
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF
	
	select tt.* from LibertyPower..TriggerType tt WITH (NOLOCK) 
	
Set NOCOUNT OFF;
END
-- Copyright 01/29/2014 Liberty Power    


GO

IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_CampaignQualifierInUse' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_CampaignQualifierInUse;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_CampaignQualifierInUse] 
 * PURPOSE:		To validate if Qualifier is in use.
 * HISTORY:		 
 *******************************************************************************
 * 01/31/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************
 */

Create PROCEDURE [dbo].[usp_CampaignQualifierInUse]
	@p_CampaignId int
	
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF 
select top 1 1 from  LibertyPower..Qualifier qf  with (NOLock)
	Join LibertyPower..ContractQualifier cq with (NOLock) on qf.QualifierId=cq.QualifierId
where qf.CampaignId=@p_CampaignId

Set NOCOUNT OFF;
END
-- Copyright 01/31/2013 Liberty Power

GO

IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_CampaignCodeDelete' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_CampaignCodeDelete;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_CampaignCodeDelete]
 * PURPOSE:		Deletes Campaign Code  for specified Campaign Code Id
 * HISTORY:		 
 *******************************************************************************
 * 12/13/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_CampaignCodeDelete]
	@p_CampaignId	int
AS
BEGIN
    SET NOCOUNT ON;
if not exists( select 1 from LibertyPower..Qualifier QF  with (NOLock) where qf.CampaignId=@p_CampaignId)   
	Begin
		DELETE FROM	LibertyPower..CampaignFulfillment
		WHERE		CampaignId = @p_CampaignId
		DELETE FROM	LibertyPower..Campaign
		WHERE		CampaignId = @p_CampaignId
	End
    SET NOCOUNT OFF;
END
GO

-- Copyright 12/13/2013 Liberty Power