USE lp_mtm
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MTMReportBookUpdate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MTMReportBookUpdate]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo 
-- Create date: 5/23/2013
-- Description:	update report book 
-- =============================================
-- exec 
-- ============================================
CREATE PROCEDURE usp_MTMReportBookUpdate
( @BookID int 
	, @BookName varchar(150)
	, @Inactive bit = 0 
	, @userId int 
)
AS 
BEGIN 

	SET NOCOUNT ON;

	UPDATE [lp_mtm].[dbo].[MtMReportBook]
	SET [BookName] = @BookName
      ,[Inactive] = @Inactive
    
      ,[DateModified] = GETDATE()
      ,[ModifiedBY] = @userId
	WHERE BookID = @BookID

	SET NOCOUNT OFF;
END
GO


