USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_HasCampaignReachedMaxLimit]    Script Date: 12/13/2013 11:10:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_HasCampaignReachedMaxLimit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_HasCampaignReachedMaxLimit]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_HasCampaignReachedMaxLimit]    Script Date: 12/13/2013 11:10:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
*
* PROCEDURE:	[usp_HasCampaignReachedMaxLimit]
*
* DEFINITION:  Finds if the given Qualifier has hit the max limit given in the Campaign Table
*
* RETURN CODe:
*
* REVISIONS:	Sara lakshamanan 12/12/2013

exec [usp_HasCampaignReachedMaxLimit] 159
*/

CREATE PROCEDURE [dbo].[usp_HasCampaignReachedMaxLimit]
	 @p_QualifierId int
AS
BEGIN


-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF
Declare @result bit=0;
Declare @w_noofContracts int;

Declare @w_CampaignId int;
Set @w_CampaignId=(Select CampaignId from Libertypower..Qualifier with (NoLock) where QualifierId=@p_QualifierId)

If exists (Select C.MaxEligible  from Libertypower..Campaign C with (NoLock) where C.CampaignId=@w_CampaignId and C.MaxEligible is Not Null)
Begin

Set @w_noofContracts =(Select Distinct Count(CQ.ContractId) from Libertypower..ContractQualifier CQ  with (NoLock)
Inner Join LibertyPower..Qualifier Q with (NoLock) on Q.QualifierId= CQ.QualifierId
Inner Join Libertypower..Campaign C  with (NoLock) on C.CampaignId=Q.CampaignId
Where C.CampaignId =@w_CampaignId)

If (@w_noofContracts>=(Select C.MaxEligible  from Libertypower..Campaign C with (NoLock) where C.CampaignId=@w_CampaignId  ))
    Select @result=1   
END

  Select @result;  
  
Set NOCOUNT OFF;
END


GO


