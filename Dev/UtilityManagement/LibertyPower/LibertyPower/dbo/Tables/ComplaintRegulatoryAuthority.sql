CREATE TABLE [dbo].[ComplaintRegulatoryAuthority] (
    [ComplaintRegulatoryAuthorityID] INT           IDENTITY (1, 1) NOT NULL,
    [Name]                           VARCHAR (255) NOT NULL,
    [RequiredDaysForResolution]      INT           NOT NULL,
    [MarketCode]                     CHAR (2)      NULL,
    [IsActive]                       BIT           CONSTRAINT [DF_ComplaintRegulatoryAuthority_IsActive] DEFAULT ((1)) NOT NULL,
    [CalendarType]                   VARCHAR (10)  NULL,
    [LegacyID]                       INT           NULL,
    CONSTRAINT [PK_RegulatoryAuthority] PRIMARY KEY CLUSTERED ([ComplaintRegulatoryAuthorityID] ASC)
);

