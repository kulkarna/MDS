CREATE TABLE [dbo].[ServiceClass] (
    [ID]               INT          IDENTITY (1, 1) NOT NULL,
    [ServiceClassCode] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ServiceClass_1] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [UQ__ServiceClass__5728DECD] UNIQUE NONCLUSTERED ([ServiceClassCode] ASC)
);

