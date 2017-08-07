USE [Lp_transactions]
GO

-- =============================================
-- Author:  Abhijeet Kulkarni
-- Create date: 06/13/2013
-- Description: Delete file log and related data
-- =============================================

/****** Object:  StoredProcedure [dbo].[usp_DeleteAccountData]    Script Date: 04/03/2013 15:37:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteAccountData]    Script Date: 04/01/2013 15:37:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DeleteAccountData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DeleteAccountData]
GO

CREATE PROCEDURE [dbo].[usp_DeleteAccountData] 
	@AccountNumber varchar(50)
	,@UtilityCode varchar(50)
	,@UserName varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
	
		declare @IdrFileLogHeaderID int 
		
		-- First retrieve the ID from the dbo.IdrFileLogHeader based on the passed in parameters		
		select @IdrFileLogHeaderID = h.ID
		from dbo.IdrFileLogHeader h (nolock)
		inner join dbo.IdrFileLogDetail fd (nolock) on fd.FileLogHeaderId = h.ID
		where fd.AccountNumber = @AccountNumber and fd.UtilityCode = @UtilityCode
	
		BEGIN TRAN

			-- IdrFileVsHuDiscrepancies table
			DELETE fd
			From dbo.IdrFileVsHuDiscrepancies fd
			inner join dbo.IdrFileLogDetail d (nolock) on fd.IdrFileLogDetailId = d.ID
			where d.AccountNumber = @AccountNumber and d.UtilityCode = @UtilityCode 
					
			-- IdrFileLogHeader
			Update h
			set	Notes = Notes + ' Account ' + @AccountNumber + ' under utility code ' + @UtilityCode + ' deleted by user ' + @UserName
				, ModifiedBy = @UserName
			from dbo.IdrFileLogHeader h			
			where ID = @IdrFileLogHeaderID
			
			-- IdrFileLogDetail
			delete fd
			from dbo.IdrFileLogDetail fd
			where fd.AccountNumber = @AccountNumber and fd.UtilityCode = @UtilityCode
			
			-- IdrAccountVsHuDiscrepancies
			delete d
			from dbo.IdrAccountVsHuDiscrepancies d
			inner join dbo.IdrNonEdiHeader h on d.IdrNonEdiHeaderId = h.ID
			where h.AccountNumber = @AccountNumber and h.UtilityCode = @UtilityCode
			
			-- IdrNonEdiDetail
			delete d
			from dbo.IdrNonEdiDetail d
			inner join dbo.IdrNonEdiHeader h on h.ID = d.IdrAccountId  
			where h.AccountNumber = @AccountNumber and h.UtilityCode = @UtilityCode
			
			-- IdrAccountDetail
			delete d
			from dbo.IdrAccountDetail d
			inner join dbo.IdrAccountStageInfo h on h.ID = d.IdrAccountId  
			where h.AccountNumber = @AccountNumber and h.UtilityCode = @UtilityCode
			
			-- IdrAccountStageInfo_History			
			delete from dbo.IdrAccountStageInfo_History 
			where AccountNumber = @AccountNumber and UtilityCode = @UtilityCode
			
			-- IdrAccountStageInfo
			delete from dbo.IdrAccountStageInfo  
			where AccountNumber = @AccountNumber and UtilityCode = @UtilityCode

			-- IdrNonEdiHeader
			delete from dbo.IdrNonEdiHeader  
			where AccountNumber = @AccountNumber and UtilityCode = @UtilityCode	
			
			SET NOCOUNT OFF;		
		COMMIT TRAN
	END TRY
	
	BEGIN CATCH	
		declare @ErrorMessage nvarchar(max), @ErrorSeverity int, @ErrorState int;
		select @ErrorMessage = ERROR_MESSAGE() + ' Line ' + cast(ERROR_LINE() as nvarchar(5)), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		ROLLBACK TRANSACTION;
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH			
END


GO


