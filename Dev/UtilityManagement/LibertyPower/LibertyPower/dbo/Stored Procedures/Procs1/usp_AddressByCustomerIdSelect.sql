/*
Date	  : 6/11/2012
Created By: Jaime Forero
Notes	  : Gets all address records by customerid

TEST: 
EXEC LibertyPower.[dbo].[usp_AddressByCustomerIdSelect] 261033

*/
CREATE PROCEDURE [dbo].[usp_AddressByCustomerIdSelect]
	@CustomerID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		A.[AddressID],
		A.[Address1],
		A.[Address2],
		A.[City],
		A.[State],
		A.[StateFips],
		A.[Zip],
		A.[County],
		A.[CountyFips],
		A.[Modified],
		A.[ModifiedBy],
		A.[DateCreated],
		A.[CreatedBy]
	From LibertyPower.dbo.[Address] A WITH (nolock)
	JOIN LibertyPower.dbo.[CustomerAddress] CA WITH (NOLOCK) ON A.AddressID = CA.AddressId
	Where CustomerID = @CustomerID

END

