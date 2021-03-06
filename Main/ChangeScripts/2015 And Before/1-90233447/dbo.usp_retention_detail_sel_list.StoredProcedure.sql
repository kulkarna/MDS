USE [Lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_retention_detail_sel_list]    Script Date: 06/11/2013 14:03:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_retention_detail_sel_list]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_retention_detail_sel_list]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_retention_detail_sel_list]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--exec usp_retention_detail_sel_list ''test'', ''200606-00000001'', ''ALL'', 0

CREATE procedure [dbo].[usp_retention_detail_sel_list]
(@p_username                                        nchar(100),
 @p_call_request_id                                 char(15),
 @p_view                                            varchar(35) = ''ALL'',
 @p_rec_sel                                         int = 50)
as
 
declare @w_account_id                               char(12)

select @w_account_id                                = account_id
from retention_header a WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = retention_header_idx)
where call_request_id                               = @p_call_request_id

--set rowcount @p_rec_sel
 
if @p_view                                          = ''ALL''
begin
	SELECT	DISTINCT [select]                                  = case when a.[select] = 1 
															   or   b.account_id = @w_account_id
															   then ''Yes''
															   else ''No''  
														  end,
	a.call_request_id,
	a.phone,
	a.account_id,
	b.account_number,
	f.status_descp,
	g.sub_status_descp,
	a.contract_nbr,
	a.utility_id,
	a.annual_usage,
	account_name                              = d.full_name,
	first_name                                = c.first_name,
	last_name                                 = c.last_name,
	owner_name                                = e.full_name,
	profitability_factor                      = case when a.utility_id = ''CONED''
												   then h.field_06_value
												   else ''0''
											  end,
	a.origin,
	a.username,
	a.date_created,
	a.chgstamp,
	''months_remaining''						= case when ltrim(rtrim(b.product_id))  = ltrim(rtrim(b.utility_id)) + ''_VAR''
												then cast(datediff(month, getdate(), b.date_end) as varchar(20)) + '' (default product)''
												else cast(datediff(month, getdate(), b.date_end) as varchar(20))
											  end
	FROM	retention_detail a WITH (NOLOCK)
			INNER JOIN lp_account..account b WITH (NOLOCK) ON a.account_id = b.account_id 
			INNER JOIN lp_account..account_contact c WITH (NOLOCK) ON b.account_id = c.account_id
			INNER JOIN lp_account..account_name d WITH (NOLOCK) ON b.account_id = d.account_id AND b.account_name_link = d.name_link
			INNER JOIN lp_account..account_name e WITH (NOLOCK) ON b.account_id = e.account_id AND b.owner_name_link = e.name_link
			INNER JOIN lp_account..enrollment_status f WITH (NOLOCK) ON b.status = f.status
			INNER JOIN lp_account..enrollment_sub_status g WITH (NOLOCK) ON b.status = g.status AND b.sub_status = g.sub_status
			LEFT JOIN lp_account..account_additional_info h WITH (NOLOCK) ON b.account_id = h.account_id
	WHERE	a.call_request_id = @p_call_request_id
	ORDER BY 1 DESC
end
' 
END
GO
