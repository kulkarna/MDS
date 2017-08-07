
-- =============================================
-- Author:		<Lev A. Rosenblum>
-- Create date: <09/06/2012>
-- Description:	<Update MultiTermWinServiceStatusId into MultiTermWinServiceData table >
-- =============================================
-- ALTER date: <12/04/2012> by Lev A. Rosenblum
-- Add @ErrMsg with default value=null
-- =============================================
CREATE PROCEDURE [dbo].[usp_UpdateStatusMultiTermRecord] 
(
	@RecordId int
	, @ProcessStatusId int
	, @UserId int
	, @ErrMsg nvarchar(200) = null
)
AS
DECLARE @Now DATETIME
SET @Now=GETDATE()
BEGIN
	SET NOCOUNT ON;
	Update dbo.MultiTermWinServiceData
	SET MultiTermWinServiceStatusId=@ProcessStatusId
	, DateModified=@Now
	, ServiceLastRunDate=@Now
	, ModifiedBy=@UserId
	, IstaErrorMssg=CASE when @ErrMsg=NULL or @ErrMsg='' then NULL else @ErrMsg END
	WHERE ID=@RecordId
END

