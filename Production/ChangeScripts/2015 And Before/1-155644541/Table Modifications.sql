
-- MtMAccount
-- ==================================
ALTER TABLE lp_mtm..MtMAccount 
ADD [CustomDealID] [int] NULL
GO 

-- CustomDealAccount
-- ==================================
ALTER TABLE lp_mtm..MtMCustomDealAccount 
ADD [DealPricingID] [int] NULL
GO 

ALTER TABLE lp_mtm..MtMCustomDealAccount
ADD [InActive]  [bit] NOT NULL DEFAULT(0)
GO

ALTER TABLE lp_mtm..MtMCustomDealAccount
ADD	[DateModified] [datetime] NULL
GO

ALTER TABLE lp_mtm..MtMCustomDealAccount
ADD	[ModifiedBy]  [varchar](50)  NULL
GO 


-- CustomDealEntry
-- ===========================
ALTER TABLE lp_mtm..MtMCustomDealEntry
ADD [CustomDealID] [int] NULL
GO

ALTER TABLE lp_mtm..MtMCustomDealEntry
ADD [DealPricingID] [int] NULL
GO

ALTER TABLE lp_mtm..MtMCustomDealEntry
ADD [InActive] [bit] NOT NULL DEFAULT(0)
GO

ALTER TABLE lp_mtm..MtMCustomDealEntry
ADD [DateModified]  [datetime] NULL
GO

ALTER TABLE lp_mtm..MtMCustomDealEntry
ADD [ModifiedBy]  [varchar](50) NULL
GO 


-- CustomDealHeader
-- ===========================
ALTER TABLE lp_mtm..MtMCustomDealHeader
ADD [InActive]   [bit] NOT NULL DEFAULT(0)
GO

ALTER TABLE lp_mtm..MtMCustomDealHeader
ADD [DateModified]  [datetime] NULL
GO

ALTER TABLE lp_mtm..MtMCustomDealHeader
ADD [ModifiedBy]  [varchar](50)  NULL
GO 

GO

-- MtMZainetMaxAccount
-- ====================
sp_RENAME 'MtMZainetMaxAccount.DealPricingID' , 'CustomDealID', 'COLUMN'
GO 

ALTER TABLE lp_mtm..MtMCustomDealHeader
ADD [EntityCount]  [int]  NULL
GO 


