CREATE TABLE [dbo].[Inputs] (
    [ID]               INT              IDENTITY (1, 1) NOT NULL,
    [InputCode]        VARCHAR (50)     NOT NULL,
    [InputDescription] VARCHAR (200)    NOT NULL,
    [InputTypeID]      INT              NOT NULL,
    [ValueTypeID]      INT              NOT NULL,
    [CurveID]          INT              NULL,
    [Guid]             UNIQUEIDENTIFIER NOT NULL,
    [DateCreated]      DATETIME         NOT NULL,
    [CreatedBy]        INT              NOT NULL,
    [DateModified]     DATETIME         NULL,
    [ModifiedBy]       INT              NULL,
    CONSTRAINT [PK_Inputs] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Inputs_InputType] FOREIGN KEY ([InputTypeID]) REFERENCES [dbo].[InputType] ([ID]),
    CONSTRAINT [FK_Inputs_ValueType] FOREIGN KEY ([ValueTypeID]) REFERENCES [dbo].[ValueType] ([ID])
);

