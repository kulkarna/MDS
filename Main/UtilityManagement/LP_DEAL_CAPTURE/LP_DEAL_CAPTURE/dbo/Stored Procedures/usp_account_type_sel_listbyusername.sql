
-- CREATED 5/1/2008
-- Eric Hernandez
--------------------
-- Updated 12/9/2009
-- Eric Hernandez
-- Removed the restriction where sales channels could not see LCI option

CREATE procedure [dbo].[usp_account_type_sel_listbyusername] (@p_username nvarchar(100) = '')
AS

SELECT option_id = account_type, return_value = ltrim(rtrim(p.account_type_id))
FROM lp_common..product_account_type p

--select CASE WHEN accounttype = 'RES'
--            THEN 'RESIDENTIAL'
--            ELSE accounttype
--       END as option_id
--     , id as return_value    
-- from libertypower..accounttype





/*


SELECT option_id = account_type, return_value = ltrim(rtrim(p.account_type_id))
FROM lp_common..product_account_type p

select CASE WHEN accounttype = 'RES'
            THEN 'RESIDENTIAL'
            ELSE accounttype
       END as option_id
     , id as return_value    
 from libertypower..accounttype
*/