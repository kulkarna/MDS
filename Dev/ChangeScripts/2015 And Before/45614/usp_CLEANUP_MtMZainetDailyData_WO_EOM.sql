USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_CLEANUP_MtMZainetDailyData]    Script Date: 07/28/2014 15:41:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
--========================================
--Author : Luca Fagetti
--Creation Date: 3/17/2014
--Purpose: Cleaning up table MtMZainetDailyData 
--==============Modifications=============
--Author : Luca Fagetti
--Creation Date: 7/28/2014
--Purpose: Cleaning up table MtMZainetDailyData 
-- Exclude EOM dates
	
*/

ALTER PROCEDURE [dbo].[usp_CLEANUP_MtMZainetDailyData]
as

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

--- Determine all distinct dates in the table

	Select distinct rundate
	into #Rundate_for_EOM_exclusion
	from  lp_mtm.dbo.MtMZainetDailyData (nolock)

-- Remove those dates that do match the EOM date for yyyy-mm
-- Formula is: form date with hardcoded first day of the monththen add a month and subtract a day

	Delete from #Rundate_for_EOM_exclusion
	where RunDate = dateadd(day,-1,dateadd(month,1,convert(date, convert(varchar,DATEPART(year,rundate)) + '-' + convert(varchar,DATEPART(MONTH,rundate)) + '-' + '01'))  )

	Create clustered index cidx1 on #Rundate_for_EOM_exclusion (rundate) with (fillfactor = 100)

	Declare @Rowcnt int =1

	While @Rowcnt > 0
		begin
		
			begin transaction

			Delete top (50000) zdd
			from lp_mtm.dbo.MtMZainetDailyData zdd
			join		#Rundate_for_EOM_exclusion t on t.RunDate = zdd.RunDate -- allow deletion only of the dates that are not a EOM
			where zdd.rundate < dateadd(day, -3, convert(date,GETDATE()))

			Select @Rowcnt = @@ROWCOUNT

			commit

			waitfor delay '00:00:01'

		end

	SET NOCOUNT OFF
	
