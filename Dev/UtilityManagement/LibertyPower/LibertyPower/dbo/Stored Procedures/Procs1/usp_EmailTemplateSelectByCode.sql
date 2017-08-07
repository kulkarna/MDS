CREATE PROCEDURE [dbo].[usp_EmailTemplateSelectByCode]
	@Code varchar(20)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @EmailTemplateID INT

	SELECT @EmailTemplateID = EmailTemplateID FROM EmailTemplate WHERE Code = @Code

	SELECT 
		EmailTemplate.EmailTemplateID,
		EmailTemplate.Code,
		EmailTemplate.[Description],
		EmailTemplateAddress.EmailTemplateAddress AS FromMailAddress,
		EmailTemplateAddress.DisplayName AS FromDisplayName, 
		EmailTemplate.[Subject],
		EmailTemplate.Body,
		EmailTemplate.IsHtml
	FROM EmailTemplate
		INNER JOIN EmailTemplateAddress ON EmailTemplateAddress.EmailTemplateAddressID = EmailTemplate.DefaultFromAddressID
	WHERE EmailTemplateID = @EmailTemplateID
 
	SELECT   
		EmailTemplateAddress.EmailTemplateAddress AS EmailAddress, 
		EmailTemplateAddress.DisplayName, 
		EmailTemplateRecipient.EmailRecipientTypeID,
		EmailRecipientType.TypeName AS EmailRecipientTypeName
	FROM EmailTemplateRecipient
		INNER JOIN EmailTemplateAddress ON EmailTemplateRecipient.EmailTemplateAddressID = EmailTemplateAddress.EmailTemplateAddressID 
		INNER JOIN EmailRecipientType ON EmailTemplateRecipient.EmailRecipientTypeID = EmailRecipientType.EmailRecipientTypeID
 	WHERE EmailTemplateRecipient.EmailTemplateID = @EmailTemplateID

	SET NOCOUNT OFF;

END

