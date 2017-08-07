CREATE TABLE [dbo].[ComplaintRegulatoryAuthorityLegacyMap] (
    [ComplaintRegulatoryAuthorityID] INT NOT NULL,
    [LegacyID]                       INT NOT NULL,
    CONSTRAINT [FK_ComplaintRegulatoryAuthorityLegacyMap_ComplaintRegulatoryAuthority] FOREIGN KEY ([ComplaintRegulatoryAuthorityID]) REFERENCES [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID])
);

