CREATE PROCEDURE [dbo].[usp_unsubmitted_deals_list]
	@p_SalesChannel nvarchar(50), @p_Username nvarchar(50), @p_DateCreated nvarchar(50), @p_ContractNumber nvarchar(50)
AS
BEGIN
	declare @sql nvarchar(max), @where nvarchar(max)

	set @sql = N'select n.full_name,
					dc.sales_channel_role,
					dc.username,
					dc.date_created,
					dc.contract_nbr,
					dc.contract_type
				from lp_deal_capture..deal_contract dc left join lp_deal_capture..deal_name n
				on dc.contract_nbr = n.contract_nbr and dc.customer_name_link = n.name_link'

	set @where = N''

	if @p_SalesChannel <> ''
	begin
		if @where = N''
		begin
			set @where = N'
				where'
		end
		
		set @where = @where + N' dc.sales_channel_role like ''%' + cast(@p_SalesChannel as nvarchar) + '%'''
	end

	if @p_UserName <> ''
	begin
		if @where = N''
		begin
			set @where = N'
				where'
		end
		else
			set @where = @where + N' and'
		
		set @where = @where + N' dc.username like ''%' + cast(@p_UserName as nvarchar) + '%'''
	end

	if @p_DateCreated <> ''
	begin
		if @where = N''
		begin
			set @where = N'
				where'
		end
		else
			set @where = @where + N' and'
				
		declare @date datetime, @tdate datetime, @adate datetime
		set @date = convert(datetime, @p_DateCreated)
		set @tdate = convert(datetime, floor(convert(numeric(18, 9), @date)))
		set @adate = dateadd(ss, 59, dateadd(mi, 59, dateadd(hh, 23, @tdate)))

		set @where = @where + N' (dc.date_created > ''' + convert(nvarchar, @tdate) + ''' and dc.date_created < ''' + convert(nvarchar, @adate) + ''')'
	end

	if @p_ContractNumber <> ''
	begin
		if @where = N''
		begin
			set @where = N'
				where'
		end
		else
			set @where = @where + N' and'
		
		set @where = @where + N' dc.contract_nbr like ''%' + cast(@p_ContractNumber as nvarchar) + '%'''
	end

	set @sql = @sql + @where

	declare @stat nvarchar(max)
	set @stat =  N'set @cur_dc = cursor for ' + @sql + N'; open @cur_dc'

	declare @cur_dc cursor
	exec sp_executesql @stat, N'@cur_dc cursor output', @cur_dc output

	declare @customerName varchar(50), @salesChannel varchar(50), @userName varchar(50), @dateCreated varchar(50), @contractNumber varchar(50), @contractType varchar(50), @originalContractNumber varchar(50), @accountCount int, @first10Accounts varchar(500)
	declare @final_dc table(CustomerName varchar(50), SalesChannel varchar(50), UserName varchar(50), DateCreated varchar(50), ContractNumber varchar(50), ContractType varchar(50), OriginalContractNumber varchar(50), AccountCount int, First10Accounts varchar(500))
	declare @t_ac varchar(50)

	fetch @cur_dc
	into @customerName, @salesChannel, @userName, @dateCreated, @contractNumber, @contractType

	while @@fetch_status = 0
	begin
		set @accountCount = (select count(*) from lp_deal_capture..deal_contract_account where lp_deal_capture..deal_contract_account.contract_nbr = @contractNumber)
		
		declare cur_fdc cursor for
			select top 10 contract_nbr
			from lp_deal_capture..deal_contract_account 
			where lp_deal_capture..deal_contract_account.contract_nbr = @contractNumber

		open cur_fdc

		fetch cur_fdc
		into @t_ac

		set @first10Accounts = ''

		while @@fetch_status = 0
		begin
			if @first10Accounts <> ''
			begin
				set @first10Accounts = @first10Accounts + ', '
			end

			set @first10Accounts = @first10Accounts + @t_ac

			fetch cur_fdc
			into @t_ac
		end

		close cur_fdc
		deallocate cur_fdc

		insert into @final_dc values(@customerName, @salesChannel, @userName, @dateCreated, @contractNumber, @contractType, '', @accountCount, @first10Accounts)

		fetch @cur_dc
		into @customerName, @salesChannel, @userName, @dateCreated, @contractNumber, @contractType
	end
	close @cur_dc
	deallocate @cur_dc

	-- For Renewall
	set @sql = N'select n.full_name,
					dc.sales_channel_role,
					dc.username,
					dc.date_created,
					dc.contract_nbr,
					dc.contract_type,
					dc.original_contract_nbr
				from lp_contract_renewal..deal_contract dc left join lp_contract_renewal..deal_name n
				on dc.contract_nbr = n.contract_nbr and dc.customer_name_link = n.name_link'
				
	set @sql = @sql + @where

	set @stat =  N'set @cur_dc = cursor for ' + @sql + N'; open @cur_dc'

	exec sp_executesql @stat, N'@cur_dc cursor output', @cur_dc output

	declare @final_rdc table(CustomerName varchar(50), SalesChannel varchar(50), UserName varchar(50), DateCreated varchar(50), ContractNumber varchar(50), ContractType varchar(50), OriginalContractNumber varchar(50), AccountCount int, First10Accounts varchar(500))

	fetch @cur_dc
	into @customerName, @salesChannel, @userName, @dateCreated, @contractNumber, @contractType, @originalContractNumber

	while @@fetch_status = 0
	begin
		set @accountCount = (select count(*) from lp_contract_renewal..deal_contract_account where lp_contract_renewal..deal_contract_account.contract_nbr = @contractNumber)
		
		declare cur_fdc cursor for
			select top 10 contract_nbr
			from lp_contract_renewal..deal_contract_account
			where lp_contract_renewal..deal_contract_account.contract_nbr = @contractNumber

		open cur_fdc

		fetch cur_fdc
		into @t_ac

		set @first10Accounts = ''

		while @@fetch_status = 0
		begin
			if @first10Accounts <> ''
			begin
				set @first10Accounts = @first10Accounts + ', '
			end

			set @first10Accounts = @first10Accounts + @t_ac

			fetch cur_fdc
			into @t_ac
		end

		close cur_fdc
		deallocate cur_fdc

		insert into @final_rdc values(@customerName, @salesChannel, @userName, @dateCreated, @contractNumber, @contractType, @originalContractNumber, @accountCount, @first10Accounts)

		fetch @cur_dc
		into @customerName, @salesChannel, @userName, @dateCreated, @contractNumber, @contractType, @originalContractNumber
	end
	close @cur_dc
	deallocate @cur_dc

	select * from @final_dc 
	union
	select * from @final_rdc
END



