/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    procedures:
        [dbo].[usp_account_deenrollment]

     Make LPCD7X64-036\MSSQL2008R2.Lp_Account Equal vm4lpcnocsqlint1\prod.lp_account

   AUTHOR:	[Insert Author Name]

   DATE:	2/27/2013 1:15:23 PM

   LEGAL:	2012[Insert Company Name]

   ------------------------------------------------------------ */

SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
GO
USE [Lp_Account]
GO

BEGIN TRAN
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Alter Procedure [dbo].[usp_account_deenrollment]
Print 'Alter Procedure [dbo].[usp_account_deenrollment]'
GO
-- ====================================================
-- Modified: Gail Mangaroo
-- 8/17/2007
-- Added column list to account_commission_request insert
-- Added call to usp_account_commission_request_ins stored proc 
-- ====================================================
-- Modified: Gail Mangaroo 
-- altered to use [usp_comm_trans_detail_ins] stored proc
-- ====================================================
-- Modified: Gail Mangaroo 11/18/2010
-- removed commission call 
-- ===================================================
-- Modified: Jose Munoz 12/12/2012
-- Check the update, the status udpate is not working
-- ===================================================
-- Modified: Isabelle Tamanini 2/12/2012  
-- Add Retentiton Log
-- SR1-56302261
-- =================================================== 

ALTER procedure [dbo].[usp_account_deenrollment]  
(@p_username                                        nchar(100),
 @p_account_id                                      char(12),
 @p_customer_id                                     char(10),
 @p_contract_nbr                                    char(12),
 @p_deenrollment_type                               varchar(20),
 @p_retention_process                               varchar(20),
 @p_reason_code                                     varchar(10),
 @p_comment                                         varchar(max),
 @p_deenrollment_days                               int = 0,
 @p_error                                           char(01) = ' ' output,
 @p_msg_id                                          char(08) = ' ' output,
 @p_descp                                           varchar(250) = ' ' output,
 @p_result_ind                                      char(01) = 'Y',
 @p_reason_code_sub_array							varchar(100) = ''
)
as
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(150)
declare @history_id									int
declare @sub_reason_code							varchar(10)
		,@ProcessDate								datetime
		,@user										varchar(100)
		,@ContractID								int
		
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
select @w_descp_add                                 = ' '
		,@ProcessDate								= Getdate()
		,@user										= suser_sname()
	
declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_contract_nbr                             char(12)
select @w_contract_nbr                              = @p_contract_nbr

if @p_deenrollment_type                             = 'ACCOUNT'
begin
   if not exists(select account_id
                 from account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx)
                 where account_id                   = @p_account_id
                 and  (ltrim(rtrim(status))  
                     + ltrim(rtrim(sub_status))    <= '0500030'  
                 or   (ltrim(rtrim(status))  
                     + ltrim(rtrim(sub_status))    >= '0600010'  
                 and   ltrim(rtrim(status))  
                     + ltrim(rtrim(sub_status))    <= '0600030')  
                 or    ltrim(rtrim(status))  
                     + ltrim(rtrim(sub_status))     = '1300060'  
                 or    status                       = '905000'
                 or    status                       = '906000'))
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00001015'
      select @w_return                              = 1
      goto goto_select
   end

   if exists (select call_request_id
              from lp_enrollment..call_header WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = call_header_idx1)
              where account_id                      = @p_account_id
              and  (call_status                     = 'O'
              or    call_status                     = 'A'))
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00001019'
      select @w_return                              = 1
      goto goto_select
   end
end

if @p_deenrollment_type                             = 'CONTRACT'
begin
   if not exists(select account_id
                 from account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx2)
                 where contract_nbr                 = @p_contract_nbr
                 and  (ltrim(rtrim(status))  
                     + ltrim(rtrim(sub_status))    <= '0500030'  
                 or   (ltrim(rtrim(status))  
                     + ltrim(rtrim(sub_status))    >= '0600010'  
                 and   ltrim(rtrim(status))  
                     + ltrim(rtrim(sub_status))    <= '0600030')  
                 or    ltrim(rtrim(status))  
                     + ltrim(rtrim(sub_status))     = '1300060'  
                 or    status                       = '905000'
                 or    status                       = '906000'))
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00001015'
      select @w_return                              = 1
      goto goto_select
   end

   if exists (select call_request_id
              from lp_enrollment..call_header WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = call_header_idx2)
              where contract_nbr                    = @p_contract_nbr
              and  (call_status                     = 'O'
              or    call_status                     = 'A'))
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00001020'
      select @w_return                              = 1
      goto goto_select
   end

end

if @p_deenrollment_type                            is null
or @p_deenrollment_type                             = ' '
or @p_deenrollment_type                             = 'NONE'
begin
   select @w_application                            = 'COMMON'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00001016'
   select @w_return                                 = 1
   goto goto_select
end

if @p_retention_process                            is null
or @p_retention_process                             = ' '
begin
   select @w_application                            = 'COMMON'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00001017'
   select @w_return                                 = 1
   goto goto_select
end

if @p_reason_code                                  is null
or @p_reason_code                                   = ' '
or @p_reason_code                                   = 'NONE'
begin
   select @w_application                            = 'COMMON'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00001018'
   select @w_return                                 = 1
   goto goto_select
end

if @p_comment                                      is null
or @p_comment                                       = ' '
begin
   select @w_application                            = 'COMMON'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00001011'
   select @w_return                                 = 1
   goto goto_select
end

--1-56302261
--Rafael Vasques #Ticket: 1-33402901 
--Begin
insert into lp_enrollment..deenrolled_submit_log (username, account_id, customer_id, contract_nbr, deenrollment_type, retention_process, reason_code, comment, deenrollment_days)
values (@p_username, @p_account_id, @p_customer_id, @p_contract_nbr, @p_deenrollment_type, @p_retention_process, @p_reason_code, @p_comment, @p_deenrollment_days)
--End


--check if there is a deal screening for the contract or account (SD16457)
declare @w_cancel_deal_screening bit
set @w_cancel_deal_screening = 0
if exists (select account_id 
		  from lp_enrollment..check_account
		  where contract_nbr = @p_contract_nbr
		    and approval_status = 'PENDING')
begin
  --Check if the entire contract is being deenrolled OR
  --If one account is being deenrolled, make sure there are no 
  --other active accounts on the contract.
  if @p_deenrollment_type = 'CONTRACT'
	 OR (
		0 = (select count(*) 
			from lp_account..account
			where contract_nbr = @p_contract_nbr
			  and account_id <> @p_account_id
			  and status not in ('911000','999998','999999'))
		)
  begin
	 set @w_cancel_deal_screening = 1
  end
end

declare @w_getdate                                  datetime
select @w_getdate                                   = getdate()

declare @w_getdate_str                              varchar(20)
select @w_getdate_str                               = convert(varchar(20), @w_getdate)

declare @w_call_request_id                          char(15)
declare @w_account_number                           varchar(30)
declare @w_contact_link                             int
declare @w_phone                                    varchar(20)

declare @w_request_id                               varchar(50)
select @w_request_id                                = 'CHARGEBACK-'
                                                    + ltrim(rtrim(@p_contract_nbr))
                                                    + '-'
                                                    + convert(char(08), getdate(), 112)
                                                    + '-'
                                                    + convert(char(10), getdate(), 108)
                                                    + ':' 
                                                    + convert(varchar(03), datepart(ms, getdate()))

if @p_deenrollment_type                             = 'ACCOUNT'
begin

--   update account set date_deenrollment = dateadd(dd, @p_deenrollment_days, @w_getdate)  
--   from account with (NOLOCK INDEX = account_idx)  
--   where account_id                                 = @p_account_id  

   insert into account_comments
   select @p_account_id,
          @w_getdate,
          'DEENROLLMENT REQUEST',
          @p_comment,
          @p_username,
          0

   insert into account_reason_code_hist
   select @p_account_id,
          @w_getdate,
          @p_reason_code,
          'DEENROLLMENT REQUEST',
          @p_username,
          0

		SET @history_id = @@IDENTITY

		--  sub array of reason codes  ----------------
		IF LEN(@p_reason_code_sub_array) > 0
			BEGIN
				DECLARE cur CURSOR FOR
					SELECT value FROM lp_account.dbo.ufn_split_delimited_string (@p_reason_code_sub_array, ',')
				OPEN cur
				FETCH NEXT FROM cur INTO @sub_reason_code
				WHILE (@@FETCH_STATUS <> -1) 
					BEGIN 
						INSERT INTO lp_account..account_reason_code_hist_additional  
							SELECT	@history_id, @sub_reason_code
						FETCH NEXT FROM cur INTO @sub_reason_code
					END
				CLOSE cur 
				DEALLOCATE cur
			END

   select @w_return                                 = 0

     

   exec @w_return = usp_account_status_process @p_username,
                                               'DEENROLLMENT REQUEST',
                                               @p_account_id,
                                               'NONE',
                                               @w_getdate_str,
                                               ' ',
                                               ' ',
                                               ' ',
                                               ' ',
                                               ' ',
                                               ' ',
                                               ' ',
                                               @w_error output,
                                               @w_msg_id output,
                                               @w_descp output,
                                               @w_descp_add,
                                               'N'

   if @w_return                                    <> 0
   begin
      goto goto_select
   end


end

if @p_deenrollment_type                             = 'CONTRACT'
begin
   declare @w_account_id                            char(12)
   declare @t_account_number                        varchar(30)

   select @t_account_number                         = ''

   create table #contract
  (account_id                                       char(12),
   account_number                                   varchar(30))

   insert into #contract
   select account_id,
          account_number
   from account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx2)
   where contract_nbr                               = @p_contract_nbr
   and   account_number                             > @t_account_number
   and  (ltrim(rtrim(status))  
       + ltrim(rtrim(sub_status))                  <= '0500030'  
   or   (ltrim(rtrim(status))  
       + ltrim(rtrim(sub_status))                  >= '0600010'  
   and   ltrim(rtrim(status))  
       + ltrim(rtrim(sub_status))                  <= '0600030')  
   or    ltrim(rtrim(status))  
       + ltrim(rtrim(sub_status))                   = '1300060'  
   or    status                                     = '905000'
   or    status                                     = '906000')
   order by account_id

   set rowcount 1

   select @w_account_id                             = account_id,
          @w_account_number                         = account_number
   from #contract
   where account_number                             > @t_account_number

   while @@rowcount                                <> 0
   begin

      set rowcount 0

      select @t_account_number                      = @w_account_number 

--      update account set date_deenrollment = dateadd(dd, @p_deenrollment_days, @w_getdate)  
--      from account with (NOLOCK INDEX = account_idx)  
--      where account_id               = @w_account_id  

      insert into account_comments
      select @w_account_id,
             @w_getdate,
             'DEENROLLMENT REQUEST',
             @p_comment,
             @p_username,
             0

      insert into account_reason_code_hist
      select @w_account_id,
             @w_getdate,
             @p_reason_code,
             'DEENROLLMENT REQUEST',
             @p_username,
             0

		SET @history_id = @@IDENTITY

		--  sub array of reason codes  ----------------
		IF LEN(@p_reason_code_sub_array) > 0
			BEGIN
				DECLARE cur CURSOR FOR
					SELECT value FROM lp_account.dbo.ufn_split_delimited_string (@p_reason_code_sub_array, ',')
				OPEN cur
				FETCH NEXT FROM cur INTO @sub_reason_code
				WHILE (@@FETCH_STATUS <> -1) 
					BEGIN 
						INSERT INTO lp_account..account_reason_code_hist_additional  
							SELECT	@history_id, @sub_reason_code
						FETCH NEXT FROM cur INTO @sub_reason_code
					END
				CLOSE cur 
				DEALLOCATE cur
			END

      select @w_return                              = 0

      exec @w_return = usp_account_status_process @p_username,
                                                  'DEENROLLMENT REQUEST',
                                                  @w_account_id,
                                                  'NONE',
                                                  @w_getdate_str,
                                                  ' ',
                                                  ' ',
                                                  ' ',
                                                  ' ',
                                                  ' ',
                                                  ' ',
        ' ',
                                                  @w_error output,
                                                  @w_msg_id output,
                                                  @w_descp output,
                                                  @w_descp_add,
                                                  'N'

      if @w_return                                 <> 0
      begin
         goto goto_select
      end

      set rowcount 1

      delete #contract
      where account_number                          = @t_account_number

      select @w_account_id                          = account_id,
             @w_account_number                      = account_number
      from #contract
      where account_number                          > @t_account_number

   end   

   set rowcount 0

end

if @p_retention_process                             = 'SEND'
begin

   select @w_contact_link                           = billing_contact_link
   from account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx)
   where account_id                                 = @p_account_id

   select @w_phone                                  = phone
   from account_contact WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_contact_idx)
   where account_id                                 = @p_account_id
   and   contact_link                               = @w_contact_link

   exec lp_common..usp_phone @w_phone output

   select @w_return                                 = 0

   exec @w_return = lp_enrollment..usp_retention_header_ins @p_username,
                                                            @w_phone,
                                                            @p_account_id,
                                                            @p_deenrollment_type,
                                                            0,
                                                            0,
                                                            'L',
                                                            @p_reason_code,
                                                            'NONE',
                                                            '19000101',
                                                            'ONLINE',
                                                            ' ',
                                                            ' ',
                                                            ' ',
                                                            'N'


   if @w_return                                    <> 0
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000087'
      select @w_descp_add                           = ' (Insert Retention)'
      select @w_return                              = 1
      goto goto_select
   end
end


goto_select:

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application

   select @w_descp                                  = ltrim(rtrim(@w_descp ))
                                                    + ''
                                                    + @w_descp_add
end
 
if (@w_msg_id = '00000001' AND @w_cancel_deal_screening = 1)
begin
	
	SELECT @ContractId		= ContractId
	FROM Libertypower..[Contract] WITH (NOLOCK)
	WHERE Number			= @p_contract_nbr
	
	IF NOT EXISTS (	SELECT NULL FROM Libertypower..Account WITH (NOLOCK)
					WHERE (CurrentContractID		= @ContractId
					OR CurrentRenewalContractID		= @ContractId)
					AND AccountIdLegacy				<>	@p_account_id)
	BEGIN
		UPDATE libertypower..WIPTask
		SET TaskStatusId			= 4
		,DateUpdated				= @ProcessDate
		,UpdatedBy					= @user
		FROM libertypower..WIPTask WT WITH (NOLOCK)
		INNER JOIN libertypower..WipTaskHeader WTH WITH (NOLOCK)
		ON WTH.WIPTaskHeaderId		= WT.WIPTaskHeaderId
		INNER JOIN libertypower..[Contract] C WITH (NOLOCK)
		ON C.ContractId				= WTH.ContractId
		WHERE C.ContractId			= @ContractId
		AND TaskStatusId			IN (2, 6, 7) 

		UPDATE libertypower..[Contract] 
		SET ContractStatusID		= 2
		WHERE ContractId			= @ContractId
		
		--SELECT TOP 3 * FROM libertypower..WIPTask WITH (NOLOCK)
		--SELECT TOP 3 * FROM libertypower..wiptaskheader WITH (NOLOCK)
		--SELECT TOP 3 * FROM libertypower..[Contract] C WITH (NOLOCK)
		/*	
		 update lp_enrollment..check_account
		 set approval_status		= 'REJECTED',
			 approval_comments		= 'Account was Deenrolled',
			 approval_status_date	= getdate(),
			 username				= @p_username
		 where contract_nbr			= @p_contract_nbr
		   and approval_status		= 'PENDING'	  
		*/	   
	END	
	
	--Record comments
	INSERT INTO lp_account..account_comments
	SELECT A.AccountIdLegacy AS account_id,
	  @ProcessDate, 
	  'DEENROLLMENT REQUEST',
	  @p_comment,  
	  @user,
	  0
	FROM LibertyPower..Account A WITH (NOLOCK)
	WHERE (CurrentContractID		= @ContractId
	 OR CurrentRenewalContractId	= @ContractId)
	AND AccountIdLegacy				= @p_account_id

	INSERT INTO lp_account..account_renewal_comments
	SELECT A.AccountIdLegacy AS account_id,
	  @ProcessDate,
	  'DEENROLLMENT REQUEST',
	  @p_comment, 
	  @user,
	  0
	FROM LibertyPower..Account A WITH (NOLOCK)
	WHERE CurrentRenewalContractId	= @ContractId
	and AccountIDLegacy				= @p_account_id

	INSERT INTO lp_account..account_status_history 
	SELECT A.AccountIDLegacy, AST.[Status], AST.SubStatus, @ProcessDate, @user, 
	'DEENROLLMENT REQUEST', '','','','','','','','',getdate()
	FROM LibertyPower..Account A WITH (NOLOCK)
	JOIN LibertyPower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID 
			   AND (A.CurrentContractID = AC.ContractID
			  OR A.CurrentRenewalContractId = AC.ContractId)
	JOIN LibertyPower..[Contract] C WITH (NOLOCK)  ON AC.ContractID = C.ContractID
	JOIN LibertyPower..AccountStatus AST  WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE C.ContractID = @ContractId
	AND A.AccountIdLegacy			= @p_account_id
	
end 
 
if @p_result_ind                                    = 'Y'
begin
   select flag_error                                = @w_error,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
end
 
select @p_error                                     = @w_error,
       @p_msg_id                                    = @w_msg_id,
       @p_descp                                     = @w_descp
 

   
goto_return:
return @w_return


GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

