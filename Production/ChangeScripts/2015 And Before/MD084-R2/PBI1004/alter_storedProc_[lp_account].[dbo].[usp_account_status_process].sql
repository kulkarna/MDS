USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_status_process]    Script Date: 01/25/2013 12:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Modified 8/21/2007
-- Gail Mangaroo
-- Commission Insert stored proc. Transaction created based on account status.

-- Modified 9/11/2007
-- Rick Deigsler
-- Changed logic for status change.
-- If curent status is Not Enrolled (999999), 
-- then flip status to Welcome Letter (03000 or 04000) sub_status 20.
-- ===================================================================

-- Modified 12/06/2007
-- Gail Mangaroo
-- Added source parameter to [usp_comm_trans_detail_ins_auto] call 
-- ===================================================================
-- Modified 12/2/2010
-- Gail Mangaroo 
-- Changed commission call to usp_transaction_request_enrollment_process
-- ===================================================================
-- Modified 12/20/2010
-- Thiago Nogueira
-- ticket 19352
-- Do not update account to enrolled status if the account is in the DealScreening process.
-- ===================================================================-- Modified 12/20/2010
-- Lucio 7/20/2011
-- ticket 21747
-- If someone clicks the "reenroll" button on an enrolled-cancelled account, its gets queued for enrollment.
-- ===================================================================
-- Modified  8/31/2011
-- By Al Tafur
-- Ticket 1-1950791
-- Added logic to allow status update to create utility file for account needs fix status.
-- ===================================================================
-- Modified  8/31/2011
-- By José Muñoz
-- Ticket SD21269
-- Added Comments to account status change
-- ===================================================================
-- Modified  1/25/2012
-- By Lev Rosenblum
-- PBI1004
-- Add routine to submit new reenrolled rate to ISTA
-- ===================================================================


ALTER procedure [dbo].[usp_account_status_process]
(@p_username                                        nchar(100),
 @p_process_id                                      varchar(50) = ' ',
 @p_account_id                                      varchar(12) = 'NONE',
 @p_account_number                                  varchar(30) = 'NONE',
 @p_param_01                                        varchar(20) = ' ' output,
 @p_param_02                                        varchar(20) = ' ' output,
 @p_param_03                                        varchar(20) = ' ' output,
 @p_param_04                                        varchar(20) = ' ' output,
 @p_param_05                                        varchar(20) = ' ' output, 
 @p_param_06                                        varchar(20) = ' ' output,
 @p_param_07                                        varchar(20) = ' ' output,
 @p_param_08                                        varchar(20) = ' ' output,
 @p_error                                           char(01) = ' ' output,
 @p_msg_id                                          char(08) = ' ' output,
 @p_descp                                           varchar(250) = ' ' output,
 @p_descp_add                                       varchar(100) = ' ' output,
 @p_result_ind                                      char(01) = 'Y')
as
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(100)
declare @w_application                              varchar(20)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
select @w_descp_add                                 = ' '
select @w_application                               = 'COMMON'

declare @w_getdate                                  datetime
declare @w_utility_id                               char(15)
declare @w_contract_nbr                             char(12)
declare @w_account_id                               char(12)
declare @w_contract_type                            varchar(35)
declare @w_account_type                             varchar(35)
declare @w_por_option                               varchar(03)
declare @w_order                                    int
declare @t_order                                    int
declare @w_check_type                               char(15)
declare @w_check_request_id                         char(25)
declare @w_approval_status                          char(15)
declare @w_approved_status                          char(15)
declare @w_approved_sub_status                      char(15)
declare @w_rejected_status                          char(15)
declare @w_rejected_sub_status                      char(15)
declare @w_status_code                              char(15)

declare @w_comments									varchar(max)


select @w_account_id                                = @p_account_id
select @w_getdate                                   = getdate()

if @w_account_id                                    = 'NONE'
begin
   select @w_account_id                             = account_id
   from account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx1)
   where account_number                             = @p_account_number
end

declare @w_status                                   varchar(15)
declare @w_sub_status                               varchar(15)       

select @w_status                                    = ' '
select @w_sub_status                                = ' '
--select @w_sub_status                                = '19000101'
 
if @p_process_id                                    = 'DEAL CAPTURE'
begin
   exec @w_return                                   = usp_account_status_deal_capture @p_username,
                                                                                      @p_param_01, --utility id
                                                                                      @p_param_02 output, --status
                                                                                      @p_param_03 output, --sub_status
                                                                                      @p_param_04 output -- credit check
   return @w_return
end

if @p_process_id                                    = 'DEENROLLMENT REQUEST'
begin

   select @w_status                                 = case when ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) <= '0500010'
                                                           or   ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) = '0600010'
                                                           then '999999' -- Modified 2007-11-29 by Douglas Marino to reflect the right status it was updating to 999998
                                                           when ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) = '1300060'
                                                           then '911000'
                                                           when ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) = '0500030' 
                                                              and date_flow_start >= getdate()
                                                           then '999998'
                                                           else '11000'
                                                      end,
          @w_sub_status                             = case when ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) <= '0500010'
                                                           or   ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) = '0600010'
                                                           or  (ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) = '0500030' 
                                                              and date_flow_start >= getdate())
                                                           then '10'
                                                           when ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) = '1300060'
                                                           then '10'
                                                           else '30'
                                                      end
   from account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx)
   where account_id                                 = @p_account_id

   goto goto_account

end
                                                     
if @p_process_id                                    = 'ENROLLMENT-REENROLLMENT'
begin

   select @p_param_06                               = '13000'
   select @p_param_07                               = '60'

   if  ltrim(rtrim(@p_param_03))
   +   ltrim(rtrim(@p_param_04))                    = '1100030'
   begin
      select @p_param_06                            = '905000'
      select @p_param_07                            = '10'

      if  @p_param_02                               = 'YES'
      begin
         select @p_param_06                         = '906000'
         select @p_param_07                         = '10'
      end
   end

   if  ltrim(rtrim(@p_param_03))
   +   ltrim(rtrim(@p_param_04))                    = '99999910'
   begin
      select @p_param_06                            = '03000'
      select @p_param_07                            = '20'

      if  @p_param_05                               = 'PAPER'
      begin
         select @p_param_06                         = '04000'
         select @p_param_07                         = '20'
      end
   end

   /*Ticket 21747*/
   if ltrim(rtrim(@p_param_03))                     = '999998'
      or
      ltrim(rtrim(@p_param_03))
   +  ltrim(rtrim(@p_param_04))                    = '0500025' -- 1-1950791
   begin
        select @p_param_06                          = '05000'
        select @p_param_07                          = '10'
   end
   
   if ltrim(rtrim(@p_param_03))
   +  ltrim(rtrim(@p_param_04))                     = ltrim(rtrim(@p_param_06))
                                                    + ltrim(rtrim(@p_param_07))
   begin
      goto goto_select
   end

   select @w_status                                 = @p_param_06
   select @w_sub_status                             = @p_param_07

   goto goto_account
end

if @p_process_id                                    = 'RETENTION LOST'
begin
   select @p_param_05                               = @p_param_03
   select @p_param_06                               = @p_param_04

   if ltrim(rtrim(@p_param_03))
   +  ltrim(rtrim(@p_param_04))                     < '1100030'
   begin
      select @p_param_05                            = '11000'
      select @p_param_06                            = '30'
   end

   if ltrim(rtrim(@p_param_03))
   +  ltrim(rtrim(@p_param_04))                     = ltrim(rtrim(@p_param_05))
                                                    + ltrim(rtrim(@p_param_06))
   begin
      goto goto_select
   end

   select @w_status                                 = @p_param_05
   select @w_sub_status                             = @p_param_06

   goto goto_account
end

if @p_process_id = 'RETENTION SAVE'
begin

   declare @currentstatus varchar(10)
   set @currentstatus = ltrim(rtrim(@p_param_03)) + ltrim(rtrim(@p_param_04))

   -- ticket 24172
   -- Logic simplified to reduce errors.  See Vault for old version.

   if @currentstatus in ('1100040','1100050','91100010')  -- If utility knows of drop request, schedule reenrollment.
   begin
	  select @p_param_05 = '13000'
	  select @p_param_06 = '60'
   end
   else if @currentstatus in ('1100010','1100020','1100030')  -- If utility does not know yet, act like nothing happened, put account back to enrolled.
   begin
      select @p_param_05 = '905000'
      select @p_param_06 = '10'
   end
   else  -- Other statuses should not be modified by this process.
   begin
	  goto goto_select
   end
   

   if @currentstatus = ltrim(rtrim(@p_param_05)) + ltrim(rtrim(@p_param_06))
   begin
      goto goto_select
   end

   select @w_status = @p_param_05, @w_sub_status = @p_param_06

   goto goto_account
end

if @p_process_id                                    = 'ENROLLMENT-FILE'
begin
   select @w_status                                 = '05000'
   select @w_sub_status                             = '20'

   goto goto_account

end

if @p_process_id                                    = 'ENROLLMENT-CONSOLIDATED-FILE'
begin
   select @w_status                                 = '06000'
   select @w_sub_status                             = '20'

   goto goto_account

end

if @p_process_id                                    = 'DEENROLLMENT-FILE'
begin

   select @w_status                                 = '11000'
   select @w_sub_status                             = '40'

   goto goto_account

end

if @p_process_id                                    = 'SET NUMBER'
begin

   select @w_status                                 = @p_param_01
   select @w_sub_status                             = @p_param_02

   goto goto_account
end

if @p_process_id                                    = 'TPV'
begin

   select @w_status                                 = '03000'
   select @w_sub_status                             = '20'

   goto goto_account
end

select @w_application                               = 'COMMON'
select @w_error                                     = 'E'
select @w_msg_id                                    = '00000051'
select @w_return                                    = 1
select @w_descp_add                                 = '(Process ID Not Exist)'
goto goto_select

goto_account:

--*****
begin tran account

set @w_comments										= @p_process_id + ' (Processed on ' + convert(varchar(10), @w_getdate , 101) + ').'   -- Added ticket SD21269


-- Update account status
exec @w_return = lp_account..usp_account_status_process_upd @p_username,
                                                            @p_process_id,
                                                            @w_account_id,
                                                            @w_status,
                                                            @w_sub_status,
                                                            @p_param_01,
                                                            @p_param_02,
                                                            @p_param_03,
                                                            @p_param_04,
                                                            @p_param_05,
                                                            @p_param_06,
                                                            @p_param_07,
                                                            @p_param_08,
                                                            @w_descp_add output,
															@w_comments

if @w_return                                        = 1
begin
   rollback tran account
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000051'
   goto goto_select
end


----   PBI 1004 implementation: resubmit new rate to ISTA for multi-term implementation Start here --------------------------

	IF (@w_status='13000' and @w_sub_status='80')
	BEGIN
		DECLARE @UserId int
		DECLARE @EffReenrollmentDate DateTime
		SELECT @UserId=UserID FROM LibertyPower.dbo.[User] WHERE UserName=@p_username;
		SET @EffReenrollmentDate=Convert(DateTime,Convert(char(10),DATEADD(d,1,GETDATE()),101))

		exec @w_return = LibertyPower.dbo.usp_AddReEnrolledAccountToMultiTermProcessingTable @AccountIdLegacy=@w_account_id, @ReenrollmentDate=@EffReenrollmentDate, @SubmitterUserId=@UserId;
		
		if @w_return = 1
		begin
		   rollback tran account
		   select @w_error                                  = 'E'
		   select @w_msg_id                                 = '00000051'
		   goto goto_select
		end
	END 

----   PBI 1004 implementation: resubmit new rate to ISTA for multi-term implementation End here   --------------------------


commit tran account
--*****




---- Call Comm Trans stored proc to determine what commission transaction needs to be created
---- ========================================================================================
execute lp_commissions.dbo.usp_transaction_request_enrollment_process
	 @p_account_id = @w_account_id                
	, @p_contract_nbr = null -- optional
	, @p_transaction_type_code = null -- optional 
	, @p_reason_code = ''
	, @p_source = @p_process_id
	, @p_username = @p_username



goto_select:

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application
   select @w_descp                                  = ltrim(rtrim(@w_descp))
                                                    + ' '
                                                    + @w_descp_add 
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

