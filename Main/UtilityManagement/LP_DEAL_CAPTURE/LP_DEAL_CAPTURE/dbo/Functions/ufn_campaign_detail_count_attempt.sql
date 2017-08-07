-- =============================================
-- Author:		Rick Deigsler
-- Create date: 6/22/2007
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION ufn_campaign_detail_count_attempt
(@p_username                                        nchar(100),
 @p_contract_nbr									char(12),
 @p_campaign_id										int)
RETURNS int
begin
declare @total_attempt as int
select 
      @total_attempt = count(1)
from campaign_comment with (NOLOCK INDEX = campaign_comment_idx)
where	contract_nbr					= @p_contract_nbr 
and		call_status						= 'A' 
and		campaign_id						= @p_campaign_id
return @total_attempt
end