-- 1-147200431

update lp_deal_capture..deal_pricing
set date_expired = '6/17/2013' , date_modified = GETDATE() , modified_by = 'LIBERTYPOWER\gmangaroo'
where deal_pricing_id in ( 15481, 15482, 15483, 15484 ) 