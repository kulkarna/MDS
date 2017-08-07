--***********************************************************************************
--Change MtMCustomDealAccount in order to attend the Delivery and Settlement Location
--***********************************************************************************
use lp_mtm
go

--sp_rename 'MtMCustomDealAccount.DeliveryLocation' , 'DeliveryPointFixedPrice', 'COLUMN'

sp_rename 'MtMCustomDealAccount_BackUP', 'MtMCustomDealAccount'
GO

