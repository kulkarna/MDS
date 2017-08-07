CREATE TABLE [dbo].[AccountType] (
    [ID]                   INT           IDENTITY (1, 1) NOT NULL,
    [AccountType]          VARCHAR (50)  NOT NULL,
    [Description]          VARCHAR (100) DEFAULT ('') NOT NULL,
    [AccountGroup]         VARCHAR (50)  NULL,
    [DateCreated]          DATETIME      CONSTRAINT [DF_AccountType_DateCreated] DEFAULT (getdate()) NOT NULL,
    [ProductAccountTypeID] INT           NULL,
    CONSTRAINT [PK_EflAccountType] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO


CREATE TRIGGER [dbo].[zAuditAccountTypeUpdate]
	ON  [dbo].[AccountType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditAccountType] 
	(
		[ID],
		[AccountType],
		[Description],
		[AccountGroup],
		[DateCreated],
		[ProductAccountTypeID]
	)
	SELECT 
		[ID],
		[AccountType],
		[Description],
		[AccountGroup],
		[DateCreated],
		[ProductAccountTypeID]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Account', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountType';

