CREATE TABLE [dbo].[UsageReqStatus] (
    [UsageReqStatusID] INT          IDENTITY (1, 1) NOT NULL,
    [Status]           VARCHAR (50) NOT NULL,
    [Sequence]         INT          CONSTRAINT [DF_UsageReqStatus_Sequence] DEFAULT ((9999)) NOT NULL,
    [Active]           BIT          CONSTRAINT [DF_UsageReqStatus_Active] DEFAULT ((1)) NOT NULL,
    [DateCreated]      DATETIME     CONSTRAINT [DF_UsageReqStatus_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_UsageReqStatus] PRIMARY KEY CLUSTERED ([UsageReqStatusID] ASC)
);

