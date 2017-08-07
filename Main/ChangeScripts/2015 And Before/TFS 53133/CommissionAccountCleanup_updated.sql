use lp_commissions

DECLARE @accountnumber varchar(80)
DECLARE @usage float
--declare @FinalAccountList table (AccountNumber varchar(80), Usage float, transaction_detail_id int) 

DECLARE an_cursor CURSOR FAST_FORWARD
    FOR SELECT        a.AccountNumber, u.usage
FROM            Lp_commissions..transaction_usage_detail AS u WITH (NOLOCK) INNER JOIN
                         Lp_commissions..transaction_detail AS d WITH (NOLOCK) ON d.transaction_detail_id = u.transaction_detail_id INNER JOIN
                         Libertypower..Account AS a WITH (NOLOCK) ON d.account_id = a.AccountIdLegacy INNER JOIN
                         Lp_commissions..vendor AS v WITH (NOLOCK) ON v.vendor_id = d.vendor_id
WHERE        (1 = 1) AND (d.transaction_type_id = 7) AND (d.base_amount < 0) AND (d.amount < 0) AND (d.void = 0)
Group by a.AccountNumber,u.usage having count(*)>1
ORDER BY a.AccountNumber
OPEN an_cursor
	FETCH NEXT FROM an_cursor 
	INTO @accountnumber, @usage

	WHILE @@FETCH_STATUS = 0
	BEGIN

	--Print @accountnumber
			update transaction_detail set transaction_type_id=2  --from 7 (ADJUSTMENT) we need them to be 2 (CHBK)
		    --insert @FinalAccountList
			--select @accountnumber as AccountNumber, @usage as Usage, transaction_detail_id from transaction_detail
			where transaction_detail_id in
					(SELECT  u.transaction_detail_id
							FROM            Lp_commissions..transaction_usage_detail AS u WITH (NOLOCK) INNER JOIN
                         Lp_commissions..transaction_detail AS d WITH (NOLOCK) ON d.transaction_detail_id = u.transaction_detail_id INNER JOIN
                         Libertypower..Account AS a WITH (NOLOCK) ON d.account_id = a.AccountIdLegacy INNER JOIN
                         Lp_commissions..vendor AS v WITH (NOLOCK) ON v.vendor_id = d.vendor_id
						WHERE  (d.transaction_type_id = 7) AND (d.base_amount < 0) AND (d.amount < 0) AND (d.void = 0)
						and a.AccountNumber=@accountnumber and u.usage = @usage
					)
					
					and
					
					transaction_detail_id not in
					(SELECT top 1 d.transaction_detail_id
							FROM            Lp_commissions..transaction_usage_detail AS u WITH (NOLOCK) INNER JOIN
                         dbo.transaction_detail AS d WITH (NOLOCK) ON d.transaction_detail_id = u.transaction_detail_id INNER JOIN
                         Libertypower.dbo.Account AS a WITH (NOLOCK) ON d.account_id = a.AccountIdLegacy INNER JOIN
                         Lp_commissions..vendor AS v WITH (NOLOCK) ON v.vendor_id = d.vendor_id
						WHERE  (d.transaction_type_id = 7) AND (d.base_amount < 0) AND (d.amount < 0) AND (d.void = 0)
						and a.AccountNumber=@accountnumber and u.usage = @usage order by d.transaction_detail_id asc
					)

	 FETCH NEXT FROM an_cursor 
		INTO @accountnumber, @usage
	END 
CLOSE an_cursor;
DEALLOCATE an_cursor;

--select * from @FinalAccountList
