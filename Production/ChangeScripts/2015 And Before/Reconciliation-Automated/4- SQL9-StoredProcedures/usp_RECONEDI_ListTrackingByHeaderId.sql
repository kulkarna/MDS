/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ListTrackingByHeaderId]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_ListTrackingByHeaderId
 * List all tracking records  
 * 
 * History
 *******************************************************************************
 * 2014/04/01 - Felipe Medeiros
 * Created.
 *******************************************************************************
 * <Date Modified,date,> - <Developer Name,,>
 * <Modification Description,,>
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_RECONEDI_ListTrackingByHeaderId]
	@p_ReconID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM RECONEDI_Tracking A (NOLOCK) 
	WHERE A.ReconID = @p_ReconID
	
	SET NOCOUNT OFF;
END


GO
