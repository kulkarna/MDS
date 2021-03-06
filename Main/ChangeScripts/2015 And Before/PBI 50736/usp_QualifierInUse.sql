USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_QualifierInUse]    Script Date: 7/14/2015 12:32:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

 * PROCEDURE:	[usp_QualifierInUse] 
 * PURPOSE:		To validate if Qualifier is in use.
 * HISTORY:		 
 *******************************************************************************
 * 01/22/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************
 * ModifiedBy: Manish Pandey
 * ModifiedDate: 08/14/2015
 * Ticket/PBI: 1-891895781 / 50736
 * Modification: To To allow to change signed date and contract date.
 ---------
 Profiler
 exec [usp_QualifierInUse] @p_CampaignId=25, @p_PromotionCodeId=21, @p_GroupBy=1, @p_IsDateOnlyChanged=0
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_QualifierInUse]
	@p_CampaignId int,
	@p_PromotionCodeId	int,
	@p_GroupBy int=null,
	@p_IsDateOnlyChanged int=null
	
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

--Check if date got changed.if true then return data
if (ISNULL(@p_IsDateOnlyChanged,0)=0) 
	select top 1 1 from  LibertyPower..Qualifier qf  with (NOLock)
		Join LibertyPower..ContractQualifier cq with (NOLock) on qf.QualifierId=cq.QualifierId
			where qf.PromotionCodeId=@p_PromotionCodeId and qf.CampaignId=@p_CampaignId and qf.GroupBy=@p_GroupBy

Set NOCOUNT OFF;
END
-- Copyright 01/22/2013 Liberty Power

