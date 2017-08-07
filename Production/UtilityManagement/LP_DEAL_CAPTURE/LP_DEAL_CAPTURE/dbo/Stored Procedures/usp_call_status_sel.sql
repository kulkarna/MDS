
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 6/29/07
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_call_status_sel]
(@p_username                                        nchar(100),
 @p_action                                          char(03),
 @p_view                                            char(03) = 'NONE',
 @p_reason_code_parent								nvarchar(5) = 'NONE')
as

-- child reason codes
if @p_reason_code_parent <> 'NONE'
	begin
		select option_id                                    = a.option_id,
			   return_value                                 = a.return_value
		from lp_common..common_views a with (NOLOCK INDEX = common_views_idx),
			 lp_enrollment..call_status b with (NOLOCK INDEX = call_status_idx1)
		where a.process_id                                  = 'REASON CODE'
		and   b.reason_code                                 = a.return_value
		and   b.call_status                                 = @p_action
		and	  b.reason_code not in ('A','L','S','O')
		and b.reason_code_parent = @p_reason_code_parent
		and a.active = 1
		order by a.option_id
		return 0
	end

if @p_action                                        = 'ALL'
begin
   select a.option_id,
          a.return_value
   from (select seq                                 = 1,
         option_id                                  = 'All',
         return_value                               = 'ALL'
         union
         select distinct
                seq                                 = 2,
                option_id                           = a.option_id,
                return_value                        = a.return_value
         from lp_common..common_views a with (NOLOCK INDEX = common_views_idx),
              lp_enrollment..call_status b with (NOLOCK INDEX = call_status_idx1)
         where a.process_id                         = 'REASON CODE'
         and   b.reason_code                        = a.return_value
		 and b.reason_code not in ('A','L','S','O')
		 and b.reason_code_parent = 0
		 and a.active = 1) a
   order by a.option_id
   return 0
end

if  @p_action                                      <> 'ALL'
and @p_view                                         = 'ALL'
begin
   select a.option_id,
          a.return_value
   from (select seq                                 = 1,
                option_id                           = 'All',
                return_value                        = 'ALL'
         union
         select seq                                 = 2,
                option_id                           = a.option_id,
                return_value                        = a.return_value
         from lp_common..common_views a with (NOLOCK INDEX = common_views_idx),
              lp_enrollment..call_status b with (NOLOCK INDEX = call_status_idx1)
         where a.process_id                         = 'REASON CODE'
         and   b.reason_code                        = a.return_value
         and   b.call_status                        = @p_action
		 and b.reason_code not in ('A','L','S','O')
		 and b.reason_code_parent = 0
		 and a.active = 1) a
   order by a.option_id
   return 0
end

select option_id                                    = a.option_id,
       return_value                                 = a.return_value
from lp_common..common_views a with (NOLOCK INDEX = common_views_idx),
     lp_enrollment..call_status b with (NOLOCK INDEX = call_status_idx1)
where a.process_id                                  = 'REASON CODE'
and   b.reason_code                                 = a.return_value
and   b.call_status                                 = @p_action
and	  b.reason_code not in ('A','L','S','O')
and	  b.reason_code_parent = 0
and   a.active = 1
order by a.option_id
return 0
