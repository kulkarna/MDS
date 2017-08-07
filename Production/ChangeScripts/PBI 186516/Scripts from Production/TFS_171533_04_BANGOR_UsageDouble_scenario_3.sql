
					Use Libertypower
						Go


       IF OBJECT_ID('TEMPDB..#temp') IS NOT NULL
       DROP TABLE TEMPDB..#temp

       select distinct b.* into #temp
       from(
                     select distinct a.AccountNumber,a.UtilityCode,a.ToDate from Libertypower..UsageConsolidated a(nolock)
                     where a.UtilityCode='BANGOR' 
                   	   and a.Active=1
					 group by a.AccountNumber,a.UtilityCode,A.ToDate
                     HAVING COUNT(DISTINCT a.MeterNumber)>1
            )t
       inner join Libertypower..UsageConsolidated b(nolock)
       on t.AccountNumber=b.AccountNumber
       and t.UtilityCode=b.UtilityCode
       and t.ToDate=b.ToDate and b.Active=1
	   --where b.active=1
	   inner join (select distinct a.AccountNumber,a.UtilityCode,a.ToDate from Libertypower..UsageConsolidated a(nolock)
                     where a.UtilityCode='BANGOR' 
					 and a.MeterNumber=''                 
					    and a.Active=1
					 group by a.AccountNumber,a.UtilityCode,A.ToDate,a.MeterNumber)a
					 on b.AccountNumber=a.AccountNumber
					 and b.UtilityCode=a.UtilityCode
					 and b.ToDate=a.ToDate
					 where b.active=1  
					  and b.UsageSource=2
					 and b.UsageType=1
					 
					 
	   If object_id('Tempdb..#Temp2') is not null
	   Drop table Tempdb..#Temp2
	   select distinct b.Accountnumber,b.utilitycode,b.fromdate,b.ToDate,
	   b.Totalkwh as consolidated_usage,b.meternumber,t.Id as Ediaccountid,B.Active
	   INTO #TEMP2
	   from ISTA.[dbo].[vw_BilledUsage]a(NOLOCK)
	   inner join #TEMP b(nolock)
	   on a.AccountNumber=b.AccountNumber
	   and a.utility=b.UtilityCode
	  -- and a.FromDate=b.FromDate
	   --and a.ToDate=b.ToDate
	  inner join (select a.accountnumber,a.utilitycode,max(a.id) as ID 
					from lp_transactions..Ediaccount a(nolock)
					inner join #temp t(nolock)
					on t.Accountnumber=a.accountnumber
					and t.utilitycode=a.UtilityCode
					where a.UtilityCode='BANGOR'
					group by a.accountnumber,a.utilitycode)t
					on t.AccountNumber=a.AccountNumber
					and t.UtilityCode=a.utility
					inner join lp_transactions..Ediusage eu(nolock)
					on t.id=eu.ediaccountid
					--and a.FromDate=eu.BeginDate
					and a.ToDate=eu.EndDate and eu.UnitOfMeasurement='KH' and eu.MeasurementSignificanceCode='51'
					where 1=1 and eu.UnitOfMeasurement='KH' and eu.MeasurementSignificanceCode='51'
					and b.UsageSource=2
					 and b.UsageType=1
					 and b.Active=1


		
					Delete a 
					from libertypower..usageconsolidated a(nolock)
					inner join #TEMP2 b(nolock)
					on a.AccountNumber=b.AccountNumber
					and a.UtilityCode=b.UtilityCode
					and a.FromDate=b.FromDate
					and a.ToDate=b.ToDate
					--and a.Meternumber=b.MeterNumber
					--and a.TotalKwh=b.Consolidated_Usage
					--and a.Created=b.Created
					and a.Active=0
					
					
					UPDATE UC
					SET UC.Active=0,
					uc.Modified=GETDATE()									
				   FROM LIBERTYPOWER..UsageConsolidated UC(NOLOCK)
					INNER JOIN #TEMP2 B(NOLOCK)
					ON UC.AccountNumber=B.AccountNumber
					AND UC.UtilityCode=B.UtilityCode
					--AND UC.FromDate=B.FromDate
					AND UC.ToDate=B.ToDate
					AND UC.TotalKwh=B.consolidated_usage 
					AND UC.MeterNumber=B.MeterNumber
					and uc.UsageSource=2
					 and uc.UsageType=1
					 and uc.Active=1
				

					