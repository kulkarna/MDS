USE [lp_transactions]
GO

/****** Object:  StoredProcedure [dbo].[usp_EdiImport_CreateIdrNonEdiData]    Script Date: 05/23/2013 10:40:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[usp_EdiImport_CreateIdrNonEdiData]    Script Date: 05/22/2013 10:47:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_EdiImport_CreateIdrNonEdiData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_EdiImport_CreateIdrNonEdiData]
GO


-- ======================================================
-- Author:		Abhi/Miguel
-- Create date: 5/2/2013
-- Description:	Creates new IdrNonEdiRecords on tables
--				'IdrNonEdiHeader' and 'IdrNonEdiDetail'.
-- =====================================================

CREATE PROCEDURE [dbo].[usp_EdiImport_CreateIdrNonEdiData] 
	@EdiDayRecordList as dbo.EdiDayRecord READONLY
	, @Interval int
	, @UserName varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	declare @IdrAccountId int
	BEGIN TRY
	
		SELECT distinct @IdrAccountId = ID
		FROM dbo.IdrNonEdiHeader i (NOLOCK)
		INNER JOIN @EdiDayRecordList e ON i.AccountNumber = e.AccountNumber AND i.UtilityCode = e.UtilityCode

		BEGIN TRAN
			-- Check if we have a IdrNonEdiHeader record
			IF (IsNull(@IdrAccountId, 0) = 0)
			BEGIN	
				INSERT INTO dbo.IdrNonEdiHeader (UtilityCode, AccountNumber, UsageSource, UsageType, OriginalUnit, Intervals, CreatedBy, [TimeStamp])
				SELECT TOP 1 UtilityCode, AccountNumber, 0, 3, UnitOfMeasurement, 24 * 60/@Interval, @UserName, GETDATE()
				FROM @EdiDayRecordList
				
				Set @IdrAccountId = SCOPE_IDENTITY()
			END
			
			
			-- Delete existing data for the account
			Delete from  d 
			from dbo.IdrNonEdiDetail d inner join
				@EdiDayRecordList t on d.IdrAccountId = @IdrAccountId and t.Date = d.IdrDate 	
			
			-- Insert the rows in the IdrNonEdiDetails
			INSERT INTO dbo.IdrNonEdiDetail (IdrAccountId, IdrDate, Intervals)
			select @IdrAccountId, Date, case
				when @Interval = 60 then
					isnull(C45, '') + ',' + 		
					isnull(C145, '') + ',' + 		
					isnull(C245, '') + ',' + 		
					isnull(C345, '') + ',' + 
					isnull(C445, '') + ',' + 
					isnull(C545, '') + ',' + 
					isnull(C645, '') + ',' + 
					isnull(C745, '') + ',' + 
					isnull(C845, '') + ',' + 
					isnull(C945, '') + ',' + 
					isnull(C1045, '') + ',' + 
					isnull(C1145, '') + ',' + 
					isnull(C1245, '') + ',' + 
					isnull(C1345, '') + ',' + 
					isnull(C1445, '') + ',' + 
					isnull(C1545, '') + ',' + 
					isnull(C1645, '') + ',' + 
					isnull(C1745, '') + ',' + 
					isnull(C1845, '') + ',' + 
					isnull(C1945, '') + ',' + 
					isnull(C2045, '') + ',' + 
					isnull(C2145, '') + ',' + 
					isnull(C2245, '') + ',' + 
					isnull(C2345, '') 
					
				when @Interval = 30 then
					isnull(C15, '') + ',' + isnull(C45, '') + ',' + 		
					isnull(C115, '') + ',' + isnull(C145, '') + ',' + 		
					isnull(C215, '') + ',' + isnull(C245, '') + ',' + 		
					isnull(C315, '') + ',' + isnull(C345, '') + ',' + 
					isnull(C415, '') + ',' + isnull(C445, '') + ',' + 
					isnull(C515, '') + ',' + isnull(C545, '') + ',' + 
					isnull(C615, '') + ',' + isnull(C645, '') + ',' + 
					isnull(C715, '') + ',' + isnull(C745, '') + ',' + 
					isnull(C815, '') + ',' + isnull(C845, '') + ',' + 
					isnull(C915, '') + ',' + isnull(C945, '') + ',' + 
					isnull(C1015, '') + ',' + isnull(C1045, '') + ',' + 
					isnull(C1115, '') + ',' + isnull(C1145, '') + ',' + 
					isnull(C1215, '') + ',' + isnull(C1245, '') + ',' + 
					isnull(C1315, '') + ',' + isnull(C1345, '') + ',' + 
					isnull(C1415, '') + ',' + isnull(C1445, '') + ',' + 
					isnull(C1515, '') + ',' + isnull(C1545, '') + ',' + 
					isnull(C1615, '') + ',' + isnull(C1645, '') + ',' + 
					isnull(C1715, '') + ',' + isnull(C1745, '') + ',' + 
					isnull(C1815, '') + ',' + isnull(C1845, '') + ',' + 
					isnull(C1915, '') + ',' + isnull(C1945, '') + ',' + 
					isnull(C2015, '') + ',' + isnull(C2045, '') + ',' + 
					isnull(C2115, '') + ',' + isnull(C2145, '') + ',' + 
					isnull(C2215, '') + ',' + isnull(C2245, '') + ',' + 
					isnull(C2315, '') + ',' + isnull(C2345, '')

				when @Interval = 15 then
					isnull(C0, '') + ',' + isnull(C15, '') + ',' + isnull(C30, '') + ','  + isnull(C45, '') + ',' +
					isnull(C100, '') + ',' + isnull(C115, '') + ',' + isnull(C130, '') + ','  + isnull(C145, '') + ',' +
					isnull(C200, '') + ',' + isnull(C215, '') + ',' + isnull(C230, '') + ','  + isnull(C245, '') + ',' +
					isnull(C300, '') + ',' + isnull(C315, '') + ',' + isnull(C330, '') + ','  + isnull(C345, '') + ',' +
					isnull(C400, '') + ',' + isnull(C415, '') + ',' + isnull(C430, '') + ','  + isnull(C445, '') + ',' +
					isnull(C500, '') + ',' + isnull(C515, '') + ',' + isnull(C530, '') + ','  + isnull(C545, '') + ',' +
					isnull(C600, '') + ',' + isnull(C615, '') + ',' + isnull(C630, '') + ','  + isnull(C645, '') + ',' +
					isnull(C700, '') + ',' + isnull(C715, '') + ',' + isnull(C730, '') + ','  + isnull(C745, '') + ',' +
					isnull(C800, '') + ',' + isnull(C815, '') + ',' + isnull(C830, '') + ','  + isnull(C845, '') + ',' +
					isnull(C900, '') + ',' + isnull(C915, '') + ',' + isnull(C930, '') + ','  + isnull(C945, '') + ',' +
					isnull(C1000, '') + ',' + isnull(C1015, '') + ',' + isnull(C1030, '') + ','  + isnull(C1045, '') + ',' +
					isnull(C1100, '') + ',' + isnull(C1115, '') + ',' + isnull(C1130, '') + ','  + isnull(C1145, '') + ',' +
					isnull(C1200, '') + ',' + isnull(C1215, '') + ',' + isnull(C1230, '') + ','  + isnull(C1245, '') + ',' +
					isnull(C1300, '') + ',' + isnull(C1315, '') + ',' + isnull(C1330, '') + ','  + isnull(C1345, '') + ',' +
					isnull(C1400, '') + ',' + isnull(C1415, '') + ',' + isnull(C1430, '') + ','  + isnull(C1445, '') + ',' +
					isnull(C1500, '') + ',' + isnull(C1515, '') + ',' + isnull(C1530, '') + ','  + isnull(C1545, '') + ',' +
					isnull(C1600, '') + ',' + isnull(C1615, '') + ',' + isnull(C1630, '') + ','  + isnull(C1645, '') + ',' +
					isnull(C1700, '') + ',' + isnull(C1715, '') + ',' + isnull(C1730, '') + ','  + isnull(C1745, '') + ',' +
					isnull(C1800, '') + ',' + isnull(C1815, '') + ',' + isnull(C1830, '') + ','  + isnull(C1845, '') + ',' +
					isnull(C1900, '') + ',' + isnull(C1915, '') + ',' + isnull(C1930, '') + ','  + isnull(C1945, '') + ',' +
					isnull(C2000, '') + ',' + isnull(C2015, '') + ',' + isnull(C2030, '') + ','  + isnull(C2045, '') + ',' +
					isnull(C2100, '') + ',' + isnull(C2115, '') + ',' + isnull(C2130, '') + ','  + isnull(C2145, '') + ',' +
					isnull(C2200, '') + ',' + isnull(C2215, '') + ',' + isnull(C2230, '') + ','  + isnull(C2245, '') + ',' +
					isnull(C2300, '') + ',' + isnull(C2315, '') + ',' + isnull(C2330, '') + ','  + isnull(C2345, '')
				end
			from @EdiDayRecordList
		COMMIT TRAN
	END TRY
	
	BEGIN CATCH	
		declare @ErrorMessage nvarchar(max), @ErrorSeverity int, @ErrorState int;
		select @ErrorMessage = ERROR_MESSAGE() + ' Line ' + cast(ERROR_LINE() as nvarchar(5)), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		ROLLBACK TRANSACTION;
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH			

	SET NOCOUNT OFF;
END

GO

