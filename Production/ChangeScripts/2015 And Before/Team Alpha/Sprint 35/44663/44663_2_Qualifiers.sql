USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersNotReachedMaxLimitforToday]    Script Date: 07/17/2014 14:49:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
*
* PROCEDURE:	[usp_GetAllValidQualifiersNotReachedMaxLimitforToday]
*
* DEFINITION:  Selects the list of Qualifier records not reached max limit that are valid as of today
*
* RETURN CODE: Returns the Qualifier Information 
*
* REVISIONS:	Sara lakshmanan 6/20/2014
* Added Optional in parameter @SalesChannelID --July 17 2014 Sara
--exec [usp_GetAllValidQualifiersNotReachedMaxLimitforToday] @SalesChannelID=1226
*/

ALTER PROCEDURE [dbo].[usp_GetAllValidQualifiersNotReachedMaxLimitforToday]	( @SalesChannelID int = null)
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF
--Create a Table variable
Declare  @Qualifier Table(
	[QualifierId] [int]  NOT NULL,
	[CampaignId] [int] NOT NULL,
	[PromotionCodeId] [int] NOT NULL,
	[SalesChannelId] [int] NULL,
	[MarketId] [int] NULL,
	[UtilityId] [int] NULL,
	[AccountTypeId] [int] NULL,
	[Term] [int] NULL,
	[ProductBrandId] [int] NULL,
	[SignStartDate] [datetime] NOT NULL,
	[SignEndDate] [datetime] NOT NULL,
	[ContractEffecStartPeriodStartDate] [datetime] NULL,
	[ContractEffecStartPeriodLastDate] [datetime] NULL,
	[PriceTierId] [int] NULL,
	[AutoApply] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[GroupBy] [int] NULL)

Declare @CampaignID Int;
--Get the disnct camapigns valid as of today
Select Distinct Q.CampaignId  into #TempCampaignList from LibertyPower..Qualifier  Q with (NoLock) Inner Join LIbertypower..Campaign C With (NoLock)
 on Q.CampaignId=C.CampaignId 
 Inner Join LibertyPower..PromotionCode P with (NOLock) on Q.PromotionCodeId=P.PromotionCodeId
 where
 Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
and C.InActive=0
and P.InActive=0
and (Q.SalesChannelId = @SalesChannelID or  @SalesChannelID is null  or Q.SalesChannelId is Null)
--Create a cursor to loop through the distinct campaigns
DECLARE db_cursor CURSOR Fast_Forward FOR 
Select * from #TempCampaignList                                                                                                                                      


OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @CampaignID   

WHILE @@FETCH_STATUS = 0   
BEGIN  

--Find if campaign has reached max limit 
 Declare @HasCampaignMaxReached bit
    SET @HasCampaignMaxReached=(SELECT LibertyPower.dbo.[ufn_HasCampaignReachedMaxLimit_CampaignId](@CampaignID));
									
 If (@HasCampaignMaxReached=0)
 Begin
--If not then add the qualifiers list to the tablet variable
Insert into @Qualifier 
Select Q.* from LibertyPower..Qualifier  Q with (NoLock) Inner Join LIbertypower..Campaign C With (NoLock)
 on Q.CampaignId=C.CampaignId 
 Inner Join LibertyPower..PromotionCode P with (NOLock) on Q.PromotionCodeId=P.PromotionCodeId
 Where  Q.CampaignId=@CampaignID
 and 
 Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
and C.InActive=0
and P.InActive=0
and (Q.SalesChannelId = @SalesChannelID or  @SalesChannelID is null  or Q.SalesChannelId is Null)
 
 END
    
   FETCH NEXT FROM db_cursor INTO @CampaignID   
END   

CLOSE db_cursor   
DEALLOCATE db_cursor
--Return the list of Qualifers
Select * from @Qualifier

Set NOCOUNT OFF;
END

