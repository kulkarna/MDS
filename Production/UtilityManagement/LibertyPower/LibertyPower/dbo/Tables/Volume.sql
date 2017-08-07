CREATE TABLE [dbo].[Volume] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [VolumeCode]        VARCHAR (20)  NOT NULL,
    [VolumeDescription] VARCHAR (200) NOT NULL,
    [Formula]           VARCHAR (300) NOT NULL,
    [DateCreated]       DATETIME      NOT NULL,
    [CreatedBy]         INT           NOT NULL,
    [DateModified]      DATETIME      NULL,
    [ModifiedBy]        INT           NULL,
    CONSTRAINT [PK_Volume] PRIMARY KEY CLUSTERED ([ID] ASC)
);

