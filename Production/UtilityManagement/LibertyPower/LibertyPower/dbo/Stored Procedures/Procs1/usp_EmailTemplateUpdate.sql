
CREATE PROCEDURE [dbo].[usp_EmailTemplateUpdate]
	@EmailTemplateID int
	,@Code varchar(20)
	,@Description varchar(100)
	,@DefaultFromAddressID int
	,@Subject varchar(100)
	,@Body varchar(max)
	,@IsHtml bit = 1
	,@UserID int
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [EmailTemplate]
		SET [Code] = @Code
			,[Description] = @Description
			,[DefaultFromAddressID] = @DefaultFromAddressID
			,[Subject] = @Subject
			,[Body] = @Body
			,[IsHtml] = @IsHtml
		    ,[ModifiedByID] = @UserID
			,[ModifiedDate] = GetDate()
	 WHERE EmailTemplateID = @EmailTemplateID
	 
	SET NOCOUNT OFF;
	 
END
