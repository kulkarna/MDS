

CREATE PROCEDURE [dbo].[usp_VRE_RateChangeBillingHistorySelect]  
	
AS

Set NoCount On

Select
	AccountNumber,
	EffectiveBillingCycleStart as StartDate,
	EffectiveBillingCycleEnd as EndDate
From
	RateChange
Order By
	DateCreated Desc


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_RateChangeBillingHistorySelect';

