CREATE proc [dbo].[usp_CreditScoreRangeSelect] 
	-- Add the parameters for the stored procedure here
	@CreditAgencyID  int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM dbo.CreditAgencyScoreRange WHERE CreditAgencyID = @CreditAgencyID
                                               
		 
	
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditScoreRangeSelect';

