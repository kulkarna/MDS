CREATE TABLE [dbo].[BusinessActivity] (
    [BusinessActivityID] INT          IDENTITY (1, 1) NOT NULL,
    [Activity]           VARCHAR (50) NOT NULL,
    [Sequence]           INT          CONSTRAINT [DF_BusinessActivity_Sequence] DEFAULT ((9999)) NOT NULL,
    [Active]             BIT          CONSTRAINT [DF_BusinessActivity_Active] DEFAULT ((1)) NOT NULL,
    [DateCreated]        DATETIME     CONSTRAINT [DF_BusinessActivity_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_BusinessActivity] PRIMARY KEY CLUSTERED ([BusinessActivityID] ASC)
);

