-- Migrate Data from replacing DealPricing ID with CustomDEalID

USE LP_MTM
GO

select	m.*, ca.CustomDealID as CID
into	#D
from	MtMAccount m (nolock)
Inner	Join LibertyPower..Account a  (nolock)
on		m.AccountID=a.AccountID
inner	Join MtMCustomDealAccount ca  (nolock)
ON		a.AccountNumber=ca.AccountNumber
and		m.DealPricingID=ca.DealPricingID
Inner	join MtMCustomDealHeader ch  (nolock)
on		ca.CustomDealID=ch.ID
and		m.QuoteNumber like '%' + ch.PricingRequest + '%'
where	m.DealPricingID is not null
AND		m.CustomDealID IS NULL

select	ID,COUNT(*)
from	#D
group	by ID
Having	COUNT(*) > 1

/*

UPDATE	m
SET		m.CustomDealID = d.CID
FROM	MtMAccount m
Inner	Join #D d
On		m.ID = d.ID

*/

select	*
from	MtMAccount m  (nolock)
where	m.DealPricingID is not null
and		m.CustomDealID is null

/*
-- Remove Index
ALTER TABLE MtMAccount DROP UC_MtMAccount_AccountID

-- Remove Column
ALTER TABLE MTMAccount DROP COLUMN DealPricingID

--Create new index
ALTER TABLE [dbo].[MtMAccount] ADD  CONSTRAINT [UC_MtMAccount_AccountID] UNIQUE NONCLUSTERED 
(
	[BatchNumber] ASC,
	[QuoteNumber] ASC,
	[AccountID] ASC,
	[CustomDealID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO


*/