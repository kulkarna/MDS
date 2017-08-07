CREATE PROC usp_flowdates_upd
(
      @contract_nbr char(12),
      @newMonth int
)
AS

UPDATE deal_contract_account
SET requested_flow_start_date = 
	convert (datetime, cast(@newMonth as varchar(2)) + '/' + 
	cast(day(requested_flow_start_date) as varchar(2)) + '/' + 
	cast(year(requested_flow_start_date) as varchar(4)))
WHERE contract_nbr = @contract_nbr
