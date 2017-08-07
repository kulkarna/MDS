





--exec usp_import_account_4
--truncate table dbo.call_detail
--truncate table dbo.call_header
--DELETE FROM lp_account..account_comments where process_id = 'RETENTION'
--update lp_account..account_get_key  set last_number = 0 where process_id = 'CALL REQUEST ID'


CREATE procedure [dbo].[usp_import_account_RETENTION]
as


declare @w_getdate                                  datetime
select @w_getdate                                   = getdate()

declare @w_username                                 nchar(100)
select @w_username                                  = 'libertypower\dmarino'

declare @w_phone                                    varchar(20)

declare	@w_CallPK                  int
declare	@w_ContactPhone                  nvarchar(50)
declare	@w_NoOfAccounts                  int
declare	@w_TotalAnnualUsage         float
declare	@w_RetDate                  datetime
declare	@w_RetParentStatusID                  nvarchar(2)
declare	@w_RetStatusID                  nvarchar(2)
declare	@w_AssignedTo                  nvarchar(50)
declare	@w_ResolvedDate                  datetime
declare	@w_AccountNumber    nvarchar(50)
declare	@w_UtilityID     nvarchar(50)
declare	@w_ReasonCode   int
declare	@w_CallStatus    nvarchar(50)
declare @w_call_request_id char(15)
declare @w_rowcount                  int
declare @w_account_id char(12)
declare @w_account_number varchar(30)
declare @w_contract_nbr char(12)
declare @w_reason_code char(03)


CREATE TABLE #call(
	[CallPK] [int] NOT NULL,
	[ContactPhone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoOfAccounts] [int] NULL,
	[TotalAnnualUsage] [float] NULL,
	[RetDate] [datetime] NULL,
	[RetParentStatusID] [nvarchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RetStatusID] [nvarchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssignedTo] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResolvedDate] [datetime] NULL,
	[OldCallPK] [int] NULL
)

insert into #call
select *
  FROM Enrollment_Access..tblRetentionSummary
--select count(*) FROM lp_enrollment..retention_header (NOLOCK)


set rowcount 1


select @w_CallPK = CallPK,
       @w_ContactPhone = ContactPhone,
       @w_NoOfAccounts = NoOfAccounts,
       @w_TotalAnnualUsage = TotalAnnualUsage,
       @w_RetDate = RetDate,
       @w_RetParentStatusID = RetParentStatusID,
       @w_RetStatusID = RetStatusID,
       @w_AssignedTo = AssignedTo,
       @w_ResolvedDate = ResolvedDate
  FROM #call



select @w_rowcount                          = @@rowcount

while @w_rowcount                                  <> 0
begin

   set rowcount 0

   select @w_call_request_id    = ' '

   exec lp_account..usp_get_key @w_username,
                                            'CALL REQUEST ID',
                                            @w_call_request_id output, 
                                            'N'
   
   select top 1
          @w_account_number                    = ltrim(rtrim(AccountNumber))
   from Enrollment_Access..tblRetentionAccounts
   where CallPK                                = @w_CallPK

   select @w_account_id                        = account_id,
          @w_contract_nbr                      = contract_nbr
   from lp_account..account with (NOLOCK INDEX = account_idx1)
   where account_number                        = @w_account_number

   select @w_reason_code                       = ReasonCode
   from Enrollment_Access..tblRetentionStatus
   where RetStatusID                           = @w_RetStatusID

   select @w_phone                             = substring(ltrim(rtrim(@w_ContactPhone)), 1, 20)

   exec lp_common..usp_phone @w_phone output

   insert into lp_enrollment..retention_header
   select @w_call_request_id
         ,@w_phone
         ,@w_account_id
         ,@w_contract_nbr
         ,@w_NoOfAccounts
         ,@w_TotalAnnualUsage
         ,substring(@w_RetParentStatusID, 1, 1)
         ,@w_reason_code
         ,case when @w_AssignedTo = 'Lynette'
               then 'libertypower\lcalabro'
               when @w_AssignedTo = 'Betty'
               then 'libertypower\bdorta'
               when @w_AssignedTo = 'Randy'
               then 'libertypower\rcoots'
               when @w_AssignedTo = 'Jeremiah'
               then 'libertypower\jcruz'
               when @w_AssignedTo = 'Other'
               then 'libertypower\Outsourced'
               else 'NONE'
          end
         ,isnull(@w_ResolvedDate, '19000101')
         ,'INIT LOAD'
         ,@w_username
         ,isnull(@w_RetDate, @w_getdate)
         ,0
 

   insert into lp_enrollment..retention_detail
   select @w_call_request_id
         ,@w_phone
         ,b.account_id
         ,b.contract_nbr
         ,b.utility_id
         ,0
         ,0
         ,'INIT LOAD'
         ,@w_username
         ,isnull(@w_RetDate, @w_getdate)
         ,0
   from Enrollment_Access..tblRetentionAccounts a,
        lp_account..account b
   where a.CallPK                               = @w_CallPK
   and   ltrim(rtrim(a.AccountNumber))          = ltrim(rtrim(b.account_number))
 
   insert into lp_enrollment..retention_comment
   select @w_call_request_id
         ,isnull(a.CallTime, getdate())
         ,substring(@w_RetParentStatusID, 1, 1)
         ,@w_reason_code
         ,Comments
         ,@w_username
         ,0         
   from Enrollment_Access..tblAttemptedCalls a
   where a.CallPK                           = @w_CallPK 
   and  (a.Comments                          is not null
   or    a.Comments                         <> ' ')

   if substring(@w_RetParentStatusID, 1, 1)   = 'L'
   or substring(@w_RetParentStatusID, 1, 1)   = 'S'
   begin
      insert into lp_account..account_comments
      select c.account_id,
             isnull(a.CallTime, getdate()),
             'RETENTION',
             Comments,
             @w_username,
             0
      from Enrollment_Access..tblAttemptedCalls a,
           Enrollment_Access..tblRetentionAccounts b,
           lp_account..account c 
      where a.CallPK                               = @w_CallPK 
      and  (a.Comments                          is not null
      or    a.Comments                         <> ' ')
      and   a.CallPK                               = b.CallPK 
      and   ltrim(rtrim(b.AccountNumber))          = ltrim(rtrim(c.account_number))
   end 

   set rowcount 1

   delete #call
   from #call
   WHERE CallPK = @w_CallPK

select @w_CallPK = CallPK,
       @w_ContactPhone = ContactPhone,
       @w_NoOfAccounts = NoOfAccounts,
       @w_TotalAnnualUsage = TotalAnnualUsage,
       @w_RetDate = RetDate,
       @w_RetParentStatusID = RetParentStatusID,
       @w_RetStatusID = RetStatusID,
       @w_AssignedTo = AssignedTo,
       @w_ResolvedDate = ResolvedDate
  FROM #call

   select @w_rowcount                          = @@rowcount

end








