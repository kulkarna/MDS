CREATE PROCEDURE [dbo].[usp_EmailTemplateInsert]
	@Code varchar(20)
	,@Description varchar(100)
	,@DefaultFromAddressID int
	,@Subject varchar(100)
	,@Body varchar(MAX)
	,@IsHtml bit
	,@UserID int
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [EmailTemplate]
		([Code]
		,[Description]
		,[DefaultFromAddressID]
		,[Subject]
		,[Body]
		,[IsHtml]
        ,[CreatedByID]
        ,[ModifiedByID])
     VALUES
           (@Code
           ,@Description
           ,@DefaultFromAddressID
		   ,@Subject	
           ,@Body
           ,@IsHtml
           ,@UserID
           ,@UserID)

	SELECT Scope_Identity()

	SET NOCOUNT OFF;

END
