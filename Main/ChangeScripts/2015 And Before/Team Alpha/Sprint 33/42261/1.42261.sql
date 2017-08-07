USE [LibertyPower]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_HasCampaignReachedMaxLimit_CampaignId]    Script Date: 06/20/2014 08:58:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_HasCampaignReachedMaxLimit_CampaignId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_HasCampaignReachedMaxLimit_CampaignId]
GO

USE [LibertyPower]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_HasCampaignReachedMaxLimit_CampaignId]    Script Date: 06/20/2014 08:58:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*
*
* Function:	[[ufn_HasCampaignReachedMaxLimit_CampaignId]]
*
* DEFINITION:  Finds if the given Campaign has hit the max limit given in the Campaign Table
*
* RETURN CODe: bit true or false
*
* REVISIONS:	Sara lakshamanan 6/20/2014

exec [ufn_HasCampaignReachedMaxLimit_CampaignId] 1

//Created a new proc from the exiting Proc, the difference is the input parameter is campaignId instead of QualifierId
*/

CREATE Function [dbo].[ufn_HasCampaignReachedMaxLimit_CampaignId]
	( @p_CampaignId int)
	 returns bit
AS
BEGIN

Declare @result bit=0;
Declare @w_noofContracts int;

If exists (Select C.MaxEligible  from Libertypower..Campaign C with (NoLock) where C.CampaignId=@p_CampaignId and C.MaxEligible is Not Null)
Begin

Set @w_noofContracts =(Select  Count(Distinct CQ.ContractId) from Libertypower..ContractQualifier CQ  with (NoLock)
Inner Join LibertyPower..Qualifier Q with (NoLock) on Q.QualifierId= CQ.QualifierId
Inner Join Libertypower..Campaign C  with (NoLock) on C.CampaignId=Q.CampaignId
Where C.CampaignId =@p_CampaignId)

If (@w_noofContracts>=(Select C.MaxEligible  from Libertypower..Campaign C with (NoLock) where C.CampaignId=@p_CampaignId  ))
    Select @result=1   
END

  return @result;
  

END

GO

