CREATE TABLE [dbo].[zAuditAccountContractRate] (
    [zAuditAccountContractRateID] INT            IDENTITY (1, 1) NOT NULL,
    [AccountContractRateID]       INT            NOT NULL,
    [AccountContractID]           INT            NOT NULL,
    [LegacyProductID]             CHAR (20)      NULL,
    [Term]                        INT            NULL,
    [RateID]                      INT            NULL,
    [Rate]                        FLOAT (53)     NULL,
    [RateCode]                    VARCHAR (50)   NOT NULL,
    [RateStart]                   DATETIME       NOT NULL,
    [RateEnd]                     DATETIME       NOT NULL,
    [IsContractedRate]            BIT            NOT NULL,
    [HeatIndexSourceID]           INT            NULL,
    [HeatRate]                    DECIMAL (9, 2) NULL,
    [TransferRate]                FLOAT (53)     NULL,
    [GrossMargin]                 FLOAT (53)     NULL,
    [CommissionRate]              FLOAT (53)     NULL,
    [AdditionalGrossMargin]       FLOAT (53)     NULL,
    [Modified]                    DATETIME       NOT NULL,
    [ModifiedBy]                  INT            NOT NULL,
    [DateCreated]                 DATETIME       NOT NULL,
    [CreatedBy]                   INT            NOT NULL,
    [AuditChangeType]             CHAR (3)       NOT NULL,
    [AuditChangeDate]             DATETIME       CONSTRAINT [DFzAuditAccountContractRateAuditChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]               VARCHAR (30)   CONSTRAINT [DFzAuditAccountContractRateAuditChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation]         VARCHAR (30)   CONSTRAINT [DFzAuditAccountContractRateAuditChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]              VARCHAR (MAX)  NULL,
    [ColumnsChanged]              VARCHAR (MAX)  NULL,
    [ProductCrossPriceMultiID]    BIGINT         NULL,
    [PriceID]                     BIGINT         NULL
);


GO
CREATE CLUSTERED INDEX [zAuditAccountContractRate__zAuditAccountContractRateID]
    ON [dbo].[zAuditAccountContractRate]([zAuditAccountContractRateID] ASC);


GO
CREATE NONCLUSTERED INDEX [NDX_zAuditAccountContractRateAuditChangeDate]
    ON [dbo].[zAuditAccountContractRate]([AuditChangeDate] ASC);


GO
CREATE NONCLUSTERED INDEX [zAuditAccountContractRate__AccountContractID_I]
    ON [dbo].[zAuditAccountContractRate]([AccountContractID] ASC, [IsContractedRate] ASC)
    INCLUDE([zAuditAccountContractRateID]);

