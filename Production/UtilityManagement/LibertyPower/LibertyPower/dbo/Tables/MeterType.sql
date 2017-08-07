CREATE TABLE [dbo].[MeterType] (
    [ID]            INT          IDENTITY (1, 1) NOT NULL,
    [MeterTypeCode] VARCHAR (50) NOT NULL,
    [Sequence]      INT          CONSTRAINT [DF_MeterType_Sequence] DEFAULT ((9999)) NOT NULL,
    [Active]        BIT          CONSTRAINT [DF_MeterType_Active] DEFAULT ((1)) NOT NULL,
    [DateCreated]   DATETIME     CONSTRAINT [DF_MeterType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_MeterType] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [UQ__MeterType__629A9179] UNIQUE NONCLUSTERED ([MeterTypeCode] ASC)
);

