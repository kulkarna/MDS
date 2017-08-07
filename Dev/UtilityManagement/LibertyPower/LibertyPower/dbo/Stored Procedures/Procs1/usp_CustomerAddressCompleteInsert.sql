
-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- ADD @IsSilent parameter for procedure calls
-- =======================================

CREATE PROCEDURE [dbo].[usp_CustomerAddressCompleteInsert]
	@CustomerID int,
	@Address1 nvarchar(150),
	@Address2 nvarchar(150) = '',
	@City nvarchar(100),
	@State char(2),
	@StateFips char(2) = '',
	@Zip char(10),
	@County nvarchar(100) = '',
	@CountyFips char(3) = '',
	@ModifiedBy int,
	@CreatedBy int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @AddressID INT;

	EXECUTE @AddressID = [Libertypower].[dbo].[usp_AddressInsert] 
	   @Address1
	  ,@Address2
	  ,@City
	  ,@State
	  ,@StateFips
	  ,@Zip
	  ,@County
	  ,@CountyFips
	  ,@ModifiedBy
	  ,@CreatedBy
	  ,1;

	DECLARE @CustomerAddressId INT;
	EXECUTE @CustomerAddressId = [Libertypower].[dbo].[usp_CustomerAddressInsert] 
	   @CustomerID
	  ,@AddressID
	  ,@ModifiedBy
	  ,@CreatedBy
	  ,1
   
	RETURN @AddressID;
END

