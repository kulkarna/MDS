CREATE TABLE [dbo].[VREISOZone] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [UtilityCode]  VARCHAR (50) NOT NULL,
    [Zone]         VARCHAR (60) NULL,
    [ISOZone]      VARCHAR (60) NULL,
    [IsActive]     BIT          CONSTRAINT [DF_VREISOZone_IsActive] DEFAULT ((1)) NOT NULL,
    [DateCreated]  DATETIME     CONSTRAINT [DF_VREISOZone_DateCreated] DEFAULT (getdate()) NOT NULL,
    [DateModified] DATETIME     CONSTRAINT [DF_VREISOZone_DateModified] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    INT          CONSTRAINT [DF_VREISOZone_CreatedBy] DEFAULT ((0)) NOT NULL,
    [ModifiedBy]   INT          CONSTRAINT [DF_VREISOZone_ModifiedBy] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_VREISOZone] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VREISOZone';

