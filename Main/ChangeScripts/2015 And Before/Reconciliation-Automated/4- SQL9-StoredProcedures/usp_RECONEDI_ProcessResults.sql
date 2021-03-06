/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ProcessResults]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************  
 * usp_RECONEDI_ProcessResults 
 * Process the reconciliation results
 *   
 * History  
 *******************************************************************************  
 * 2014/04/18 - Felipe Medeiros  
 * Created.  
 *******************************************************************************  
 * <Date Modified,date,> - <Developer Name,,>  
 * <Modification Description,,>  
 *******************************************************************************  
 */  
CREATE PROCEDURE [dbo].[usp_RECONEDI_ProcessResults]
(@p_ReconID                                         int)
as
begin
    
    set nocount on;

    declare @w_AsOfDate                            datetime

    select @w_AsOfDate                             = AsOfDate
    from dbo.RECONEDI_Header (nolock)
    where ReconID                                  = @p_ReconID

    declare @ISO table
    (ISO varchar(50) primary key clustered)

    insert into @ISO
    select distinct 
           a.WholeSaleMktID
    from Libertypower..Utility a (nolock)
    cross join dbo.RECONEDI_Header b (nolock)
    where b.ReconID                                = @p_ReconID
    and (a.WholeSaleMktID                          = b.ISO
    or   b.ISO                                     = '*')
    and  a.InactiveInd                             = 0 

    delete b
	from RECONEDI_MTMAccounts a (nolock)
	inner join RECONEDI_MTMVolume b (nolock)
	on  a.ID                                       = b.ReconMTMAccountID
    where a.ReconID                                = @p_ReconID

    delete a
	from RECONEDI_MTMAccounts a (nolock)
    where a.ReconID                                = @p_ReconID

    delete b
	from RECONEDI_EDIAccounts a (nolock)
	inner join RECONEDI_EDIVolume b (nolock)
	on  a.ID                                       = b.ReconEDIAccountID
    where a.ReconID                                = @p_ReconID

    delete a
	from RECONEDI_EDIAccounts a (nolock)
    where a.ReconID                                = @p_ReconID

	delete a
	from RECONEDI_MarkToMarketData a (nolock)
	where a.ReconID                                = @p_ReconID

    /* QUERY TO GET DATA from MARK TO MARKET TO DO COMPARISon*/

	insert into RECONEDI_MarkToMarketData
    select @p_ReconID,
	       a.AccountID,
           a.ContractID,
		   x.ContractNumber,
           d.ISO,
		   x.UtilityCode,
		   x.AccountNumber,
           a.Zone,
           d.MtMAccountID,
           d.StartDate,
           d.EndDate,
           d.YearUsage,
           Volume                                  = sum(d.TotalUsage),
           z.Book,
           AsOfDate                                = @w_AsOfDate,
           DateCreated                             = getdate()
    from lp_MtM..MtMAccount a (nolock) 
    inner join lp_MtM..MtMZainetDailyData d (nolock) 
    on  a.id                                       = d.MtMAccountID
    inner join lp_MtM..MtMReportZkeyDetail zd (nolock)
    on  d.Zkey                                     = zd.Zkey
    inner join lp_MtM..MtMReportZkey z (nolock) 
    on  z.ZkeyID                                   = zd.ZkeyID
    inner join @ISO w 
    on  d.ISO                                      = w.ISO
    left join (select distinct
	                  a.AccountID,
                      c.ContractID,
                      ContractNumber               = c.Number,
					  u.UtilityCode,
					  a.AccountNumber
               from Libertypower..Account a (nolock)
               inner join Libertypower..Utility u (nolock) 
               on a.UtilityID                      = u.ID
			   inner join @ISO w 
			   on  u.WholeSaleMktID                = w.ISO
               inner join Libertypower..AccountContract b (nolock) 
               on  a.accountid                     = b.accountid
               inner join Libertypower..[Contract] c (nolock) 
               on  b.Contractid                    = c.Contractid) x 
	on  a.AccountID                                = x.AccountID
    and a.ContractID                               = x.ContractID
    where d.RunDate                                = dateadd(dd, 1, convert(datetime, @w_AsOfDate, 113))
    group by a.AccountID,
             a.ContractID,
		     x.ContractNumber,
             d.ISO,
		     x.UtilityCode,
		     x.AccountNumber,
             a.Zone,
             d.MtMAccountID,
             d.StartDate,
             d.EndDate,
             d.YearUsage,
             z.Book

    /* TO GET MARK TO MARKET ACCOUNTS TO COMPARE */

    insert into RECONEDI_MTMAccounts
    select distinct 
           Reconid,
           AccountID,
           ContractID,
           ContractNumber, 
           ISO,
		   UtilityCode,
		   AccountNumber,
           MtMAccountID,
           StartDate,
           EndDate,
           Book,
		   'Unmatched',
		   12
    from RECONEDI_MarkToMarketData (nolock)
    where ReconID                                  = @p_ReconID

    /* TO GET MARK TO MARKET VOLUME TO COMPARE */
    insert into RECONEDI_MTMVolume
    select distinct
	       b.ID,
		   a.YearUsage,
           Volume                                  = round(sum(a.Volume)/1000,0)
    from RECONEDI_MarkToMarketData a (nolock)
	inner join dbo.RECONEDI_MTMAccounts b (nolock)
	on  a.ReconID                                  = b.ReconID
	and a.AccountID                                = b.AccountID
	and a.ContractID                               = b.ContractID
    where a.ReconID                                = @p_ReconID
	group by b.ID,
	         a.YearUsage

    /* TO DELETE DUPLICATES IN MTM, BUT HAVE TO STORE */

    select a.Accountid,
           a.Contractid,
           MtMAccountID                            = Min(a.MtMAccountID)
    into #DeleteMTMDups
    from RECONEDI_MTMAccounts a (nolock)
    where a.Reconid                                = @p_ReconID
    group by accountid,
             contractid 
    having count(*)                                > 1

    /* DELETING DUPS */

	delete b
	from RECONEDI_MTMAccounts a (nolock)
	inner join RECONEDI_MTMVolume b (nolock)
	on  a.ID                                       = b.ReconMTMAccountID
	inner join #DeleteMTMDups c (nolock)
	on  a.AccountID                                = c.AccountID
	and a.ContractID                               = c.ContractID
	and a.MtMAccountID                             = c.MtMAccountID
    where a.ReconID                                = @p_ReconID
    
	delete a
	from RECONEDI_MTMAccounts a (nolock)
	inner join #DeleteMTMDups b (nolock)
	on  a.AccountID                                = b.AccountID
	and a.ContractID                               = b.ContractID
	and a.MtMAccountID                             = b.MtMAccountID
    where a.ReconID                                = @p_ReconID
    
    /* QUERY TO GET EDI ACCOUNTS TO COMPARE, WILL ALSO BE THE INFORMATIon SHOWN IN SCREEN (HAVE TO REPRESENT BETTER) */

    insert into RECONEDI_EDIAccounts
	select a.ReconID,
           a.AccountID,
           a.ContractID,
		   a.ContractNumber,
           a.ISO,
		   a.Utility,
           a.AccountNumber,
		   ContractRateStart                       = min(a.ContractRateStart),
           ContractRateEnd                         = max(a.ContractRateEnd),
           a.ProcessType,
		   'Unmatched',
		   11
    from RECONEDI_ForecastWholesale_vw a (nolock)
    inner join RECONEDI_StatusSubStatus_vw b (nolock)
    on  a.Status                                   = b.Status 
    and a.SubStatus                                = b.SubStatus
    where a.ReconID                                = @p_ReconID
    and   a.SearchActualEndDate                   >= @w_AsOfDate -- THIS DATE CORRESPonDS TO [AS OF DATE]
    and   not exists (select null
                      from RECONEDI_AccountOut y (nolock)
                      where y.AccountNumber        = a.AccountNumber
                      and   y.ContractNumber       = a.ContractNumber
                      and   y.UtilityCode          = a.Utility)
    group by a.ReconID,
	         a.AccountID,
             a.ContractID,
	   	     a.ContractNumber,
             a.ISO,
		     a.Utility,
             a.AccountNumber,
			 a.ProcessType

    /* QUERY TO GET THE EDI VOLUMES TO COMPARE */
    
	insert into RECONEDI_EDIVolume
    select c.ID,
           a.UsagesYear,
           TotalVolumeMwh                          = round(sum(a.Month01TotalVolume
                                                             + a.Month02TotalVolume
                                                             + a.Month03TotalVolume
                                                             + a.Month04TotalVolume
                                                             + a.Month05TotalVolume
                                                             + a.Month06TotalVolume
                                                             + a.Month07TotalVolume
                                                             + a.Month08TotalVolume
                                                             + a.Month09TotalVolume
                                                             + a.Month10TotalVolume
                                                             + a.Month11TotalVolume
                                                             + a.Month12TotalVolume) /1000, 0)
    from RECONEDI_ForecastWholesale_vw a (nolock)
    inner join RECONEDI_StatusSubStatus_vw b (nolock)
    on  a.Status                                   = b.Status 
    and a.SubStatus                                = b.SubStatus
    inner join RECONEDI_EDIAccounts c (nolock)
	on  a.ReconID                                   = c.ReconID
	and a.AccountID                                 = c.AccountID
	and a.ContractID                                = c.ContractID
    where a.ReconID                                = @p_ReconID
    and   a.SearchActualEndDate                   >= @w_AsOfDate -- THIS DATE CORRESPonDS TO [AS OF DATE]
    and   not exists (select null
                      from RECONEDI_AccountOut y (nolock)
                      where y.AccountNumber        = a.AccountNumber
                      and   y.ContractNumber       = a.ContractNumber
                      and   y.UtilityCode          = a.Utility)
    group by c.ID,
             a.ProcessType,
             a.UsagesYear

    /* Common Info MTM */

    update a set ReconStatus = 'Matched',
	             ReconReasonID = 15
	from RECONEDI_MTMAccounts a (nolock)
	inner join RECONEDI_EDIAccounts b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.Accountid                                = b.Accountid 
    and a.Contractid                               = b.Contractid
    where a.ReconID                                = @p_ReconID

	/* Common Info EDI */

    update a set ReconStatus = 'Matched',
	             ReconReasonID = 14
	from RECONEDI_EDIAccounts a (nolock)
	inner join RECONEDI_MTMAccounts b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.Accountid                                = b.Accountid 
    and a.Contractid                               = b.Contractid
    where a.ReconID                                = @p_ReconID

    /* ACCOUNTS MISSING IN EDI */

    update a set ReconReasonID = 16
	from RECONEDI_MTMAccounts a (nolock)
	left join RECONEDI_EDIAccounts b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.Accountid                                = b.Accountid 
    and a.Contractid                               = b.Contractid
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 12
    and   b.AccountID                             is null


    /* ACCOUNTS MISSING IN MARK TO MARKET */

    update a set ReconReasonID = 17
	from RECONEDI_EDIAccounts a (nolock)
	left join RECONEDI_MTMAccounts b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.Accountid                                = b.Accountid 
    and a.Contractid                               = b.Contractid
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 11
    and   b.accountid                             is null

    /* ACCOUNTS WITHOUT CONTRACTS */

    update a set ReconReasonID = 92
	from RECONEDI_MTMAccounts a (nolock)
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 16
    and   a.ContractID                            is null

    /* To determine in Excluded Account list */

    update a set ReconReasonID = 93
	from RECONEDI_MTMAccounts a (nolock)
	inner join RECONEDI_EnrollmentFixed b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.Accountid                                = b.Accountid 
    and a.ContractID                               = b.ContractID
    inner join RECONEDI_AccountOut c (nolock)
    on  b.Accountnumber                            = c.Accountnumber 
    and b.Contractnumber                           = c.Contractnumber
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 16

    /* TO DETERMINE ACCOUNTS THAT WHERE SUBMITTED AFTER PROCESS DATE */

    update a set ReconReasonID = 21
	from RECONEDI_MTMAccounts a (nolock)
    inner join (select a.AccountID,
                       c.ContractID,
                       c.SubmitDate 
                from Libertypower..Account a (nolock)
                inner join Libertypower..Utility u (nolock) 
                on  a.UtilityID                    = u.ID
                inner join Libertypower..AccountContract b (nolock) 
                on  a.accountid                    = b.accountid
                inner join Libertypower..[Contract] c (nolock) 
                on  b.Contractid                   = c.Contractid
                inner join Libertypower..ACCOUNTStatus d (nolock) 
                on  b.AccountContractID            = d.AccountContractID
                inner join Libertypower..AccountContractRate e (nolock) 
                on  b.AccountContractID            = e.AccountContractID) b
    on  a.Accountid                                = b.Accountid 
    and a.Contractid                               = b.ContractID
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 16
	and   b.SubmitDate                             > @w_AsOfDate

    /* TO DETERMINE CONTRACTS THAT HAVE STATUS OF REJECTED */

	update a set ReconReasonID = 22
	from RECONEDI_MTMAccounts a (nolock)
    inner join (select a.AccountID,
                       c.ContractID,
                       c.ContractStatusID
                from Libertypower..Account a (nolock)
                inner join Libertypower..Utility u (nolock) 
                on  a.UtilityID                    = u.ID
                inner join Libertypower..AccountContract b (nolock) 
                on  a.accountid                    = b.accountid
                inner join Libertypower..[Contract] c (nolock) 
                on  b.Contractid                   = c.Contractid
                inner join Libertypower..ACCOUNTStatus d (nolock) 
                on  b.AccountContractID            = d.AccountContractID
                inner join Libertypower..AccountContractRate e (nolock) 
                on  b.AccountContractID            = e.AccountContractID) b
    on  a.Accountid                                = b.Accountid 
    and a.Contractid                               = b.ContractID
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 16
    and   b.ContractStatusID                       = 2

    /* TO DETERMINE OVERLAPS */

    update a set ReconReasonID = 23
	from RECONEDI_MTMAccounts a (nolock)
    inner join RECONEDI_EnrollmentFixed b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.AccountID                                = b.AccountID 
    and a.ContractID                               = b.ContractID
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 16
    and   b.overlaptype                           is not null

    /* REENROLLED AFTER CONTRACT END */

    update a set ReconReasonID = 24
	from RECONEDI_MTMAccounts a (nolock)
    inner join RECONEDI_EnrollmentFixed b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.AccountID                                = b.AccountID 
    and a.ContractID                               = b.ContractID
    inner join (select a.*
                from RECONEDI_EDIResult a (nolock)
                inner join (select ReconID,
				                   LineRef         = max(LineRef),
				                   Esiid,
                                   UtilityCode 
                            from RECONEDI_EDIResult (nolock)
							where ReconID          = @p_ReconID
                            group by ReconID,
							         Esiid,
							         UtilityCode) b 
                on  a.ReconID                      = b.ReconID
				and a.LineRef                      = b.LineRef
				and a.Esiid                        = b.Esiid 
                and a.UtilityCode                  = b.UtilityCode) c 
    on  b.ReconID                                  = c.ReconID
    and b.AccountNumber                            = c.Esiid 
    and b.Utility                                  = c.UtilityCode
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 16
    and   b.ContractRateEnd                       <= c.TransactionEffectiveDatefrom 
    and   c.TransactionEffectiveDateTo            is null

    /* DEENROLLED LAST INVOICE SAME AS DROP DATE */

    update a set ReconReasonID = 25
	from RECONEDI_MTMAccounts a (nolock)
    inner join RECONEDI_EnrollmentFixed b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.AccountID                                = b.AccountID 
    and a.ContractID                               = b.ContractID
    inner join (select a.*
                from RECONEDI_EDIResult a (nolock)
                inner join (select ReconID,     
				                   LineRef         = max(LineRef),
				                   Esiid,
                                   UtilityCode 
                            from RECONEDI_EDIResult (nolock)
							where ReconID          = @p_ReconID
                            group by ReconID,
							         Esiid,
									 UtilityCode) b 
                on  a.ReconID                      = b.ReconID
                and a.LineRef                      = b.LineRef
				and a.Esiid                        = b.Esiid 
                and a.UtilityCode                  = b.UtilityCode) c 
    on  b.ReconID                                  = c.ReconID
    and b.AccountNumber                            = c.Esiid 
    and b.Utility                                  = c.UtilityCode
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 16
    and   b.InvoiceToDate                          = c.TransactionEffectiveDateTo

    /* LAST INVOICE WITHIN 5 DAYS OF DROP */

    update a set ReconReasonID = 26
	from RECONEDI_MTMAccounts a (nolock)
    inner join RECONEDI_EnrollmentFixed b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.AccountID                                = b.AccountID 
    and a.ContractID                               = b.ContractID
    inner join (select a.*
                from RECONEDI_EDIResult a (nolock)
                inner join (select ReconID,
				                   LineRef         = max(LineRef),
				                   Esiid,
                                   UtilityCode 
                            from RECONEDI_EDIResult (nolock)
							where ReconID          = @p_ReconID
                            group by ReconID,
							         Esiid,
							         UtilityCode) b 
                on  a.ReconID                      = b.ReconID
				and a.LineRef                      = b.LineRef
				and a.Esiid                        = b.Esiid 
                and a.UtilityCode                  = b.UtilityCode) c 
    on  b.ReconID                                  = c.ReconID
    and b.AccountNumber                            = c.Esiid 
    and b.Utility                                  = c.UtilityCode
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 16
    and   b.InvoiceToDate                         <= c.TransactionEffectiveDateTo 
    and   datediff(d, c.TransactionEffectiveDateTo, b.InvoiceToDate)
	                                              <= 5

    /* Wrong Status */

    update a set ReconReasonID = 27
	from RECONEDI_MTMAccounts a (nolock)
    inner join RECONEDI_EnrollmentFixed b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.AccountID                                = b.AccountID 
    and a.ContractID                               = b.ContractID
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 16
    and   not exists (select null
	                  from RECONEDI_StatusSubStatus_vw c (nolock)
					  where c.Status               = b.Status
					  and   c.SubStatus            = b.SubStatus)

    /* Dropped No New EDI*/

    update a set ReconReasonID = 28
	from RECONEDI_MTMAccounts a (nolock)
    inner join RECONEDI_EnrollmentFixed b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.AccountID                                = b.AccountID 
    and a.ContractID                               = b.ContractID
    inner join (select a.*
                from RECONEDI_EDIResult a (nolock)
                inner join (select ReconID,
				                   LineRef         = max(LineRef),
				                   Esiid,
                                   UtilityCode 
                            from RECONEDI_EDIResult (nolock)
							where ReconID          = @p_ReconID
                            group by ReconID,
							         Esiid,
							         UtilityCode) b 
                on  a.ReconID                      = b.ReconID
				and a.LineRef                      = b.LineRef
				and a.Esiid                        = b.Esiid 
                and a.UtilityCode                  = b.UtilityCode) c 
    on  b.ReconID                                  = c.ReconID
    and b.AccountNumber                            = c.Esiid 
    and b.Utility                                  = c.UtilityCode
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 16
    and   c.TransactionEffectiveDateTo        is not null

	/* Account-Contracts missing in excluded list (Back to Back) */

    update a set ReconReasonID = 31
	from RECONEDI_EDIAccounts a(nolock)
	inner join RECONEDI_MTM b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.Accountid                                = b.Accountid 
    and a.Contractid                               = b.Contractid
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 17

	/* To identify Zainet issues*/

    update a set ReconReasonID = case when b.status = 'ETPd - Failed(Zainet)'
		                              then 32
				                      when b.status = 'Failed (ETP)'
				                      then 33
				                      else 34
                                 end
	from RECONEDI_EDIAccounts a(nolock)
	inner join RECONEDI_MTM b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.Accountid                                = b.Accountid 
    and a.Contractid                               = b.Contractid
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 17
	and   b.Status                                in ('ETPd - Failed(Zainet)','Failed (ETP)','Failed (Forecasting)')

	/* Timing contract end after process date but before MtM data*/

    update a set ReconReasonID = 35
	from RECONEDI_EDIAccounts a(nolock)
	inner join RECONEDI_MTM b (nolock)
    on  a.ReconID                                  = b.ReconID 
    and a.Accountid                                = b.Accountid 
    and a.Contractid                               = b.Contractid
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 17
	and   a.ContractRateEnd                        < @w_AsOfDate

	/* Not Current Contract */

	update a set ReconReasonID = 94
	from RECONEDI_EDIAccounts a(nolock)
	inner join RECONEDI_MTM b (nolock)
	on  a.ReconID                                  = b.ReconID 
    and a.AccountID                                = b.AccountID
	and a.ContractID                               = b.ContractID
	inner join RECONEDI_MtMAccounts c (nolock)
	on  b.ReconID                                  = c.ReconID 
    and b.AccountID                                = c.AccountID
	and b.ContractID                              <> c.ContractID
    where a.ReconID                                = @p_ReconID
    and   a.ReconReasonID                          = 17

    set nocount off;

end


GO
