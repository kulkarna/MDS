CREATE TYPE [dbo].[tvp_ocou_terms_prices_flow_dates] AS TABLE (
    [Term]          INT             NOT NULL,
    [Price]         DECIMAL (16, 2) NULL,
    [FlowStartDate] DATETIME        NOT NULL);

