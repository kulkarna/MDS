CREATE TABLE [dbo].[VREAncillaryServicesCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_PEAncillaryServiceAndReplacementReserveCurve_FileContextGuid] DEFAULT (newid()) NOT NULL,
    [ZoneID]          VARCHAR (50)     NULL,
    [Month]           INT              NULL,
    [Year]            INT              NULL,
    [Ancillary]       DECIMAL (18, 6)  NULL,
    [OtherAncillary]  DECIMAL (18, 6)  NULL,
    [CreatedBy]       INT              NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_PEAncillaryServiceAndReplacementReserveCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AncillaryServiceAndReplacementReserveCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VREAncillaryServicesCurve';

