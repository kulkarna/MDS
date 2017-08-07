--Create table to hold additional rate calculation type
CREATE TABLE [dbo].[rate_type_addcalc](
	[rate_type_addcalc_id] [int] IDENTITY(1,1) NOT NULL,
	[rate_type_addcalc_code] [varchar](15) NOT NULL,
	[rate_type_addcalc_descp] [varchar](50) NOT NULL,
	[calculation_rule_id] [int] NOT NULL,
 CONSTRAINT [PK_rate_type_addcalc] PRIMARY KEY CLUSTERED 
(
	[rate_type_addcalc_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- Add Fields to trx details
ALTER TABLE [dbo].[transaction_detail] ADD [AdditionalRateTypeCalcId] int NULL
ALTER TABLE [dbo].[transaction_detail] ADD [AdditionalRateTypeId] int NULL
ALTER TABLE [dbo].[transaction_detail] ADD [AdditionalRateAmount] float NULL
Go

-- Add Fields to vendor rates
ALTER TABLE [dbo].[vendor_rate] ADD [AdditionalRateTypeCalcId] int NULL
ALTER TABLE [dbo].[vendor_rate] ADD [AdditionalRateTypeId] int NULL
ALTER TABLE [dbo].[vendor_rate] ADD [AdditionalRateAmount] float NULL

-- TODO: Add constraints to for additionalRateTypeCalc



-- TODO: Add constraints to for additionalRateTypeId




