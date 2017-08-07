CREATE TABLE [dbo].[Contact] (
    [ContactID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FirstName]   NVARCHAR (50) NOT NULL,
    [LastName]    NVARCHAR (50) NOT NULL,
    [Title]       NVARCHAR (50) NOT NULL,
    [Phone]       VARCHAR (20)  NOT NULL,
    [Fax]         VARCHAR (20)  NULL,
    [Email]       NVARCHAR (75) NOT NULL,
    [Birthdate]   DATETIME      NULL,
    [Modified]    DATETIME      CONSTRAINT [DF_Contact_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]  INT           CONSTRAINT [DF_Contact_ModifiedBy] DEFAULT ((1029)) NOT NULL,
    [DateCreated] DATETIME      CONSTRAINT [DF_Contact_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   INT           CONSTRAINT [DF_Contact_CreatedBy] DEFAULT ((1029)) NOT NULL,
    CONSTRAINT [PK_Contact_ContactID] PRIMARY KEY CLUSTERED ([ContactID] ASC),
    CONSTRAINT [FK_Contact_UserCreated] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_Contact_UserModified] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [Contact__Phone]
    ON [dbo].[Contact]([Phone] ASC);


GO


Create TRIGGER [dbo].[ContactCleanup]
   ON  [dbo].[Contact]
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
		
	Update  C
	Set
		FirstName = dbo.StripSpecialCharacters(I.FirstName),
		LastName = dbo.StripSpecialCharacters(I.LastName),
		Title = dbo.StripSpecialCharacters(I.Title),
		Email = dbo.StripSpecialCharacters(I.Email),		
		Phone = dbo.StripSpecialCharacters(I.Phone),
		Fax = dbo.StripSpecialCharacters(I.Fax)
	From 
		LibertyPower.dbo.[Contact] C
		Join Inserted I on C.ContactID = I.ContactID
	Where 
		C.ContactID = I.ContactID
END

