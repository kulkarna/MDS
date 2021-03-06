USE [lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_report_data_commission_forecast]    Script Date: 10/16/2012 03:49:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 1/5/2011
-- Description:	Get Commission Forecast Report 
-- =============================================
-- Modified: 3/1/32011 Gail Mangaroo 
-- Allow all vendors to be processed at once
-- =============================================
-- Modifief: 5/9/2011 Gail Mangaroo 
-- Added account overrides and handling of cpmplex payment structures.
-- Currently forecast wil lbe delayed for complex structures until/unless clr is implemented
--==============================================
-- Modified: 6/16/2011 Gail Mangaroo 
-- Added @p_forecasted_only param to limit results only to forecasted values
-- =============================================
-- Modified 8/4/2011 Gail Mangaroo 
-- Added voidng adjustments and trueup transaction type 
-- =============================================
-- Modified 8/18/2011 Gail Mangaroo 
-- Altered to use isDefault field to detect rollover products/contracts 
-- ===============================================
-- Modified 8/23/2011 Gail Mangaroo 
-- Added database name qualifier to final query and corrected issue with residuals not showing
-- ==============================================
-- Modified 10/19/2011 Gail Mangaroo
-- Added function to generate residual payment number
-- ==============================================
-- Modified 2/10/2012 Gail Mangaroo
-- altered to use new LibertyPower.dbo.Account table
-- =============================================
-- Modified 2/15/2012 Gail Mangaroo 
-- Added parameters @p_pending_non_residuals, @p_paid_non_residuals
-- =============================================
-- Modified 9/18/2012 GaIl Mangaroo 
-- Use LibertyPower..Name and temp tables instead of table variables and permanent tables
-- ==============================================
-- exec usp_report_data_commission_forecast 27, 1,0 , 0
ALTER PROC [dbo].[usp_report_data_commission_forecast] 
(@p_vendor_id int 
, @p_forecasted_only bit = 0  -- residuals 
, @p_pending_non_residuals bit = 0 -- other  pymts
, @p_paid_non_residuals bit = 0  -- other pymts 
) 
	
AS 
BEGIN 
	
			--drop table #ven_list
			--drop table #commissions_forecast 
			--drop table #residual_opts 

			--declare @p_vendor_id int 
			--declare @p_forecasted_only bit
			--declare @p_pending_non_residuals bit
			--declare @p_paid_non_residuals bit 
			
			--set @p_vendor_id = 27 
			--set @p_forecasted_only = 1 
			--set @p_pending_non_residuals  = 1 
			--set @p_paid_non_residuals = 1 
			

	CREATE TABLE #commissions_forecast(
		[job_id] [uniqueidentifier] NULL,
		[account_id] [varchar](50) NULL,
		[account_nbr] [varchar](50) NULL,
		[contract_nbr] [varchar](50) NULL,
		[contract_term] [int] NULL,
		[vendor_id] [int] NULL,
		[product_id] [varchar](50) NULL,
		[retail_mkt_id] [varchar](50) NULL,
		[status] [varchar](50) NULL,
		[sub_status] [varchar](50) NULL,
		[res_date] [datetime] NULL,
		[res_num] [int] NULL,
		[res_usage] [float] NULL,
		[res_rate] [float] NULL,
		[pro_rate] [float] NULL,
		[res_amount] [money] NULL,
		[pymt_term] [float] NULL,
		[tran_type_id] [int] NULL,
		[tran_id] [int] NULL,
		[pymt_opt_def_id] [int] NULL,
		[date_created] [datetime] NULL
	)

	DECLARE @acct_id varchar(50) 
	DECLARE @acct_no varchar(50) 
	DECLARE @contract_nbr varchar(50) 
	DECLARE @product_id varchar(50) 
	DECLARE @flow_date datetime 
	DECLARE @contract_term int 

	DECLARE @usage float 
	DECLARE @res_start datetime
	DECLARE @res_rate float
	DECLARE @num_residuals float 
	DECLARE @res_pymt_term float
	DECLARE @actual_res_pymt_term float
	DECLARE @init_pymt_term float
	DECLARE @vendor_id int 
	DECLARE @pymt_num int
	DECLARE @pro_rate float
	DECLARE @res_pymt_opt_def_id int 
	
	DECLARE @acct_cntr_id int
	DECLARE @allow_ovr int
	DECLARE @mkt varchar(50)
	DECLARE @status varchar(50)
	DECLARE @sub_status varchar(50)
	
	DECLARE @current_vendor_id int
	DECLARE @jobID uniqueidentifier

	SET @jobID = NEWID()

	--CREATE TABLE #rollover
	--( zaudit_id int 
	--, contract_type varchar(50) 
	--, contract_eff_start_date datetime 
	--, date_flow_start datetime 
	--, term_months int 
	--) 
	
	CREATE TABLE #residual_opts 
	( vendor_id int
	, payment_option_id int 
	, res_opt_date_start datetime
	, res_opt_date_end datetime
	, payment_term float 
	, is_term_fixed bit 
	, payment_option_def_id int
	) 
	create INDEX IDX_VEN_1_RES_OPTS on #residual_opts ( vendor_id  ) 

	SELECT vendor_id 
		into #ven_list
	FROM [lp_commissions].[dbo].vendor 
	WHERE vendor_id = @p_vendor_id OR isnull(@p_vendor_id, 0) = 0 
	ORDER BY 1
	
	CREATE index idx_ven_list ON #ven_list ( vendor_id ) 
	
	DECLARE vndr_csr CURSOR FAST_FORWARD FOR 
		SELECT vendor_id 
		FROM #ven_list
						
	OPEN vndr_csr
	FETCH NEXT FROM vndr_csr INTO @current_vendor_id
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
	--sum ( case when payment_option_setting_param_value is null then 0 else 1 end )
	--	DELETE @residual_opts
		
		-- get residual payment types
		INSERT INTO #residual_opts
		SELECT vpo.vendor_id 
			, case when count(distinct payment_option_def_id) > 1 then 0 else vpo.payment_option_id  end 
			, res_opt_date_start = vpo.date_effective 
			, res_opt_date_end = case when isnull(vpo.term, 0) = 0 then  '12/31/3000' else DATEADD(month, vpo.term , vpo.date_effective ) end
			, case when count(distinct payment_option_def_id) > 1 then 0 else max(po.payment_term) end 
			, case when count(distinct payment_option_def_id) > 1 then 0 else max(cast ( po.is_term_fixed as int)) end 
			, case when count(distinct payment_option_def_id) > 1 then 0 else max(po.payment_option_def_id) end 
			
		FROM lp_commissions.dbo.vendor_payment_option vpo (NOLOCK)
			JOIN [lp_commissions].[dbo].[vw_PaymentOptionDetail] po (NOLOCK) ON vpo.payment_option_id = po.payment_option_id
		WHERE vpo.vendor_id = @current_vendor_id 
			AND po.payment_option_type_id = 2 
			AND vpo.active = 1 
		GROUP BY vpo.vendor_id  , vpo.payment_option_id , vpo.term , vpo.date_effective
		
		---- update end dates 
		UPDATE r1 
			SET res_opt_date_end = isnull (( select  min(r2.res_opt_date_start) 
											from #residual_opts r2 
											where  r1.vendor_id = r2.vendor_id 
												and  r2.res_opt_date_start > r1.res_opt_date_start 
											) , r1.res_opt_date_end ) 
		from #residual_opts r1
		
	-- ****** debgug			
	-- SELECT * FROM @residual_opts
		
		DECLARE ama_csr CURSOR FAST_FORWARD FOR 

			SELECT DISTINCT  a.accountidLegacy
				, a.accountnumber 
				, c.Number 
				, Term = acr.Term 
				, acr.LegacyProductID 
				, RateStart  = acr.RateStart 
				, v.vendor_id 
				, d.term
				, res_payment_term = case when opts.is_term_fixed = 1 then opts.payment_term else opts.payment_term * d.contract_term end
				, opts.payment_option_def_id
				, ac.AccountContractID 
				, v.allow_account_override
				, m.marketcode
				, s.status
				, s.subStatus
				
			FROM LibertyPower.dbo.Account a  (NOLOCK)
				JOIN LibertyPower.dbo.AccountContract ac (NOLOCK) ON a.AccountID = ac.Accountid 
				JOIN LibertyPower.dbo.Contract c (NOLOCK) ON ac.ContractID = c.ContractID
				--JOIN LibertyPower.dbo.AccountContractRate acr (NOLOCK) ON acr.AccountContractID = ac.AccountContractID  
				--	AND IsContractedRate = 1 
				JOIN LibertyPower.dbo.vw_AccountContractRate acr (NOLOCK) ON acr.AccountContractID = ac.AccountContractID 
					AND acr.IsContractedRate = 1
				JOIN LibertyPower.dbo.Market m (NOLOCK) on m.ID = a.retailmktID
				LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON s.AccountContractID = ac.AccountContractID
				JOIN lp_commissions.dbo.vendor v (NOLOCK) ON c.SalesChannelID = v.ChannelID 
				JOIN lp_commissions.dbo.transaction_detail d (NOLOCK) ON a.accountIdLegacy = d.account_id  
					AND v.vendor_id = d.vendor_id		-- account should still belong to vendor
					AND c.Number = d.contract_nbr	-- account should still be under the same contract number
					AND d.transaction_type_id in ( 1,5)	-- original commission 
					AND d.void = 0						-- commission should be paid/payable
					AND d.approval_status_id <> 2	-- not rejected
					AND d.reason_code not like 'c5000%'	-- Not ATMS !! 
					
				LEFT JOIN lp_commissions.dbo.transaction_detail chbk (NOLOCK) ON chbk.assoc_transaction_id = d.transaction_detail_id 
					AND chbk.void =0					-- chargeback is paid/payable
					AND (chbk.transaction_type_id = 2 OR ( chbk.transaction_type_id = 7 AND chbk.reason_code like '%C0012%')) 	-- chargeback or voiding adjustment
					AND chbk.approval_status_id <> 2	-- not rejected
				
				JOIN lp_common.dbo.common_product p (NOLOCK) on acr.LegacyProductID = p.product_id 
				
				JOIN #residual_opts opts on opts.vendor_id = v.vendor_id
					AND c.SignedDate between opts.res_opt_date_start and opts.res_opt_date_end
					
			WHERE 1=1 
				AND s.status in ( '05000', '06000', '905000' , '906000' ) -- account in enrolled status
				AND acr.RateStart > '1/1/1900'   -- account should be flowing
				AND chbk.transaction_detail_id is null  -- original commission not charged back 
				AND d.transaction_detail_id is not null  -- commission paid
				
				AND d.reason_code not like 'C5000%'
				AND v.vendor_id = @current_vendor_id
			
			ORDER BY  v.vendor_id, c.Number, a.accountIDLegacy
			
		OPEN ama_csr
		FETCH NEXT FROM ama_csr INTO @acct_id ,@acct_no ,@contract_nbr, @contract_term , @product_id, @flow_date ,@vendor_id 
										, @init_pymt_term ,@res_pymt_term , @res_pymt_opt_def_id, @acct_cntr_id, @allow_ovr, @mkt, @status, @sub_status
						-- ,@init_opt_id, @init_opt_value ,@res_opt_id ,@res_opt_value 

		WHILE @@FETCH_STATUS = 0 
		BEGIN 
			-- Check for override values 
			DECLARE @ovr int 
			DECLARE @ovr_term int
			
			if @allow_ovr = 1			
				SELECT @ovr = case when count(distinct payment_option_def_id) > 1 then 0 else max(po.payment_option_def_id) end  -- isnull(residual_option_id, 0) --, residual_commission_end
					, @ovr_term = case when max(cast(po.is_term_fixed as int)) = 1 then max(po.payment_term )else max(po.payment_term) * @contract_term end
				FROM LibertyPower.dbo.AccountContractCommission a (NOLOCK)
					JOIN [lp_commissions].[dbo].[vw_PaymentOptionDetail] po (NOLOCK) ON a.residualOptionId = po.payment_option_id
				WHERE a.accountContractID = @acct_cntr_id
			
			--IF @ovr = 0  
			--	SET @res_pymt_term = 0   -- override settings complex structure
			
			IF @ovr IS NOT NULL 
				SET @res_pymt_term = @ovr_term  -- 0 indicates override settings is a complex structure
				
			-- Check if residual payment settings avail. and enter a record in commissions estimate if not
			-- Either this or the comissions assembly is called to calculate the settings. 
			-- ============================================================================================						
			IF @res_pymt_term = 0 
			BEGIN 
				IF (SELECT COUNT(*) FROM lp_commissions.dbo.commission_estimate (NOLOCK) where account_id = @acct_id and contract_nbr = @contract_nbr and vendor_id = @vendor_id)  > 0 
								
					SELECT @res_pymt_term = case when d.is_term_fixed = 1 then d.payment_term else d.payment_term * @contract_term end  
							, @res_pymt_opt_def_id = e.res_pymt_opt_def_id
					FROM lp_commissions.dbo.commission_estimate e (NOLOCK)
						JOIN lp_commissions.dbo.payment_option_def d (NOLOCK) on e.res_pymt_opt_def_id = d.payment_option_def_id
					WHERE account_id = @acct_id
						AND contract_nbr = @contract_nbr
						AND vendor_id = @vendor_id
				ELSE
						-- request estimate
						INSERT INTO [lp_commissions].[dbo].[commission_estimate] ([account_id],[contract_nbr],[vendor_id],[date_created],[username])
						VALUES (@acct_id , @contract_nbr , @vendor_id , getdate() , 'Commissions Forecast' ) 

				SET @res_pymt_term = isnull(@res_pymt_term, 0)
				
				IF isnull(@res_pymt_term, 0) = 0 
					-- insert place holder
					INSERT INTO #commissions_forecast (job_id, account_id, account_nbr, contract_nbr, contract_term, vendor_id, product_id, retail_mkt_id, status, sub_status, res_date, res_num, res_usage, res_rate, pro_rate, res_amount, pymt_term, tran_type_id, tran_id, pymt_opt_def_id ) 
	    			SELECT @jobID,  @acct_id ,@acct_no ,@contract_nbr , @contract_term , @vendor_id , @product_id, @mkt, @status, @sub_status, dateadd(month, @res_pymt_term * (@pymt_num -1), @res_start)  ,@pymt_num , @usage , @res_rate , @pro_rate , @usage * @res_rate * @pro_rate , 0, 0 , 0 ,@res_pymt_opt_def_id


			END 
							
			SET @num_residuals = 0 
			SET @pymt_num = 0 
			    			    
			-- get last rate and usage used 
			--=======================================
			SELECT TOP 1 @res_rate = d.rate,  @usage = d.base_amount 
				, @pymt_num = case when d.reason_code like 'c2000%' or d.reason_code like 'c3000-%' then cast ( replace(replace(d.reason_code, 'C2000',''), 'C3000-', '') as int ) else 0 end 
				, @res_pymt_term =  case when d.transaction_type_id = 6 and isnull(d.term, 0) > 0 then d.term else @res_pymt_term end

			FROM lp_commissions.dbo.transaction_detail d (NOLOCK)
				LEFT JOIN lp_commissions.dbo.transaction_detail chbk (NOLOCK) on chbk.assoc_transaction_id = d.transaction_detail_id 
					and chbk.void =0 
					and (chbk.transaction_type_id = 2 OR ( chbk.transaction_type_id = 7 AND chbk.reason_code like '%C0012%')) 	-- chargeback or voiding adjustment
					and chbk.approval_status_id <> 2	-- not rejected
					
			WHERE d.account_id  = @acct_id
				and d.vendor_id = @vendor_id 
				and d.contract_nbr = @contract_nbr 
				and d.transaction_type_id in ( 1,5,6) 
				-- and ( d.reason_code like 'c3000%' OR d.reason_code like 'c2000%')
				and chbk.transaction_detail_id is null 
				and d.void = 0 
				and d.approval_status_id <> 2	-- not rejected
				
			ORDER BY d.transaction_type_id desc, d.date_created desc
			-- ========================================
			
			
			IF @res_pymt_term > 0 
				SET @num_residuals = (@contract_term - @init_pymt_term) / @res_pymt_term  
			--IF  ((cast(@contract_term as int)- cast(@init_pymt_term as int)) % cast(@res_pymt_term as int)) > 0 
			--	SET @num_residuals = @num_residuals + 1 --cast(@num_residuals + 1  as int ) 
			
			
			--get date of first residual 
			SET @res_start = dateadd(month, @init_pymt_term, @flow_date) 
			SET @actual_res_pymt_term = @res_pymt_term
			--IF @contract_term - @init_pymt_term , 
			

	  --**************   debug 	
	  --select res_pymt_term = 	@res_pymt_term , init_pymt_term = @init_pymt_term , num_residuals = @num_residuals , usage = @usage , pymt_num = @pymt_num , contract_term = @contract_term -- ,  (@contract_term - @init_pymt_term) / @res_pymt_term  

			-- =================================	
			-- get actual residuals already paid 
			-- ===================================
			INSERT INTO #commissions_forecast (job_id, account_id, account_nbr, contract_nbr, contract_term, vendor_id, product_id, retail_mkt_id, status, sub_status, res_date, res_num, res_usage, res_rate, pro_rate, res_amount, pymt_term, tran_type_id, tran_id , pymt_opt_def_id) 
			SELECT @jobID, @acct_id ,@acct_no ,@contract_nbr , @contract_term , @vendor_id , @product_id, @mkt, @status, @sub_status ,d.date_created  ,  lp_commissions.dbo.ufn_GetResidualNumber (d.reason_code )  -- cast ( replace(replace(replace(d.reason_code, 'C2000',''), 'C3000-', ''), 'C3002-', '') as int )  
				,d.base_amount ,d.rate ,d.pro_rate_factor ,d.amount , @res_pymt_term,  d.transaction_type_id , d.transaction_detail_id	, @res_pymt_opt_def_id
			
			FROM lp_commissions.dbo.transaction_detail d (NOLOCK)
			
				LEFT JOIN lp_commissions.dbo.transaction_detail chbk (NOLOCK) on chbk.assoc_transaction_id = d.transaction_detail_id  -- check not charged back 
					and chbk.void =0					-- payable
					and (chbk.transaction_type_id = 2 OR ( chbk.transaction_type_id = 7 AND chbk.reason_code like '%C0012%')) 	-- chargeback or voiding adjustment
					and chbk.approval_status_id <> 2	-- not rejected
			
				LEFT JOIN lp_commissions.dbo.transaction_detail assoc (NOLOCK) on d.assoc_transaction_id = assoc.transaction_detail_id -- for true-ups ensure associated residual is not charged back. 
					and assoc.void = 0					-- payable 
					and assoc.transaction_type_id = 6	-- residual that true-up is associated with
					and assoc.approval_status_id <> 2	-- not rejected
					-- and assoc.assoc_transaction_id > 0	-- ???
			
				LEFT JOIN lp_commissions.dbo.transaction_detail chbk2 (NOLOCK) on chbk2.assoc_transaction_id = assoc.transaction_detail_id -- check that related transaction is not charged back
					and chbk2.void =0					-- payable
					and (chbk.transaction_type_id = 2 OR ( chbk.transaction_type_id = 7 AND chbk.reason_code like '%C0012%')) 	-- chargeback or voiding adjustment
					and chbk2.approval_status_id <> 2	-- not rejected
			
			WHERE d.account_id  = @acct_id			
				and d.vendor_id = @vendor_id 
				and d.contract_nbr = @contract_nbr 
				and d.transaction_type_id in ( 6, 7, 9)	-- residual or true-up transaction 
				and (d.reason_code like '%c3000%' OR d.reason_code like '%c2000%' OR d.reason_code like '%c3002%') -- residual or true-up transaction 
				and chbk.transaction_detail_id is null  -- transaction not charged back
				and chbk2.transaction_detail_id is null -- transaction not charged back
				and d.void = 0							-- payable 	
				and d.approval_status_id <> 2	-- not rejected


	-- **************   debug 			    
	 --SELECT pymt_num = @pymt_num , num_residu = @num_residuals
	 --select * from lp_commissions.dbo.commissions_forecast r			
			
			-- forecast the rest
			WHILE @num_residuals - @pymt_num > 0 
			BEGIN 
				-- Repeat calculations for each residual payment to be received.
				SET @pro_rate = case when  @num_residuals - @pymt_num > 0 and @num_residuals - @pymt_num < 1  then @num_residuals - @pymt_num else 1 end * (@res_pymt_term/12)
				SET @actual_res_pymt_term = case when  @num_residuals - @pymt_num > 0 and @num_residuals - @pymt_num < 1 then @contract_term - @init_pymt_term - @pymt_num * @res_pymt_term else @res_pymt_term end 
				
				SET @pymt_num = @pymt_num + 1 			

	-- **************   debug 	
	 --SELECT pymt_num = @pymt_num , num_residu = @num_residuals, 'while'

				
				INSERT INTO #commissions_forecast (job_id, account_id, account_nbr, contract_nbr, contract_term, vendor_id, product_id, retail_mkt_id, status, sub_status, res_date, res_num, res_usage, res_rate, pro_rate, res_amount, pymt_term, tran_type_id, tran_id, pymt_opt_def_id ) 
		    	SELECT @jobID,  @acct_id ,@acct_no ,@contract_nbr , @contract_term , @vendor_id , @product_id, @mkt, @status, @sub_status , dateadd(month, @res_pymt_term * (@pymt_num -1), @res_start)  ,@pymt_num , @usage , @res_rate , @pro_rate , @usage * @res_rate * @pro_rate , @actual_res_pymt_term, 6 , 0 , @res_pymt_opt_def_id

	-- **************   debug 		
	-- select contract_term =  @contract_term , init_term = @init_pymt_term , res_term = @res_pymt_term , pymt_num = @pymt_num		
	-- select @contract_term - @init_pymt_term - @res_pymt_term*(@pymt_num -1	)
	---- case when (@contract_term - @init_pymt_term - @res_pymt_term*@pymt_num) > 0 then (@contract_term - @init_pymt_term - @res_pymt_term*@pymt_num)/ @res_pymt_term else 1 end
				
			END -- forecast 
			
			FETCH NEXT FROM ama_csr INTO @acct_id ,@acct_no ,@contract_nbr, @contract_term , @product_id, @flow_date ,@vendor_id 
											, @init_pymt_term ,@res_pymt_term ,  @res_pymt_opt_def_id, @acct_cntr_id, @allow_ovr, @mkt, @status, @sub_status
						-- ,@init_opt_id, @init_opt_value ,@res_opt_id ,@res_opt_value 
		END -- FETCH
				
		CLOSE ama_csr
		DEALLOCATE ama_csr 
	
		-- =================================	
		-- get actual residuals already paid 
		-- ===================================
		INSERT INTO #commissions_forecast (job_id, account_id, account_nbr, contract_nbr, contract_term, vendor_id, product_id, retail_mkt_id, status, sub_status, res_date, res_num, res_usage, res_rate, pro_rate, res_amount, pymt_term, tran_type_id, tran_id , pymt_opt_def_id) 
		SELECT @jobID, d.account_id ,a.accountNumber ,d.contract_nbr , d.contract_term , d.vendor_id , d.product_id, d.retail_mkt_id, s.status, s.subStatus ,d.date_created  ,  lp_commissions.dbo.ufn_GetResidualNumber (d.reason_code )  -- cast ( replace(replace(replace(d.reason_code, 'C2000',''), 'C3000-', ''), 'C3002-', '') as int )  
			,d.base_amount ,d.rate ,d.pro_rate_factor ,d.amount , d.term,  d.transaction_type_id , d.transaction_detail_id	, d.payment_option_def_id
		
		FROM lp_commissions.dbo.transaction_detail d (NOLOCK)
			
			JOIN LibertyPower.dbo.Account a (NOLOCK) on a.accountIDLegacy = d.account_id
			
			JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.Number = d.contract_nbr 
			JOIN LibertyPower.dbo.AccountContract ac (NOLOCK) ON a.AccountID = ac.Accountid AND c.ContractID = ac.ContractID
			LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON s.AccountContractID = ac.AccountContractID 
			
			LEFT JOIN lp_commissions.dbo.transaction_detail chbk (NOLOCK) on chbk.assoc_transaction_id = d.transaction_detail_id  -- check not charged back 
				and chbk.void =0					-- payable
				and (chbk.transaction_type_id = 2 OR ( chbk.transaction_type_id = 7 AND chbk.reason_code like '%C0012%')) 	-- chargeback or voiding adjustment
				and chbk.approval_status_id <> 2	-- not rejected
		
			LEFT JOIN lp_commissions.dbo.transaction_detail assoc (NOLOCK) on d.assoc_transaction_id = assoc.transaction_detail_id -- for true-ups ensure associated residual is not charged back. 
				and assoc.void = 0					-- payable 
				and assoc.transaction_type_id = 6	-- residual that true-up is associated with
				and assoc.approval_status_id <> 2	-- not rejected
				-- and assoc.assoc_transaction_id > 0	-- ???
		
			LEFT JOIN lp_commissions.dbo.transaction_detail chbk2 (NOLOCK) on chbk2.assoc_transaction_id = assoc.transaction_detail_id -- check that related transaction is not charged back
				and chbk2.void =0					-- payable
				and (chbk.transaction_type_id = 2 OR ( chbk.transaction_type_id = 7 AND chbk.reason_code like '%C0012%')) 	-- chargeback or voiding adjustment
				and chbk2.approval_status_id <> 2	-- not rejected
		
			LEFT JOIN #commissions_forecast r (NOLOCK) ON d.transaction_detail_id = r.tran_id 
				
		WHERE @p_forecasted_only = 0
			AND d.vendor_id = @vendor_id 
			AND d.transaction_type_id in ( 6, 7, 9)	-- residual or true-up transaction 
			-- and (d.reason_code like '%c3000%' OR d.reason_code like '%c2000%' OR d.reason_code like '%c3002%') -- residual or true-up transaction 
			-- and chbk.transaction_detail_id is null  -- transaction not charged back
			-- and chbk2.transaction_detail_id is null -- transaction not charged back
			AND d.void = 0							-- payable 	
			AND d.approval_status_id <> 2	-- not rejected
			AND r.tran_id is null 
			
		FETCH NEXT FROM vndr_csr INTO @current_vendor_id
	END 
	
	CLOSE vndr_csr
	DEALLOCATE vndr_csr 
		
		select [VendorName] =  sc.ChannelName
			, [AccountNumber] = r.account_nbr 
			, [ContractNumber] = r.contract_nbr 
			, [Product] = r.product_id 
			, [ContractTerm] = r.contract_term
			, Market = r.retail_mkt_id
			, [TransactionType] = t.transaction_type_descp 
			, [PaymentOptionCode] = po.payment_option_def_code -- = po.payment_option_code
			, [PaymentTerm] = pymt_term 
			, Usage = r.res_usage 
			, [Rate] = r.res_rate 
			, [ProRateFactor] = r.pro_rate 
			, Amount = r.res_amount 
			, [DateDue] = r.res_date
			, [PaymentNumber] = r.res_num
			, Notes = case when tran_type_id = 0 then 'Estimate required for froecast not yet avail.' when isnull(r.tran_id, 0) = 0 then  'Forecasted Residual Payment' else '' end
			, [Status] = sv.status_descp 
			-- , v.residual_option_id ,, r.* 
			, [ForecastStatus] = case when tran_type_id = 0 then 'UNAVIALABLE' when isnull(r.tran_id, 0) = 0 then 'FORECASTED' else 'ACTUAL' end 
			, TransactionDetailID = r.tran_id
			, AccountID = r.account_id
			, VendorID = v.vendor_id
			, AccountName = an.name 
			, DatePaid = rpt.target_date
			
		from #commissions_forecast r (NOLOCK)
			JOIN LibertyPower.dbo.Account a (NOLOCK) on a.accountIDLegacy = r.account_id
			LEFT JOIN libertyPower.dbo.Name an (NOLOCK) ON an.nameid = a.accountnameid 
			join lp_commissions.dbo.vendor v (NOLOCK) on v.vendor_id = r.vendor_id 
			join lp_commissions.dbo.transaction_type t (NOLOCK) on r.tran_type_id = t.transaction_type_id 
			LEFT JOIN lp_account.dbo.enrollment_status_substatus_vw sv (NOLOCK) on r.status = sv.status and r.sub_status = sv.sub_status
			LEFT JOIN lp_commissions.dbo.payment_option_def po (NOLOCK) on r.pymt_opt_def_id  = po.payment_option_def_id
			LEFT JOIN LibertyPower.dbo.SalesChannel SC (NOLOCK) on SC.channelID = v.channelID
			LEFT JOIN lp_commissions.dbo.transaction_detail d (NOLOCK) on r.tran_id = d.transaction_detail_id
			LEFT JOIN lp_commissions.dbo.invoice i (NOLOCK) on i.invoice_id = d.invoice_id 
			LEFT JOIN lp_commissions.dbo.report rpt (NOLOCK) on rpt.report_id = i.report_id 

		where job_id = @jobID
			AND ( @p_forecasted_only = 0 OR isnull(r.tran_id, 0) = 0 )
		
		UNION 
		
		SELECT [VendorName] =  sc.ChannelName
			, a.accountnumber 
			, contract_nbr =  d.contract_nbr 
			--, a.status 
			--, a.sub_status
			, product_id = d.product_id 
			, contract_term  = d.contract_term 
			, retail_mkt_id = d.retail_mkt_id 
			, t.transaction_type_descp 
			, '' as pymt_option_code
			, pymt_term = d.term 
			, d.base_amount 
			, d.rate 
			, d.pro_rate_factor
			, d.amount 
			, d.date_due
			, 1 as pymt_num
			, 'Non-Residual Payment Pending' as notes 
			, sv.status_descp 
			, 'Actual' as ForeCastStatus
			, d.transaction_detail_id 
			, AccountID = d.account_id
			, VendorID = d.vendor_id
			, AccountName = an.Name 
			, DatePaid = r.target_date
			
		FROM lp_commissions.dbo.transaction_detail d (NOLOCK) 
			JOIN LibertyPower.dbo.Account a  (NOLOCK) ON a.AccountIDLegacy = d.account_id
			JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.Number = d.contract_nbr 
			JOIN LibertyPower.dbo.AccountContract ac (NOLOCK) ON a.AccountID = ac.Accountid AND c.ContractID = ac.ContractID
			LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON s.AccountContractID = ac.AccountContractID 
			LEFT JOIN lp_commissions.dbo.transaction_type t (NOLOCK)  ON d.transaction_type_id = t.transaction_type_id 
			LEFT JOIN lp_account.dbo.enrollment_status_substatus_vw sv (NOLOCK) ON s.status = sv.status and s.subStatus = sv.sub_status
			LEFT JOIN libertyPower.dbo.Name an (NOLOCK) ON an.nameid = a.accountnameid 
			JOIN lp_commissions.dbo.vendor v (NOLOCK) ON d.vendor_id = v.vendor_id 
			LEFT JOIN LibertyPower.dbo.SalesChannel SC (NOLOCK) on SC.channelID = v.ChannelID
			LEFT JOIN lp_commissions.dbo.invoice i (NOLOCK) on i.invoice_id = d.invoice_id 
			LEFT JOIN lp_commissions.dbo.report r (NOLOCK) on r.report_id = i.report_id 

		WHERE d.vendor_id in  ( select vendor_id from #ven_list )
			ANd d.void = 0 
			AND (	( @p_pending_non_residuals = 1 AND d.invoice_id = 0 ) 
						OR 
					(@p_paid_non_residuals = 1 AND d.invoice_id <> 0 )
				)
			AND d.transaction_type_id not in ( 6, 7, 9)
		
		ORDER BY 1,3,2		
		
	--DELETE workspace.dbo.commissions_forecast WHERE job_id = @jobID

END  
