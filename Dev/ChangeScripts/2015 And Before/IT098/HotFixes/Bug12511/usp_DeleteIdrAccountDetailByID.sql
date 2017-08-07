USE [lp_transactions]
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteIdrAccountDetailByID]    Script Date: 05/23/2013 10:53:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteIdrAccountDetailByID]    Script Date: 05/22/2013 10:47:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DeleteIdrAccountDetailByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DeleteIdrAccountDetailByID]
GO


CREATE PROCEDURE [dbo].[usp_DeleteIdrAccountDetailByID] 
	@IdrAccountDetailIdList as dbo.IDList READONLY
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		BEGIN TRAN	
			Delete d
			from dbo.IdrAccountDetail d
			inner join @IdrAccountDetailIdList t on d.Id = t.Id
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


