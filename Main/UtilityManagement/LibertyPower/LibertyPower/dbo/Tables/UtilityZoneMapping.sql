CREATE TABLE [dbo].[UtilityZoneMapping] (
    [ID]            INT              IDENTITY (1, 1) NOT NULL,
    [UtilityID]     INT              NULL,
    [Grid]          VARCHAR (100)    NULL,
    [LBMPZone]      VARCHAR (100)    NULL,
    [LossFactor]    DECIMAL (20, 16) NULL,
    [IsActive]      TINYINT          CONSTRAINT [DF_ZoneIsActive] DEFAULT ((1)) NULL,
    [UtilityZoneID] INT              NULL,
    [DateCreated]   DATETIME         CONSTRAINT [DF_UtilityZoneMapping_DateCreated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_UtilityZoneMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

