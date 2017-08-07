USE [lp_contract_renewal]
Go

ALTER TABLE deal_contract_account
ADD RatesString varchar(200) Null;
GO

ALTER TABLE deal_contract
ADD RatesString varchar(200) Null;
GO