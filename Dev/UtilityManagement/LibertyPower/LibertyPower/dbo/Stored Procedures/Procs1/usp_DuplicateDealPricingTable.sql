	

create procedure dbo.usp_DuplicateDealPricingTable(
		@deal_pricing_id			int = 0)
as
begin		
	set nocount on;
	
	declare @DetailCount				int
		,@deal_pricing_detail_id		int
		,@InsertControl					smallint
		,@ProcessDate					datetime
		,@UserName						varchar(50)
		,@NewDealPricingId				int
		,@msg							varchar(max)
		
	select 	@ProcessDate				= getdate()
		,@UserName						= suser_sname()
		
	declare DealPricingCursor insensitive cursor for
	select distinct deal_pricing_id
	from lp_deal_capture..deal_pricing 
	where deal_pricing_id		= case when @deal_pricing_id = 0 then deal_pricing_id else @deal_pricing_id end
	order by 1

	open DealPricingCursor
	fetch next from DealPricingCursor into @deal_pricing_id
	while @@fetch_status	= 0
	begin
		--print @deal_pricing_id
		set @DetailCount = (select count(1) 
							from lp_deal_capture..deal_pricing_detail 
							where deal_pricing_id = @deal_pricing_id)
		if @DetailCount > 1
		begin
			--select @deal_pricing_id, @DetailCount
			declare DealPricingDetailCursor insensitive cursor for
			select distinct deal_pricing_detail_id
			from lp_deal_capture..deal_pricing_detail
			where deal_pricing_id = @deal_pricing_id
			order by 1
			open DealPricingDetailCursor
			fetch next from DealPricingDetailCursor into @deal_pricing_detail_id
			set @InsertControl		= 1
			while @@fetch_status	= 0
			begin
				if @InsertControl > 1
				begin
					insert into lp_deal_capture..deal_pricing (
							account_name
							,sales_channel_role
							,commission_rate
							,date_expired
							,date_created
							,username
							,date_modified
							,modified_by)
					select account_name
							,sales_channel_role
							,commission_rate
							,date_expired
							,@ProcessDate		-- date_created
							,@UserName			-- username
							,'19000101'			-- date_modified
							,''					-- modified_by
					from lp_deal_capture..deal_pricing 
					where deal_pricing_id		= @deal_pricing_id
					
					set @NewDealPricingId = SCOPE_IDENTITY()
					
					update lp_deal_capture..deal_pricing_detail
					set deal_pricing_id		= @NewDealPricingId
					where deal_pricing_detail_id = @deal_pricing_detail_id

					select @msg = 'New Pricing_id created :' + rtrim(ltrim(str(@NewDealPricingId)))
					print @msg
					
				end				
				set @InsertControl = @InsertControl  + 1
				fetch next from DealPricingDetailCursor into @deal_pricing_detail_id	
			end
			close DealPricingDetailCursor
			deallocate DealPricingDetailCursor
		end						
		fetch next from DealPricingCursor into @deal_pricing_id
	end
	close DealPricingCursor
	deallocate DealPricingCursor

	set nocount off;
end




/*
sp_help deal_pricing 
deal_pricing_id

*/