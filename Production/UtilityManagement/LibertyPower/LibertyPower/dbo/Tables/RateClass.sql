CREATE TABLE [dbo].[RateClass] (
    [ID]            INT          IDENTITY (1, 1) NOT NULL,
    [RateClassCode] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_RateClass] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO



CREATE TRIGGER [dbo].[zAuditRateClassUpdate]
	ON  [dbo].[RateClass]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditRateClass]
           ([ID]
           ,[RateClassCode])
	SELECT 
		[ID],[RateClassCode]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END




GO



CREATE TRIGGER [dbo].[zAuditRateClassInsert]
	ON  [dbo].[RateClass]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditRateClass]
           ([ID]
           ,[RateClassCode])
	SELECT 
		[ID],[RateClassCode]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END



