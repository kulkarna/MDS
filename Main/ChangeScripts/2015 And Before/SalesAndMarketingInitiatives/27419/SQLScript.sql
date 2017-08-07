USE LibertyPower
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter table LibertyPower..Campaign add  MaxEligible Int null
go
alter table LibertyPower..Qualifier add  GroupBy Int null

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************

 * PROCEDURE:	[usp_campaignCode_list]
 * PURPOSE:		Selects the CampaignCode Details
 * HISTORY:		To display the Campaign code list 
 *******************************************************************************
 * 11/28/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

create PROCEDURE [dbo].[usp_campaignCode_list] 
	@p_CampaignCode		 nchar(40) = ''
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF
	
if (ltrim(rtrim(@p_CampaignCode))<>'')                                                                                                                              
	Select c.CampaignId,c.Code,c.[Description] ,c.StartDate,c.EndDate,c.MaxEligible, u.Firstname + ' ' + u.Lastname as CreatedBy,c.CreatedDate 
	from  LibertyPower..Campaign c with (NOLock)	
		join LibertyPower..[User] u with (NOLock) on c.CreatedBy=u.UserID 
	where c.Code=@p_CampaignCode
else
	Select c.CampaignId,c.Code,c.[Description] ,c.StartDate,c.EndDate,c.MaxEligible, u.Firstname + ' ' + u.Lastname as CreatedBy,c.CreatedDate 
	from  LibertyPower..Campaign c with (NOLock)	
		join LibertyPower..[User] u with (NOLock) on c.CreatedBy=u.UserID 
Set NOCOUNT OFF;
END
-- Copyright 11/28/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	[usp_campaignCodebyIdSelect]
 * PURPOSE:		Selects the CampaignCode Details based on Campaign code and ID
 * HISTORY:		To check if Campaign code  exists in case of Campaign code update 
 *******************************************************************************
 * 11/28/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_campaignCodebyIdSelect]
	 @p_CampaignID		Int
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
                                                                                                                                       
Select C.* from  LibertyPower..Campaign C with (NOLock)

where C.CampaignId=@p_CampaignID


Set NOCOUNT OFF;
END
-- Copyright 11/28/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	[usp_campaignCodebyCodeSelect]
 * PURPOSE:		Selects the CampaignCode Details based on Campaign code
 * HISTORY:		To check if Campaign code already exists 
 *******************************************************************************
 * 11/28/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_campaignCodebyCodeSelect]
	 @p_CampaignCode		 nchar(40) = ''
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
                                                                                                                                       
Select C.* from  LibertyPower..Campaign C with (NOLock)

where C.Code=@p_CampaignCode


Set NOCOUNT OFF;
END
-- Copyright 11/28/2013 Liberty Power
         
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	[usp_campaignCodebyCodeAndIdSelect]
 * PURPOSE:		Selects the CampaignCode Details based on Campaign code and ID
 * HISTORY:		To check if Campaign code  exists in case of Campaign code update 
 *******************************************************************************
 * 11/28/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_campaignCodebyCodeAndIdSelect]
	 @p_CampaignID		Int,
	 @p_CampaignCode char(20)
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
                                                                                                                                       
Select C.* from  LibertyPower..Campaign C with (NOLock)

where
C.Code=@p_CampaignCode and C.CampaignId<>@p_CampaignID


Set NOCOUNT OFF;
END
-- Copyright 11/28/2013 Liberty Power

         
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	[usp_campaigncode_ins]
 * PURPOSE:		Add new Campaign code details
 * HISTORY:		Add new Campaign code details
 *******************************************************************************
 * 11/29/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */
create proc usp_campaigncode_ins
(
	@p_CampaignCode		nchar(40),
	@p_Desc				varchar(1000)='',
	@p_StartDate		Datetime,
	@p_EndDate			Datetime,
	@p_MaxEligible		int=null,
	@p_CreatedBy		int	
)
as
Begin
SET NOCOUNT ON
if not exists(select code from LibertyPower..Campaign with (NOLock) where code=LTRIM(rtrim(@p_CampaignCode)))
	Begin
	 insert into LibertyPower..Campaign(Code, [Description], StartDate, EndDate,MaxEligible, CreatedBy, CreatedDate)
		values(@p_CampaignCode,@p_Desc, @p_StartDate, @p_EndDate,@p_MaxEligible, @p_CreatedBy, getdate())	
		select C.* from LibertyPower..Campaign C with (NOLock) where C.CampaignId=SCOPE_IDENTITY()
	end
Set NOCOUNT OFF;
End
 
-- Copyright 11/29/2013 Liberty Power
         
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	usp_campaigncode_update
 * PURPOSE:		To update Campaign code details
 * HISTORY:		To update Campaign code details
 *******************************************************************************
 * 11/29/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */
 
Create proc usp_campaigncode_update
(
	@p_CampaignId		int,
	@p_CampaignCode	nchar(40),
	@p_Desc				varchar(1000)='',
	@p_StartDate		Datetime,
	@p_EndDate			Datetime,
	@p_MaxEligible		int=null
)
as
Begin
SET NOCOUNT ON
if not exists(select code from LibertyPower..Campaign with (NOLock) where code=LTRIM(rtrim(@p_CampaignCode)) and CampaignId<>@p_CampaignId)
	Begin
		update LibertyPower..Campaign set Code=@p_CampaignCode, [Description]=@p_Desc,StartDate=@p_StartDate,EndDate=@p_EndDate,MaxEligible=@p_MaxEligible
		where CampaignId=@p_CampaignId
		select C.* from LibertyPower..Campaign C with (NOLock) where C.CampaignId=@p_CampaignId
	 End
Set NOCOUNT OFF;
End

-- Copyright 11/29/2013 Liberty Power

Go
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
order by QF.GroupBy Desc


Set NOCOUNT OFF;
END
-- Copyright 12/05/2013 Liberty Power



Go
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
alter FUNCTION [dbo].[ufn_GetQualifierFieldValues] ( @TableName Varchar(30), @CampaignID Int, @GroupBy Int ) 
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