



--exec usp_list_sel_bylnk 'WVILCHEZ', '2006-0000121', 'NAME'

CREATE procedure [dbo].[usp_list_sel_bylnk]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_link_type                                       varchar(20))
as

if @p_link_type                                     = 'ADDRESS'
begin
   select option_id                                 = '(NEW)',
          return_value                              = 0 
   union
   select option_id                                 = ltrim(rtrim(address)) 
                                                    + ', '
                                                    + ltrim(rtrim(city)) 
                                                    + ', '
                                                    + ltrim(rtrim(state)) 
                                                    + ', '
                                                    + ltrim(rtrim(zip)),
          return_value                              = address_link 
   from deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr                               = @p_contract_nbr 
end

if @p_link_type                                     = 'CONTACT'
begin
   select option_id                                 = '(NEW)',
          return_value                              = 0 
   union
   select option_id                                 = ltrim(rtrim(first_name)) 
                                                    + ', '
                                                    + ltrim(rtrim(last_name))
                                                    + ', '
                                                    + ltrim(rtrim(title)),
          return_value                              = contact_link 
   from deal_contact with (NOLOCK INDEX = deal_contact_idx)
   where contract_nbr                               = @p_contract_nbr 
end

if @p_link_type                                     = 'NAME'
begin
   select option_id                                 = '(NEW)',
          return_value                              = 0 
   union
   select option_id                                 = ltrim(rtrim(full_name)),
          return_value                              = name_link 
   from deal_name with (NOLOCK INDEX = deal_name_idx)
   where contract_nbr                               = @p_contract_nbr 
end
 




