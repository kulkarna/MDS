CREATE TABLE [dbo].[VREAccountTypes] (
    [VreAccountTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [VreAccountType]   VARCHAR (50) NULL,
    CONSTRAINT [PK_VreAccountTypes] PRIMARY KEY CLUSTERED ([VreAccountTypeID] ASC)
);

