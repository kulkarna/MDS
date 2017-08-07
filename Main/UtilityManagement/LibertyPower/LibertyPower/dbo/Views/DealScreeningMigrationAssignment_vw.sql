


CREATE VIEW [dbo].[DealScreeningMigrationAssignment_vw]
AS
SELECT ROW_NUMBER() OVER (PARTITION BY u.utility_id, dpa.ContractType ORDER BY dpa.utility desc, dpa.market desc) as rownum
	, u.utility_id, dpa.utility as matching_utility, dpa.market as matching_market, dpa.ContractType, dpa.DealScreeningPathID
FROM lp_common..common_utility u
JOIN libertypower..DealScreeningPathAssignment dpa 
	ON (u.retail_mkt_id = dpa.market OR dpa.market is null)
		and 
	   (u.utility_id = dpa.utility OR dpa.utility is null)
	    and
	   (u.por_option = dpa.por or dpa.por is null)
WHERE u.inactive_ind = 0
--and dpa.AccountTypeID is null -- for the purposes of matching legacy, legacy ignores accounttype
--order by 2,5,4 desc,3 desc

--SELECT u.utility_id, dpa.ContractType, dpa.DealScreeningPathID
--FROM lp_common..common_utility u
--JOIN libertypower..DealScreeningPathAssignment dpa ON u.utility_id = dpa.utility
--WHERE u.inactive_ind = 0
--UNION
--SELECT u.utility_id, dpa.ContractType, dpa.DealScreeningPathID
--FROM lp_common..common_utility u
--JOIN libertypower..DealScreeningPathAssignment dpa ON u.retail_mkt_id = dpa.market
--WHERE dpa.utility is null and u.inactive_ind = 0
--UNION
--SELECT u.utility_id, dpa.ContractType, dpa.DealScreeningPathID
--FROM lp_common..common_utility u
--CROSS JOIN libertypower..DealScreeningPathAssignment dpa
--WHERE dpa.utility is null and dpa.market is null and u.inactive_ind = 0



