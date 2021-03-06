/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EDIResult]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_EDIResult
 * Calculate EDI Information.  
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
 CREATE procedure [dbo].[usp_RECONEDI_EDIResult]
(@p_ReconID                                        int,
 @p_UtilityCode                                    varchar(50),
 @p_AccountNumber                                  varchar(50),
 @p_AsOfDate                                       date,
 @p_ProcessDate                                    datetime)
as

set nocount on

create table #Result
(LineRef                                           int identity(1, 1) primary key clustered,
 esiid                                             varchar(50),
 UtilityCode                                       varchar(50),
 IDFrom                                            int,
 TransactionDateFrom                               datetime,
 TransactionEffectiveDateFrom                      datetime,
 ReadCycleDateFrom                                 datetime,
 OriginFrom                                        varchar(100),
 ReferenceNbrFrom                                  varchar(100),
 IDTo                                              int,
 TransactionDateTo                                 datetime,
 TransactionEffectiveDateTo                        datetime,
 ReadCycleDateTo                                   datetime,
 OriginTo                                          varchar(100),
 ReferenceNbrTo                                    varchar(100),
 Note                                              varchar(500),
 Status                                            varchar(08),
 DateCanRej                                        datetime)


declare @w_LastActiveID                            int
select @w_LastActiveID                             = 0

declare @w_ISO                                     varchar(50)

select @w_ISO                                      = WholeSaleMktID
from Libertypower..Utility with (nolock)
where UtilityCode                                  = @p_UtilityCode

declare @w_Note                                    varchar(500)
declare @w_Status                                  varchar(08)
declare @w_Date                                    datetime

declare @w_LastEnrollmentDate                      datetime

declare @w_ReadCycleDate                           datetime

create table #EDIPending 
([814_Key]                                         int,
 esiid                                             varchar(100),
 UtilityCode                                       varchar(50),
 TransactionType                                   varchar(100),
 TransactionStatus                                 varchar(100),
 ChangeReason                                      varchar(100),
 ChangeDescription                                 varchar(100),
 StatusCode                                        nvarchar(255),
 TransactionDate                                   datetime,
 TransactionEffectiveDate                          datetime,
 ReferenceNbr                                      varchar(100),
 TransactionNbr                                    varchar(100),
 AssignId                                          varchar(100),
 Origin                                            varchar(100),
 ProcessType                                       varchar(100))

insert into #EDIPending
select a.[814_Key],
       a.Esiid,
       a.UtilityCode,
       a.TransactionType,
       a.TransactionStatus,
       a.ChangeReason,
       a.ChangeDescription,
       a.StatusCode,
       a.TransactionDate,
       a.TransactionEffectiveDate,
       a.ReferenceNbr,
       a.TransactionNbr,
       a.AssignId,
       a.Origin,
       b.ProcessType
from dbo.RECONEDI_EDIPending_Work a with (nolock)
inner join dbo.RECONEDI_Transaction b with (nolock)
on    a.TransactionType                            = b.TransactionType
where a.UtilityCode                                = @p_UtilityCode
and   a.Esiid                                      = @p_AccountNumber
and  (b.ISO                                        = @w_ISO
or    b.ISO                                        = '*')
and   b.Action                                     = 'I'
and ((b.ProcessType                               in ('ENROLLMENT', 'CHANGE', 'DROP')
and   a.TransactionEffectiveDate               is not null)
or   (b.ProcessType                               in ('CANCEL', 'REJECT', 'REJECT DROP')
and   a.TransactionEffectiveDate                  is null))
and ((isnull(a.TransactionStatus, 'null')          = b.TransactionStatus
or    b.TransactionStatus                          = '*')
and  (isnull(a.StatusCode, 'null')                 = b.StatusCode
or    b.StatusCode                                 = '*')
and  (isnull(a.ChangeReason, 'null')               = b.ChangeReason                               
or    b.ChangeReason                               = '*')
and  (isnull(a.ChangeDescription, 'null')          = b.ChangeDescription                        
or    b.ChangeDescription                          = '*'))

delete a
from #EDIPending a 
inner join dbo.RECONEDI_Transaction b with (nolock)
on    b.Action                                     = 'D'
and   a.TransactionType                            = b.TransactionType
and   a.ProcessType                                = b.ProcessType
and ((isnull(a.TransactionStatus, 'null')          = b.TransactionStatus
or    b.TransactionStatus                          = '*')
and  (isnull(a.StatusCode, 'null')                 = b.StatusCode
or    b.StatusCode                                 = '*')
and  (isnull(a.ChangeReason, 'null')               = b.ChangeReason                               
or    b.ChangeReason                               = '*')
and  (isnull(a.ChangeDescription, 'null')          = b.ChangeDescription                        
or    b.ChangeDescription                          = '*'))
where (b.ISO                                       = @w_ISO
or     b.ISO                                       = '*')

create table #EDIPending_Work
(ID                                                int primary key clustered,
 esiid                                             varchar(50),
 UtilityCode                                       varchar(50),
 TransactionType                                   nvarchar(255),
 TransactionStatus                                 nvarchar(255),
 ChangeReason                                      nvarchar(255),
 ChangeDescription                                 nvarchar(255),
 StatusCode                                        nvarchar(255),
 TransactionDate                                   datetime,
 TransactionEffectiveDate                          datetime,
 ReferenceNbr                                      varchar(100),
 Origin                                            varchar(100),
 ProcessType                                       varchar(100),
 Type                                              varchar(01))

create table #EDIPending_New
(OrderID                                           int identity(1, 1),                 
 ID                                                int primary key clustered,
 esiid                                             varchar(50),
 UtilityCode                                       varchar(50),
 TransactionType                                   nvarchar(255),
 TransactionStatus                                 nvarchar(255),
 ChangeReason                                      nvarchar(255),
 ChangeDescription                                 nvarchar(255),
 StatusCode                                        nvarchar(255),
 TransactionDate                                   datetime,
 TransactionEffectiveDate                          datetime,
 ReferenceNbr                                      varchar(100),
 Origin                                            varchar(100),
 ProcessType                                       varchar(100),
 Type                                              varchar(01))

insert into #EDIPending_Work
select a.ID,
       a.esiid,
       a.UtilityCode,
       a.TransactionType,
       a.TransactionStatus,
       a.ChangeReason,
       a.ChangeDescription,
       a.StatusCode,
       a.TransactionDate,
       a.TransactionEffectiveDate,
       a.ReferenceNbr,
       a.Origin,
       a.ProcessType,
       'N'
from (select ID                                    = ROW_NUMBER() over (order by a.TransactionDate,
                                                                                 a.TransactionNbr,
                                                                                 a.ReferenceNbr),
             a.esiid,
             a.UtilityCode,
             a.TransactionType,
             a.TransactionStatus,
             a.ChangeReason,
             a.ChangeDescription,
             a.StatusCode,
             a.TransactionDate,
             a.TransactionEffectiveDate,
             a.ReferenceNbr,
             a.Origin,
             a.ProcessType
      from #EDIPending a) a
order by a.ID

declare @w_ID                                      int
declare @w_esiid                                   nvarchar(255)
declare @w_UtilityCode                             nvarchar(255)
declare @w_TransactionType                         nvarchar(255)
declare @w_TransactionStatus                       nvarchar(255)
declare @w_ChangeReason                            nvarchar(255)
declare @w_ChangeDescription                       nvarchar(255)
declare @w_StatusCode                              nvarchar(255)
declare @w_TransactionDate                         datetime
declare @w_TransactionEffectiveDate                datetime
declare @w_ReferenceNbr                            varchar(100)
declare @w_Origin                                  varchar(100)
declare @w_ProcessType                             varchar(100)
declare @w_Type                                    varchar(01)

declare @w_BillingGroup                            varchar(15)

declare @t_ID                                      int

declare @w_Try table
(ID                                                int)

if exists(select null
          from #EDIPending_Work
          group by TransactionDate
          having COUNT(*) > 1)
begin

   declare @w_OrderID                              int
   select @w_OrderID                               = 0
   
   select @t_ID                                    = 0

   select top 1
          @w_ID                                    = ID,
          @w_esiid                                 = esiid,
          @w_UtilityCode                           = UtilityCode,
          @w_TransactionType                       = TransactionType,
          @w_TransactionStatus                     = TransactionStatus,
          @w_ChangeReason                          = ChangeReason,
          @w_ChangeDescription                     = ChangeDescription,
          @w_StatusCode                            = StatusCode,
          @w_TransactionDate                       = TransactionDate,
          @w_TransactionEffectiveDate              = TransactionEffectiveDate,
          @w_ReferenceNbr                          = ReferenceNbr,
          @w_Origin                                = Origin,
          @w_ProcessType                           = ProcessType   
   from #EDIPending_Work
   where ID                                        > @t_ID
   
   while @@rowcount                               <> 0
   begin
      select @t_ID                                 = @w_ID

      insert into #EDIPending_New
      select *
      from #EDIPending_Work
      where ID                                     = @t_ID

      delete #EDIPending_Work
      where ID                                     = @t_ID
   
      if (exists(select null    
                 from #EDIPending_Work
                 where ID                          > @w_ID
                 and   TransactionDate             = @w_TransactionDate
                 and   ReferenceNbr                = @w_ReferenceNbr)
      or  exists(select null    
                 from #EDIPending_Work
                 where ID                          > @w_ID
                 and   ReferenceNbr                = @w_ReferenceNbr))
      and @w_ReferenceNbr                         is not null
      and LEN(ltrim(rtrim(@w_ReferenceNbr)))       > 0
      begin
         insert into #EDIPending_New
         select *
         from #EDIPending_Work
         where ID                                  > @t_ID
         and   ReferenceNbr                        = @w_ReferenceNbr

         update #EDIPending_New set Type = 'R'
         where ReferenceNbr                        = @w_ReferenceNbr
         
         delete #EDIPending_Work
         where ID                                  > @t_ID
         and   ReferenceNbr                        = @w_ReferenceNbr
      end

      select top 1
             @w_ID                                 = ID,
             @w_esiid                              = esiid,
             @w_UtilityCode                        = UtilityCode,
             @w_TransactionType                    = TransactionType,
             @w_TransactionStatus                  = TransactionStatus,
             @w_ChangeReason                       = ChangeReason,
             @w_ChangeDescription                  = ChangeDescription,
             @w_StatusCode                         = StatusCode,
             @w_TransactionDate                    = TransactionDate,
             @w_TransactionEffectiveDate           = TransactionEffectiveDate,
             @w_ReferenceNbr                       = ReferenceNbr,
             @w_Origin                             = Origin,
             @w_ProcessType                        = ProcessType   
      from #EDIPending_Work
      where ID                                     > @t_ID
   end
   
   delete #EDIPending_Work

   insert into #EDIPending_Work
   select OrderID,
          esiid,
          UtilityCode,
          TransactionType,
          TransactionStatus,
          ChangeReason,
          ChangeDescription,
          StatusCode,
          TransactionDate,
          TransactionEffectiveDate,
          ReferenceNbr,
          Origin,
          ProcessType,
          Type
   from #EDIPending_New
end

select @t_ID                                       = 0

select top 1
       @w_ID                                       = ID,
       @w_esiid                                    = esiid,
       @w_UtilityCode                              = UtilityCode,
       @w_TransactionType                          = TransactionType,
       @w_TransactionStatus                        = TransactionStatus,
       @w_ChangeReason                             = ChangeReason,
       @w_ChangeDescription                        = ChangeDescription,
       @w_StatusCode                               = StatusCode,
       @w_TransactionDate                          = TransactionDate,
       @w_TransactionEffectiveDate                 = TransactionEffectiveDate,
       @w_ReferenceNbr                             = ReferenceNbr,
       @w_Origin                                   = Origin,
       @w_ProcessType                              = ProcessType,
       @w_Type                                     = Type
from #EDIPending_Work
where ID                                           > @t_ID

while @@rowcount                                  <> 0
begin

   select @t_ID                                    = @w_ID
   
   if @w_BillingGroup                             is null
   begin
      select @w_BillingGroup                       = BillingGroup
      from Libertypower.dbo.Account a (nolock)
      inner join Libertypower.dbo.Utility b (nolock)
      on  a.UtilityID                              = b.ID
      where a.AccountNumber                        = @w_esiid
      and   b.UtilityCode                          = @w_UtilityCode
   end
   
   if @w_ProcessType                               = 'ENROLLMENT'
   begin
   
      if  not exists (select null
                      from #Result (nolock)
                      where LineRef                       = @w_LastActiveID
                      and ((TransactionEffectiveDateTo   is not null
                      and   (TransactionEffectiveDateTo   = @w_TransactionEffectiveDate
                      or     DATEDIFF(DD, TransactionEffectiveDateTo, @w_TransactionEffectiveDate) = 1))
                      or   (TransactionEffectiveDateTo   is null
                      and   TransactionEffectiveDateFrom  = @w_TransactionEffectiveDate)))
      begin
         delete #Result
         where LineRef                                    = @w_LastActiveID
         and   IDTo                                      is null

         select @w_ReadCycleDate                          = null
 
         select @w_ReadCycleDate                          = read_date
         from lp_common.dbo.meter_read_calendar with (nolock)
         where calendar_year                              = YEAR(@w_TransactionEffectiveDate)
         and   calendar_month                             = MONTH(@w_TransactionEffectiveDate)
         and   utility_id                                 = @w_UtilityCode
         and   read_cycle_id                              = case when len(ltrim(rtrim(read_cycle_id))) >
                                                                      len(ltrim(rtrim(@w_BillingGroup)))
                                                                 then REPLICATE('0', len(ltrim(rtrim(read_cycle_id)))
                                                                                   - len(ltrim(rtrim(@w_BillingGroup))))
                                                                                   + ltrim(rtrim(@w_BillingGroup))
                                                                 else @w_BillingGroup
                                                            end

         insert into #Result 
         select @w_esiid, @w_UtilityCode, @w_ID, @w_TransactionDate, @w_TransactionEffectiveDate, @w_ReadCycleDate, @w_Origin, @w_ReferenceNbr, null, null, null, null, null, null, null, null, null
         select @w_LastActiveID                    = @@IDENTITY
      end
      else
      begin
         update #Result set IDTo                         = null,
                             TransactionDateTo           = null,
                             TransactionEffectiveDateTo  = null,
                             ReadCycleDateTo             = null,
                             OriginTo                    = null,
                             ReferenceNbrTo              = null
         where LineRef                                   = @w_LastActiveID
      end

      insert into @w_Try
      select @w_ID
      
      select @w_LastEnrollmentDate                 = @w_TransactionEffectiveDate
      
   end
   
   if @w_ProcessType                               = 'CHANGE'
   begin
      select @w_ReadCycleDate                      = null
      
      select @w_ReadCycleDate                      = read_date
      from lp_common.dbo.meter_read_calendar with (nolock)
      where calendar_year                          = YEAR(@w_TransactionEffectiveDate)
      and   calendar_month                         = MONTH(@w_TransactionEffectiveDate)
      and   utility_id                             = @w_UtilityCode
      and   read_cycle_id                          = case when len(ltrim(rtrim(read_cycle_id))) >
                                                               len(ltrim(rtrim(@w_BillingGroup)))
                                                          then REPLICATE('0', len(ltrim(rtrim(read_cycle_id)))
                                                                            - len(ltrim(rtrim(@w_BillingGroup))))
                                                                            + ltrim(rtrim(@w_BillingGroup))
                                                          else @w_BillingGroup
                                                     end

      if @w_ChangeReason                           = 'DTM150'
      or @w_ChangeDescription                      = 'DTM150'
      begin
      
         update #Result set IDFrom                       = @w_ID,
                            TransactionDateFrom          = @w_TransactionDate,
                            TransactionEffectiveDateFrom = @w_TransactionEffectiveDate,
                            ReadCycleDateFrom            = @w_ReadCycleDate,
                            OriginFrom                   = @w_Origin,
                            ReferenceNbrFrom             = @w_ReferenceNbr
         where LineRef                                   = @w_LastActiveID
      end

      if @w_ChangeReason                           = 'DTM151'
      or @w_ChangeDescription                      = 'DTM151'
      begin
         if  not exists (select null
                         from #Result (nolock)
                         where LineRef                       = @w_LastActiveID
                         and   TransactionEffectiveDateTo   is null)
         begin
            update #Result set IDTo                         = @w_ID,
                               TransactionDateTo            = @w_TransactionDate,
                               TransactionEffectiveDateTo   = @w_TransactionEffectiveDate,
                               ReadCycleDateTo              = @w_ReadCycleDate,
                               OriginTo                     = @w_Origin,
                               ReferenceNbrTo               = @w_ReferenceNbr
            where LineRef                                   = @w_LastActiveID
         end
      end
   end

   if @w_ProcessType                               = 'DROP'
   begin
      if  exists (select null
                  from #Result (nolock)
                  where LineRef                        = @w_LastActiveID
                  and  (TransactionEffectiveDateTo    is null
                  and   TransactionEffectiveDateFrom   > @w_TransactionEffectiveDate))
      begin
         delete #Result          
         where LineRef                             = @w_LastActiveID
         
         select @w_LastActiveID                    = isnull(MAX(LineRef), 0)
         from #Result (nolock)                
         where LineRef                             < @w_LastActiveID

         select @w_Note                            = 'Canceled' 
         select @w_Status                          = 'Canceled' 
         select @w_Date                            = @w_TransactionDate
      end
      else
      begin
         if (exists (select null
                     from #Result (nolock)
                     where LineRef                        = @w_LastActiveID
                     and   TransactionEffectiveDateTo     > @w_TransactionEffectiveDate)
         and @w_StatusCode                                = 'B38')
         or (exists (select null
                     from #Result (nolock)
                     where LineRef                        = @w_LastActiveID
                     and  (TransactionEffectiveDateTo     < @w_TransactionEffectiveDate   
                     or    (TransactionEffectiveDateTo   is null
                     and    TransactionEffectiveDateFrom <= @w_TransactionEffectiveDate))))
         begin
            select @w_ReadCycleDate                = null
   
            select @w_ReadCycleDate                = read_date
            from lp_common.dbo.meter_read_calendar with (nolock)
            where calendar_year                    = YEAR(@w_TransactionEffectiveDate)
            and   calendar_month                   = MONTH(@w_TransactionEffectiveDate)
            and   utility_id                       = @w_UtilityCode
            and   read_cycle_id                    = case when len(ltrim(rtrim(read_cycle_id))) >
                                                               len(ltrim(rtrim(@w_BillingGroup)))
                                                          then REPLICATE('0', len(ltrim(rtrim(read_cycle_id)))
                                                                            - len(ltrim(rtrim(@w_BillingGroup))))
                                                                            + ltrim(rtrim(@w_BillingGroup))
                                                          else @w_BillingGroup
                                                     end
  
            update #Result set IDTo                       = @w_ID,
                               TransactionDateTo          = @w_TransactionDate,
                               TransactionEffectiveDateTo = @w_TransactionEffectiveDate,
                               ReadCycleDateTo            = @w_ReadCycleDate,
                               OriginTo                   = @w_Origin,
                               ReferenceNbrTo             = @w_ReferenceNbr
            where LineRef                                 = @w_LastActiveID
      
            delete #Result              
            where LineRef                          = @w_LastActiveID
            and   TransactionEffectiveDateFrom     = TransactionEffectiveDateTo
         end
      end
   end

   if @w_ProcessType                               = 'CANCEL'
   begin
      if  exists (select null
                  from #Result (nolock)
                  where LineRef                    = @w_LastActiveID
                  and  TransactionEffectiveDateTo is null
                  and  TransactionDateTo           = @w_TransactionDate)
      begin
         select @w_Note                            = 'Canceled'
         select @w_Status                          = 'Canceled'
         select @w_Date                            = @w_TransactionDate
         
         delete #Result             
         where LineRef                             = @w_LastActiveID

         select @w_LastActiveID                    = isnull(MAX(LineRef), 0)
         from #Result (nolock)                
         where LineRef                             < @w_LastActiveID

         insert into #Result 
         select @p_AccountNumber, @p_UtilityCode, null, null, null, null, null, null, null, null, null, null, null, null, @w_Note, @w_Status, @w_Date
      end

   end

   if @w_ProcessType                                = 'REJECT DROP'
   begin
      update #Result set IDTo                       = null,
                         TransactionDateTo          = null,
                         TransactionEffectiveDateTo = null,
                         ReadCycleDateTo            = null,
                         OriginTo                   = null,
                         ReferenceNbrTo             = null
      where LineRef                                 = @w_LastActiveID
      and   IDTo                                   is not null
      and   ReferenceNbrTo                          = @w_ReferenceNbr
   end

   if @w_ProcessType                               = 'REJECT'
   and not exists (select null
                   from #Result (nolock)
                   where Note                      = 'Rejected'
                   and   LineRef                  in (select MAX(LineRef)
                                                      from #Result (nolock)))
   and exists (select null
               from #Result (nolock)
               where LineRef                       = @w_LastActiveID
               and  TransactionEffectiveDateTo    is null
               and  TransactionDateTo              = @w_TransactionDate)
   begin
      select @w_Note                               = 'Rejected'
      select @w_Date                               = @w_TransactionDate
   end
   
   select top 1
          @w_ID                                    = ID,
          @w_esiid                                 = esiid,
          @w_UtilityCode                           = UtilityCode,
          @w_TransactionType                       = TransactionType,
          @w_TransactionStatus                     = TransactionStatus,
          @w_ChangeReason                          = ChangeReason,
          @w_ChangeDescription                     = ChangeDescription,
          @w_StatusCode                            = StatusCode,
          @w_TransactionDate                       = TransactionDate,
          @w_TransactionEffectiveDate              = TransactionEffectiveDate,
          @w_ReferenceNbr                          = ReferenceNbr,
          @w_Origin                                = Origin,
          @w_ProcessType                           = ProcessType,
          @w_Type                                  = Type
   from #EDIPending_Work
   where ID                                        > @t_ID
end
declare @w_MaxID                                   int
declare @w_CountID                                 int


select @w_MaxID                                    = case when isnull(MAX(IDTo), 0) > MAX(IDFrom)
                                                          then MAX(IDTo)
                                                          else MAX(IDFrom)
                                                     end
from #Result (nolock)

select @w_CountID                                  = isnull(COUNT(*), 0)
from @w_Try    
where ID                                           > @w_MaxID

if @w_CountID                                      > 0
begin
   Update #Result set Note = 'Number of enrollment attempts: ' 
                           + ltrim(rtrim(convert(char(10), @w_CountID)))
                           + ' - '
                           + 'Date of last attempt: '
                           + CONVERT(char(10), @w_LastEnrollmentDate, 101)
   where IDTo                                      = @w_MaxID
end                                       
if (select count(*) 
    from #Result (nolock))                             = 0
begin
   insert into #Result
   select @p_AccountNumber, @p_UtilityCode, null, null, null, null, null, null, null, null, null, null, null, null, @w_Note, @w_Status, @w_Date
end 

insert into dbo.RECONEDI_EDIResult
select @p_ReconID,
       a.*,
       @p_AsOfDate,
       @p_ProcessDate
from #Result a with (nolock)

set nocount off


GO
