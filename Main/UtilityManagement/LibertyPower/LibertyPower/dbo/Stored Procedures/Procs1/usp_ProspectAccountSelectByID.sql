
/*******************************************************************************
 * usp_ProspectAccountSelectByUtilityAndAccount
 * Selects from ProspectAccount by DocumentID (FileContext.FileGuid)
 *
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_ProspectAccountSelectByID]
(
	@ID INT
)
AS
	SET NOCOUNT ON;

		SELECT
				ID,
				ServiceAddressID, 
				BillingAddressID, 
				AccountNumber, 
				BillingAccount,
				UtilityCode, 
				RetailMarketId, 
				RateClass, 
				NameKey, 
				LoadProfile,
				MeterReadCycleID,
				DocumentID, 
				CreatedBy
			FROM
				ProspectAccount
			WHERE
				ID = @ID

