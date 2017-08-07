/*
*
* PROCEDURE:	[[usp_GetAllValidQualifiersforToday]]
*
* DEFINITION:  Selects the list of Qualifier records that are valid as of today
*
* RETURN CODE: Returns the Qualifier Information 
*
* REVISIONS:	Sara lakshmanan     Created												10/18/2013
				Satchi Jena			Added missing columns  CreatedDate and CreatedBy	11/15/2013
*/

ALTER PROCEDURE [dbo].[usp_GetAllValidQualifiersforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--SET FMTONLY OFF
                                                                                                                                       
Select Q.QualifierId,Q.CampaignId, Q.PromotionCodeId, Q.SalesChannelId, Q.MarketId, Q.UtilityId,Q.AccountTypeId, Q.Term,
Q.ProductTypeId,Q.SignStartDate,Q.SignEndDate,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,
Q.PriceTierId,Q.AutoApply,Q.CreatedDate,Q.CreatedBy from LibertyPower..Qualifier  Q with (NoLock)
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
Set NOCOUNT OFF;
END
