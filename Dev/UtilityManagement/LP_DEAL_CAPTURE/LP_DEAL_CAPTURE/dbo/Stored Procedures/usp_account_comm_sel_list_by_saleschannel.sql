
--exec  usp_account_comm_sel_list_by_saleschannel @p_username=N'LIBERTYPOWER\dmarino',@p_account_id=N'NONE',@p_account_number=N'403029401460003',@p_view=N'ALL',@p_rec_sel=N'50'
-- exec  usp_account_comm_sel_list_by_saleschannel 'LIBERTYPOWER\dmarino' , '2010-0029737' , 'NONE' , '', 100 

-- ===========================================================
-- Author: ????
-- ===========================================================
-- Modified: Gail Mangaroo - 3/11/2009 
-- Altered to select from new commissions database.
-- ===========================================================
-- Modified: Gail Mangaroo - 4/27/2010
-- Altered ignore voided transactions
-- ===========================================================
CREATE procedure [dbo].[usp_account_comm_sel_list_by_saleschannel]
(@p_username                                        nchar(100),
 @p_account_id                                      char(12) = 'NONE',
 @p_account_number                                  varchar(30) =  'NONE',
 @p_view                                            varchar(35),
 @p_rec_sel                                         int = 50
 )

AS

BEGIN 
 
	set rowcount @p_rec_sel

	if @p_account_id                                    = 'NONE'
	begin
	   select @p_account_id                             = account_id 
	   from lp_account..account with (NOLOCK INDEX = account_idx1)
	   where @p_account_number                          = account_number
	end

	SELECT date_comm_trans_efft		= d.date_deal
			, base_amt				= d.base_amount
			, channel_trans_amt     = abs(d.amount ) 
			, broker_trans_amt      = 0
			, comm_trans_type_descp  = t.transaction_type_descp
			, comm_trans_status		= sl.status_descp
			, date_comm_trans_due	= d.date_due
			, sales_channel_role	= v.vendor_system_name 
			, account_id			= d.account_id
			, contract_nbr			= d.contract_nbr 
			
	FROM lp_commissions..transaction_detail d 
		JOIN lp_commissions..vendor v ON d.vendor_id = v.vendor_id 
		JOIN ufn_account_sales_channel(@p_username) s ON v.vendor_system_name = s.sales_channel_role
		JOIN lp_commissions..transaction_type t ON d.transaction_type_id = t.transaction_type_id 
		JOIN lp_commissions..status_list sl ON d.approval_status_id = sl.status_id 
				
	WHERE d.account_id                               = @p_account_id
		AND d.void = 0 


--if exists(select a.broker_id
--          from lp_enrollment..comm_trans_detail a with (NOLOCK INDEX = comm_trans_detail_idx),
--               ufn_account_sales_channel(@p_username) b
--          where a.account_id                        = @p_account_id
--          and   a.broker_id                         = b.sales_channel_role)
--begin
--   select a.date_comm_trans_efft,
--          a.base_amt,
--          channel_trans_amt                         = case when a.comm_trans_dr_code = 'D'
--                                                           then a.sales_channel_trans_amt
--                                                           else a.sales_channel_trans_amt * -1 
--                                                      end,
--          broker_trans_amt                          = case when a.comm_trans_dr_code = 'D'
--                                                           then a.broker_trans_amt
--                                                           else a.broker_trans_amt * -1 
--                                                      end,
--          c.comm_trans_type_descp,
--          a.comm_trans_status,
--          a.date_comm_trans_due
--   from lp_enrollment..comm_trans_detail a with (NOLOCK INDEX = comm_trans_detail_idx4),
--        ufn_account_sales_channel(@p_username) b,
--        lp_enrollment..comm_trans_type c with (NOLOCK INDEX = comm_trans_type_idx)
--   where a.account_id                               = @p_account_id
--   and   a.broker_id                                = b.sales_channel_role
--   and   a.comm_trans_type_id                       = c.comm_trans_type_id
--end
--else
--begin
--   select a.date_comm_trans_efft,
--          a.base_amt,
--          channel_trans_amt                         = case when a.comm_trans_dr_code = 'D'
--                                                           then a.sales_channel_trans_amt
--                                                           else a.sales_channel_trans_amt * -1 
--                                                      end,
--          broker_trans_amt                          = 0,
--          c.comm_trans_type_descp,
--          a.comm_trans_status,
--          a.date_comm_trans_due
--   from lp_enrollment..comm_trans_detail a with (NOLOCK INDEX = comm_trans_detail_idx5),
--        ufn_account_sales_channel(@p_username) b,
--        lp_enrollment..comm_trans_type c with (NOLOCK INDEX = comm_trans_type_idx)
--   where a.account_id                               = @p_account_id
--   and   a.sales_channel_role                       = b.sales_channel_role
--   and   a.comm_trans_type_id                       = c.comm_trans_type_id
--end    

END 
