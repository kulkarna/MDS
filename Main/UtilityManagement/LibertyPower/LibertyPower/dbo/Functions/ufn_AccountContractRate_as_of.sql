






-- Created By: Eric Hernandez
-- Created On: 3-1-2013
-- Use: select * from dbo.ufn_AccountContractRate_as_of('1-12-2007')

-- Note that when you pass in a date, SQL will assume that the time portion is 00:00:000 unless specified.  
-- So passing in 1-12-2007 would give data as of 1-12-2007 00:00:000 which would not include data from 1-12-2007




CREATE FUNCTION [dbo].[ufn_AccountContractRate_as_of] ( @as_of_date datetime )
RETURNS Table
AS


RETURN
(
	SELECT a.*
	FROM zAuditAccountContractRate a WITH (NOLOCK)
	JOIN (
		select AccountContractRateID , max(zAuditAccountContractRateID) as max_id
		from zAuditAccountContractRate b with (nolock)
		where AuditChangeDate <= @as_of_date
		group by AccountContractRateID
		 ) m
	on a.AccountContractRateID = m.AccountContractRateID and a.zAuditAccountContractRateID = m.max_id
	WHERE a.AuditChangeType <> 'DEL'

--select top 10 * from zAuditAccountContractRate
)








