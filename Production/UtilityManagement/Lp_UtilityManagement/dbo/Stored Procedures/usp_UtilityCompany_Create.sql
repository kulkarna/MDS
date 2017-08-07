CREATE PROC usp_UtilityCompany_Create
	@UtilityCode NVARCHAR(50),
	@FullName NVARCHAR(255),
	@IsoId UNIQUEIDENTIFIER,
	@MarketId UNIQUEIDENTIFIER,
	@PrimaryDunsNumber NVARCHAR(255),
	@LpEntityId NVARCHAR(255),
	@ParentCompany NVARCHAR(255),
	@UtilityStatusId UNIQUEIDENTIFIER,
	@Inactive BIT,
	@User NVARCHAR(100)
AS
BEGIN

	INSERT INTO 
		dbo.UtilityCompany 
		(Id, UtilityIdInt, UtilityCode, FullName, IsoId, MarketId, PrimaryDunsNumber, LpEntityId, 
			ParentCompany, UtilityStatusId, Inactive, LastModifiedBy, LastModifiedDate, CreatedBy, CreatedDate )
		VALUES
		(NEWID(), (SELECT MAX(UtilityIdInt) + 1 FROM UtilityCompany), @UtilityCode, @FullName, @IsoId, @MarketId, 
		@PrimaryDunsNumber, @LpEntityId, @ParentCompany, @UtilityStatusId, @Inactive, 
		@User, GETDATE(), @User, GETDATE())
END