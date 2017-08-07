--***********************************************************************************
--Change MtMCustomDealAccount in order to attend the Delivery and Settlement Location
--***********************************************************************************
use lp_mtm
go

sp_rename 'MtMCustomDealAccount.DeliveryPointFixedPrice' , 'DeliveryLocation', 'COLUMN'
GO

ALTER TABLE MtMCustomDealAccount
ADD SettlementLocation varchar(50)
GO