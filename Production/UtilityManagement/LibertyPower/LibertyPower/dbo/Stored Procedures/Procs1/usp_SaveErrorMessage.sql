
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

