CREATE TABLE [dbo].[temp_product_rate] (
    [product_rate_history_id] INT            IDENTITY (1, 1) NOT NULL,
    [product_id]              CHAR (20)      NOT NULL,
    [rate_id]                 INT            NOT NULL,
    [rate]                    FLOAT (53)     NOT NULL,
    [eff_date]                DATETIME       NOT NULL,
    [date_created]            DATETIME       NOT NULL,
    [username]                NCHAR (100)    NOT NULL,
    [contract_eff_start_date] DATETIME       NULL,
    [GrossMargin]             DECIMAL (9, 6) NULL,
    [term_months]             INT            NULL,
    [inactive_ind]            CHAR (1)       NULL
);

