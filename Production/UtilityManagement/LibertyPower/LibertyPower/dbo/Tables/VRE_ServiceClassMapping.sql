CREATE TABLE [dbo].[VRE_ServiceClassMapping] (
    [ID]              INT          IDENTITY (1, 1) NOT NULL,
    [ServiceClass]    VARCHAR (50) NOT NULL,
    [UtilityCode]     VARCHAR (50) NOT NULL,
    [RawServiceClass] VARCHAR (50) NOT NULL,
    [IsActive]        BIT          CONSTRAINT [DF_VRE_ServiceClassMapping_IsActive] DEFAULT ((1)) NOT NULL,
    [DateCreated]     DATETIME     CONSTRAINT [DF_VRE_ServiceClassMapping_DateCreated_1] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT          CONSTRAINT [DF_VRE_ServiceClassMapping_CreatedBy_1] DEFAULT ((0)) NOT NULL,
    [DateModified]    DATETIME     CONSTRAINT [DF_VRE_ServiceClassMapping_DateCreated] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]      INT          CONSTRAINT [DF_VRE_ServiceClassMapping_CreatedBy] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_VRE_ServiceClassMapping_1] PRIMARY KEY CLUSTERED ([UtilityCode] ASC, [RawServiceClass] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VRE_ServiceClassMapping';

