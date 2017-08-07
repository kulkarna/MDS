



/*

SELECT * FROM [vw_LegacyAccount_P] order by 1
SELECT * FROM [vw_LegacyAccount] order by 1

*/


CREATE VIEW [dbo].[vw_LegacyAccount]
AS

select * from lp_account..account


