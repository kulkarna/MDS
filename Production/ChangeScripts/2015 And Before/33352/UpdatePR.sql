USE		lp_deal_capture
GO
--Update the PR for the rate 18397
Update	lp_deal_capture..deal_pricing
SET		pricing_request_id = 'PR-201311-49564',
		date_modified = GETDATE(),
		modified_by = 'Libertypower\rcoots'
WHERE	deal_pricing_id=18397