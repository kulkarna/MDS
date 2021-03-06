USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[Usp_GetIdrHourlyUsage]    Script Date: 03/01/2017 13:22:56 ******/
if OBJECT_ID('Usp_GetIdrHourlyUsage') is not null
DROP PROCEDURE [dbo].[Usp_GetIdrHourlyUsage]
GO
/****** Object:  StoredProcedure [dbo].[Usp_GetIdrHourlyUsage]    Script Date: 03/01/2017 13:22:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[Usp_GetIdrHourlyUsage] 
@ACCOUNTUSAGELIST
AS      
DBO.AccountUsageList READONLY 
AS      
      
BEGIN      
 SET NOCOUNT ON;     
 DECLARE @err_message nvarchar(255)

 select a.AccountNumber,a.UtilityId,t.UtilityCode,t.ID,a.FromDate,a.ToDate into #ValidAccounts from @ACCOUNTUSAGELIST a
 inner join (select distinct a.accountnumber,max(a.ID) as ID ,a.Utilitycode from lp_transactions..EdiAccount a(nolock)
 group by a.AccountNumber,a.UtilityCode)t
 on A.AccountNumber=t.AccountNumber
inner join lp_transactions..EdiAccount b(nolock)
on t.accountnumber=b.AccountNumber
and t.id=b.ID
inner join lp_transactions..IdrUsageHorizontal d(nolock)
on t.id=d.EdiAccountId
where 1=1 
and D.UnitOfMeasurement='KH'

select a.AccountNumber,A.UtilityId,A.FromDate,A.ToDate into #InvalidAccount from @ACCOUNTUSAGELIST a
left join #ValidAccounts b(nolock)
on a.accountnumber=b.AccountNumber
where 1=1
and b.Accountnumber is null



 select distinct t.AccountNumber,t.UtilityId,e.MeterNumber,e.[Date],t.Id
           , case when e.[15] is null then isnull(cast( e.[100] as varchar(20)),0)+','+isnull(cast(e.[200] as varchar(20)),0)
+','+isnull(cast(e.[300] as varchar(20)),0)+','+isnull(cast(e.[400] as varchar(20)),0)+','+isnull(cast(e.[500] as varchar(20)),0)
+','+isnull(cast(e.[600] as varchar(20)),0)+','+isnull(cast(e.[700] as varchar(20)),0)+','+isnull(cast(e.[800] as varchar(20)),0)
+','+isnull(cast(e.[900] as varchar(20)),0)+','+isnull(cast(e.[1000] as varchar(20)),0)+','+isnull(cast(e.[1100] as varchar(20)),0)
+','+isnull(cast(e.[1200] as varchar(20)),0)+','+isnull(cast(e.[1300] as varchar(20)),0)+','+isnull(cast(e.[1400] as varchar(20)),0)
+','+isnull(cast(e.[1500] as varchar(20)),0)+','+isnull(cast(e.[1600] as varchar(20)),0)+','+isnull(cast(e.[1700] as varchar(20)),0)
+','+isnull(cast(e.[1800] as varchar(20)),0)+','+isnull(cast(e.[1900] as varchar(20)),0)+','+isnull(cast(e.[2000] as varchar(20)),0)
+','+isnull(cast(e.[2100] as varchar(20)),0)+','+isnull(cast(e.[2200] as varchar(20)),0)+','+isnull(cast(e.[2300] as varchar(20)),0)
+','+isnull(cast(e.[2359] as varchar(20)),0)
            when e.[15] is not null then cast((e.[0]+e.[15]+e.[30]+e.[45]) as varchar(40))+','+cast((e.[100]+e.[115]+e.[130]+e.[145]) as varchar(40))
            +','+cast((e.[200]+e.[215]+e.[230]+e.[245]) as varchar(40))+','+cast((e.[300]+e.[315]+e.[330]+e.[345]) as varchar(40))
            +','+cast((e.[400]+e.[415]+e.[430]+e.[445]) as varchar(40))+','+cast((e.[500]+e.[515]+e.[530]+e.[545]) as varchar(40))
            +','+cast((e.[600]+e.[615]+e.[630]+e.[645]) as varchar(40))+','+cast((e.[700]+e.[215]+e.[730]+e.[745]) as varchar(40)) 
            +','+cast((e.[800]+e.[815]+e.[830]+e.[845]) as varchar(40))+','+cast((e.[900]+e.[915]+e.[930]+e.[945]) as varchar(40))
            +','+cast((e.[1000]+e.[1015]+e.[1030]+e.[1045]) as varchar(40))+','+cast((e.[1100]+e.[1115]+e.[1130]+e.[1145]) as varchar(40))
            +','+cast((e.[1200]+e.[1215]+e.[1230]+e.[1245]) as varchar(40))+','+cast((e.[1300]+e.[1315]+e.[1330]+e.[1345]) as varchar(40))
            +','+cast((e.[1400]+e.[1415]+e.[1430]+e.[1445]) as varchar(40))+','+cast((e.[1500]+e.[1515]+e.[1530]+e.[1545]) as varchar(40))
            +','+cast((e.[1600]+e.[1615]+e.[1630]+e.[1645]) as varchar(40))+','+cast((e.[1700]+e.[1715]+e.[1730]+e.[1745]) as varchar(40))
            +','+cast((e.[1800]+e.[1815]+e.[1830]+e.[1845]) as varchar(40))+','+cast((e.[1900]+e.[1915]+e.[1930]+e.[1945]) as varchar(40))
            +','+cast((e.[2000]+e.[2015]+e.[2030]+e.[2045]) as varchar(40))+','+cast((e.[2100]+e.[2115]+e.[2130]+e.[2145]) as varchar(40))
            +','+cast((e.[2200]+e.[2215]+e.[2230]+e.[2245]) as varchar(40))+','+cast((e.[2300]+e.[2315]+e.[2330]+e.[2345]) as varchar(40))

            end [Usage],
	
	case when  e.[15] IS NULL 
  and e.[100] is null and e.[200]is null and e.[300] is null and e.[400]is null
  and e.[500] is null and e.[600]is null and e.[700] is null and e.[800]is null
  and e.[900] is null and e.[1000]is null and e.[1100] is null and e.[1200]is null
  and e.[1300] is null and e.[1400]is null and e.[1500] is null and e.[1600]is null
  and e.[1700] is null and e.[1800]is null and e.[1900] is null and e.[2000]is null
  and e.[2100] is null and e.[2200]is null and e.[2300] is null and e.[2359]is null then'' end abc
	
			 into #t
  from
            #ValidAccounts t
            inner join lp_transactions..EdiAccount d(nolock)
            on t.accountnumber=d.AccountNumber
            and t.id=d.ID
            and t.UtilityCode=d.utilitycode
            inner join lp_transactions..IdrUsageHorizontal e(nolock)
            on t.id=e.EdiAccountId
            and e.Date between t.FromDate and t.Todate
            where 1=1 and d.UtilityCode=t.UtilityCode
            and e.UnitOfMeasurement='KH'
			 and e.Date between t.FromDate and t.Todate

            			
			Select  t.AccountNumber,t.UtilityId,t.MeterNumber,t.[Date],t.Id,t.usage,
						Case when abc =''  then 'USAGE NOT EXISTS'  
						else ''end as ErrorMessage
					  
					from 			#t t
					UNION 
		  select Accountnumber,UtilityId,null,GETDATE(),null,null,'ACCOUNT  NOT EXISTS ' from #InvalidAccount a
					
				
        
 SET NOCOUNT OFF;      
END

GO
