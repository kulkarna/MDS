
USE lp_common
GO

BEGIN TRY
	BEGIN TRAN

	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170509' WHERE calendar_year = '2017' AND calendar_month = '5' AND utility_id = 'AMEREN' AND read_cycle_id = '8'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170510' WHERE calendar_year = '2017' AND calendar_month = '5' AND utility_id = 'AMEREN' AND read_cycle_id = '9'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170915' WHERE calendar_year = '2017' AND calendar_month = '9' AND utility_id = 'ALLEGMD' AND read_cycle_id = '14'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170908' WHERE calendar_year = '2017' AND calendar_month = '9' AND utility_id = 'SHARYLAND' AND read_cycle_id = '5'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20171212' WHERE calendar_year = '2017' AND calendar_month = '12' AND utility_id = 'SHARYLAND' AND read_cycle_id = '9'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170612' WHERE calendar_year = '2017' AND calendar_month = '6' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '8'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170613' WHERE calendar_year = '2017' AND calendar_month = '6' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '9'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170614' WHERE calendar_year = '2017' AND calendar_month = '6' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '10'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170615' WHERE calendar_year = '2017' AND calendar_month = '6' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '11'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170616' WHERE calendar_year = '2017' AND calendar_month = '6' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '12'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170617' WHERE calendar_year = '2017' AND calendar_month = '6' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '13'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170618' WHERE calendar_year = '2017' AND calendar_month = '6' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '14'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170619' WHERE calendar_year = '2017' AND calendar_month = '6' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '15'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170620' WHERE calendar_year = '2017' AND calendar_month = '6' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '16'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170621' WHERE calendar_year = '2017' AND calendar_month = '6' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '17'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170630' WHERE calendar_year = '2017' AND calendar_month = '7' AND utility_id = 'NSTAR-BOS' AND read_cycle_id = '1'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20171107' WHERE calendar_year = '2017' AND calendar_month = '11' AND utility_id = 'SCE' AND read_cycle_id = '56'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170116' WHERE calendar_year = '2017' AND calendar_month = '1' AND utility_id = 'WMECO' AND read_cycle_id = '10'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170117' WHERE calendar_year = '2017' AND calendar_month = '1' AND utility_id = 'WMECO' AND read_cycle_id = '11'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170118' WHERE calendar_year = '2017' AND calendar_month = '1' AND utility_id = 'WMECO' AND read_cycle_id = '12'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170119' WHERE calendar_year = '2017' AND calendar_month = '1' AND utility_id = 'WMECO' AND read_cycle_id = '13'
	UPDATE METER_READ_CALENDAR SET READ_DATE = '20170120' WHERE calendar_year = '2017' AND calendar_month = '1' AND utility_id = 'WMECO' AND read_cycle_id = '14'

	COMMIT TRAN
	PRINT 'COMMIT'
END TRY
BEGIN CATCH
	SELECT  
		ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage; 
	ROLLBACK TRAN
	PRINT 'ROLLBACK'
END CATCH