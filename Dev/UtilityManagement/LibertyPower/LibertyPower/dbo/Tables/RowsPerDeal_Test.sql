CREATE TABLE [dbo].[RowsPerDeal_Test] (
    [DealID]        VARCHAR (50) NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [RowID]         BIGINT       NOT NULL,
    [IsEstimated]   TINYINT      CONSTRAINT [DF_RowsPerDeal_Test_IsEstimated] DEFAULT ((0)) NOT NULL,
    [Created]       DATETIME     CONSTRAINT [DF_RowsPerDeal_Test_Created] DEFAULT (getdate()) NULL
);

