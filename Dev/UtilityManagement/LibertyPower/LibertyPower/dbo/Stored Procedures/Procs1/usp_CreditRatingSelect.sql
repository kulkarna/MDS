CREATE PROC [dbo].[usp_CreditRatingSelect] 
	-- Add the parameters for the stored procedure here
	@CreditAgencyID  int, 
	@order int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF @order = 0
		SELECT * FROM dbo.CreditRating WHERE CreditAgencyID = @CreditAgencyID
		ORDER BY [Numeric] desc
	ELSE
		SELECT * FROM dbo.CreditRating WHERE CreditAgencyID = @CreditAgencyID
		ORDER BY [Numeric] 
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditRatingSelect';

