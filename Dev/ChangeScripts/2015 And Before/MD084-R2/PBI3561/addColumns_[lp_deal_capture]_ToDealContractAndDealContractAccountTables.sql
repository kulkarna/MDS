USE [lp_deal_capture]
Go

ALTER TABLE deal_contract_account
ADD RatesString varchar(200) Null;
GO

ALTER TABLE deal_contract
ADD RatesString varchar(200) Null;
GO
