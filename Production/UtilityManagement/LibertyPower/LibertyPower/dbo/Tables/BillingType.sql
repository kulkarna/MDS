CREATE TABLE [dbo].[BillingType] (
    [BillingTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Type]          VARCHAR (50) NOT NULL,
    [Sequence]      INT          CONSTRAINT [DF_BillingType_Sequence] DEFAULT ((9999)) NOT NULL,
    [Active]        BIT          CONSTRAINT [DF_BillingType_Active] DEFAULT ((1)) NOT NULL,
    [DateCreated]   DATETIME     NOT NULL,
    [Description]   VARCHAR (50) NULL,
    CONSTRAINT [PK_BillingType] PRIMARY KEY CLUSTERED ([BillingTypeID] ASC)
);


GO



CREATE TRIGGER [dbo].[zAuditBillingTypeInsert]
	ON  [dbo].[BillingType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditBillingType]
           ([BillingTypeID]
           ,[Type]
           ,[Sequence]
           ,[Active]
           ,[DateCreated]
           ,[Description])
	SELECT 
		[BillingTypeID]
           ,[Type]
           ,[Sequence]
           ,[Active]
           ,[DateCreated]
           ,[Description]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END

GO



CREATE TRIGGER [dbo].[zAuditBillingTypeUpdate]
	ON  [dbo].[BillingType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditBillingType]
           ([BillingTypeID]
           ,[Type]
           ,[Sequence]
           ,[Active]
           ,[DateCreated]
           ,[Description])
	SELECT 
		[BillingTypeID]
           ,[Type]
           ,[Sequence]
           ,[Active]
           ,[DateCreated]
           ,[Description]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END
