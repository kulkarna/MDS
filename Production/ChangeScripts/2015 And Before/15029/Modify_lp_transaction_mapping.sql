ALTER TABLE integration..lp_transaction_mapping
ADD wholesale_market_id char(10)

UPDATE integration..lp_transaction_mapping
SET wholesale_market_id = 
	(SELECT TOP(1) WholesaleMktId 
	 FROM libertypower..utility u
	 WHERE integration..lp_transaction_mapping.utility_id = u.ID
	       OR Integration..lp_transaction_mapping.market_id = u.MarketID) 	 
