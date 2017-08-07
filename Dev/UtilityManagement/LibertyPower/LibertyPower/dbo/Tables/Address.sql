CREATE TABLE [dbo].[Address] (
    [AddressID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Address1]    NVARCHAR (150) NOT NULL,
    [Address2]    NVARCHAR (150) NULL,
    [City]        NVARCHAR (100) NOT NULL,
    [State]       CHAR (2)       NOT NULL,
    [StateFips]   CHAR (2)       NULL,
    [Zip]         CHAR (10)      NOT NULL,
    [County]      NVARCHAR (100) NULL,
    [CountyFips]  CHAR (3)       NULL,
    [Modified]    DATETIME       CONSTRAINT [DF_Address_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]  INT            CONSTRAINT [DF_Address_ModifiedBy] DEFAULT ((1029)) NOT NULL,
    [DateCreated] DATETIME       CONSTRAINT [DF_Address_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   INT            CONSTRAINT [DF_Address_CreatedBy] DEFAULT ((1029)) NOT NULL,
    CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED ([AddressID] ASC),
    CONSTRAINT [FK_Address_UserCreated] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_Address_UserModified] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);


GO
Create TRIGGER [dbo].[AddressCleanup]
   ON  dbo.Address
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON	
		
	Update  A
	Set
		Address1 = dbo.StripSpecialCharacters(I.address1),
		Address2 = dbo.StripSpecialCharacters(I.address2),
		City = dbo.StripSpecialCharacters(I.city),
		[State] = dbo.StripSpecialCharacters(I.[state]),
		County = dbo.StripSpecialCharacters(I.county)
	From 
		LibertyPower.dbo.[Address] A
		Join Inserted I on A.AddressID = I.AddressID
	Where 
		A.AddressID = I.AddressID
END
