CREATE TABLE [dbo].[BusinessType] (
    [BusinessTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Type]           VARCHAR (50) NOT NULL,
    [Sequence]       INT          CONSTRAINT [DF_BusinessType_Sequence] DEFAULT ((9999)) NOT NULL,
    [Active]         BIT          CONSTRAINT [DF_BusinessType_Active] DEFAULT ((1)) NOT NULL,
    [DateCreated]    DATETIME     CONSTRAINT [DF_BusinessType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_BusinessType] PRIMARY KEY CLUSTERED ([BusinessTypeID] ASC)
);

