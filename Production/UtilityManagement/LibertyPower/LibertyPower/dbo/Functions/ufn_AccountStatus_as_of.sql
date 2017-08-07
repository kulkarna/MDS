






-- Created By: Eric Hernandez
-- Created On: 3-1-2013
-- Use: select * from dbo.ufn_AccountStatus_as_of('1-12-2007')

-- Note that when you pass in a date, SQL will assume that the time portion is 00:00:000 unless specified.  
-- So passing in 1-12-2007 would give data as of 1-12-2007 00:00:000 which would not include data from 1-12-2007




CREATE FUNCTION [dbo].[ufn_AccountStatus_as_of] ( @as_of_date datetime )
RETURNS Table
AS


RETURN
(
	SELECT a.*
	FROM zAuditAccountStatus a WITH (NOLOCK)
	JOIN (
		select AccountStatusID , max(zAuditAccountStatusID) as max_id
		from zAuditAccountStatus b with (nolock)
		where AuditChangeDate <= @as_of_date
		group by AccountStatusID
		 ) m
	on a.AccountStatusID = m.AccountStatusID and a.zAuditAccountStatusID = m.max_id
	WHERE a.AuditChangeType <> 'DEL'

--select top 10 * from zAuditAccountStatus
)








