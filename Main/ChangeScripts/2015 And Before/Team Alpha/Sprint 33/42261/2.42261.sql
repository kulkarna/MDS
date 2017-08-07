
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidPromotionCodenotReachedMaxLimitforToday]    Script Date: 06/20/2014 09:03:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAllValidPromotionCodenotReachedMaxLimitforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllValidPromotionCodenotReachedMaxLimitforToday]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidPromotionCodenotReachedMaxLimitforToday]    Script Date: 06/20/2014 09:03:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[[usp_GetAllValidPromotionCodenotReachedMaxLimitforToday]]
*
* DEFINITION:  Selects the list of PromotionCodes of the Campaign that has not reachesd the max limit that are valid as of today
*
* RETURN CODE: Returns the Promotion code list
*
* REVISIONS:	Sara lakshmanan 6/20/2014

--exec [usp_GetAllValidPromotionCodenotReachedMaxLimitforToday]
*/

Create PROCEDURE [dbo].[usp_GetAllValidPromotionCodenotReachedMaxLimitforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF
--Create a table variable
Declare  @Promotion Table(
		[PromotionCodeId] [int]  NOT NULL,
	[PromotionTypeId] [int] NULL,
	[Code] [nchar](20) NOT NULL,
	[Description] [varchar](1000) NOT NULL,
	[MarketingDescription] [varchar](1000) NULL,
	[LegalDescription] [varchar](1000) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[InActive] [bit] NULL)

Declare @CampaignID Int;

--Get Distinct Campaigns
Select Distinct Q.CampaignId  into #TempCampaignList from LibertyPower..Qualifier  Q with (NoLock) Inner Join LIbertypower..Campaign C With (NoLock)
 on Q.CampaignId=C.CampaignId 
 Inner Join LibertyPower..PromotionCode P with (NOLock) on Q.PromotionCodeId=P.PromotionCodeId
where Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
and C.InActive=0
and P.InActive=0
--Create a cursor to loop through the campaigns
DECLARE db_cursor CURSOR Fast_Forward FOR 
Select * from #TempCampaignList                                                                                                                                      


OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @CampaignID   

WHILE @@FETCH_STATUS = 0   
BEGIN  
--Find if the campaign has reached the max limit
 Declare @HasCampaignMaxReached bit
    SET @HasCampaignMaxReached=(SELECT LibertyPower.dbo.[ufn_HasCampaignReachedMaxLimit_CampaignId](@CampaignID));
									
 If (@HasCampaignMaxReached=0)
 Begin
--If campaign has not reached the max limit, add them to PromoCode table variable
Insert into @Promotion 
Select P.* from LibertyPower..Qualifier  Q with (NoLock) Inner Join LIbertypower..Campaign C With (NoLock)
 on Q.CampaignId=C.CampaignId 
 Inner Join LibertyPower..PromotionCode P with (NOLock) on Q.PromotionCodeId=P.PromotionCodeId
 where 
  Q.CampaignId=@CampaignID
  and
  Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
and C.InActive=0
and P.InActive=0
 END
     
   FETCH NEXT FROM db_cursor INTO @CampaignID   
END   

CLOSE db_cursor   
DEALLOCATE db_cursor

--Return the list of promotionCodes added to the table variable
Select Distinct * from @Promotion

Set NOCOUNT OFF;
END

GO

