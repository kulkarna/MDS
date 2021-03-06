USE [Lp_Enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_lead_search_sel]    Script Date: 02/13/2013 16:50:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alberto Franco
-- Create date: November 29, 2007
-- Description:	Retrieves a list of leads based on the given filter.
-- Modified:	December 7, 2007
-- Description:	Modified for Lead Management v1.2
-- Modified:	March 5, 2013
-- Description: Included the following fields to the generated query: AccountCount, 
--				LeadAging, ContractEndDate, ContractEndDateSortable, DaysToExpiration,
--				Utility, AnnualUsage, ContractHasAccountFlowing
-- =============================================
ALTER PROCEDURE [dbo].[usp_lead_search_sel]
	@p_top int,
	@p_active_campaign_only bit,
	@p_campaign_id smallint,
	@p_sales_channel_id int,
	@p_status_id smallint,
	@p_reason_id smallint,
	@p_company_name nvarchar(50),
	@p_date_last_modified datetime,
	@p_with_callback_date bit,
	@p_sic_desc nvarchar(50),
	@p_contact_name nvarchar(50),
	@p_contact_title nvarchar(50),
	@p_phone_num nvarchar(10),
	@p_ethnicity nvarchar(50),
	@p_order_by nvarchar(20),
	@p_order_dir nvarchar(4)
AS
BEGIN
	SET NOCOUNT ON;

	--quick fix
	--note that @p_date_last_modified is labeled "Date Called filter"
	--so that's how we're going to use it in this quick fix
	DECLARE @f_join_date_last_modified nvarchar(500);
	SET @f_join_date_last_modified = N'';

	DECLARE @m_sql nvarchar(4000);

	DECLARE -- @f for filter
		@f_by_active_only        nvarchar(500),
		@f_by_campaign_id        nvarchar(500),
		@f_by_sales_channel_id   nvarchar(500),
		@f_by_status_id          nvarchar(500),
		@f_by_reason_id          nvarchar(500),
		@f_by_company_name       nvarchar(500),
		@f_by_date_last_modified nvarchar(500),
		@f_by_callback_date      nvarchar(500),
		@f_by_sic_desc           nvarchar(500),
		@f_by_contact_name       nvarchar(500),
		@f_by_contact_title      nvarchar(500),
		@f_by_phone_num          nvarchar(500),
		@f_by_ethnicity          nvarchar(500);

	-- initialize filters
	SET @f_by_active_only        = N'';
	SET @f_by_campaign_id        = N'';
	SET @f_by_sales_channel_id   = N'';
	SET @f_by_status_id          = N'';
	SET @f_by_reason_id          = N'';
	SET @f_by_company_name       = N'';
	SET @f_by_date_last_modified = N'';
	SET @f_by_callback_date      = N'';
	SET @f_by_sic_desc           = N'';
	SET @f_by_contact_name       = N'';
	SET @f_by_contact_title      = N'';
	SET @f_by_phone_num          = N'';
	SET @f_by_ethnicity          = N'';


	IF @p_active_campaign_only IS NOT NULL BEGIN
		SET @f_by_active_only = N' AND a.is_active = ' + CONVERT(nvarchar(10), @p_active_campaign_only) + N' ';
	END

	/*
		use NULL to ignore this filter
		use 0 to return all leads NOT associated with a campaign
		use a valid campaign_id to retrieve leads associated with a specific campaign
		an invalid campaign_id will retrieve nothing
	*/
	IF @p_campaign_id = 0
		SET @f_by_campaign_id = N' AND lcl.campaign_id IS NULL ';
	ELSE IF @p_campaign_id > 0
		SET @f_by_campaign_id = N' AND lcl.campaign_id = ' + CONVERT(nvarchar(10), @p_campaign_id) + N' ';

	/*
		use NULL to ignore this filter
		use 0 to return all UNASSIGNED leads
		use a valid channel_id to retrieve all ASSIGNED leads to a specific channel
		an invalid channel_id will return nothing
	*/
	IF @p_sales_channel_id IS NOT NULL BEGIN
		IF @p_sales_channel_id  < 0
			SET @f_by_sales_channel_id = N' AND l.channel_id IS NOT NULL ' -- assigned lead
		ELSE IF @p_sales_channel_id = 0
			SET @f_by_sales_channel_id = N' AND l.channel_id IS NULL ' -- unassigned lead
		ELSE -- > 0
			SET @f_by_sales_channel_id = N' AND l.channel_id = ' + CONVERT(nvarchar(20), @p_sales_channel_id) +  N' ';
	END

	/*
		use NULL to ignore this filter
		use a valid status_id to retrieve leads in that state
		an incorrect status code will return nothing
	*/
	IF @p_status_id IS NOT NULL
		SET @f_by_status_id = N' AND d.status_id = ' + CONVERT(nvarchar(10), @p_status_id) + N' ';

	/*
		use NULL to ignore this filter
		use a valid reason code to retrieve leads in that state
		an incorrect reason code will return nothing
	*/
	IF @p_reason_id IS NOT NULL
		SET @f_by_reason_id = N' AND d.reason_id = ' + CONVERT(nvarchar(10), @p_reason_id) + N' ';

	/*
		use NULL to ignore this filter
		use '' to return leads with NO company_name
		use anything else to filter by company name
		using '' will return NOT NULL values with an empty company name (may not be what you want)
	*/
	IF @p_company_name = ''
		SET @f_by_company_name = N' AND (l.company_name IS NULL OR l.company_name = '''') '
	ELSE IF LEN(@p_company_name) > 0
		SET @f_by_company_name = N' AND l.company_name LIKE ''' + REPLACE(@p_company_name, '''', '''''') + N''' ';

	/*
		use NULL to ignore this filter
		use a date to filter by date_last_called
		the time is ignored
	*/
	IF @p_date_last_modified IS NOT NULL
		SET @f_by_date_last_modified = N' AND DATEDIFF(day, l.date_last_modified, ''' + CONVERT(nvarchar(30), @p_date_last_modified, 101) + N''') = 0 ';

	-- added for quick fix
	IF @p_date_last_modified IS NOT NULL
		SET @f_join_date_last_modified = 
			N'INNER JOIN (' +
				N'SELECT lead_id FROM lead_call ' +
				N'WHERE DATEDIFF(day, date_called, ''' + CONVERT(nvarchar(30), @p_date_last_modified, 101) + N''') = 0' +
				N') AS k WITH (nolock) ON l.lead_id = k.lead_id '

	/*
		use NULL to ignore this filter
		use 0 to return leads WITHOUT a callback_date
		use 1 to return leads WITH a callback_date
		the time is ignored
	*/
	IF @p_with_callback_date = 0
		SET @f_by_callback_date = N' AND l.callback_date IS NULL '
	ELSE IF @p_with_callback_date = 1
		SET @f_by_callback_date = N' AND l.callback_date IS NOT NULL ';

	/*
		use NULL to ignore this filter
		use '' to return leads with NO SIC description
		use anything else to filter by SIC description
	*/
	IF @p_sic_desc = ''
		SET @f_by_sic_desc = N' AND (l.sic_desc IS NULL OR l.sic_desc = '''') '
	ELSE IF LEN(@p_sic_desc) > 0
		SET @f_by_sic_desc = N' AND l.sic_desc LIKE ''' + REPLACE(@p_sic_desc,'''','''''') + N''' ';

	/*
		use NULL to ignore this filter
		use '' to return leads with NO contact_name
		use anything else to filter by contact_name
	*/
	IF @p_contact_name = ''
		SET @f_by_contact_name = N' AND (c.contact_name IS NULL OR c.contact_name = '''') '
	IF LEN(@p_contact_name) > 0
		SET @f_by_contact_name = N' AND c.contact_name LIKE ''' + REPLACE(@p_contact_name,'''','''''') + N''' ';

	/*
		use NULL to ignore this filter
		use '' to return leads with a contact WITHOUT a contact_title
		use anything else to filter by contact_title
	*/
	IF @p_contact_title = ''
		SET @f_by_contact_title = N' AND (c.contact_title IS NULL OR c.contact_title = '''') '
	ELSE IF LEN(@p_contact_title) > 0
		SET @f_by_contact_title = N' AND c.contact_title LIKE ''' + REPLACE(@p_contact_title,'''','''''') + N''' ';

	/*
		use NULL to ignore this filter
		use '' to return leads WITHOUT a phone_num
		use anything else to filter by phone_num
	*/
	IF @p_phone_num = ''
		SET @f_by_phone_num = N' AND (l.phone_num IS NULL OR l.phone_num = '''') ';
	ELSE IF LEN(@p_phone_num) > 0
		SET @f_by_phone_num = N' AND L.phone_num LIKE ''' + REPLACE(@p_phone_num,'''','''') + N''' ';

	/*
		use NULL to ignore this filter
		use '' to return leads WITHOUT an ethnicity
		use anything else to filter by ethnicity
	*/
	IF @p_ethnicity = ''
		SET @f_by_ethnicity = N' AND (l.ethnicity IS NULL OR l.ethnicity = '''') ';
	ELSE IF LEN(@p_ethnicity) > 0
		SET @f_by_ethnicity = N' AND l.ethnicity LIKE ''' + @p_ethnicity + N''' ';

	/*
		finally build the query
	*/
	SET @m_sql =
		N'SELECT ' + CASE WHEN @p_top IS NOT NULL THEN N' TOP ' + CONVERT(nvarchar(20), @p_top) + N' ' ELSE N' ' END +
			N'l.lead_id, ' +
			N'(SELECT COUNT(acc.AccountNumber) FROM LibertyPower.dbo.Contract AS lpc WITH (nolock) INNER JOIN LibertyPower.dbo.AccountContract ' +
			N'AS lpac WITH (nolock) ON lpc.ContractID = lpac.ContractID INNER JOIN LibertyPower.dbo.Account AS acc WITH (nolock) ON lpac.AccountID = acc.AccountID WHERE lpc.Number = cl.old_contract_nbr) AS AccountCount, ' +
			N'DATEDIFF(day, ISNULL(l.Channel_Assigned_Date, Lp_Enrollment.dbo.ufn_GetLastCalledDate(l.lead_id)), GETDATE()) as LeadAging, ' +
			N'LP.ContractEndDate, ' +
			N'DATEDIFF(day, GetDate(), LP.ContractEndDate) as DaysToExpiration, ' +
			N'convert(char, cast(LP.ContractEndDate as datetime), 112) as ContractEndDateSortable, ' +
			N'lcl.campaign_id, ' +
			N'a.campaign_code, ' +
			N'l.company_name, ' +
			N'l.primary_addr, '  +
			N'l.primary_city, '  +
			N'l.primary_state, '  +
			N'l.primary_zip, '  +
			N'l.phone_num, ' +
			N'l.ethnicity, ' +
			N'l.channel_id, ' +
			N'c.contact_name, ' +
			N'c.contact_title, ' +
			N'h.nickname AS sales_channel, ' +
			N'd.status_code, ' +
			N'd.reason_code, ' +
			N'l.disposition_id, ' +
			
			N'(select COUNT(lc.call_id) from lead_call lc WITH (nolock) where lc.lead_id = l.lead_id) as number_of_calls, ' +
			
			N'l.callback_date, ' +
			N'l.date_last_modified, ' +
			N'l.created_by, ' +
			N'l.date_created, ' +
			N'l.color, ' +
			
			N'LP.contractid Contract_ID,' +
			N'LP.Number Contract_Number,' +
			N'LP.Term Contract_Term,' +
            N'LP.FullName Utility_Name, ' +
            N'LP.AnnualUsage, ' +
            N'[LibertyPower].[dbo].[ufn_ContractHasAccountsFlowing] (cl.old_contract_nbr) as ContractHasAccountsFlowing ' +
			
		N'FROM lead AS l WITH (nolock) ' +
		N'LEFT JOIN lead_campaign_lead AS lcl WITH (nolock) ON l.lead_id = lcl.lead_id ' +
		N'INNER JOIN lead_campaign AS a WITH (nolock) ON lcl.campaign_id = a.campaign_id ' +
		N'LEFT JOIN lead_contact AS c WITH (nolock) ON l.lead_id = c.lead_id ' +
		N'LEFT JOIN lead_sales_channel AS h WITH (nolock) ON l.channel_id = h.channel_id ' +
		N'INNER JOIN vw_lead_disposition AS d WITH (nolock) ON l.disposition_id = d.disposition_id ' +
		N'LEFT JOIN lead_customer_lead cl WITH (nolock) on l.lead_id = cl.lead_id ' +
		@f_join_date_last_modified + -- added this for quick fix
		
		N' LEFT JOIN ' +
		N'(select lpc.Number,lpac.ContractID,lpar.Term,lpu.FullName,SUM(lpus.AnnualUsage) AS AnnualUsage, ' +
		N'LibertyPower.dbo.ufn_GetSoonestContractEndDate(lpc.Number) ContractEndDate ' +
        N'from libertypower..Contract lpc (nolock) ' +
        N'join libertypower..AccountContract lpac (nolock) on lpc.ContractID = lpac.ContractID ' +
        N'join libertypower..AccountContractRate lpar (nolock) on lpac.AccountContractID = lpar.AccountContractID ' +
        N'and IsContractedRate = 1 ' +        
        N'join libertypower..Account lpa (nolock) on lpac.AccountID = lpa.AccountID ' +
        N'join libertypower..Utility lpu (nolock) on lpa.UtilityID = lpu.ID ' +
        N'left join LibertyPower.dbo.AccountUsage lpus WITH (NOLOCK) ON lpus.AccountID = lpa.AccountID and lpc.StartDate = lpus.EffectiveDate ' +
        N'group by lpc.Number, lpac.ContractID, lpar.Term, lpu.FullName)LP on LP.number = cl.old_contract_nbr ' +		
		
		N'WHERE 1=1 ' +
			@f_by_active_only +
			@f_by_campaign_id +
			@f_by_sales_channel_id +
			@f_by_status_id +
			@f_by_reason_id +
			@f_by_company_name +
			--@f_by_date_last_modified + -- removed this for quick fix
			@f_by_callback_date +
			@f_by_sic_desc +
			@f_by_contact_name +
			@f_by_contact_title +
			@f_by_phone_num +
			@f_by_ethnicity +
		N'ORDER BY ' + @p_order_by + N' ' + @p_order_dir;


--	INSERT INTO _eraseme (s) VALUES (@m_sql);
	
	EXECUTE sp_executesql @m_sql;
	print @m_sql
--	SELECT @m_sql;

END
