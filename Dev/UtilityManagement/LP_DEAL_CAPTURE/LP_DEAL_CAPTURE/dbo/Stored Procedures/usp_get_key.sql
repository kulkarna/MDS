--exec usp_get_key 'dbo', 'CREATE CONTRACTS'
--exec usp_get_key 'dbo', 'PRINT CONTRACTS'
/*
************************************************************
* History.
* Modify	: 06/16/2010 - JOSE MUNOZ
* TICKET	: 14017 
*			VERIFY IF CONTRACT NUMBER EXISTS. If the contract number exists, 
			repeat the process until a new number is available
* 
*/
CREATE procedure [dbo].[usp_get_key]
(@p_username                                        nchar(100),
 @p_process_id                                      varchar(20),
 @p_unickey                                         varchar(20) = ' ' output,
 @p_result_ind                                      char(01) = 'Y')
as

select @p_process_id                                = upper(@p_process_id)

declare @w_start_date                               datetime
declare @w_unickey                                  varchar(20)

select @w_unickey                                   = ' '
 
if @p_process_id                                    = 'PRINT CONTRACTS'
begin
	begin tran 

	WHILE (1 = 1) -- ADD TICKET 14027
	BEGIN
		update deal_get_key set last_number = case when convert(char(08), start_date, 112)
                                                <> convert(char(08), getdate(), 112)
                                              then 1
                                              else last_number + 1
                                         end,
                           start_date = case when convert(char(08), start_date, 112)
                                               <> convert(char(08), getdate(), 112)
                                             then convert(char(08), getdate(), 112)
                                             else start_date
                                        end
		from deal_get_key with (INDEX = deal_get_key_idx)
		where process_id                                 = @p_process_id

		if @@error                                      <> 0
		begin
			select @w_unickey
			select @p_unickey                             = @w_unickey
			rollback tran
			return 1
		end

		select @w_unickey                                = convert(char(08), start_date, 112) 
														+ ' - ' 
														+ ltrim(rtrim(convert(varchar(20), last_number)))
		from deal_get_key with (INDEX = deal_get_key_idx)
		where process_id                                 = @p_process_id

		/* TICKET 14017 END*/
		/* VERIFY IF CONTRACT NUMBER EXISTS */
		/* If the contract number exists, repeat the process until a new number is available */
		IF EXISTS (SELECT 1 FROM lp_account..account WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE	   
	   
		IF EXISTS (SELECT 1 FROM lp_account..account_renewal WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE	   
			   
		IF EXISTS (SELECT 1 FROM lp_contract_renewal..deal_contract WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE
			
		IF EXISTS (SELECT 1 FROM lp_deal_capture..deal_contract WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE
			
		BREAK
		/* TICKET 14017 END*/
	END

	select @p_unickey                                = @w_unickey

	if @p_result_ind                                 = 'Y'
	begin
		select @w_unickey
	end

	commit tran

	return 0
end

if @p_process_id                                    = 'CREATE CONTRACTS'
begin
	begin tran 

	WHILE (1 = 1) -- ADD TICKET 14027
	BEGIN
		update deal_get_key set last_number = case when year(start_date)
													<> year(getdate())
												  then 1
												  else last_number + 1
											 end,
							   start_date = case when year(start_date)
												   <> year(getdate())
												 then convert(char(08), getdate(), 112)
												 else start_date
											end
		from deal_get_key with (INDEX = deal_get_key_idx)
		where process_id                                 = @p_process_id

		if @@error                                      <> 0
		begin
			select @w_unickey
			select @p_unickey                             = @w_unickey
			rollback tran
			return 1
		end

		select @w_unickey                                = substring(convert(char(08), start_date, 112), 1, 4) 
														+ '-' 
														+ right('0000000' + ltrim(rtrim(convert(varchar(07), last_number))), 7)
		from deal_get_key with (INDEX = deal_get_key_idx)
		where process_id                                 = @p_process_id

		/* TICKET 14017 END*/
		/* VERIFY IF CONTRACT NUMBER EXISTS */
		/* If the contract number exists, repeat the process until a new number is available */
		IF EXISTS (SELECT 1 FROM lp_account..account WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE	   
	   
		IF EXISTS (SELECT 1 FROM lp_account..account_renewal WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE	   
			   
		IF EXISTS (SELECT 1 FROM lp_contract_renewal..deal_contract WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE
			
		IF EXISTS (SELECT 1 FROM lp_deal_capture..deal_contract WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE
			
		BREAK
		/* TICKET 14017 END*/
	END

	select @p_unickey                                = @w_unickey

   if @p_result_ind                                 = 'Y'
   begin
      select @w_unickey
   end

   commit tran
   return 0
end

if @p_process_id                                    = 'ACCOUNT ID'
begin
   begin tran 

   update deal_get_key set last_number = case when year(start_date)
                                                <> year(getdate())
                                              then 1
                                              else last_number + 1
                                         end,
                           start_date = case when year(start_date)
                                               <> year(getdate())
                                             then convert(char(08), getdate(), 112)
                                             else start_date
                                        end
   from deal_get_key with (INDEX = deal_get_key_idx)
   where process_id                                 = @p_process_id

   if @@error                                      <> 0
   begin
      select @w_unickey
      select @p_unickey                             = @w_unickey
      rollback tran
      return 1
   end

   select @w_unickey                                = substring(convert(char(08), start_date, 112), 1, 4) 
                                                    + '-' 
                                                    + right('0000000' + ltrim(rtrim(convert(varchar(07), last_number))), 7)
   from deal_get_key with (INDEX = deal_get_key_idx)
   where process_id                                 = @p_process_id

   select @p_unickey                                = @w_unickey

   if @p_result_ind                                 = 'Y'
   begin
      select @w_unickey
   end

   commit tran
   return 0
end

if @p_process_id                                    = 'CONTRACT NBR'
begin
	begin tran 

	WHILE (1 = 1) -- ADD TICKET 14027
	BEGIN
		update deal_get_key set last_number = case when year(start_date)
                                                <> year(getdate())
                                              then 1
                                              else last_number + 1
                                         end,
                              start_date = case when year(start_date)
                                                  <> year(getdate())
                                                then convert(char(08), getdate(), 112)
                                                else start_date
                                           end
	from deal_get_key with (INDEX = deal_get_key_idx)
	where process_id                                 = @p_process_id

	if @@error                                      <> 0
	begin
		select @w_unickey
		select @p_unickey                             = @w_unickey
		rollback tran
		return 1
	end

	select @w_unickey                                = 'PM'
                                                    + '-' 
                                                    + right(convert(char(04), start_date, 112), 2)
                                                    + '-' 
                                                    + right('000000' + ltrim(rtrim(convert(varchar(06), last_number))), 6)
	from deal_get_key with (INDEX = deal_get_key_idx)
	where process_id                                 = @p_process_id

		/* TICKET 14017 END*/
		/* VERIFY IF CONTRACT NUMBER EXISTS */
		/* If the contract number exists, repeat the process until a new number is available */
		IF EXISTS (SELECT 1 FROM lp_account..account WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE	   
	   
		IF EXISTS (SELECT 1 FROM lp_account..account_renewal WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE	   
			   
		IF EXISTS (SELECT 1 FROM lp_contract_renewal..deal_contract WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE
			
		IF EXISTS (SELECT 1 FROM lp_deal_capture..deal_contract WITH (NOLOCK)
					WHERE contract_nbr	= @w_unickey)
			CONTINUE
			
		BREAK
		/* TICKET 14017 END*/
	END

	select @p_unickey                                = @w_unickey



	if @p_result_ind                                 = 'Y'
	begin
		select @w_unickey
	end

	commit tran

	return 0
end

