CREATE TABLE [dbo].[OfferUsageMapping_map] (
    [OfferAccountsId] BIGINT       NOT NULL,
    [UsageId2]        BIGINT       NOT NULL,
    [Id2]             BIGINT       NOT NULL,
    [Utility]         VARCHAR (50) NOT NULL,
    [AccountN]        VARCHAR (50) NOT NULL,
    [UT]              INT          NOT NULL,
    [US]              INT          NOT NULL,
    [FromD]           DATETIME     NOT NULL,
    [ToD]             DATETIME     NOT NULL,
    [DaysU]           INT          NULL,
    [Kwh]             INT          NOT NULL,
    [MeterN]          VARCHAR (50) NULL,
    [Creatd]          DATETIME     NOT NULL
);

