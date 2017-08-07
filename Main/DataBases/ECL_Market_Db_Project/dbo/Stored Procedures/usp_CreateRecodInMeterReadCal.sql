﻿/*
******************************************************************************

 * PROCEDURE:	[usp_CreateRecodInMeterReadCal]
 * PURPOSE:		Insert record in Lp_Common.[dbo].[meter_read_calendar] table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 11/11/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE usp_CreateRecodInMeterReadCal
(
	
	@FileId AS INT
 )
AS
BEGIN

Set nocount on;
-- Insert record in Lp_Common.[dbo].[meter_read_calendar]
Insert into Lp_Common.[dbo].[meter_read_calendar](calendar_year,calendar_month,utility_id,read_cycle_id,read_date)
Select 
t1.[Caldendar Year],
t1.[Calendar Month],
t2.[UtilityCode],
t1.[Read Cycle],
t1.[Read Date]
from Staging.Meco t1 with(nolock) 
inner join LibertyPower.[dbo].Utility t2 With(Nolock)
on t1.Utility=t2.UtilityCode
where t1.FileImportID= @FileId and t1.[Read Cycle] !> 20
and NOT EXISTS
    (SELECT 1 
     from Lp_common.dbo.meter_read_calendar mcr with(nolock) 
	 where  mcr.calendar_year = t1.[Caldendar Year]  and mcr.calendar_month= t1.[Calendar Month]
	  and mcr.read_cycle_id = Convert(Varchar(50),t1.[Read Cycle])  and mcr.utility_id=t2.UtilityCode and mcr.read_date=t1.[Read Date])


END
 






