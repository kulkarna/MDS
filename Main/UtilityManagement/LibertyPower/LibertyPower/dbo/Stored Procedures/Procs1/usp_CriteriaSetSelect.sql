-- =============================================
-- Author:		Antonio Jr
-- Create date: 12/30/2009
-- Description:	Select the CriteriaSet by Id
-- =============================================
CREATE PROCEDURE dbo.usp_CriteriaSetSelect
	@p_Id int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from CriteriaSet where CriteriaSetId = @p_Id
END
