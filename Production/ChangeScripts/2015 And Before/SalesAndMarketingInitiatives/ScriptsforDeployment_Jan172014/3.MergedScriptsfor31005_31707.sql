USE [LibertyPower]
GO
-------------------------------------------------------------------
--Merged Scripts for 31005: delete in promoCode
--31707: Max limit logic
------------------------------------------------------------------



/****** Object:  StoredProcedure [dbo].[usp_DeleteContractQualifier]    Script Date: 01/20/2014 13:08:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DeleteContractQualifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DeleteContractQualifier]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteContractQualifier]    Script Date: 01/20/2014 13:08:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------
-- Added		: Fernando ML Alves
-- Date			: 20/01/2014
-- Description	: Proc to delete a promotion code association from the ContractQualifier table (for 
--				  all accounts) based in the contractQualifierId. 
-- Format:		: exec usp_DeleteContractQualifier contractQualifierId
---------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_DeleteContractQualifier] (
	@p_contractQualifierId INT) AS 
BEGIN 
	SET NOCOUNT ON;

	DELETE FROM 
		ContractQualifier 
	WHERE 
		ContractQualifierId IN (
			SELECT 
				C2.ContractQualifierId
			FROM 
				ContractQualifier C1, ContractQualifier C2
			WHERE 
				C1.ContractId=C2.ContractId AND C1.QualifierId=C2.QualifierId
			AND
				C1.ContractQualifierId=@p_contractQualifierId
		);

	SET NOCOUNT OFF;	
END;

GO


-------------------------------------------------------------

USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_HasCampaignReachedMaxLimit]    Script Date: 01/20/2014 14:59:17 ******/
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

Modified Jan 20 2014
Sara Lakshmanan 
BUg: 31707: When promo codes are being assigned to a contract, it looks like the counter for th max limit is using the number of accounts instead of the number of contracts
Modified Distinct Count(CQ.ContractId) 
to  Count(Distinct CQ.ContractId) 

*/

ALTER PROCEDURE [dbo].[usp_HasCampaignReachedMaxLimit]
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

--Modified Jan 20 2014
Set @w_noofContracts =(Select  Count(Distinct CQ.ContractId) from Libertypower..ContractQualifier CQ  with (NoLock)
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


------------------------------------------