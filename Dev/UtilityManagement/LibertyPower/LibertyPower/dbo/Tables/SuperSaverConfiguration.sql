CREATE TABLE [dbo].[SuperSaverConfiguration] (
    [SuperSaverID] INT          IDENTITY (1, 1) NOT NULL,
    [DisplayName]  VARCHAR (50) NOT NULL,
    [LowTerm]      INT          NOT NULL,
    [HighTerm]     INT          NOT NULL,
    [CreatedBy]    INT          NOT NULL,
    [DateCreated]  DATETIME     NOT NULL,
    [ModifiedBy]   INT          NOT NULL,
    [DateModified] DATETIME     NOT NULL,
    CONSTRAINT [PK_SuperSaverConfiguration] PRIMARY KEY CLUSTERED ([SuperSaverID] ASC) WITH (FILLFACTOR = 90)
);

