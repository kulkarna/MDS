/*******************************************************************************
 * usp_ProspectAccountInsert
 * Inserts a new row into the ProspectAccount table.
 *
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_ProspectAccountInsert]
(
	@ServiceAddressID int, 
	@BillingAddressID int, 
	@AccountNumber varchar(50), 
	@BillingAccount varchar(50),
	@UtilityCode varchar(50), 
	@RetailMarketId varchar(2), 
	@RateClass varchar(50), 
	@NameKey varchar(50), 
	@LoadProfile varchar(50), 
	@MeterReadCycleID varchar(50),
	@DocumentID uniqueidentifier, 
	@CreatedBy varchar(100)
)
AS
	SET NOCOUNT ON;

	DECLARE @ID int;
	
	INSERT INTO ProspectAccount
		(
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
		)
		VALUES
		(
			@ServiceAddressID,
			@BillingAddressID,
			@AccountNumber,
			@BillingAccount,
			@UtilityCode,
			@RetailMarketId,
			@RateClass,
			@NameKey,
			@LoadProfile,
			@MeterReadCycleID, 
			@DocumentID,
			@CreatedBy
		);

	IF @@ROWCOUNT > 0
	BEGIN

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
				ID = SCOPE_IDENTITY();
		
	END

	RETURN