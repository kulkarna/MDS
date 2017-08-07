USE lp_mtm
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MTMReportBookInsert]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MTMReportBookInsert]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo 
-- Create date: 5/23/2013
-- Description:	create new report book 
-- =============================================
-- exec 
-- ============================================
CREATE PROCEDURE usp_MTMReportBookInsert
( @BookName varchar(150)
	, @Inactive bit = 0 
	, @userId int 
)
AS 
BEGIN 

	SET NOCOUNT ON;

	INSERT INTO [lp_mtm].[dbo].[MtMReportBook]
           ([BookName]
           ,[Inactive]
           ,[DateCreated]
           ,[CreatedBy]
          )
     VALUES
           (@BookName
           ,@Inactive
           ,GETDATE()
           ,@userId
			)
     RETURN SCOPE_IDENTITY()

	 SET NOCOUNT OFF;
END
GO


