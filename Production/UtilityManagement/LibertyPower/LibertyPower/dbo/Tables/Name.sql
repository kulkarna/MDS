CREATE TABLE [dbo].[Name] (
    [NameID]      INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]        NVARCHAR (150) NULL,
    [Modified]    DATETIME       CONSTRAINT [DF_Name_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]  INT            CONSTRAINT [DF_Name_ModifiedBy] DEFAULT ((1029)) NOT NULL,
    [DateCreated] DATETIME       CONSTRAINT [DF_Name_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   INT            CONSTRAINT [DF_Name_CreatedBy] DEFAULT ((1029)) NOT NULL,
    CONSTRAINT [PK_Name_NameID] PRIMARY KEY CLUSTERED ([NameID] ASC),
    CONSTRAINT [FK_Name_UserCreated] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_Name_UserModified] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_Name_FullName]
    ON [dbo].[Name]([Name] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO


Create TRIGGER [dbo].[NameCleanup]
   ON  [dbo].[Name]
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON	
		
	Update  N
	Set
		Name = dbo.StripSpecialCharacters(I.Name)
	From 
		LibertyPower.dbo.[Name] N
		Join Inserted I on N.NameID = I.NameID
	Where 
		N.NameID = I.NameID
END


