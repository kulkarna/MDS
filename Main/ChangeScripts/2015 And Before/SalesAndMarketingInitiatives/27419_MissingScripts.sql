----MIssing Scripts for campaign Code

USE [Libertypower]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetQualifierFieldValues]    Script Date: 12/18/2013 10:16:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_GetQualifierFieldValues]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_GetQualifierFieldValues]
GO

USE [Libertypower]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetQualifierFieldValues]    Script Date: 12/18/2013 10:16:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

* Function:      [ufn_GetQualifierFieldValues]
* PURPOSE:       Returns list of field values for qualifier table based on table name
* HISTORY:       To return the value of fields for qualifier table.
*******************************************************************************
* 12/05/2013 - Pradeep Katiyar
* Created.
*******************************************************************************

*/
CREATE FUNCTION [dbo].[ufn_GetQualifierFieldValues] ( @TableName Varchar(30), @CampaignID Int, @GroupBy Int ) 
RETURNS Varchar(Max) 
AS 
BEGIN 
      DECLARE @values Varchar(Max)
      if (@TableName ='SalesChannel')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + SC.ChannelName
                  FROM LibertyPower..SalesChannel SC  with (NOLock)
                        where SC.ChannelID in(select QF.SalesChannelId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='Market')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + MA.RetailMktDescp 
                  FROM LibertyPower..Market MA with (NOLock) 
                  Where MA.ID in(select QF.MarketId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='Utility')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + UT.FullName
                  FROM LibertyPower..Utility UT with (NOLock) 
                  where  UT.ID in(select QF.UtilityId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='AccountType')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + AT.AccountType
                  FROM LibertyPower..AccountType AT with (NOLock) 
                  Where  AT.ID in(select QF.AccountTypeId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='ProductBrand')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + PT.Name
                  FROM LibertyPower..ProductType PT with (NOLock) 
                  Where PT.ProductTypeID in(select QF.ProductTypeID from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='DailyPricingPriceTier')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + DP.Name
                  FROM LibertyPower..DailyPricingPriceTier DP with (NOLock) 
                  where DP.ID in(select QF.PriceTierId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
                        
      
RETURN @values
END

-- Copyright 12/05/2013 Liberty Power
GO

-------------------------
If Exists (Select * from Libertypower..Qualifier where GroupBY is Null)
Begin
Update Libertypower..Qualifier  Set groupBY=1 where GroupBy is Null
End

-------------------------------------

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_qualifierListbyCampaignIdSelect]    Script Date: 12/18/2013 10:17:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_qualifierListbyCampaignIdSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_qualifierListbyCampaignIdSelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_qualifierListbyCampaignIdSelect]    Script Date: 12/18/2013 10:17:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	[usp_qualifierListbyCampaignIdSelect]
 * PURPOSE:		Selects the Qualifier list based on Campaign Id
 * HISTORY:		To display the qualifier list based on campaign Id
 *******************************************************************************
 * 12/05/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_qualifierListbyCampaignIdSelect] 
	 @p_CampaignID		Int
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
                                                                                                                                       
select distinct QF.PromotionCodeId,PC.Code,
	dbo.ufn_GetQualifierFieldValues('SalesChannel',QF.CampaignId,QF.GroupBy) as ChannelName,
	dbo.ufn_GetQualifierFieldValues('Market',QF.CampaignId,QF.GroupBy) as MarketCode,
	dbo.ufn_GetQualifierFieldValues('Utility',QF.CampaignId,QF.GroupBy) as UtilityCode,
	dbo.ufn_GetQualifierFieldValues('AccountType',QF.CampaignId,QF.GroupBy) as AccountType,
	dbo.ufn_GetQualifierFieldValues('ProductBrand',QF.CampaignId,QF.GroupBy) as ProductBrand,
	QF.Term,QF.SignStartDate,QF.SignEndDate,QF.ContractEffecStartPeriodStartDate,QF.ContractEffecStartPeriodLastDate,
	dbo.ufn_GetQualifierFieldValues('DailyPricingPriceTier',QF.CampaignId,QF.GroupBy) as PriceTier,
	QF.GroupBy 
	from LibertyPower..Qualifier QF  with (NOLock)
		Join LibertyPower..Campaign C  with (NOLock) on QF.CampaignId=C.CampaignId
		Join LibertyPower..PromotionCode PC  with (NOLock) on QF.PromotionCodeId=PC.PromotionCodeId
Where QF.CampaignId=@p_CampaignID
order by QF.GroupBy ASC


Set NOCOUNT OFF;
END
-- Copyright 12/05/2013 Liberty Power
GO


---------------------------------------------------------------------------------------



