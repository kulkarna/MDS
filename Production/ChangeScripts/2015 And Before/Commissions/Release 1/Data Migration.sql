--/*

---- Update Interval_types
---- =============================
 --Update lp_commissions..vendor_grace_period  set interval_type_id = 1 , date_modified = getdate() , Modified_by = 'System' 
 --Update lp_commissions..vendor_report_date_option  set interval_type_id = 1 , date_modified = getdate() , Modified_by = 'System' 

-- Update Vendor Grace Period options
-- =================================
--INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
--           ([setting_type_id] ,[setting_id]  ,[param_id] ,[param_value],[active] ,[date_created] ,[username] ,[param_operator])
	
--SELECT 2 , vr.option_id , 10 , vr.contract_group_id, 1, getdate() , 'System' , 1 -- equal
--FROM lp_commissions..vendor_report_date_option vr
--	LEFT JOIN [lp_commissions].[dbo].[vendor_setting_param] vsp on vsp.setting_type_id = 6 
--		and vsp.setting_id = vr.option_id
--WHERE 1 =1 
--	and vsp.setting_id is null 
--	and isnull(vr.contract_group_id , 0 ) <> 0 


---- update product rate types 
---- ==========================
--Update Lp_commissions..vendor_rate set product_rate_type_id = 0, date_modified = GETDATE() , modified_by = 'System' 
--where rate_type_id = 1  and product_rate_type_id is null 

--Update Lp_commissions..vendor_rate set product_rate_type_id = 1, date_modified = GETDATE() , modified_by = 'System' 
--where rate_type_id = 2  and product_rate_type_id is null 

--Update Lp_commissions..vendor_rate set product_rate_type_id = 2, date_modified = GETDATE() , modified_by = 'System' 
--where rate_type_id = 3  and product_rate_type_id is null 

---- update rate application levels
---- =================================
--Update lp_commissions..vendor_rate set rate_level_id = 2 , date_modified = getdate() , modified_by = 'System'
--where vendor_id in ( 95, 411, 532, 535, 553, 741, 746, 770, 794,817,821,844,847,849,906,914,915,916,929,930,938,946,951) 
--	and rate_type_id = 1
--	and transaction_type_id in ( 1,5 ) 
--*/

/* 
-- create custom rates 
-- =========================
	INSERT INTO [lp_commissions].[dbo].[vendor_rate]
		([rate_type_id],[rate],[vendor_pct],[house_pct],[rate_vendor_type_id],[vendor_id],[transaction_type_id],[pro_rate_term],[inactive_ind],[date_created] 
			,[username],[rate_cap],[date_effective],[rate_level_id],[product_rate_type_id] ,[end_date],[rate_setting_rank],[assoc_rate_setting_id] ,[payment_cap] 
			,[payment_cap_level_id] ,[group_id]
		)
		
	SELECT 4 , 0  , 0 ,0 , 1 , vpo.vendor_id , 1, 1, 0, getdate(), 'System', 0 , min(date_effective ), 1, 0, null , 0 , 0 , 0 , 0, 0   -- * 
	FROM lp_Commissions..vendor_payment_option vpo 
		join lp_Commissions..payment_option po on vpo.payment_option_id = po.payment_option_id 
		join lp_Commissions..payment_option_setting pos on pos.payment_option_id = po.payment_option_id
		join lp_Commissions..payment_option_setting_param posp on posp.payment_option_setting_id = pos.payment_option_setting_id	
		join lp_commissions..vendor v on vpo.vendor_id = v.vendor_id 
	WHERE posp.payment_option_param_id in ( 1,2 ) 
	GROUP BY vpo.vendor_id 



*/

/*
-- associate chbks
--===========================
-- don't prorate term for fixed amounts
-- ensure fixed amount chrgebacks are negative 
-- check for $0 chargebacks
-- if no chbk then create 0 chargeback
-- set up fixed amount by contract on vendor in 'Pay per Contract list'

 INSERT INTO [lp_commissions].[dbo].[vendor_rate]
	([rate_type_id],[rate],[vendor_pct],[house_pct],[rate_vendor_type_id],[vendor_id],[transaction_type_id],[pro_rate_term],[inactive_ind],[date_created] 
		,[username],[rate_cap],[date_effective],[rate_level_id],[product_rate_type_id] ,[end_date],[rate_setting_rank],[assoc_rate_setting_id] ,[payment_cap] 
		,[payment_cap_level_id] ,[group_id]
	)
           
	SELECT 2 , rate = case when comm_rate.vendor_id in ( 472,302,346,770,951,957,874,488 )  then 0 else 1 end , 0 , 0
		, comm_rate.rate_vendor_type_id, comm_rate.vendor_id , 2, 0  , 0 , getdate(), 'System', 1
		, comm_rate.date_effective, comm_rate.rate_level_id
		, comm_rate.product_rate_type_id   , comm_rate.end_date , 1, comm_rate.rate_setting_id, 0 , 0 , 0 
	            
		-- select distinct comm_rate.* , chbk_rate.rate_setting_id, v.vendor_system_name  -- v.vendor_system_name  -- 
	FROM lp_commissions..vendor_rate comm_rate 
		left join lp_Commissions..vendor_rate chbk_rate on comm_rate.rate_setting_id = chbk_rate.assoc_rate_setting_id
		join lp_Commissions..vendor v on comm_rate.vendor_id = v.vendor_id 
	
	WHERE 1 = 1 
		--and comm_rate.inactive_ind <> 1
		and chbk_rate.rate_setting_id is null 
		-- and comm_rate.vendor_id = 410 
		-- and transaction_type_id not in ( 1,5, 2 ) 
		and comm_rate.transaction_type_id <> 2
		-- and pro_rate_term <> 1 
		and comm_rate.rate_type_id = 1
	ORDER BY comm_rate.rate_type_id 

--Check 0 rate CHBKS for !!!!!!!!!!!!
--Sales Channel/API
--Sales Channel/INK
--Sales Channel/FOE

-- end assoc fixed amount chargebacks
-- =========================================================
*/


/*
---- assoc other chbk
---- =========================================================
--select v.vendor_system_name , * 
--from lp_Commissions..vendor_rate chbk_rate
--	join lp_Commissions..vendor v on v.vendor_id = chbk_rate.vendor_id 
--where  1 = 1
--	-- and chbk_rate.rate_setting_id is null 
--	and isnull(chbk_rate.assoc_rate_Setting_id, 0) = 0 
--	and chbk_rate.inactive_ind = 0 
--	and chbk_rate.rate_type_id <> 1
--	and chbk_rate.transaction_type_id= 2 
--	--and chbk_rate.rate <> 1
--	--and pro_rate_term <> 1 


 INSERT INTO [lp_commissions].[dbo].[vendor_rate]
	([rate_type_id],[rate],[vendor_pct],[house_pct],[rate_vendor_type_id],[vendor_id],[transaction_type_id],[pro_rate_term],[inactive_ind],[date_created] 
		,[username],[rate_cap],[date_effective],[rate_level_id],[product_rate_type_id] ,[end_date],[rate_setting_rank],[assoc_rate_setting_id] ,[payment_cap] 
		,[payment_cap_level_id] ,[group_id]
	)
           
	SELECT  2 , 1 , 0 , 0
		, comm_rate.rate_vendor_type_id, comm_rate.vendor_id , 2, comm_rate.pro_rate_term , 0 , getdate(), 'System', 1, comm_rate.date_effective, comm_rate.rate_level_id
		, comm_rate.product_rate_type_id   , comm_rate.end_date , 1, comm_rate.rate_setting_id, 0 , 0 , 0 
		  
		-- select v.vendor_system_name , * 
	FROM lp_Commissions..vendor_rate comm_rate
		join lp_Commissions..vendor v on v.vendor_id = comm_rate.vendor_id 
		left join lp_Commissions..vendor_rate chbk_rate on comm_rate.rate_setting_id = chbk_rate.assoc_rate_setting_id
		
	WHERE  1 = 1
		and chbk_rate.rate_setting_id is null 
		and isnull(comm_rate.assoc_rate_Setting_id, 0) = 0 
		and comm_rate.inactive_ind = 0 
		and comm_rate.rate_type_id <> 1
		and comm_rate.transaction_type_id <> 2 
		--and comm_rate.rate <> 1
		--and pro_rate_term <> 1 
	
	
---- chbk rate for  !!!!!!!!
---- Sales Channel/advs
----Sales Channel/aeg
----Sales Channel/COMMTEST
----Sales Channel/DTD
----Sales Channel/SCE-HSE
----Sales Channel/OEG

---- end assoc other chbk
---- ===================================
*/ 


/*
----- only allow fixed rate or fixed amount chbks
---- =================================
--select * 
---- update vr set rate_type_id = 2 , date_modified = getdate() , modified_by = 'System'
--from lp_commissions..vendor_rate vr
--where transaction_type_id = 2 
--	and rate_type_id not in ( 1, 2 ) 
--	and inactive_ind = 0
--	--and rate in (0,1 ) 

---- end only allow 
---- ==============================
*/
	
--select vr.vendor_id, vendor_system_name, sum(case when transaction_type_id = 2 then 1 else 0 end)  
--from lp_Commissions..vendor_rate vr 
--	join lp_Commissions..vendor v on v.vendor_id = vr.vendor_id 
--where 1= 1
--	-- and transaction_type_id = 2 
--	and isnull(vr.assoc_rate_Setting_id, 0) = 0 
--	and vr.inactive_ind = 0 
--group by vr.vendor_id , vendor_system_name
--having sum(case when transaction_type_id = 2 then 1 else 0 end) = 0 

--select * from lp_commissions..vendor_rate 
--where 1 =1 
--	-- and vendor_id = 770
--	and transaction_type_id = 2 
--	and isnull(assoc_rate_Setting_id, 0) = 0 
--	and inactive_ind = 0 
--	and rate = 0 
	
---- update lp_Commissions..vendor_rate set rate = 0 where vendor_id in ( 472,302,346,770,951,957,874,488 ) and transaction_type_id = 2 and isnull(assoc_rate_Setting_id, 0) > 0 
----select * from lp_commissions..rate_type 
---- select * from lp_commissions..vendor where vendor_id in ( 408, 532, 585  ) 


----rate_type_id	rate_type_code	rate_type_descp	calculation_rule_id
----0	NONE	None	0
----1	STD-FIXED-VAL	Fixed Amount	0
----2	STD-FLAT-RATE	Fixed Rate	1
----3	STD-FLEX-RATE	Flexible Rate	2
----4	STD-CUSTOM-RATE	Custom Rate	1





/* 
 assoc parameters
-- ==============================
product_id	product_category	product_sub_category	retail_mkt_id 
term_months, account_type, payment_option_def_id, contract_usage_range_start,	contract_usage_range_end



	-- product_cat
	-- ==================
	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
           ([setting_type_id] ,[setting_id]  ,[param_id] ,[param_value],[active] ,[date_created] ,[username] ,[param_operator])
	
	SELECT 6 , vr.rate_setting_id , 12 , vr.product_category, 1, getdate() , 'System' , 1 -- equal
	FROM lp_commissions..vendor_rate vr
		LEFT JOIN [lp_commissions].[dbo].[vendor_setting_param] vsp on vsp.setting_type_id = 6 
			and vsp.setting_id = vr.rate_setting_id
			and vsp.param_id = 12
	WHERE 1 =1 
		and vsp.setting_id is null 
		and vr.inactive_ind = 0
		and len( product_category) > 0 
	
	GO 
	
	-- product_sub_cat
	-- ==================
	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
           ([setting_type_id] ,[setting_id]  ,[param_id] ,[param_value],[active] ,[date_created] ,[username] ,[param_operator])
	
	SELECT 6 , vr.rate_setting_id , 13 , vr.product_sub_category, 1, getdate() , 'System' , 1
	FROM lp_commissions..vendor_rate vr
		LEFT JOIN [lp_commissions].[dbo].[vendor_setting_param] vsp on vsp.setting_type_id = 6 
			and vsp.setting_id = vr.rate_setting_id
			and vsp.param_id = 13
	WHERE 1 =1 
		and vsp.setting_id is null 
		and vr.inactive_ind = 0
		and len( product_sub_category) > 0 
	
	GO 
	
	-- market 
	-- ================
	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
           ([setting_type_id] ,[setting_id]  ,[param_id] ,[param_value],[active] ,[date_created] ,[username] ,[param_operator])

	SELECT 6 , vr.rate_setting_id , 3 , vr.retail_mkt_id, 1, getdate() , 'System' , 1
	FROM lp_commissions..vendor_rate vr
		left JOIN libertypower..market  m on m.marketcode = vr.retail_mkt_id and m.inactiveind = 0
		LEFT JOIN [lp_commissions].[dbo].[vendor_setting_param] vsp on vsp.setting_type_id = 6 
			and vsp.setting_id = vr.rate_setting_id
			and vsp.param_id = 3
	WHERE 1 =1 
		and vsp.setting_id is null 
		and vr.inactive_ind = 0
		and len( retail_mkt_id) > 0 
	
	GO 
	
	-- term 
	-- ============================
	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
       ([setting_type_id] ,[setting_id]  ,[param_id] ,[param_value],[active] ,[date_created] ,[username] ,[param_operator])

	SELECT 6 , vr.rate_setting_id , 4 , vr.term_months, 1, getdate() , 'System' , 2 -- less than or equal
	FROM lp_commissions..vendor_rate vr
		LEFT JOIN [lp_commissions].[dbo].[vendor_setting_param] vsp on vsp.setting_type_id = 6 
			and vsp.setting_id = vr.rate_setting_id
			and vsp.param_id = 4
	WHERE 1 =1 
		and vsp.setting_id is null 
		and vr.inactive_ind = 0
		and len( term_months) <> 0
		and term_months <> 0 
		and term_months <= 12 

	GO 

	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
       ([setting_type_id] ,[setting_id]  ,[param_id] ,[param_value],[active] ,[date_created] ,[username] ,[param_operator])

	SELECT 6 , vr.rate_setting_id , 4 , '13~' + cast(vr.term_months as varchar), 1, getdate() , 'System' , 4 -- between
	FROM lp_commissions..vendor_rate vr
		--left JOIN libertypower..market  m on m.marketcode = vr.retail_mkt_id and m.inactiveind = 0
		LEFT JOIN [lp_commissions].[dbo].[vendor_setting_param] vsp on vsp.setting_type_id = 6 
			and vsp.setting_id = vr.rate_setting_id
			and vsp.param_id = 4
	WHERE 1 =1 
		and vsp.setting_id is null 
		and vr.inactive_ind = 0
		and len( term_months) <> 0
		and term_months <> 0 
		and term_months > 12 
		and term_months <= 24 
	
	GO 
	
	
			-- delete lp_commissions..vendor_setting_param where date_created > '12/12/2012' and param_id = 3 -- 4
			--select * from vendor_rate where term_months = 6  
			--select * from param_operator 
			-- select * from lp_Commissions..vendor_setting_param where param_id = 4

	-- account_type 
	-- =============
	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
       ([setting_type_id] ,[setting_id]  ,[param_id] ,[param_value],[active] ,[date_created] ,[username] ,[param_operator])

	SELECT 6 , vr.rate_setting_id , 9 , vr.account_type , 1, getdate() , 'System' , 1 -- equal
	FROM lp_commissions..vendor_rate vr
		left join libertypower..accountType at on at.id = vr.account_type 
		LEFT JOIN [lp_commissions].[dbo].[vendor_setting_param] vsp on vsp.setting_type_id = 6 
			and vsp.setting_id = vr.rate_setting_id
			and vsp.param_id = 9 
	WHERE 1 =1 
		and vsp.setting_id is null 
		and vr.inactive_ind = 0
		and len( account_type) > 0 
		and account_type is not null 
	
	GO 
	
	-- payment option 
	-- =======================
	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
       ([setting_type_id] ,[setting_id]  ,[param_id] ,[param_value],[active] ,[date_created] ,[username] ,[param_operator])

	SELECT 6 , vr.rate_setting_id , 15 , vr.payment_option_def_id , 1, getdate() , 'System' , 1 -- equal
	FROM lp_commissions..vendor_rate vr
		LEFT JOIN [lp_commissions].[dbo].[vendor_setting_param] vsp on vsp.setting_type_id = 6 
			and vsp.setting_id = vr.rate_setting_id
			and vsp.param_id = 15
	WHERE 1 =1 
		and vsp.setting_id is null 
		and vr.inactive_ind = 0
		and len( payment_option_def_id) > 0 
		and payment_option_def_id > 0 
		-- and account_type_id is not null 
	
	GO
	
	-- usage range 
	-- ==================================	
	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
       ([setting_type_id] ,[setting_id]  ,[param_id] ,[param_value],[active] ,[date_created] ,[username] ,[param_operator])

	SELECT 6 , vr.rate_setting_id , 6 , cast(isnull(vr.contract_usage_range_start, 0) as varchar) + '~' + convert(varchar, convert(int, isnull(vr.contract_usage_range_end, 0) )), 1, getdate() , 'System' , 4 -- b/w
	FROM lp_commissions..vendor_rate vr
		LEFT JOIN [lp_commissions].[dbo].[vendor_setting_param] vsp on vsp.setting_type_id = 6 
			and vsp.setting_id = vr.rate_setting_id
			and vsp.param_id = 6
	WHERE 1 =1 
		and vsp.setting_id is null 
		and vr.inactive_ind = 0
		and ( isnull(vr.contract_usage_range_end, 0) > 0 
		or isnull(vr.contract_usage_range_start, 0) > 0 ) 
	
	GO 

	-- Custom Rates
	-- ==================================	
	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
       ([setting_type_id] ,[setting_id]  ,[param_id] ,[param_value],[active] ,[date_created] ,[username] ,[param_operator])

	SELECT 6 , vr.rate_setting_id , 2 , 'True', 1, getdate() , 'System' , 1 -- eq
	FROM lp_commissions..vendor_rate vr
		LEFT JOIN [lp_commissions].[dbo].[vendor_setting_param] vsp on vsp.setting_type_id = 6 
			and vsp.setting_id = vr.rate_setting_id
			and vsp.param_id = 2
	WHERE 1 =1 
		and vsp.setting_id is null 
		and vr.inactive_ind = 0
		and vr.rate_type_id = 4
	
	GO 

	
*/
	
--select v.vendor_system_name , vr.* 
--from lp_commissions..vendor_rate vr
--	left join lp_commissions..vendor_rate cr on cr.assoc_rate_setting_id = vr.rate_setting_id 
--	join lp_commissions..vendor v on vr.vendor_id = v.vendor_id 
--where cr.rate_setting_id is null 
--	and vr.inactive_ind = 0 
	


----0	UnKnown	UnKnown
----1	=	Equals
----2	<=	LessThanOrEqual
----3	>=	GreaterThanOrEqual
----4	<>	Between



--payment_option_setting_id
--select * from payment_option_param
--select * from payment_option_setting where payment_option_id = 11 
--select * from payment_option_setting_param where payment_option_setting_id in ( 13, 14 ) 
-- select * from lp_commissions..rate_level
-- select * from lp_commissions..product_rate_type 
-- select * from [lp_commissions].[dbo].[vendor_setting_param] where param_id = 2 
-- delete [lp_commissions].[dbo].[vendor_setting_param] where param_id = 2 