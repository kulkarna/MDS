USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_SaveErrorMessage]    Script Date: 09/13/2012 15:47:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Lev A. Rosenblum>
-- Create date: <09/13/2012>
-- Description:	<Save error message the record submitted to ISTA (processed by win. service)>
-- =============================================
CREATE PROCEDURE [dbo].[usp_SaveErrorMessage]
(
	@RecordId int
	, @ErrorMssg nvarchar(200)
	, @UserId int	
)
AS
BEGIN
	SET NOCOUNT ON;

	Update dbo.MultiTermWinServiceData
	SET IstaErrorMssg=@ErrorMssg
	, DateModified=GETDATE()
	, ModifiedBy=@UserId
	WHERE ID=@RecordId
	
END

GO

