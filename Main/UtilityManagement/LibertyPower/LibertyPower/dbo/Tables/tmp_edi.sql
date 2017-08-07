CREATE TABLE [dbo].[tmp_edi] (
    [AccountNumber]               VARCHAR (25) NULL,
    [UtilityCode]                 VARCHAR (25) NULL,
    [BeginDate]                   DATETIME     NULL,
    [EndDate]                     DATETIME     NULL,
    [Quantity]                    INT          NULL,
    [MeasurementSignificanceCode] VARCHAR (5)  NULL,
    [MeterNumber]                 VARCHAR (25) NULL,
    [TransactionSetPurposeCode]   VARCHAR (5)  NULL
);

