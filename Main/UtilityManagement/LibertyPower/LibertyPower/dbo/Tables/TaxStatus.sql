CREATE TABLE [dbo].[TaxStatus] (
    [TaxStatusID] INT          IDENTITY (1, 1) NOT NULL,
    [Status]      VARCHAR (50) NOT NULL,
    [Sequence]    INT          CONSTRAINT [DF_TaxStatus_Sequence] DEFAULT ((9999)) NOT NULL,
    [Active]      BIT          CONSTRAINT [DF_TaxStatus_Active] DEFAULT ((1)) NOT NULL,
    [DateCreated] DATETIME     NOT NULL,
    CONSTRAINT [PK_TaxStatus] PRIMARY KEY CLUSTERED ([TaxStatusID] ASC)
);

