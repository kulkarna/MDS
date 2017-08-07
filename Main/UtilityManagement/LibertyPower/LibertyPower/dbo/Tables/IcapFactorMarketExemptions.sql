CREATE TABLE [dbo].[IcapFactorMarketExemptions] (
    [RetailMarketId] VARCHAR (25) NOT NULL,
    [IcapException]  TINYINT      CONSTRAINT [DF_IcapFactorMarketExceptions_IcapException] DEFAULT ((0)) NOT NULL,
    [TcapException]  TINYINT      CONSTRAINT [DF_IcapFactorMarketExceptions_TcapException] DEFAULT ((0)) NOT NULL,
    [ZeroIcap]       TINYINT      CONSTRAINT [DF_IcapFactorMarketExemptions_ZeroIcap] DEFAULT ((0)) NOT NULL,
    [ZeroTcap]       TINYINT      CONSTRAINT [DF_IcapFactorMarketExemptions_ZeroTcap] DEFAULT ((0)) NOT NULL
);

