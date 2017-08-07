CREATE TABLE [dbo].[RateCodePreferenceBySlice] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [Utility]            VARCHAR (50) NOT NULL,
    [ServiceClass]       VARCHAR (50) NULL,
    [Zone]               VARCHAR (50) NULL,
    [MeterType]          VARCHAR (50) NULL,
    [RateCodePreference] INT          NOT NULL,
    [DateCreated]        DATETIME     CONSTRAINT [DF_RateCodePreferenceBySlice_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          INT          CONSTRAINT [DF_RateCodePreferenceBySlice_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateModified]       DATETIME     CONSTRAINT [DF_RateCodePreferenceBySlice_DateModified] DEFAULT (getdate()) NULL,
    [ModifiedBy]         INT          NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RateCodePreferenceBySlice';

