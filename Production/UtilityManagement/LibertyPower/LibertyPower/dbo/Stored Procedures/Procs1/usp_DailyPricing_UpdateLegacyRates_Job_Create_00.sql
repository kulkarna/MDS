

CREATE proc [dbo].[usp_DailyPricing_UpdateLegacyRates_Job_Create_00]
		(@ProcessDate		datetime = null)
as
begin
	set nocount on 
	
	delete from lp_common..common_product_rate
	where substring(ltrim(rtrim(str(rate_id))), 4,2) in ('00')
	
	declare @product_id			char(20)
		,@count					int
		,@error					int
		,@rowcount				int
		,@strMessage			varchar(400)
	
	if @ProcessDate is null
		set @ProcessDate		= convert(varchar(8), getdate(), 112)
	
	select 	distinct PR.product_id, count (1) as [count]
	into #TempProductId
	from lp_common..common_product_rate PR with (nolock)
	inner join lp_common..common_product P with (nolock)
	on P.product_id			= PR.product_id
	inner join libertypower..Utility UT with (nolock)
	on UT.UtilityCode		= P.Utility_id
	inner join libertypower..Market MA with (nolock)
	on MA.ID				= UT.MarketID
	where PR.eff_date		= @ProcessDate
	and len(PR.rate_id)		= 9
	and substring(ltrim(rtrim(str(PR.rate_id))), 4,2) in ('01')
	and MA.MArketCode		<> 'TX'
	group by PR.product_id 

	declare ProductCursor cursor FAST_FORWARD for
	select product_id, [count] from #TempProductId

	open ProductCursor

	fetch next from ProductCursor into @product_id, @count
	
	While @@fetch_status = 0
	begin

		set @strMessage = @product_id + ': ' + ltrim(rtrim(str(@count)))
		print @strMessage 
		begin tran
		
		insert into lp_common..common_product_rate (
			product_id
			,rate_id
			,eff_date
			,rate
			,rate_descp
			,due_date
			,grace_period
			,contract_eff_start_date
			,val_01
			,input_01
			,process_01
			,val_02
			,input_02
			,process_02
			,service_rate_class_id
			,zone_id
			,date_created
			,username
			,inactive_ind
			,active_date
			,chgstamp
			,term_months
			,fixed_end_date
			,GrossMargin
			,IndexType
			,BillingTypeID)
		select 	
			a.product_id
			,left(a.rate_id,4) + '0' + right(a.rate_id,4) as rate_id
			,a.eff_date
			,a.rate
			,a.rate_descp
			,a.due_date
			,a.grace_period
			,dateadd(month, -1, a.contract_eff_start_date) as contract_eff_start_date
			,a.val_01
			,a.input_01
			,a.process_01
			,a.val_02
			,a.input_02
			,a.process_02
			,a.service_rate_class_id
			,a.zone_id
			,getdate()				--date_created
			,a.username
			,a.inactive_ind
			,a.active_date
			,a.chgstamp
			,a.term_months
			,a.fixed_end_date
			,a.GrossMargin
			,a.IndexType
			,a.BillingTypeID
		from lp_common..common_product_rate a with (nolock)
		where a.eff_date									= @ProcessDate
		and len(a.rate_id)									= 9
		and substring(ltrim(rtrim(str(a.rate_id))), 4,2)	in ('01')
		and a.product_id									= @product_id
		and not exists (select 1 from lp_common..common_product_rate b with (nolock)
						where b.product_id				= a.product_id
						and b.rate_id					= left(a.rate_id,4) + '0' + right(a.rate_id,4)
						and b.eff_date					= a.eff_date)

		select @Rowcount		= @@rowcount
			,@error				= @@error

		if @error = 0 and @Rowcount > 0
		begin
			commit tran
			set @strMessage		= 'commit tran: ' + @product_id
		end
		else
		begin
			rollback tran
			if @error <> 0
				set @strMessage		= 'Rollback Tran Error: ' + @product_id
			else
				set @strMessage		= 'Rollback Tran: ' + @product_id
				
		end

		print @strMessage
			
		fetch next from ProductCursor into @product_id, @count
	end

	close ProductCursor
	deallocate ProductCursor

	drop table #TempProductId
			
	set nocount off 

end

-- exec [dbo].[usp_DailyPricing_UpdateLegacyRates_Job_Create_00]



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricing_UpdateLegacyRates_Job_Create_00';

