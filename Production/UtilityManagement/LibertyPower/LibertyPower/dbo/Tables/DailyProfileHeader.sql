CREATE TABLE [dbo].[DailyProfileHeader] (
    [DailyProfileId] BIGINT        IDENTITY (37, 1) NOT NULL,
    [ISO]            VARCHAR (50)  NOT NULL,
    [UtilityCode]    VARCHAR (50)  NOT NULL,
    [LoadShapeID]    VARCHAR (100) NOT NULL,
    [Zone]           VARCHAR (50)  NULL,
    [FileName]       VARCHAR (200) NOT NULL,
    [DateCreated]    DATETIME      NOT NULL,
    [CreatedBy]      VARCHAR (100) NOT NULL,
    [Version]        INT           NOT NULL,
    CONSTRAINT [PK_DailyProfileHeader] PRIMARY KEY CLUSTERED ([DailyProfileId] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_DailyProfileHeader_113_398624463__K9_K3_K4_K5_K1_2_6_7_8]
    ON [dbo].[DailyProfileHeader]([Version] ASC, [UtilityCode] ASC, [LoadShapeID] ASC, [Zone] ASC, [DailyProfileId] ASC)
    INCLUDE([ISO], [FileName], [DateCreated], [CreatedBy]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ndx_UtilityCodeLoadShapeIDZone]
    ON [dbo].[DailyProfileHeader]([UtilityCode] ASC, [LoadShapeID] ASC, [Zone] ASC) WITH (FILLFACTOR = 90);


GO
CREATE STATISTICS [_dta_stat_398624463_4_3_5]
    ON [dbo].[DailyProfileHeader]([LoadShapeID], [UtilityCode], [Zone]);


GO
CREATE STATISTICS [_dta_stat_398624463_4_1_9]
    ON [dbo].[DailyProfileHeader]([LoadShapeID], [DailyProfileId], [Version]);


GO
CREATE STATISTICS [_dta_stat_398624463_5_3]
    ON [dbo].[DailyProfileHeader]([Zone], [UtilityCode]);


GO
CREATE STATISTICS [_dta_stat_398624463_5_1_9_3]
    ON [dbo].[DailyProfileHeader]([Zone], [DailyProfileId], [Version], [UtilityCode]);


GO
CREATE STATISTICS [_dta_stat_398624463_1_3_4]
    ON [dbo].[DailyProfileHeader]([DailyProfileId], [UtilityCode], [LoadShapeID]);


GO
CREATE STATISTICS [_dta_stat_398624463_3_4]
    ON [dbo].[DailyProfileHeader]([UtilityCode], [LoadShapeID]);


GO
CREATE STATISTICS [_dta_stat_398624463_1_9_3_4_5]
    ON [dbo].[DailyProfileHeader]([DailyProfileId], [Version], [UtilityCode], [LoadShapeID], [Zone]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyProfileHeader';

