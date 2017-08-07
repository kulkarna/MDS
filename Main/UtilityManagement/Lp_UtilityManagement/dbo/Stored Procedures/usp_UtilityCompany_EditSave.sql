--ALTER TABLE dbo.UtilityCompany DROP COLUMN UtilityStatus
--GO
--ALTER TABLE dbo.UtilityCompany ADD UtilityStatusId UNIQUEIDENTIFIER NULL
--GO
--ALTER TABLE [dbo].[UtilityCompany]  WITH CHECK ADD  CONSTRAINT [FK_UtilityCompany_TriStateValuePendingActiveInactive] FOREIGN KEY([UtilityStatusId])
--REFERENCES [dbo].[TriStateValuePendingActiveInactive] ([Id])
--GO

--ALTER TABLE [dbo].[UtilityCompany] CHECK CONSTRAINT [FK_UtilityCompany_TriStateValuePendingActiveInactive]
--GO

CREATE PROC usp_UtilityCompany_EditSave
	@Id AS UNIQUEIDENTIFIER,
	@UtilityCode NVARCHAR(50),
	@FullName NVARCHAR(255),
	@IsoId UNIQUEIDENTIFIER,
	@MarketId UNIQUEIDENTIFIER,
	@PrimaryDunsNumber NVARCHAR(255),
	@LpEntityId NVARCHAR(255),
	@ParentCompany NVARCHAR(255),
	@UtilityStatusId UNIQUEIDENTIFIER,
	@Inactive BIT,
	@LastModifiedBy NVARCHAR(100)
AS
BEGIN

	UPDATE 
		dbo.UtilityCompany 
	SET 
		UtilityCode = @UtilityCode, 
		FullName = @FullName, 
		IsoId = @IsoId, 
		MarketId = @MarketId, 
		PrimaryDunsNumber = @PrimaryDunsNumber, 
		LpEntityId = @LpEntityId, 
		ParentCompany = @ParentCompany, 
		UtilityStatusId = @UtilityStatusId, 
		Inactive = @Inactive, 
		LastModifiedBy = @LastModifiedBy, 
		LastModifiedDate = GETDATE()
	WHERE
		Id = @Id
END