
/***************************************** usp_AccountInfoAccountsInsertFromTemp **********************************************/
CREATE PROCEDURE [dbo].[usp_AccountInfoAccountsInsertFromTemp]
AS

BEGIN

	BEGIN TRY
		BEGIN TRANSACTION 
		
		-- Delete the accounts that already exists
		DELETE	I
		FROM	AccountInfoAccounts I
		INNER	JOIN AccountInfoAccounts_TEMP T
		ON		I.ESIID = T.ESIID
		
		-- insert all the accounts from the temp table
		INSERT INTO AccountInfoAccounts (
				FileLogID,
				ESIID,
  				ADDRESS,
  				ADDRESS_OVERFLOW,
  				CITY,
  				STATE,
  				ZIPCODE,
  				DUNS,
				METER_READ_CYCLE,
  				STATUS,
  				PREMISE_TYPE,
  				POWER_REGION,
  				STATIONCODE,
				STATIONNAME,
  				METERED,
  				OPEN_SERVICE_ORDERS,
  				POLR_CUSTOMER_CLASS,
  				AMS_METER_FLAG,
  				TDSP_AMS_INDICATOR,
  				SWITCH_HOLD_INDICATOR)
		SELECT	FileLogID,
				ESIID,
  				ADDRESS,
  				ADDRESS_OVERFLOW,
  				CITY,
  				STATE,
  				ZIPCODE,
  				DUNS,
				METER_READ_CYCLE,
  				STATUS,
  				PREMISE_TYPE,
  				POWER_REGION,
  				STATIONCODE,
				STATIONNAME,
  				METERED,
  				OPEN_SERVICE_ORDERS,
  				POLR_CUSTOMER_CLASS,
  				AMS_METER_FLAG,
  				TDSP_AMS_INDICATOR,
  				SWITCH_HOLD_INDICATOR
		FROM	AccountInfoAccounts_TEMP
		
		--clean the temp table
		TRUNCATE TABLE AccountInfoAccounts_TEMP
			
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

