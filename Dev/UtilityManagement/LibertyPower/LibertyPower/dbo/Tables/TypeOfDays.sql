CREATE TABLE [dbo].[TypeOfDays] (
    [Id]                    INT            IDENTITY (1, 1) NOT NULL,
    [TypeOfDaysName]        NVARCHAR (50)  NOT NULL,
    [TypeOfDaysDescription] NVARCHAR (255) NOT NULL,
    [Inactive]              BIT            NOT NULL,
    [CreateBy]              NVARCHAR (255) NULL,
    [CreateDate]            DATETIME       NULL,
    [LastModifiedBy]        NVARCHAR (255) NULL,
    [LastModifiedDate]      DATETIME       NULL,
    CONSTRAINT [PK_TypeOfDays] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

