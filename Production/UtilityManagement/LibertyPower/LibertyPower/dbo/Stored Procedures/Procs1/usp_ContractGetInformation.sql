
/*******************************************************************************
 * usp_ContractGetInformation

 * Get all information of the contract.

 * History

 *******************************************************************************

 * 03/30/2010 - Jose Munoz

 * Created.

 *******************************************************************************

 */

CREATE PROCEDURE dbo.usp_ContractGetInformation(
		@ContractNumber		char(12)
)
AS

BEGIN
    SET NOCOUNT ON;
    /* Temporal table to show result */
	declare @output table (Row		int identity
						,Label		varchar(30)
						,Value		varchar(max))
						
	/* Cursor Declare*/
	declare AccountRenewalCursor insensitive cursor for
	select account_id
		,account_number
		,account_type
		,[status]	
		,sub_status
		,contract_nbr
		,contract_type
		,utility_id
		,product_id
		,rate_id
		,rate
		,contract_eff_start_date
		,term_months
		,date_end
		,date_deal
		,date_created
		,date_submit
		,sales_channel_role
		,username
		,sales_rep
		,annual_usage
		,date_flow_start
		,date_por_enrollment
		,date_deenrollment
		,date_reenrollment
	from lp_account..account_renewal with (nolock index = account_idx2)
	where contract_nbr = @ContractNumber

    /* Variables Declare*/
    declare @TotalAccountFromContract	integer
		,@account_id					char(12)
		,@account_number				varchar(30)
		,@account_type					varchar(35)
		,@status						varchar(15)
		,@sub_status					varchar(15)
		,@contract_nbr					char(12)
		,@contract_type					varchar(25)
		,@utility_id					char(15)
		,@product_id					char(20)
		,@rate_id						int
		,@rate							float
		,@contract_eff_start_date		datetime
		,@term_months					int
		,@date_end						datetime
		,@date_deal						datetime
		,@date_created					datetime
		,@date_submit					datetime
		,@sales_channel_role			nvarchar(100)
		,@username						nchar(200)
		,@sales_rep						varchar(5)
		,@annual_usage					int	
		,@date_flow_start				datetime
		,@date_por_enrollment			datetime
		,@date_deenrollment				datetime
		,@date_reenrollment				datetime

	/* Find contract in Renewal */
	select @TotalAccountFromContract = Count(1) from lp_account..account_renewal  with (nolock)
										where contract_nbr = @ContractNumber
	if @TotalAccountFromContract > 0 
	begin
		insert into @output select 'Renewal Contract: ', @ContractNumber
		insert into @output select 'Total Accounts : ', ltrim(rtrim(str(@TotalAccountFromContract)))
		/* Find Account Informations from contract */
		open AccountRenewalCursor
		fetch next from AccountRenewalCursor into @account_id
			,@account_number
			,@account_type
			,@status
			,@sub_status
			,@contract_nbr
			,@contract_type
			,@utility_id
			,@product_id
			,@rate_id
			,@rate
			,@contract_eff_start_date
			,@term_months
			,@date_end
			,@date_deal
			,@date_created
			,@date_submit
			,@sales_channel_role
			,@username
			,@sales_rep
			,@annual_usage
			,@date_flow_start
			,@date_por_enrollment
			,@date_deenrollment
			,@date_reenrollment
		while @@fetch_status = 0
		begin
			insert into @output select replicate('*', 30), replicate('*', 50)
			insert into @output select 'Account ID', @account_id
			insert into @output select 'Account Number:', @account_number
			insert into @output select 'Utility Id:', @utility_id

			fetch next from AccountRenewalCursor into @account_id
				,@account_number
				,@account_type
				,@status
				,@sub_status
				,@contract_nbr
				,@contract_type
				,@utility_id
				,@product_id
				,@rate_id
				,@rate
				,@contract_eff_start_date
				,@term_months
				,@date_end
				,@date_deal
				,@date_created
				,@date_submit
				,@sales_channel_role
				,@username
				,@sales_rep
				,@annual_usage
				,@date_flow_start
				,@date_por_enrollment
				,@date_deenrollment
				,@date_reenrollment
			
		end
		close AccountRenewalCursor

	end



    -- overwrite this comment with your statements

 
	select * from @output order by 1
	deallocate AccountRenewalCursor
    SET NOCOUNT OFF;
END

-- Copyright 03/30/2010 Liberty Power

