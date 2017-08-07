USE [lp_contract_renewal]
Go

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'deal_contract_account'             
	AND		COLUMN_NAME = 'RatesString'
) 
ALTER TABLE deal_contract_account
ADD RatesString varchar(200) Null;
GO

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'deal_contract'             
	AND		COLUMN_NAME = 'RatesString'
)
ALTER TABLE deal_contract
ADD RatesString varchar(200) Null;
GO