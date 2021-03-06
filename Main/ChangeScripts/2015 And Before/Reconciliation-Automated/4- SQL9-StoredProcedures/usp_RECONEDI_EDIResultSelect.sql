/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EDIResultSelect]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_EDIResultSelect
 * Select and format EDI Information for Utility and Account Number. 
 * 
 * History
 *******************************************************************************
 * 2014/04/01 - William Vilchez
 * Created.
 *******************************************************************************
 * <Date Modified,date,> - <Developer Name,,>
 * <Modification Description,,>
 *******************************************************************************
 */
CREATE procedure [dbo].[usp_RECONEDI_EDIResultSelect]
(@p_ReconID                                        int,
 @p_UtilityCode                                    nvarchar(255),
 @p_AccountNumber                                  nvarchar(255))
as

set nocount on

create table #Pending
(ID                                                int identity(1, 1) primary key clustered,
 Esiid                                             nvarchar(255),
 UtilityCode                                       nvarchar(255),
 AccountID                                         int,
 ContractID                                        int,
 ContractRateStart                                 datetime,
 ContractRateEnd                                   datetime,
 TransactionEffectiveDateFrom                      datetime,
 TransactionEffectiveDateTo                        datetime,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime,
 EDIResultInd                                      bit)

declare @t_ID                                      int
select @t_ID                                       = 1

declare @t_StartYear                               int
select @t_StartYear                                = 0

declare @t_EndYear                                 int
select @t_EndYear                                  = 0

declare @w_ID                                      int
declare @w_Esiid                                   nvarchar(255)
declare @w_UtilityCode                             nvarchar(255)
declare @w_AccountID                               int
declare @w_ContractID                              int
declare @w_ContractRateStart                       datetime
declare @w_ContractRateEnd                         datetime
declare @w_TransactionEffectiveDateFrom            datetime
declare @w_TransactionEffectiveDateTo              datetime
declare @w_EDIResultInd                            bit

declare @w_ActualStartDate                         datetime
declare @w_ActualEndDate                           datetime
declare @w_SearchActualStartDate                   datetime
declare @w_SearchActualEndDate                     datetime

declare @w_Rowcount                                int

declare @w_MaxLineRef                              int

select @w_MaxLineRef                               = isnull(max(LineRef), 0)
from dbo.RECONEDI_EDIResult with (nolock)
where ReconID                                      = @p_ReconID
and   UtilityCode                                  = @p_UtilityCode
and   Esiid                                        = @p_AccountNumber

declare @w_MaxTransactionEffectiveDateTo           datetime

select @w_MaxTransactionEffectiveDateTo            = TransactionEffectiveDateTo
from dbo.RECONEDI_EDIResult with (nolock)
where ReconID                                      = @p_ReconID
and   LineRef                                      = @w_MaxLineRef
and   UtilityCode                                  = @p_UtilityCode
and   Esiid                                        = @p_AccountNumber

insert into #Pending
select distinct
       a.Esiid,
       a.UtilityCode,
       a.AccountID,
       a.ContractID,
       a.ContractRateStart,
       a.ContractRateEnd,
       a.TransactionEffectiveDateFrom,
       a.TransactionEffectiveDateTo,
       a.SearchActualStartDate,
       a.SearchActualEndDate,
       EDIResultInd                                = case when a.LineRef is null
                                                          then 0
                                                          else 1
                                                     end
from (select b.LineRef,
             Esiid                                 = a.AccountNumber,
             UtilityCode                           = a.Utility,
             a.AccountID,
             a.ContractID,
             a.ContractRateStart,
             a.ContractRateEnd,
             TransactionEffectiveDateFrom          = case when a.ContractRateStart             > b.TransactionEffectiveDateFrom
                                                          then a.ContractRateStart
                                                          when a.ContractRateStart            <= b.TransactionEffectiveDateFrom
                                                          then b.TransactionEffectiveDateFrom
                                                          when b.TransactionEffectiveDateFrom is null
                                                          then a.ContractRateStart
                                                     end,
             TransactionEffectiveDateTo            = case when a.ContractRateEnd               > b.TransactionEffectiveDateTo
                                                          and  b.TransactionEffectiveDateTo   >= a.ContractRateStart
                                                          then b.TransactionEffectiveDateTo
                                                          when a.ContractRateEnd               > b.TransactionEffectiveDateTo
                                                          and  b.TransactionEffectiveDateTo    < a.ContractRateStart
                                                          then a.ContractRateEnd
                                                          when a.ContractRateEnd              <= b.TransactionEffectiveDateTo
                                                          then a.ContractRateEnd
                                                          when b.TransactionEffectiveDateTo   is null
                                                          then a.ContractRateEnd
                                                     end,
             SearchActualStartDate                 = case when a.ContractRateStart             > b.TransactionEffectiveDateFrom
                                                          then a.ContractRateStart
                                                          when a.ContractRateStart            <= b.TransactionEffectiveDateFrom
                                                          then b.TransactionEffectiveDateFrom
                                                          when b.TransactionEffectiveDateFrom is null
                                                          then a.ContractRateStart
                                                     end,
             SearchActualEndDate                   = case when a.ContractRateEnd               > b.TransactionEffectiveDateTo
                                                          and  b.TransactionEffectiveDateTo   >= a.ContractRateStart
                                                          then b.TransactionEffectiveDateTo
                                                          when a.ContractRateEnd               > b.TransactionEffectiveDateTo
                                                          and  b.TransactionEffectiveDateTo    < a.ContractRateStart
                                                          then a.ContractRateEnd
                                                          when a.ContractRateEnd              <= b.TransactionEffectiveDateTo
                                                          then a.ContractRateEnd
                                                          when b.TransactionEffectiveDateTo   is null
                                                          then a.ContractRateEnd
                                                     end
      from dbo.RECONEDI_EnrollmentFixed a with (nolock)
      left join dbo.RECONEDI_EDIResult b with (nolock)
      on  a.ReconID                                = b.ReconID
	  and a.Utility                                = b.UtilityCode
      and a.AccountNumber                          = b.ESIID
      and ((b.TransactionEffectiveDateFrom        >= a.ContractRateStart
      and   b.TransactionEffectiveDateFrom        <= a.ContractRateEnd)
      or   (b.TransactionEffectiveDateTo          >= a.ContractRateStart
      and   b.TransactionEffectiveDateTo          <= a.ContractRateEnd))
      where a.ReconID                              = @p_ReconID
	  and   a.Utility                              = @p_UtilityCode
      and   a.AccountNumber                        = @p_AccountNumber) a
order by a.UtilityCode,
         a.Esiid,
         a.TransactionEffectiveDateFrom,
         a.TransactionEffectiveDateTo

declare @w_ToDateTo                                datetime
declare @w_FromDateFrom                            datetime
declare @w_EffectiveDateFrom                       datetime

select top 1
       @w_ID                                       = ID,
       @w_Esiid                                    = Esiid,
       @w_UtilityCode                              = UtilityCode,
       @w_AccountID                                = AccountID,
       @w_ContractID                               = ContractID,
       @w_ContractRateStart                        = ContractRateStart,
       @w_ContractRateEnd                          = ContractRateEnd,
       @w_TransactionEffectiveDateFrom             = TransactionEffectiveDateFrom,
       @w_TransactionEffectiveDateTo               = TransactionEffectiveDateTo,
       @w_EDIResultInd                             = EDIResultInd
from #Pending (nolock)
where ID                                           = @t_ID

select @w_Rowcount                                 = @@Rowcount

while @w_Rowcount                                 <> 0
begin

   select @t_ID                                    = @t_ID + 1      

   select @t_StartYear                             = YEAR(@w_TransactionEffectiveDateFrom)
   select @t_EndYear                               = YEAR(@w_TransactionEffectiveDateTo)
   
   select @w_ActualStartDate                       = @w_TransactionEffectiveDateFrom
   select @w_ActualEndDate                         = @w_TransactionEffectiveDateTo
   select @w_FromDateFrom                          = DATEADD(dd, 1, @w_ActualEndDate)
   
   while @t_StartYear                             <= @t_EndYear
   begin
      
      if @t_StartYear                             <> @t_EndYear
      begin

         select @w_ActualEndDate                   = CONVERT(char(04), @t_StartYear)
                                                   + '1231'
         select @w_ActualStartDate                 = CONVERT(char(04), @t_StartYear + 1)
                                                   + '0101'
      end

      insert into #EDIResult
      select @w_AccountID,
             @w_ContractID,
             substring(@w_UtilityCode, 1, 50),
             substring(@w_Esiid, 1, 30),
             @w_TransactionEffectiveDateFrom,
             @w_ActualEndDate,
             @w_TransactionEffectiveDateFrom,
             @w_ActualEndDate
      select @w_FromDateFrom                       = DATEADD(dd, 1, @w_ActualEndDate)

      select @w_TransactionEffectiveDateFrom       = @w_ActualStartDate
      select @w_ActualEndDate                      = @w_TransactionEffectiveDateTo
            
      select @t_StartYear                          = @t_StartYear + 1
   end

   select @w_FromDateFrom                          = case when @w_EDIResultInd = 0
                                                          then DATEADD(dd, 1, @w_TransactionEffectiveDateFrom)
                                                          else DATEADD(dd, 1, @w_TransactionEffectiveDateTo)
                                                     end
                                                     
   select @w_ToDateTo                              = case when @w_EDIResultInd = 0
                                                          then @w_ContractRateStart
                                                          else @w_ContractRateEnd 
                                                     end                                                     
   
   if  @w_FromDateFrom                             < @w_ToDateTo 
   begin

      select @t_StartYear                          = YEAR(@w_FromDateFrom)
      select @t_EndYear                            = YEAR(@w_ToDateTo)
   
      select @w_EffectiveDateFrom                  = @w_FromDateFrom
      select @w_ActualStartDate                    = @w_FromDateFrom
      select @w_ActualEndDate                      = @w_ToDateTo
  
      while @t_StartYear                          <= @t_EndYear
      begin

         if @t_StartYear                          <> @t_EndYear
         begin
            select @w_ActualEndDate                = CONVERT(char(04), @t_StartYear)
                                                   + '1231'
            select @w_ActualStartDate              = CONVERT(char(04), @t_StartYear + 1)
                                                   + '0101'
         end

         insert into #EDIResult
         select @w_AccountID,
                @w_ContractID,
                substring(@w_UtilityCode, 1, 50),
                substring(@w_Esiid, 1, 30),
                @w_EffectiveDateFrom,
                @w_ActualEndDate,
                null,
                null

         select @w_EffectiveDateFrom               = @w_ActualStartDate
         select @w_ActualEndDate                   = case when @w_EDIResultInd = 0
                                                          then @w_TransactionEffectiveDateTo
                                                          else @w_ContractRateEnd 
                                                     end
            
         select @t_StartYear                      = @t_StartYear + 1
      end
   end

   select top 1
          @w_ID                                    = ID,
          @w_Esiid                                 = Esiid,
          @w_UtilityCode                           = UtilityCode,
          @w_AccountID                             = AccountID,
          @w_ContractID                            = ContractID,
          @w_ContractRateStart                     = ContractRateStart,
          @w_ContractRateEnd                       = ContractRateEnd,
          @w_TransactionEffectiveDateFrom          = TransactionEffectiveDateFrom,
          @w_TransactionEffectiveDateTo            = TransactionEffectiveDateTo,
          @w_EDIResultInd                          = EDIResultInd
   from #Pending (nolock)
   where ID                                        = @t_ID

   select @w_Rowcount                              = @@rowcount

end

if (select COUNT(*)
    from #EDIResult)                                   = 0
begin                                        

   declare @w_FromYear                             int 
   declare @w_ToYear                               int

   select @w_FromYear                              = year(@w_ContractRateStart)
   select @w_ToYear                                = year(@w_ContractRateEnd)

  ;with Dates as(select YearAdd                    = @w_FromYear
                        union all
                        select YearAdd + 1
                        from Dates
                        where YearAdd              < @w_ToYear)  

   insert into #EDIResult
   select a.AccountID,
          a.ContractID,
          substring(a.Utility, 1, 50),
          substring(a.AccountNumber, 1, 30),
          case when b.YearAdd                      = year(a.ContractRateStart)
               and  b.YearAdd                      = year(a.ContractRateEnd)
               then a.ContractRateStart
               when b.YearAdd                      = year(a.ContractRateStart)
               and  b.YearAdd                     <> year(a.ContractRateEnd)
               then a.ContractRateStart
               when b.YearAdd                     <> year(a.ContractRateStart)
               and  b.YearAdd                     <> year(a.ContractRateEnd)
               then CONVERT(char(04), b.YearAdd)
                  + '0101'
               when b.YearAdd                     <> year(a.ContractRateStart)
               and  b.YearAdd                      = year(a.ContractRateEnd)
               then CONVERT(char(04), b.YearAdd)
                  + '0101'
          end,
          case when b.YearAdd                      = year(a.ContractRateStart)
               and  b.YearAdd                      = year(a.ContractRateEnd)
               then a.ContractRateEnd
               when b.YearAdd                      = year(a.ContractRateStart)
               and  b.YearAdd                     <> year(a.ContractRateEnd)
               then CONVERT(char(04), b.YearAdd)
                  + '1231'
               when b.YearAdd                     <> year(a.ContractRateStart)
               and  b.YearAdd                     <> year(a.ContractRateEnd)
               then CONVERT(char(04), b.YearAdd)
                  + '1231'
               when b.YearAdd                     <> year(a.ContractRateStart)
               and  b.YearAdd                      = year(a.ContractRateEnd)
               then a.ContractRateEnd
          end,
          case when b.YearAdd                      = year(a.ContractRateStart)
               and  b.YearAdd                      = year(a.ContractRateEnd)
               then a.ContractRateStart
               when b.YearAdd                      = year(a.ContractRateStart)
               and  b.YearAdd                     <> year(a.ContractRateEnd)
               then a.ContractRateStart
               when b.YearAdd                     <> year(a.ContractRateStart)
               and  b.YearAdd                     <> year(a.ContractRateEnd)
               then CONVERT(char(04), b.YearAdd)
                  + '0101'
               when b.YearAdd                     <> year(a.ContractRateStart)
               and  b.YearAdd                      = year(a.ContractRateEnd)
               then CONVERT(char(04), b.YearAdd)
                  + '0101'
          end,
          case when b.YearAdd                      = year(a.ContractRateStart)
               and  b.YearAdd                      = year(a.ContractRateEnd)
               then a.ContractRateEnd
               when b.YearAdd                      = year(a.ContractRateStart)
               and  b.YearAdd                     <> year(a.ContractRateEnd)
               then CONVERT(char(04), b.YearAdd)
                  + '1231'
               when b.YearAdd                     <> year(a.ContractRateStart)
               and  b.YearAdd                     <> year(a.ContractRateEnd)
               then CONVERT(char(04), b.YearAdd)
                  + '1231'
               when b.YearAdd                     <> year(a.ContractRateStart)
               and  b.YearAdd                      = year(a.ContractRateEnd)
               then a.ContractRateEnd
          end
   from RECONEDI_EnrollmentFixed a with (nolock)
   cross join Dates b
   where a.ReconID                                 = @p_ReconID              
   and   a.Utility                                 = @p_UtilityCode
   and   a.AccountNumber                           = @p_AccountNumber

end

set nocount off

GO
