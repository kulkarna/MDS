-- =============================================
-- Author:		Rick Deigsler
-- Create date: 6/22/2007
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION ufn_campaign_nextcalldate_attempt
(@p_username                                        nchar(100),
 @p_contract_nbr									char(12),
 @p_campaign_id										int)
RETURNS datetime
begin
declare @nextcalldate as datetime

select 
		@nextcalldate = max(nextcalldate)
from	campaign_comment with (NOLOCK INDEX = campaign_comment_idx)
where	contract_nbr			= @p_contract_nbr 
and		call_status				= 'A' 
and		campaign_id				= @p_campaign_id
group by
date_comment
having date_comment = max(date_comment)

if @nextcalldate <= '19910101'
begin
select @nextcalldate = null
end

return @nextcalldate
end