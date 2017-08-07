Create PROCEDURE [dbo].[usp_CustomerContactsSelect]
	@CustomerId int
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
		CustomerId = @CustomerId
END

