USE [lp_LoadReconciliation_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_RECONEDI_EDI]    Script Date: 03/21/2014 14:27:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ufn_RECONEDI_EDI]
(@p_814_Key                                        int)
RETURNS 
@IstaAddress table
([814_Key]                                         int,
 EntityName                                        varchar(100),
 EntityName2                                       varchar(100),
 EntityName3                                       varchar(100),
 EntityDuns                                        varchar(100),
 Address1                                          varchar(100),
 Address2                                          varchar(100),
 City                                              varchar(100),
 State                                             varchar(100),
 PostalCode                                        varchar(100),
 CountryCode                                       varchar(100),
 ContactCode                                       varchar(100),
 ContactName                                       varchar(100),
 ContactPhoneNbr1                                  varchar(100),
 ContactPhoneNbr2                                  varchar(100)) 
as
begin

insert into @IstaAddress
select [814_Key],      
       EntityName                                 = Max(EntityName),
       EntityName2                                = Max(EntityName2),
       EntityName3                                = Max(EntityName3),
       EntityDuns                                 = Max(EntityDuns),
       Address1                                   = Max(Address1),
       Address2                                   = Max(Address2),
       City                                       = Max(City),
       State                                      = Max(State), 
       PostalCode                                 = Max(PostalCode),
       CountryCode                                = Max(CountryCode),
       ContactCode                                = Max(ContactCode),
       ContactName                                = Max(ContactName),
       ContactPhoneNbr1                           = Max(ContactPhoneNbr1),
       ContactPhoneNbr2                           = Max(ContactPhoneNbr2)
from ISTA_Market.dbo.tbl_814_Name
where [814_Key]                                   = @p_814_Key
group by [814_Key]
if @@ROWCOUNT                                     = 0
begin
   insert into @IstaAddress
   select @p_814_Key,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null      
end
return
end
GO
/*******************************************************************************************************************************/
USE [lp_LoadReconciliation_DW]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_RECONEDI_EDIResult]    Script Date: 03/21/2014 14:29:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--select * from ufn_RECONEDI_EDIResult('WPP', '14103033136101', '20130813')
create function [dbo].[ufn_RECONEDI_EDIResult]
(@p_UtilityCode                                    varchar(50),
 @p_AccountNumber                                  varchar(50),
 @p_ProcessDate                                    datetime)
RETURNS 
@Output table
(ReconID                                           int identity(1, 1),
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
AS
begin

declare @w_LastActiveID                            int
select @w_LastActiveID                             = 0

declare @w_ISO                                     varchar(50)

select @w_ISO                                      = WholeSaleMktID
from Libertypower..Utility (nolock)
where UtilityCode                                  = @p_UtilityCode

declare @w_Note                                    varchar(500)
declare @w_Status                                  varchar(08)
declare @w_Date                                    datetime

declare @w_LastEnrollmentDate                      datetime

declare @w_ReadCycleDate                           datetime

declare @EDIPending table
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


insert into @EDIPending
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
from dbo.RECONEDI_EDIPending_Work a with (nolock index = idx_RECONEDI_EDIPending_Work)
inner join dbo.RECONEDI_Transaction b with (nolock index = idx_RECONEDI_Transaction)
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
from @EDIPending a 
inner join dbo.RECONEDI_Transaction b with (nolock index = idx_RECONEDI_Transaction)
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

declare @EDIPending_Work table
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

declare @EDIPending_New table
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

insert into @EDIPending_Work
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
      from @EDIPending a) a
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
          from @EDIPending_Work
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
          @w_ProcessType                           = ProcessType   from @EDIPending_Work
   where ID                                        > @t_ID
   
   while @@rowcount                               <> 0
   begin
      select @t_ID                                 = @w_ID

      insert into @EDIPending_New
      select *
      from @EDIPending_Work
      where ID                                     = @t_ID

      delete @EDIPending_Work
      where ID                                     = @t_ID
   
      if (exists(select null    
                 from @EDIPending_Work
                 where ID                          > @w_ID
                 and   TransactionDate             = @w_TransactionDate
                 and   ReferenceNbr                = @w_ReferenceNbr)
      or  exists(select null    
                 from @EDIPending_Work
                 where ID                          > @w_ID
                 and   ReferenceNbr                = @w_ReferenceNbr))
      and @w_ReferenceNbr                         is not null
      and LEN(ltrim(rtrim(@w_ReferenceNbr)))       > 0
      begin
         insert into @EDIPending_New
         select *
         from @EDIPending_Work
         where ID                                  > @t_ID
         and   ReferenceNbr                        = @w_ReferenceNbr

         update @EDIPending_New set Type = 'R'
         where ReferenceNbr                        = @w_ReferenceNbr
         
         delete @EDIPending_Work
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
      from @EDIPending_Work
      where ID                                     > @t_ID
   end
   
   delete @EDIPending_Work

   insert into @EDIPending_Work
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
   from @EDIPending_New
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
from @EDIPending_Work
where ID                                           > @t_ID

while @@rowcount                                  <> 0
begin

   select @t_ID                                    = @w_ID
   
   if @w_BillingGroup                           is null
   begin
      select @w_BillingGroup                       = BillingGroup
      from SQLPROD.Libertypower.dbo.Account a (nolock)
      inner join SQLPROD.Libertypower.dbo.Utility b (nolock)
      on  a.UtilityID                              = b.ID
      where a.AccountNumber                        = @w_esiid
      and   b.UtilityCode                          = @w_UtilityCode
   end
   
   if @w_ProcessType                               = 'ENROLLMENT'
   begin
   
      if  not exists (select null
                      from @Output
                      where ReconID                       = @w_LastActiveID
                      and ((TransactionEffectiveDateTo   is not null
                      and   (TransactionEffectiveDateTo   = @w_TransactionEffectiveDate
                      or     DATEDIFF(DD, TransactionEffectiveDateTo, @w_TransactionEffectiveDate) = 1))
                      or   (TransactionEffectiveDateTo   is null
                      and   TransactionEffectiveDateFrom  = @w_TransactionEffectiveDate)))
      begin
         delete @Output
         where ReconID                                    = @w_LastActiveID
         and   IDTo                                      is null

         select @w_ReadCycleDate                          = null
 
         select @w_ReadCycleDate                          = read_date
         from sqlprod.lp_common.dbo.meter_read_calendar with (nolock)
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

         insert into @Output 
         select @w_esiid, @w_UtilityCode, @w_ID, @w_TransactionDate, @w_TransactionEffectiveDate, @w_ReadCycleDate, @w_Origin, @w_ReferenceNbr, null, null, null, null, null, null, null, null, null
         select @w_LastActiveID                    = @@IDENTITY
      end
      else
      begin
         update @Output set IDTo                         = null,
                            TransactionDateTo            = null,
                            TransactionEffectiveDateTo   = null,
                            ReadCycleDateTo              = null,
                            OriginTo                     = null,
                            ReferenceNbrTo               = null
         where ReconID                             = @w_LastActiveID
      end

      insert into @w_Try
      select @w_ID
      
      select @w_LastEnrollmentDate                 = @w_TransactionEffectiveDate
      
   end
   
   if @w_ProcessType                               = 'CHANGE'
   begin
      select @w_ReadCycleDate                      = null
      
      select @w_ReadCycleDate                      = read_date
      from sqlprod.lp_common.dbo.meter_read_calendar with (nolock)
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
      
         update @Output set IDFrom                       = @w_ID,
                                 TransactionDateFrom          = @w_TransactionDate,
                                 TransactionEffectiveDateFrom = @w_TransactionEffectiveDate,
                                 ReadCycleDateFrom            = @w_ReadCycleDate,
                                 OriginFrom                   = @w_Origin,
                                 ReferenceNbrFrom             = @w_ReferenceNbr
         where ReconID                             = @w_LastActiveID
      end

      if @w_ChangeReason                           = 'DTM151'
      or @w_ChangeDescription                      = 'DTM151'
      begin
         if  not exists (select null
                         from @Output
                         where ReconID                       = @w_LastActiveID
                         and   TransactionEffectiveDateTo   is null)
         begin
            update @Output set IDTo                         = @w_ID,
                                    TransactionDateTo            = @w_TransactionDate,
                                    TransactionEffectiveDateTo   = @w_TransactionEffectiveDate,
                                    ReadCycleDateTo              = @w_ReadCycleDate,
                                    OriginTo                     = @w_Origin,
                                    ReferenceNbrTo               = @w_ReferenceNbr
            where ReconID                          = @w_LastActiveID
         end
      end
   end

   if @w_ProcessType                               = 'DROP'
   begin
      if  exists (select null
                  from @Output
                  where ReconID                        = @w_LastActiveID
                  and  (TransactionEffectiveDateTo    is null
                  and   TransactionEffectiveDateFrom   > @w_TransactionEffectiveDate))
      begin
         delete @Output                
         where ReconID                             = @w_LastActiveID
         
         select @w_LastActiveID                    = isnull(MAX(ReconID), 0)
         from @Output                
         where ReconID                             < @w_LastActiveID

         select @w_Note                            = 'Canceled' 
         select @w_Status                          = 'Canceled' 
         select @w_Date                            = @w_TransactionDate
      end
      else
      begin
         if (exists (select null
                     from @Output
                     where ReconID                 = @w_LastActiveID
                     and   TransactionEffectiveDateTo  > @w_TransactionEffectiveDate)
         and @w_StatusCode                         = 'B38')
         or (exists (select null
                     from @Output
                     where ReconID                        = @w_LastActiveID
                     and  (TransactionEffectiveDateTo     < @w_TransactionEffectiveDate   
                     or    (TransactionEffectiveDateTo   is null
                     and    TransactionEffectiveDateFrom <= @w_TransactionEffectiveDate))))
         begin
            select @w_ReadCycleDate                = null
   
            select @w_ReadCycleDate                = read_date
            from sqlprod.lp_common.dbo.meter_read_calendar with (nolock)
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
  
            update @Output set IDTo                       = @w_ID,
                                    TransactionDateTo          = @w_TransactionDate,
                                    TransactionEffectiveDateTo = @w_TransactionEffectiveDate,
                                    ReadCycleDateTo            = @w_ReadCycleDate,
                                    OriginTo                   = @w_Origin,
                                    ReferenceNbrTo             = @w_ReferenceNbr
            where ReconID                          = @w_LastActiveID
      
            delete @Output                
            where ReconID                          = @w_LastActiveID
            and   TransactionEffectiveDateFrom     = TransactionEffectiveDateTo
         end
      end
   end

   if @w_ProcessType                               = 'CANCEL'
   begin
      if  exists (select null
                  from @Output
                  where ReconID                    = @w_LastActiveID
                  and  TransactionEffectiveDateTo is null
                  and  TransactionDateTo           = @w_TransactionDate)
      begin
         select @w_Note                            = 'Canceled'
         select @w_Status                          = 'Canceled'
         select @w_Date                            = @w_TransactionDate
         
         delete @Output                
         where ReconID                             = @w_LastActiveID

         select @w_LastActiveID                    = isnull(MAX(ReconID), 0)
         from @Output                
         where ReconID                             < @w_LastActiveID

         insert into @Output 
         select @p_AccountNumber, @p_UtilityCode, null, null, null, null, null, null, null, null, null, null, null, null, @w_Note, @w_Status, @w_Date
      end

   end

   if @w_ProcessType                               = 'REJECT DROP'
   begin
      update @Output set IDTo                       = null,
                         TransactionDateTo          = null,
                         TransactionEffectiveDateTo = null,
                         ReadCycleDateTo            = null,
                         OriginTo                   = null,
                         ReferenceNbrTo             = null
      where ReconID                                = @w_LastActiveID
      and   IDTo                                  is not null
      and   ReferenceNbrTo                         = @w_ReferenceNbr
   end

   if @w_ProcessType                               = 'REJECT'
   and not exists (select null
                   from @Output
                   where Note                      = 'Rejected'
                   and   ReconID                  in (select MAX(ReconID)
                                                      from @Output))
   and exists (select null
               from @Output
               where ReconID                       = @w_LastActiveID
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
   from @EDIPending_Work
   where ID                                        > @t_ID
end
declare @w_MaxID                                   int
declare @w_CountID                                 int


select @w_MaxID                                    = case when isnull(MAX(IDTo), 0) > MAX(IDFrom)
                                                          then MAX(IDTo)
                                                          else MAX(IDFrom)
                                                     end
from @Output

select @w_CountID                                  = isnull(COUNT(*), 0)
from @w_Try    
where ID                                           > @w_MaxID

if @w_CountID                                      > 0
begin
   Update @Output set Note = 'Number of enrollment attempts: ' 
                                + ltrim(rtrim(convert(char(10), @w_CountID)))
                                + ' - '
                                + 'Date of last attempt: '
                                + CONVERT(char(10), @w_LastEnrollmentDate, 101)
   where IDTo                                      = @w_MaxID
end                                       
if (select count(*) 
    from @Output)                             = 0
begin
   insert into @Output 
   select @p_AccountNumber, @p_UtilityCode, null, null, null, null, null, null, null, null, null, null, null, null, @w_Note, @w_Status, @w_Date
end 
return
end

GO

/*******************************************************************************************************************************/
USE [lp_LoadReconciliation_DW]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_RECONEDI_EDIResultSelect]    Script Date: 03/21/2014 14:30:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- select * from [dbo].[ufn_RECONEDI_EDIResultSelect] ('PEPCO-DC', '1646231058', '20130813', '20120710', '20140709')
-- select * from [dbo].[ufn_RECONEDI_EDIResultSelect_20130821] ('COMED', '7996314096', '20130813', '20130301', '20150228', '20130408')
CREATE function [dbo].[ufn_RECONEDI_EDIResultSelect]
(@p_UtilityCode                                    nvarchar(255),
 @p_AccountNumber                                  nvarchar(255),
 @p_ProcessDate                                    datetime)
RETURNS 
@Output table
(ID                                                int identity(1, 1),
 AccountNumber                                     varchar(30),
 Utility                                           varchar(50),
 AccountID                                         int,
 ContractID                                        int,
 ActualStartDate                                   datetime,
 ActualEndDate                                     datetime,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime,
 Status                                            char(01))
AS
begin

declare @EDIResult table
(ERID                                              int identity(1, 1) primary key clustered,
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

declare @t_ERID                                    int
select @t_ERID                                     = 0

declare @t_StartYear                               int
select @t_StartYear                                = 0

declare @t_EndYear                                 int
select @t_EndYear                                  = 0

declare @w_ERID                                    int
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

declare @w_MaxERID                                 int

select @w_MaxERID                                  = isnull(max(ERID), 0)
from dbo.RECONEDI_EDIResult with (nolock index = idx_RECONEDI_EDIResult)
where UtilityCode                                  = @p_UtilityCode
and   Esiid                                        = @p_AccountNumber

declare @w_MaxTransactionEffectiveDateTo           datetime

select @w_MaxTransactionEffectiveDateTo            = TransactionEffectiveDateTo
from dbo.RECONEDI_EDIResult with (nolock index = idx_RECONEDI_EDIResult)
where ERID                                         = @w_MaxERID
and   UtilityCode                                  = @p_UtilityCode
and   Esiid                                        = @p_AccountNumber

insert into @EDIResult
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
       EDIResultInd                                = case when a.ERID is null
                                                          then 0
                                                          else 1
                                                     end
from (select b.ERID,
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
      from dbo.RECONEDI_EnrollmentFixed a with (nolock index = idx4_RECONEDI_EnrollmentFixed)
      left join dbo.RECONEDI_EDIResult b with (nolock index = idx_RECONEDI_EDIResult)
      on  a.Utility                                = b.UtilityCode
      and a.AccountNumber                          = b.ESIID
      and ((b.TransactionEffectiveDateFrom        >= a.ContractRateStart
      and   b.TransactionEffectiveDateFrom        <= a.ContractRateEnd)
      or   (b.TransactionEffectiveDateTo          >= a.ContractRateStart
      and   b.TransactionEffectiveDateTo          <= a.ContractRateEnd))
      where a.Utility                              = @p_UtilityCode
      and   a.AccountNumber                        = @p_AccountNumber) a
order by a.UtilityCode,
         a.Esiid,
         a.TransactionEffectiveDateFrom,
         a.TransactionEffectiveDateTo

declare @w_ToDateTo                                datetime
declare @w_FromDateFrom                            datetime
declare @w_EffectiveDateFrom                       datetime

select top 1
       @w_ERID                                     = ERID,
       @w_Esiid                                    = Esiid,
       @w_UtilityCode                              = UtilityCode,
       @w_AccountID                                = AccountID,
       @w_ContractID                               = ContractID,
       @w_ContractRateStart                        = ContractRateStart,
       @w_ContractRateEnd                          = ContractRateEnd,
       @w_TransactionEffectiveDateFrom             = TransactionEffectiveDateFrom,
       @w_TransactionEffectiveDateTo               = TransactionEffectiveDateTo,
       @w_EDIResultInd                             = EDIResultInd
from @EDIResult
where ERID                                         > @t_ERID

select @w_Rowcount                                 = @@Rowcount

while @w_Rowcount                                 <> 0
begin

   select @t_ERID                                  = @w_ERID      

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

      insert into @Output
      select substring(@w_Esiid, 1, 30),
             substring(@w_UtilityCode, 1, 50),
             @w_AccountID,
             @w_ContractID,
             @w_TransactionEffectiveDateFrom,
             @w_ActualEndDate,
             @w_TransactionEffectiveDateFrom,
             @w_ActualEndDate,
             ''

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

         insert into @Output
         select substring(@w_Esiid, 1, 30),
                substring(@w_UtilityCode, 1, 50),
                @w_AccountID,
                @w_ContractID,
                @w_EffectiveDateFrom,
                @w_ActualEndDate,
                null,
                null,
                ''

         select @w_EffectiveDateFrom               = @w_ActualStartDate
         select @w_ActualEndDate                   = case when @w_EDIResultInd = 0
                                                          then @w_TransactionEffectiveDateTo
                                                          else @w_ContractRateEnd 
                                                     end
            
         select @t_StartYear                      = @t_StartYear + 1
      end
   end

   select top 1
          @w_ERID                                  = ERID,
          @w_Esiid                                 = Esiid,
          @w_UtilityCode                           = UtilityCode,
          @w_AccountID                             = AccountID,
          @w_ContractID                            = ContractID,
          @w_ContractRateStart                     = ContractRateStart,
          @w_ContractRateEnd                       = ContractRateEnd,
          @w_TransactionEffectiveDateFrom          = TransactionEffectiveDateFrom,
          @w_TransactionEffectiveDateTo            = TransactionEffectiveDateTo,
          @w_EDIResultInd                          = EDIResultInd
   from @EDIResult
   where ERID                                      > @t_ERID

   select @w_Rowcount                              = @@rowcount

end

if (select COUNT(*)
    from @Output)                                   = 0
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

   insert into @Output
   select substring(a.AccountNumber, 1, 30),
          substring(a.Utility, 1, 50),
          a.AccountID,
          a.ContractID,
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
          end,
          ''
   from RECONEDI_EnrollmentFixed a with (nolock index = idx4_RECONEDI_EnrollmentFixed)
   cross join Dates b
   where a.Utility                                 = @p_UtilityCode
   and   a.AccountNumber                           = @p_AccountNumber

end

return
end
GO

/*******************************************************************************************************************************/

USE [lp_LoadReconciliation_DW]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_RECONEDI_EDIRisk]    Script Date: 03/21/2014 14:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from ufn_RECONEDI_ISORisk('nyiso','coned', '20130531') WHERE transactioneffectivedate < '20070101'

CREATE function [dbo].[ufn_RECONEDI_EDIRisk]
(@p_ISO                                            varchar(50),
 @p_UtilityCode                                    varchar(50),
 @p_ProcessDate                                    datetime)
RETURNS 
@Edi table
([814_Key]                                         int identity(-100000, 1),
 ISO                                               varchar(50),
 Esiid                                             varchar(100),
 UtilityCode                                       varchar(50),
 TdspDuns                                          varchar(100),
 TdspName                                          varchar(100),
 TransactionType                                   varchar(100),
 TransactionStatus                                 varchar(100),
 Direction                                         bit ,
 ChangeReason                                      varchar(100),
 ChangeDescription                                 varchar(100),
 TransactionDate                                   datetime,
 TransactionEffectiveDate                          datetime,
 EsiIdStartDate                                    varchar(100),
 EsiIdEndDate                                      varchar(100),
 SpecialReadSwitchDate                             varchar(100),
 EntityName                                        varchar(100),
 MeterNumber                                       varchar(100),
 PreviousESiId                                     varchar(100),
 LDCBillingCycle                                   varchar(100),
 TransactionSetId                                  varchar(100),
 TransactionSetControlNbr                          varchar(100),
 TransactionSetPurposeCode                         varchar(100),
 TransactionNbr                                    varchar(100),
 ReferenceNbr                                      varchar(100),
 CrDuns                                            varchar(100),
 CrName                                            varchar(100),
 ProcessFlag                                       smallint ,
 ProcessDate                                       datetime,
 ServiceTypeCode1                                  varchar(100),
 ServiceType1                                      varchar(100),
 ServiceTypeCode2                                  varchar(100),
 ServiceType2                                      varchar(100),
 ServiceTypeCode3                                  varchar(100),
 ServiceType3                                      varchar(100),
 ServiceTypeCode4                                  varchar(100),
 ServiceType4                                      varchar(100),
 MaintenanceTypeCode                               varchar(100),
 RejectCode                                        varchar(100),
 RejectReason                                      varchar(100),
 StatusCode                                        varchar(100),
 StatusReason                                      varchar(100),
 StatusType                                        varchar(10),
 CapacityObligation                                varchar(100),
 TransmissionObligation                            varchar(100),
 LBMPZone                                          varchar(100),
 PowerRegion                                       varchar(100),
 stationid                                         varchar(100),
 AssignId                                          varchar(100))
begin
 
insert into @Edi
select distinct a.*
from (select ISO                                   = @p_ISO,
             Esiid                                 = ltrim(rtrim(Account_Number)),
             UtilityCode                           = utility_id,
             TdspDuns                              = null,
             TdspName                              = null,
             TransactionType                       = 'E',
             TransactionStatus                     = 'A',
             Direction                             = null,
             ChangeReason                          = null,
             ChangeDescription                     = null,                                                                  
             TransactionDate                       = convert(datetime, enroll_date, 101),
             TransactionEffectiveDate              = convert(datetime, enroll_date, 101),          
             EsiIdStartDate                        = null,
             EsiIdEndDate                          = null,
             SpecialReadSwitchDate                 = null,
             EntityName                            = null,
             MeterNumber                           = null,
             PreviousESiId                         = null,
             LDCBillingCycle                       = null,
             TransactionSetId                      = null,
             TransactionSetControlNbr              = null,
             TransactionSetPurposeCode             = null,
             TransactionNbr                        = null,
             ReferenceNbr                          = null,
             CrDuns                                = null,
             CrName                                = null,
             ProcessFlag                           = null,
             ProcessDate                           = null,
             ServiceTypeCode1                      = null,
             ServiceType1                          = null,
             ServiceTypeCode2                      = null,
             ServiceType2                          = null,
             ServiceTypeCode3                      = null,
             ServiceType3                          = null,
             ServiceTypeCode4                      = null,
             ServiceType4                          = null,
             MaintenanceTypeCode                   = null,
             RejectCode                            = null,
             RejectReason                          = null,
             StatusCode                            = null,
             StatusReason                          = null,
             StatusType                            = null,
             CapacityObligation                    = null,
             TransmissionObligation                = null,
             LBMPZone                              = null,
             PowerRegion                           = null,
             stationid                             = null,
             AssignId                              = null
      from lp_risk..risk_accounts_listing (nolock)
      where status                                 = 'open' 
      and   effective_date                        <= @p_ProcessDate
      union
      select ISO                                   = @p_ISO,
             Esiid                                 = ltrim(rtrim(Account_Number)),
             UtilityCode                           = utility_id,
             TdspDuns                              = null,
             TdspName                              = null,
             TransactionType                       = 'E',
             TransactionStatus                     = 'A',
             Direction                             = null,
             ChangeReason                          = null,
             ChangeDescription                     = null,                                                                  
             TransactionDate                       = convert(datetime, enroll_date, 101),
             TransactionEffectiveDate              = convert(datetime, enroll_date, 101),          
             EsiIdStartDate                        = null,
             EsiIdEndDate                          = null,
             SpecialReadSwitchDate                 = null,
             EntityName                            = null,
             MeterNumber                           = null,
             PreviousESiId                         = null,
             LDCBillingCycle                       = null,
             TransactionSetId                      = null,
             TransactionSetControlNbr              = null,
             TransactionSetPurposeCode             = null,
             TransactionNbr                        = null,
             ReferenceNbr                          = null,
             CrDuns                                = null,
             CrName                                = null,
             ProcessFlag                           = null,
             ProcessDate                           = null,
             ServiceTypeCode1                      = null,
             ServiceType1                          = null,
             ServiceTypeCode2                      = null,
             ServiceType2                          = null,
             ServiceTypeCode3                      = null,
             ServiceType3                          = null,
             ServiceTypeCode4                      = null,
             ServiceType4                          = null,
             MaintenanceTypeCode                   = null,
             RejectCode                            = null,
             RejectReason                          = null,
             StatusCode                            = null,
             StatusReason                          = null,
             StatusType                            = null,
             CapacityObligation                    = null,
             TransmissionObligation                = null,
             LBMPZone                              = null,
             PowerRegion                           = null,
             stationid                             = null,
             AssignId                              = null
      from lp_risk..risk_accounts_listing (nolock)
      where status                                 = 'removed' 
      and   enroll_date                           <= @p_ProcessDate
      and   effective_date                         > @p_ProcessDate) a
where not exists(select Null
                 from RECONEDI_EDIResult b
                 where b.Esiid                     = a.Esiid
                 and   b.UtilityCode               = @p_UtilityCode                 
                 and   b.TransactionEffectiveDateFrom <= @p_ProcessDate
                 and  (b.TransactionEffectiveDateTo    > @p_ProcessDate
                 or    b.TransactionEffectiveDateTo   is null
                 or    b.TransactionEffectiveDateTo    = '19000101'))      

delete a
from @Edi a
where exists(select null                        
             from libertypower..Account b (nolock)
             inner join libertypower..Utility c (nolock)
             on  b.UtilityID                       = c.ID
             inner join lp_account..account_number_history d (nolock)
             on  b.AccountIDLegacy                 = d.Account_ID
             where b.AccountNumber                 = a.Esiid
             and   c.UtilityCode                   = @p_UtilityCode
             and   exists(select Null
                          from RECONEDI_EDIResult e
                          where e.Esiid                         = d.old_account_number
                          and   e.UtilityCode                   = @p_UtilityCode                 
                          and   e.IDFrom                   is not null
                          and   e.TransactionEffectiveDateFrom <= @p_ProcessDate
                          and  (e.TransactionEffectiveDateTo    > @p_ProcessDate 
                          or    e.TransactionEffectiveDateTo   is null
                          or    e.TransactionEffectiveDateTo    = '19000101')))  
return
end

GO

/*******************************************************************************************************************************/

USE [lp_LoadReconciliation_DW]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_RECONEDI_NYISOOld]    Script Date: 03/21/2014 14:31:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[ufn_RECONEDI_NYISOOld]
()
RETURNS 
@Edi table
([814_Key]                                         int identity(1, 1),
 ISO                                               varchar(50),
 Esiid                                             varchar(100),
 UtilityCode                                       varchar(50),
 TdspDuns                                          varchar(100),
 TdspName                                          varchar(100),
 TransactionType                                   varchar(100),
 TransactionStatus                                 varchar(100),
 Direction                                         bit ,
 ChangeReason                                      varchar(100),
 ChangeDescription                                 varchar(100),
 TransactionDate                                   datetime,
 TransactionEffectiveDate                          datetime,
 EsiIdStartDate                                    varchar(100),
 EsiIdEndDate                                      varchar(100),
 SpecialReadSwitchDate                             varchar(100),
 EntityName                                        varchar(100),
 MeterNumber                                       varchar(100),
 PreviousESiId                                     varchar(100),
 LDCBillingCycle                                   varchar(100),
 TransactionSetId                                  varchar(100),
 TransactionSetControlNbr                          varchar(100),
 TransactionSetPurposeCode                         varchar(100),
 TransactionNbr                                    varchar(100),
 ReferenceNbr                                      varchar(100),
 CrDuns                                            varchar(100),
 CrName                                            varchar(100),
 ProcessFlag                                       smallint ,
 ProcessDate                                       datetime,
 ServiceTypeCode1                                  varchar(100),
 ServiceType1                                      varchar(100),
 ServiceTypeCode2                                  varchar(100),
 ServiceType2                                      varchar(100),
 ServiceTypeCode3                                  varchar(100),
 ServiceType3                                      varchar(100),
 ServiceTypeCode4                                  varchar(100),
 ServiceType4                                      varchar(100),
 MaintenanceTypeCode                               varchar(100),
 RejectCode                                        varchar(100),
 RejectReason                                      varchar(100),
 StatusCode                                        varchar(100),
 StatusReason                                      varchar(100),
 StatusType                                        varchar(10),
 CapacityObligation                                varchar(100),
 TransmissionObligation                            varchar(100),
 LBMPZone                                          varchar(100),
 PowerRegion                                       varchar(100),
 stationid                                         varchar(100),
 AssignId                                          varchar(100))
begin

insert into @Edi
select a.*
from (select ISO                                   = 'NYISO',
             Esiid                                 = ltrim(rtrim(UtilAcct)),
             UtilityCode                           = case when ltrim(rtrim(Utility)) = 'CONSOLIDATED EDISON OF NEW YORK(006982359)'
                                                          then 'CONED'
                                                          else 'NIMO'
                                                     end,
             TdspDuns                              = null,
             TdspName                              = null,
             TransactionType                       = case when ltrim(rtrim(TrnsType)) = '21'
                                                          and  ltrim(rtrim(TrnsPurp)) = '11'
                                                          and  ltrim(rtrim(Comments)) = 'ACCEPTANCE CONNECTION'
                                                          then 'E'
                                                          when ltrim(rtrim(TrnsType)) = '1'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then 'C'
                                                          when ltrim(rtrim(TrnsType)) = '24'
                                                          and  ltrim(rtrim(TrnsPurp)) = '11'
                                                          and  ltrim(rtrim(Comments)) = 'ACCEPTANCE CANCELATION'
                                                          then 'D'
                                                          when ltrim(rtrim(TrnsType)) = '24'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then 'D'
                                                          when ltrim(rtrim(TrnsType)) = '25'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then 'R'
                                                          else null
                                                     end,
             TransactionStatus                     = case when ltrim(rtrim(TrnsType)) = '21'
                                                          and  ltrim(rtrim(TrnsPurp)) = '11'
                                                          and  ltrim(rtrim(Comments)) = 'ACCEPTANCE CONNECTION'
                                                          then 'A'
                                                          when ltrim(rtrim(TrnsType)) = '1'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then '7'
                                                          when ltrim(rtrim(TrnsType)) = '24'
                                                          and  ltrim(rtrim(TrnsPurp)) = '11'
                                                          and  ltrim(rtrim(Comments)) = 'ACCEPTANCE CANCELATION'
                                                          then 'A'
                                                          when ltrim(rtrim(TrnsType)) = '24'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then '7'
                                                          when ltrim(rtrim(TrnsType)) = '25'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then 'A'
                                                          else null
                                                     end,
             Direction                             = null,
             ChangeReason                          = case when ltrim(rtrim(TrnsType)) = '1'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then ltrim(rtrim(Reason))
                                                          else null
                                                     end,
             ChangeDescription                     = null,                                                                  
             TransactionDate                       = convert(datetime, TransmissionDate, 101),
             TransactionEffectiveDate              = convert(datetime, TransEffDate, 101),          
             EsiIdStartDate                        = null,
             EsiIdEndDate                          = null,
             SpecialReadSwitchDate                 = null,
             EntityName                            = null,
             MeterNumber                           = null,
             PreviousESiId                         = null,
             LDCBillingCycle                       = null,
             TransactionSetId                      = null,
             TransactionSetControlNbr              = null,
             TransactionSetPurposeCode             = null,
             TransactionNbr                        = TrackingNumber,
             ReferenceNbr                          = null,
             CrDuns                                = null,
             CrName                                = null,
             ProcessFlag                           = null,
             ProcessDate                           = null,
             ServiceTypeCode1                      = null,
             ServiceType1                          = null,
             ServiceTypeCode2                      = null,
             ServiceType2                          = null,
             ServiceTypeCode3                      = null,
             ServiceType3                          = null,
             ServiceTypeCode4                      = null,
             ServiceType4                          = null,
             MaintenanceTypeCode                   = null,
             RejectCode                            = null,
             RejectReason                          = null,
             StatusCode                            = null,
             StatusReason                          = null,
             StatusType                            = null,
             CapacityObligation                    = null,
             TransmissionObligation                = null,
             LBMPZone                              = null,
             PowerRegion                           = null,
             stationid                             = null,
             AssignId                              = null
      from dbo.RECONEDI_NYISOOld (nolock)
      where isdate(TransmissionDate)               = 1
      and   isdate(TransEffDate)                   = 1)a
where TransactionType                         is not null
and   (a.ChangeReason                             is null 
or     a.ChangeReason                             in ('DTM150','DTM151'))

return
end

GO

/*******************************************************************************************************************************/

USE [lp_LoadReconciliation_DW]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_EdiReconAddress]    Script Date: 03/21/2014 14:36:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[ufn_EdiReconAddress]
(@p_814_Key                                        int)
RETURNS 
@IstaAddress table
([814_Key]                                         int,
 EntityName                                        varchar(100),
 EntityName2                                       varchar(100),
 EntityName3                                       varchar(100),
 EntityDuns                                        varchar(100),
 Address1                                          varchar(100),
 Address2                                          varchar(100),
 City                                              varchar(100),
 State                                             varchar(100),
 PostalCode                                        varchar(100),
 CountryCode                                       varchar(100),
 ContactCode                                       varchar(100),
 ContactName                                       varchar(100),
 ContactPhoneNbr1                                  varchar(100),
 ContactPhoneNbr2                                  varchar(100)) 
as
begin

insert into @IstaAddress
select [814_Key],      
       EntityName                                 = Max(EntityName),
       EntityName2                                = Max(EntityName2),
       EntityName3                                = Max(EntityName3),
       EntityDuns                                 = Max(EntityDuns),
       Address1                                   = Max(Address1),
       Address2                                   = Max(Address2),
       City                                       = Max(City),
       State                                      = Max(State), 
       PostalCode                                 = Max(PostalCode),
       CountryCode                                = Max(CountryCode),
       ContactCode                                = Max(ContactCode),
       ContactName                                = Max(ContactName),
       ContactPhoneNbr1                           = Max(ContactPhoneNbr1),
       ContactPhoneNbr2                           = Max(ContactPhoneNbr2)
from ISTA_Market.dbo.tbl_814_Name
where [814_Key]                                   = @p_814_Key
group by [814_Key]
if @@ROWCOUNT                                     = 0
begin
   insert into @IstaAddress
   select @p_814_Key,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null      
end
return
end

GO


/*******************************************************************************************************************************/
