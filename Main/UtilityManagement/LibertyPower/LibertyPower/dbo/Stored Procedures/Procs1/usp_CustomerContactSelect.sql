CREATE PROCEDURE [dbo].[usp_CustomerContactSelect]
	@CustomerContactId int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		CustomerContactId,
		CustomerID,
		ContactID,
		Modified,
		ModifiedBy,
		DateCreated,
		CreatedBy
	From 
		LibertyPower.dbo.CustomerContact with (nolock)		
	Where
		CustomerContactId = @CustomerContactId
END

