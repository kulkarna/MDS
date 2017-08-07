/***************************************** usp_AccountInfoSettlementInsertFromTemp **********************************************/
CREATE PROCEDURE [dbo].[usp_AccountInfoSettlementInsertFromTemp]
AS

BEGIN

	BEGIN TRY
		BEGIN TRANSACTION 
		
		-- Delete the accounts that already exists
		TRUNCATE
		TABLE	AccountInfoSettlement
		
		-- insert all the accounts from the temp table
		INSERT INTO AccountInfoSettlement (
				FileLogID,
				ElectricalBus,
  				NodeName,
  				PsseBusName,
  				VoltageLevel,
  				Substation,
  				SettlementLoadZone,
  				HubBusName,
				Hub,
  				ResourceNode)
		SELECT	FileLogID,
				ElectricalBus,
  				NodeName,
  				PsseBusName,
  				VoltageLevel,
  				Substation,
  				SettlementLoadZone,
  				HubBusName,
				Hub,
  				ResourceNode
		FROM	AccountInfoSettlement_TEMP
		
		--clean the temp table
		TRUNCATE TABLE AccountInfoSettlement_TEMP
			
		COMMIT TRANSACTION
			
	END TRY
		
	BEGIN CATCH

		ROLLBACK TRANSACTION
	
	  -- Raise an error with the details of the exception
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		SELECT @ErrMsg = ERROR_MESSAGE(),  @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
		
	END CATCH

END

