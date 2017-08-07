CREATE TABLE [dbo].[VRE_MinUsageByServiceClassZone] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [ServiceClass]       NCHAR (50)   NULL,
    [ISOZone]            NCHAR (50)   NULL,
    [MinMonthlyKwhUsage] DECIMAL (18) NULL,
    [DateModified]       DATETIME     CONSTRAINT [DF_VRE_MinUsageByZone_DateCreated] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]         INT          CONSTRAINT [DF_VRE_MinUsageByZone_CreatedBy] DEFAULT ((0)) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VRE_MinUsageByServiceClassZone';

