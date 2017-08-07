---------------------------------------------------------------------------------------------------
-- Added			: Fernando ML Alves
-- PBI          : 56910
-- Date			: 12/21/2014
-- Description	: Create a new email type, group and add a new email in the database so that 
--				  sending emails to the lptroubleshooting email address is possible.
---------------------------------------------------------------------------------------------------

USE Libertypower;

DECLARE @EmailTypeID INT = 10;
DECLARE @EmailGroupID INT;
DECLARE @Description VARCHAR(255) = 'Troubleshooting Assets';
DECLARE @EmailAddress VARCHAR(255) = 'lptroubleshooting@libertypowercorp.com';

IF NOT EXISTS (SELECT * FROM EmailType WITH (NOLOCK) WHERE Description=@Description)
	BEGIN
		SET IDENTITY_INSERT EmailType ON;
		INSERT INTO EmailType (EmailTypeID, Description) VALUES (@EmailTypeID, @Description);
		SET IDENTITY_INSERT EmailType OFF;
		SELECT @EmailTypeID = SCOPE_IDENTITY();
	END
ELSE
	BEGIN
		SELECT @EmailTypeID = EmailTypeID FROM EmailType WITH (NOLOCK) WHERE Description=@Description;
	END

IF NOT EXISTS (SELECT * FROM EmailGroup WITH (NOLOCK) WHERE Description=@Description)
	BEGIN
		INSERT INTO EmailGroup (Description) VALUES (@Description);
		SELECT @EmailGroupID = SCOPE_IDENTITY();
	END
ELSE
	BEGIN
		SELECT @EmailGroupID=EmailGroupID FROM EmailGroup WITH (NOLOCK) WHERE Description=@Description;
	END

IF NOT EXISTS (SELECT * FROM EmailTypeEmailGroup WITH (NOLOCK) WHERE EmailTypeID=@EmailTypeID AND EmailGroupID=@EmailGroupID)
	INSERT INTO EmailTypeEmailGroup(EmailTypeID, EmailGroupID) VALUES (@EmailTypeID, @EmailGroupID);

IF NOT EXISTS (SELECT * FROM EmailDistributionList WITH (NOLOCK) WHERE EmailGroupID=@EmailGroupID)
	INSERT INTO EmailDistributionList(EmailGroupID, EmailAddress, Created) VALUES (@EmailGroupID, @EmailAddress, GETDATE());
GO
