CREATE TABLE [dbo].[OE_ACCOUNT032009] (
    [ID]             INT             IDENTITY (1, 1) NOT NULL,
    [ACCOUNT_NUMBER] VARCHAR (50)    NULL,
    [ACCOUNT_ID]     VARCHAR (50)    NULL,
    [MARKET]         VARCHAR (25)    NULL,
    [UTILITY]        VARCHAR (50)    NULL,
    [METER_TYPE]     VARCHAR (50)    NULL,
    [RATE_CLASS]     VARCHAR (50)    NULL,
    [VOLTAGE]        VARCHAR (50)    NULL,
    [ZONE]           VARCHAR (50)    NULL,
    [VAL_COMMENT]    NCHAR (256)     NULL,
    [TCAP]           DECIMAL (18, 9) NULL,
    [ICAP]           DECIMAL (18, 9) NULL,
    [LOAD_SHAPE_ID]  VARCHAR (50)    NULL,
    [LOSSES]         DECIMAL (18, 9) NULL,
    [ANNUAL_USAGE]   BIGINT          NULL,
    [USAGE_DATE]     DATETIME        NOT NULL,
    [NAME_KEY]       VARCHAR (50)    NOT NULL
);

