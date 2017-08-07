/*
******************************************************************************

 * PROCEDURE:	[usp_DeleteRecodFromMeterReadCal]
 * PURPOSE:		Delete record in Lp_Common.[dbo].[meter_read_calendar],Staging.Meco and FileImport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 11/11/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE usp_DeleteRecodFromMeterReadCal
(
	
	@FileId AS INT
 )
AS
BEGIN

Set nocount on;
-- Delete record from Lp_Common.[dbo].[meter_read_calendar]
Delete mrc
from Staging.Meco t1 
inner join LibertyPower.[dbo].Utility t2 
on t1.Utility=t2.UtilityCode
inner join Lp_Common.[dbo].[meter_read_calendar] mrc  
on mrc.utility_id=t2.UtilityCode and mrc.calendar_year= t1.[Caldendar Year] and mrc.calendar_month=t1.[Calendar Month]
and mrc.read_cycle_id=Convert(varchar(50),t1.[Read Cycle]) and mrc.read_date=t1.[Read Date] 
where t1.FileImportID= @FileId and t1.[Read Cycle] !> 20

-- Delete record from staging.Meco table
Delete from Staging.Meco where FileImportID= @FileId

-- Delete record from FileImport table
Delete from FileImport where id= @FileId

END
 





