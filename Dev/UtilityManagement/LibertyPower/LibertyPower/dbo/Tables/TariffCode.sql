CREATE TABLE [dbo].[TariffCode] (
    [ID]   INT          IDENTITY (1, 1) NOT NULL,
    [Code] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TariffCode] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO



CREATE TRIGGER [dbo].[zAuditTariffCodeInsert]
	ON  [dbo].[TariffCode]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditTariffCode]
           ([ID]
           ,[Code])
	SELECT 
		[ID]
           ,[Code]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END

GO



CREATE TRIGGER [dbo].[zAuditTariffCodeUpdate]
	ON  [dbo].[TariffCode]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditTariffCode]
           ([ID]
           ,[Code])
	SELECT 
		[ID]
           ,[Code]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END
