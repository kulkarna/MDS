-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- ADD @IsSilent parameter to procedure calls
-- =======================================

CREATE PROCEDURE [dbo].[usp_CustomerNameCompleteInsert]
	@CustomerID int,
	@Name VARCHAR(150),
	@ModifiedBy INT,
	@CreatedBy INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @NameID INT;
	DECLARE @CustomerNameID INT;

	EXECUTE @NameID  = [Libertypower].[dbo].[usp_NameInsert] @Name,@ModifiedBy ,@CreatedBy, 1;
	EXECUTE @CustomerNameID = [Libertypower].[dbo].[usp_CustomerNameInsert] @CustomerID,@NameID,@ModifiedBy,@CreatedBy, 1;

	RETURN @NameID;

END


