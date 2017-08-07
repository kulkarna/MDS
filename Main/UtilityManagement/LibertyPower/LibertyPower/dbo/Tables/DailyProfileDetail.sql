CREATE TABLE [dbo].[DailyProfileDetail] (
    [DailyProfileId] BIGINT          NOT NULL,
    [DateProfile]    DATETIME        NOT NULL,
    [PeakValue]      DECIMAL (18, 7) NOT NULL,
    [OffPeakValue]   DECIMAL (18, 7) NOT NULL,
    [DailyValue]     DECIMAL (18, 7) NOT NULL,
    [PeakRatio]      DECIMAL (18, 7) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_DailyProfileDetail_113_62623266__K1_K2_3_4_5_6]
    ON [dbo].[DailyProfileDetail]([DailyProfileId] ASC, [DateProfile] ASC)
    INCLUDE([PeakValue], [OffPeakValue], [DailyValue], [PeakRatio]) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyProfileDetail';

