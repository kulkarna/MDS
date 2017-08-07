USE [lp_account]

BEGIN TRAN 

GO

/****** Object:  StoredProcedure [dbo].[usp_account_status_process]    Script Date: 03/14/2013 21:56:56 ******/
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
-- Modified  1/10/2013
-- Isabelle Tamanini
-- SR1-43328360
-- If account is not flowing with LP, it should go to 999998-10
-- ===================================================================
-- Modified 1/25/2013
-- By Lev Rosenblum
-- PBI1004
-- Add routine to submit new reenrolled rate to ISTA
-- ===================================================================
-- ===================================================================
-- Modified  2/8/2013
-- Guy Gelin 
-- SR1-55261478
-- Update deEnrollment rules based on past or future flow/enrollment date
-- as a update to the last change made on 1/10/2013 1-43328360 
-- ===================================================================
-- Merged by Lev Rosenblum at 3/15/2013
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
declare @w_enrollmentAcceptDate						datetime
declare @w_DropAcceptDate							datetime
declare @w_comments									varchar(max)


select @w_account_id                                = @p_account_id
select @w_getdate                                   = getdate()


--begin 1-55261478
set @w_enrollmentAcceptDate=(select top 1 request_date as 'EnrollmentAcceptDate' from integration..EDI_814_transaction t with (nolock)
join integration..EDI_814_transaction_result tr with (nolock) on t.EDI_814_transaction_id=tr.EDI_814_transaction_id
join integration..lp_transaction l  with (nolock) on l.lp_transaction_id =tr.lp_transaction_id
where t.account_number=@p_account_number and l.lp_transaction_id=4)


set @w_dropAcceptDate=( select top 1 request_date as 'DropAcceptDate' from integration..EDI_814_transaction t with (nolock)
join integration..EDI_814_transaction_result tr  with (nolock) on t.EDI_814_transaction_id=tr.EDI_814_transaction_id
join integration..lp_transaction l  with (nolock) on l.lp_transaction_id =tr.lp_transaction_id
where t.account_number=@p_account_number and l.lp_transaction_id=8 )

if isnull(@w_dropAcceptDate,0)=0 
begin
	set @w_dropAcceptDate=getdate()
end
--end 1-55261478


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
                                                           or   RTRIM(status) = '01000'
                                                           then '999999' -- Modified 2007-11-29 by Douglas Marino to reflect the right status it was updating to 999998
                                                           when ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) = '1300060'
                                                           then '911000'
                                                           when ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) = '0500030' 
                                                              and @w_DropAcceptDate <= @w_enrollmentAcceptDate 
                                                           then '999998'
                                                           when ltrim(rtrim(status))	--1-55261478
                                                              + ltrim(rtrim(sub_status)) = '0500030' 
                                                              and @w_DropAcceptDate > @w_enrollmentAcceptDate
                                                           then '11000'
                                                           else '11000'
                                                      end,
          @w_sub_status                             = case when ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) <= '0500010'
                                                           or   ltrim(rtrim(status))
                                                              + ltrim(rtrim(sub_status)) = '0600010'
                                                           then '10'
                                                           when ltrim(rtrim(status))	--1-55261478
                                                              + ltrim(rtrim(sub_status)) = '0500030' 
                                                              and @w_DropAcceptDate > @w_enrollmentAcceptDate
                                                           then '10'                                                           
                                                           when ltrim(rtrim(status))	--1-55261478
                                                              + ltrim(rtrim(sub_status)) = '0500030' 
                                                              and @w_DropAcceptDate > @w_enrollmentAcceptDate
                                                           then '50'
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

---- PBI 1004 implementation: resubmit new rate to ISTA for multi-term implementation Start here --------------------------
IF (@w_status='13000' and @w_sub_status='80')
BEGIN
	DECLARE @UserId int, @IsMultiTerm bit;
	DECLARE @EffReenrollmentDate DateTime
	SELECT @UserId=UserID 
	FROM LibertyPower.dbo.[User] with (nolock) 
	WHERE UserName=@p_username;
	SET @EffReenrollmentDate=Convert(DateTime,Convert(char(10),DATEADD(d,1,GETDATE()),101))
	EXEC @IsMultiTerm=LibertyPower.dbo.usp_IsMultiTermProductBrandAssociatedWithCurrentAccount @AccountIdLegacy=@w_account_id, @CurrentDate=@EffReenrollmentDate
	IF (@IsMultiTerm=1)
	BEGIN
		EXEC @w_return = LibertyPower.dbo.usp_AddRecordForReEnrolledAccountToMultiTermProcessingTable @AccountIdLegacy=@w_account_id, @ReenrollmentDate=@EffReenrollmentDate, @SubmitterUserId=@UserId;
		IF @w_return = 1
		BEGIN
			rollback tran account
			select @w_error = 'E'
			select @w_msg_id = '00000051'
			goto goto_select
		END
	END
END
---- PBI 1004 implementation: resubmit new rate to ISTA for multi-term implementation End here --------------------------

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
GO

/****** Object:  StoredProcedure [dbo].[usp_account_renewal_ins]    Script Date: 01/22/2013 15:42:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/16/2007
-- Description:	Insert account renewal information
-- =============================================
-- =============================================
-- Modify		: Jose Munoz
-- Date			: 02/18/2010
-- Description	: Add SSNClear, SSNEncrypted and CreditScoreEncrypted columns to insert.
-- Ticket		: IT002
-- =============================================
-- =============================================
-- Modify		: Jaime Forero
-- Date			: 09/24/2011
-- Description	: Completely refactored to account for new schema changes. Project IT079
-- =============================================
-- Modify		: Jose Munoz
-- Date			: 03/01/2012
-- Ticket		: 1-9784943 (Add On Accounts for Renewal Contracts)
-- Description	: For new accounts in a renewal process, the value of the CurrentContractID must be NULL.
-- =============================================
-- Modified Gabor Kovacs 05/9/2012
-- Added a null to the insertion of account_contact, account_address, and account_name.
-- The null is required since those are no longer tables, but views which have an extra field.
-- =============================================
-- Modify : Thiago Nogueira
-- Date : 06/26/2012
-- Ticket : 1-18236238 (Add-on of Accounts to Renewal Contracts Failing)
-- Description : Per Al: System was designed to work that way.
-- =============================================
-- Modify : Rick Deigsler
-- Date : 10/18/2012
-- Description : MD084 - Ad multi-term rate inserts
-- =============================================
-- Modify : Sheri Scott
-- Date : 10/31/2012
-- Ticket : 1-26273501 (Renewal contract usage is not updating)
-- Description : Annual Usage should be set to NULL until it is received from the utility.
--               Modified to set Annual Usage to NULL.
-- =============================================
-- Modify : Agata Studzinska  
-- Date : 11/8/2012  
-- Ticket : 1-27221396 
-- Description : Send Enrollment Date for Add-on Accounts were being set incorrectly. 
-- =============================================
-- Modify : Lev Rosenblum  
-- Date : 1/22/2013  
-- PBI 3561 (task 4619) 
-- independent changed subrates implementation
-- =============================================

ALTER PROCEDURE [dbo].[usp_account_renewal_ins]
(@p_username                                        nchar(100),
 @p_account_id                                      char(12),
 @p_account_number                                  varchar(30),
 @p_account_type                                    varchar(25),
 @p_status                                          varchar(15),
 @p_sub_status                                      varchar(15),
 @p_customer_id                                     char(10),
 @p_entity_id                                       char(15),
 @p_contract_nbr                                    char(12),
 @p_contract_type                                   varchar(25),
 @p_retail_mkt_id                                   char(02),
 @p_utility_id                                      char(15),
 @p_product_id                                      char(20),
 @p_rate_id                                         int,
 @p_rate                                            float,
 @p_account_name_link                               int,
 @p_customer_name_link                              int,
 @p_customer_address_link                           int,
 @p_customer_contact_link                           int,
 @p_billing_address_link                            int,
 @p_billing_contact_link                            int,
 @p_owner_name_link                                 int,
 @p_service_address_link                            int,
 @p_business_type                                   varchar(35),
 @p_business_activity                               varchar(35),
 @p_additional_id_nbr_type                          varchar(10),
 @p_additional_id_nbr                               varchar(30),
 @p_contract_eff_start_date                         datetime,
 @p_term_months                                     int,
 @p_date_end                                        datetime,
 @p_date_deal                                       datetime,
 @p_date_created                                    datetime,
 @p_date_submit                                     datetime,
 @p_sales_channel_role                              nvarchar(50),
 @p_sales_rep                                       varchar(100),
 @p_origin                                          varchar(50),
 @p_annual_usage                                    int,
 @p_date_flow_start                                 datetime = '19000101',
 @p_date_por_enrollment                             datetime = '19000101',
 @p_date_deenrollment                               datetime = '19000101',
 @p_date_reenrollment                               datetime = '19000101',
 @p_tax_status                                      varchar(20) = 'FULL',
 @p_tax_float                                       int = 0,
 @p_credit_score                                    real = 0,
 @p_credit_agency                                   varchar(30) = 'NONE',
 @p_por_option                                      varchar(03) = ' ',
 @p_billing_type                                    varchar(15) = ' ',
 @p_error                                           char(01) = ' ' output,
 @p_msg_id                                          char(08) = ' ' output,
 @p_descp                                           varchar(250) = ' ' output,
 @p_result_ind                                      char(01) = 'Y'
 ,@p_SSNClear										nvarchar	(100) = ''	-- IT002
 ,@p_SSNEncrypted									nvarchar	(512) = ''	-- IT002
 ,@p_CreditScoreEncrypted							nvarchar	(512) = ''	-- IT002
 ,@p_evergreen_option_id							int = null					-- IT021
 ,@p_evergreen_commission_end						datetime = null				-- IT021
 ,@p_residual_option_id								int = null					-- IT021
 ,@p_residual_commission_end						datetime = null				-- IT021
 ,@p_initial_pymt_option_id							int = null					-- IT021
 ,@p_sales_manager									varchar(100) = null			-- IT021
 ,@p_evergreen_commission_rate						float = null				-- IT021
 ,@PriceID int = 0 -- IT106
 )
as
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
-----------------------Multi-Term implementation Start here (PBI3561 Task 4619)-----------------
DECLARE @RatesString								varchar(200)

SELECT @RatesString= RatesString
FROM	lp_contract_renewal..deal_contract_account WITH (NOLOCK)
WHERE account_number=@p_account_number
	AND contract_nbr	= @p_contract_nbr
-----------------------Multi-Term implementation End here   (PBI3561 Task 4619)----------------- 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
 
 
-- ====================================================================================================================================================

--					NEW				SCHEMA			CHANGES

-- ==================================================================================================================================================== 
-- ====================================================================================================================================================
-- HERE WE NEED TO CREATE THE acount_address and related inserts for the renewal to work ok, any renewal data will update the exiting values:
-- ====================================================================================================================================================
-- @p_account_name_link                               int,
-- @p_customer_name_link                              int,
-- @p_customer_address_link                           int,
-- @p_customer_contact_link                           int,
-- @p_billing_address_link                            int,
-- @p_billing_contact_link                            int,
-- @p_owner_name_link                                 int,
-- @p_service_address_link                            int,

-- ACCOUNT NAME:

IF NOT EXISTS ( SELECT	account_id
				FROM	lp_account..account_name WITH ( NOLOCK )
				WHERE	account_id	= @p_account_id 
				AND		name_link	= @p_account_name_link )
BEGIN
	INSERT INTO lp_account..account_name
	SELECT	null,account_id, name_link, full_name, 0
	FROM	lp_contract_renewal..deal_account_name with (nolock)
	WHERE	account_id	= @p_account_id 
	AND		name_link	= @p_account_name_link
	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record to the account_name table, cannot continue',11,1)
	END
END

-- CUSTOMER NAME:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_name WITH ( NOLOCK )
                WHERE	account_id	= @p_account_id 
                AND		name_link	= @p_customer_name_link )
BEGIN
	INSERT INTO lp_account..account_name
	SELECT	null,account_id, name_link, full_name, 0
	FROM	lp_contract_renewal..deal_account_name WITH (NOLOCK)
	WHERE	account_id	= @p_account_id 
	AND		name_link	= @p_customer_name_link

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record to the account_name table, cannot continue',11,1)
	END
END

-- OWNER NAME:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_name WITH ( NOLOCK )
                WHERE	account_id	= @p_account_id 
                AND		name_link	= @p_owner_name_link )
BEGIN
	INSERT INTO lp_account..account_name
	SELECT	null,account_id, name_link, full_name, 0
	FROM	lp_contract_renewal..deal_account_name WITH (NOLOCK)
	WHERE	account_id	= @p_account_id 
	AND		name_link	= @p_owner_name_link

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record to the account_name table, cannot continue',11,1)
	END
END

-- CUSTOMER ADDRESS

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_address WITH (NOLOCK)
                WHERE	account_id	 = @p_account_id 
                AND		address_link = @p_customer_address_link )
BEGIN
	INSERT INTO lp_account..account_address
	SELECT	null,account_id, address_link, [address], suite, city, [state], zip, county, state_fips, county_fips, 0
	FROM	lp_contract_renewal..deal_account_address WITH ( NOLOCK )
	WHERE	account_id		= @p_account_id 
	AND		address_link	= @p_customer_address_link

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record @p_customer_address_link to the account_address table, cannot continue',11,1)
	END
END

-- BILLING ADDRESS:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_address WITH (NOLOCK)
                WHERE	account_id	 = @p_account_id 
                AND		address_link = @p_billing_address_link )
BEGIN
	INSERT INTO lp_account..account_address
	SELECT	null,account_id, address_link, [address], suite, city, [state], zip, county, state_fips, county_fips, 0
	FROM	lp_contract_renewal..deal_account_address WITH ( NOLOCK )
	WHERE	account_id		= @p_account_id 
	AND		address_link	= @p_billing_address_link

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record @p_billing_address_link to the account_address table, cannot continue',11,1)
	END
END

-- SERVICE ADDRESS:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_address WITH (NOLOCK)
                WHERE	account_id	 = @p_account_id 
                AND		address_link = @p_service_address_link )
BEGIN
	INSERT INTO lp_account..account_address
	SELECT	null,account_id, address_link, [address], suite, city, [state], zip, county, state_fips, county_fips, 0
	FROM	lp_contract_renewal..deal_account_address WITH ( NOLOCK )
	WHERE	account_id		= @p_account_id 
	AND		address_link	= @p_service_address_link 

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record @p_service_address_link to the account_address table, cannot continue',11,1)
	END
END

-- CUSTOMER CONTACT:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_contact WITH (NOLOCK)
                WHERE	account_id		= @p_account_id 
                AND		contact_link	= @p_customer_contact_link )
BEGIN
	INSERT INTO lp_account..account_contact
	SELECT	null,account_id, contact_link, first_name, last_name, title, phone, fax, email, isnull(birthday , '01/01'), 0
	FROM	lp_contract_renewal..deal_account_contact WITH (NOLOCK)
	WHERE account_id	= @p_account_id  
	AND contact_link	= @p_customer_contact_link

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record @p_customer_contact_link to the account_contact table, cannot continue',11,1)
	END
END

-- BILLING CONTACT:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_contact WITH (NOLOCK)
                WHERE	account_id		= @p_account_id 
                AND		contact_link	= @p_billing_contact_link )
BEGIN
	INSERT INTO lp_account..account_contact
	SELECT	null,account_id, contact_link, first_name, last_name, title, phone, fax, email, isnull(birthday , '01/01'), 0
	FROM	lp_contract_renewal..deal_account_contact WITH (NOLOCK)
	WHERE account_id	= @p_account_id  
	AND contact_link	= @p_billing_contact_link 

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record @p_billing_contact_link to the account_contact table, cannot continue',11,1)
	END
END

 
-- ====================================================================================================================================================
-- Contract Table
-- ====================================================================================================================================================
DECLARE @C_WasNewContractCreated BIT;
DECLARE @C_RC int;
DECLARE @C_ContractID int;
DECLARE @C_Number varchar(50);
DECLARE @C_ContractTypeID int;
DECLARE @C_ContractDealTypeID int;
DECLARE @C_ContractStatusID int;
DECLARE @C_ContractTemplateID int;
DECLARE @C_ReceiptDate datetime;
DECLARE @C_StartDate datetime;
DECLARE @C_EndDate datetime;
DECLARE @C_SignedDate datetime;
DECLARE @C_SubmitDate datetime;
DECLARE @C_SubmittedBy int;
DECLARE @C_SalesChannelID int;
DECLARE @C_SalesRep varchar(64);
DECLARE @C_SalesManagerID int;
DECLARE @C_PricingTypeID int;
DECLARE @C_ModifiedBy int;
DECLARE @C_CreatedBy int;

SET @C_Number = LTRIM(RTRIM(@p_contract_nbr));
SET @C_ContractTypeID = Libertypower.dbo.ufn_GetContractTypeId(@p_contract_type);
SET @C_ContractDealTypeID = Libertypower.dbo.ufn_GetContractDealTypeId(@p_contract_type);
SELECT @C_ContractStatusID = CS.ContractStatusID FROM LibertyPower.dbo.ContractStatus CS (NOLOCK) WHERE LOWER(CS.Descp) = 'pending';
SET @C_ContractTemplateID = Libertypower.dbo.ufn_GetContractTemplateTypeId(@p_contract_type);
SET @C_ReceiptDate = NULL;
SET @C_StartDate = MIN(lp_enrollment.dbo.ufn_date_format( @p_contract_eff_start_date ,'<YYYY>-<MM>-01'));
SET @C_EndDate  = MIN(DATEADD(mm, @p_term_months, lp_enrollment.dbo.ufn_date_format(@p_contract_eff_start_date,'<YYYY>-<MM>-01')) - 1) ;
SET @C_SignedDate = @p_date_deal;
SET @C_SubmitDate = @p_date_submit;
SET @C_SalesChannelID = Libertypower.dbo.ufn_GetSalesChannel(@p_sales_channel_role);
SET @C_SalesRep = LTRIM(RTRIM(@p_sales_rep));
SET @C_SalesManagerID = Libertypower.dbo.ufn_GetUserId(@p_sales_manager, 1);
SET @C_PricingTypeID = NULL;
SET @C_ModifiedBy = Libertypower.dbo.ufn_GetUserId(@p_username, 0);
SET @C_CreatedBy = Libertypower.dbo.ufn_GetUserId(@p_username, 0);

SELECT @C_ContractID = C.ContractID FROM Libertypower.dbo.[Contract] C (NOLOCK) WHERE C.Number = @C_Number ;
IF @C_ContractID IS NULL 
BEGIN

	EXECUTE @C_RC = [Libertypower].[dbo].[usp_ContractInsert] 
	   @C_Number
	  ,@C_ContractTypeID
	  ,@C_ContractDealTypeID
	  ,@C_ContractStatusID
	  ,@C_ContractTemplateID
	  ,@C_ReceiptDate
	  ,@C_StartDate
	  ,@C_EndDate
	  ,@C_SignedDate
	  ,@C_SubmitDate
	  ,@C_SalesChannelID
	  ,@C_SalesRep
	  ,@C_SalesManagerID
	  ,@C_PricingTypeID
	  ,@C_ModifiedBy
	  ,@C_CreatedBy
	  ,1;
	  
	SELECT @C_ContractID = C.ContractID 
	FROM Libertypower.dbo.[Contract] C with (nolock) 
	WHERE C.Number = @C_Number ;
	SET @C_WasNewContractCreated = 1;
END
ELSE
BEGIN
		
	EXECUTE @C_RC = [Libertypower].[dbo].[usp_ContractUpdate] 
	   @C_ContractID
	  ,@C_Number
	  ,@C_ContractTypeID
	  ,@C_ContractDealTypeID
	  ,@C_ContractStatusID
	  ,@C_ContractTemplateID
	  ,@C_ReceiptDate
	  ,@C_StartDate
	  ,@C_EndDate
	  ,@C_SignedDate
	  ,@C_SubmitDate
	  ,@C_SalesChannelID
	  ,@C_SalesRep
	  ,@C_SalesManagerID
	  ,@C_PricingTypeID
	  ,@C_ModifiedBy
	  ,@C_CreatedBy 
	  ,1 -- Is silent
	  ,1 -- migration complete
	;
	  
	SET @C_WasNewContractCreated = 0;
END


-- ====================================================================================================================================================
-- Account Table
-- ====================================================================================================================================================

DECLARE @A_RC int
DECLARE @A_AccountID int;
DECLARE @A_AccountIdLegacy char(12)
DECLARE @A_AccountNumber varchar(30)
DECLARE @A_AccountTypeID int
DECLARE @A_CustomerID int
DECLARE @A_CustomerIdLegacy varchar(10)
DECLARE @A_EntityID char(15)
DECLARE @A_RetailMktID int
DECLARE @A_UtilityID int
DECLARE @A_AccountNameID int
DECLARE @A_BillingAddressID int
DECLARE @A_BillingContactID int
DECLARE @A_ServiceAddressID int
DECLARE @A_Origin varchar(50)
DECLARE @A_TaxStatusID int
DECLARE @A_PorOption bit
DECLARE @A_BillingTypeID int
DECLARE @A_Zone varchar(50)
DECLARE @A_ServiceRateClass varchar(50)
DECLARE @A_StratumVariable varchar(15)
DECLARE @A_BillingGroup varchar(15)
DECLARE @A_Icap varchar(15)
DECLARE @A_Tcap varchar(15)
DECLARE @A_LoadProfile varchar(50)
DECLARE @A_LossCode varchar(15)
DECLARE @A_MeterTypeID int
DECLARE @A_CurrentContractID int
DECLARE @A_CurrentRenewalContractID int
DECLARE @A_Modified datetime
DECLARE @A_ModifiedBy int
DECLARE @A_DateCreated datetime
DECLARE @A_CreatedBy int
DECLARE @A_MigrationComplete bit

SET @A_AccountIdLegacy = @p_account_id;
SET @A_AccountNumber = LTRIM(RTRIM(@p_account_number));
SET @A_CurrentRenewalContractID = @C_ContractID; -- We are inserting a new renewal so we need to set the new renewal record

-- Get existing data so we dont overwrite values
SELECT @A_AccountID = [AccountID]
      ,@A_AccountTypeID = [AccountTypeID]
      ,@A_CustomerID = [CustomerID]
      ,@A_CustomerIdLegacy = [CustomerIdLegacy]
      ,@A_EntityID = [EntityID]
      ,@A_RetailMktID = [RetailMktID]
      ,@A_UtilityID = [UtilityID]
      ,@A_AccountNameID = [AccountNameID]
      ,@A_BillingAddressID = [BillingAddressID]
      ,@A_BillingContactID = [BillingContactID]
      ,@A_ServiceAddressID = [ServiceAddressID]
      ,@A_Origin = [Origin]
      ,@A_TaxStatusID = [TaxStatusID]
      ,@A_PorOption = [PorOption]
      ,@A_BillingTypeID = [BillingTypeID]
      ,@A_Zone = [Zone]
      ,@A_ServiceRateClass = [ServiceRateClass]
      ,@A_StratumVariable = [StratumVariable]
      ,@A_BillingGroup = [BillingGroup]
      ,@A_Icap = [Icap]
      ,@A_Tcap = [Tcap]
      ,@A_LoadProfile = [LoadProfile]
      ,@A_LossCode = [LossCode]
      ,@A_MeterTypeID = [MeterTypeID]
      ,@A_ModifiedBy = [ModifiedBy]
      ,@A_CurrentContractID = [CurrentContractID]
      ,@A_CreatedBy = [CreatedBy]
FROM [Libertypower].[dbo].[Account] with (nolock)
WHERE  [AccountIdLegacy] = @A_AccountIdLegacy 

IF @A_AccountID IS NULL OR @A_AccountID = 0 OR @A_AccountID = -1
		RAISERROR('@A_AccountID IS NULL, cannot continue',11,1)

-- Keep the same whats on the account table and update only the address:

-- NEW MD084 the link is the actual ID now
SET @A_AccountNameID	= @p_account_name_link;
SET @A_BillingAddressID = @p_billing_address_link;
SET @A_BillingContactID = @p_billing_contact_link;
SET @A_ServiceAddressID = @p_service_address_link;
--SELECT @A_AccountNameID = AN.AccountNameID		 FROM lp_account.dbo.account_name AN (NOLOCK)WHERE AN.account_id = @p_account_id AND AN.name_link = @p_account_name_link;
--SELECT @A_BillingAddressID = AA.AccountAddressID FROM lp_account.dbo.account_address AA (NOLOCK) WHERE AA.account_id = @p_account_id AND AA.address_link = @p_billing_address_link;
--SELECT @A_BillingContactID = AC.AccountContactID FROM lp_account.dbo.account_contact AC (NOLOCK) WHERE AC.account_id = @p_account_id AND AC.contact_link = @p_billing_contact_link;
--SELECT @A_ServiceAddressID = AA.AccountAddressID FROM lp_account.dbo.account_address AA (NOLOCK) WHERE AA.account_id = @p_account_id AND AA.address_link = @p_service_address_link;

SELECT @A_AccountTypeID = AT.ID 
FROM LibertyPower.dbo.AccountType AT (NOLOCK) 
WHERE LOWER(AT.AccountType) = LOWER(LTRIM(RTRIM(@p_account_type)));

SET @A_MigrationComplete = 1;

/* TICKET 1-18236238 BEGIN */
/* TICKET 1-9784943 BEGIN */
--IF @A_CurrentContractID = @A_CurrentRenewalContractID
--BEGIN
-- SET @A_CurrentContractID = NULL
--END
/* TICKET 1-9784943 END*/
/* TICKET 1-18236238 END */


EXECUTE @A_RC = [Libertypower].[dbo].[usp_AccountUpdate]
   @A_AccountId
  ,@A_AccountIdLegacy
  ,@A_AccountNumber
  ,@A_AccountTypeID
  ,@A_CurrentContractID
  ,@A_CurrentRenewalContractID
  ,@A_CustomerID
  ,@A_CustomerIdLegacy
  ,@A_EntityID
  ,@A_RetailMktID
  ,@A_UtilityID
  ,@A_AccountNameID
  ,@A_BillingAddressID
  ,@A_BillingContactID
  ,@A_ServiceAddressID
  ,@A_Origin
  ,@A_TaxStatusID
  ,@A_PorOption
  ,@A_BillingTypeID
  ,@A_Zone
  ,@A_ServiceRateClass
  ,@A_StratumVariable
  ,@A_BillingGroup
  ,@A_Icap
  ,@A_Tcap
  ,@A_LoadProfile
  ,@A_LossCode
  ,@A_MeterTypeID
  ,@A_ModifiedBy
  ,NULL
  ,NULL
  ,NULL
  ,@A_MigrationComplete
  ,1;
  
SET @A_AccountID = @A_RC;


-- ====================================================================================================================================================
-- Account Detail Table
-- ====================================================================================================================================================
/* 
NO UPDATES NEEDED IN THIS TABLE WHEN RENEWAL


DECLARE @AD_RC int
DECLARE @AD_AccountID int
DECLARE @AD_EnrollmentTypeID INT;
DECLARE @AD_OriginalTaxDesignation INT;
DECLARE @AD_ModifiedBy int

SET @AD_AccountID = @A_AccountID;
SET @AD_OriginalTaxDesignation = NULL; --@p_original_tax_designation;
SET @AD_ModifiedBy = @A_ModifiedBy;
--SELECT @AD_EnrollmentTypeID = ET.EnrollmentTypeID FROM LibertyPower.dbo.EnrollmentType ET (NOLOCK) WHERE LOWER(ET.[Type]) =  LOWER(LTRIM(RTRIM(@p_enrollment_type)));


EXECUTE @AD_RC = [Libertypower].[dbo].[usp_AccountDetailInsert] 
   @AD_AccountID
  ,@AD_EnrollmentTypeID
  ,@AD_OriginalTaxDesignation
  ,@AD_ModifiedBy

*/

-- ====================================================================================================================================================
-- Account Usage Table
-- ====================================================================================================================================================
DECLARE @AU_RC int
DECLARE @AU_AccountUsageID int
DECLARE @AU_AccountID int
DECLARE @AU_AnnualUsage int
DECLARE @AU_UsageReqStatusID int
DECLARE @AU_EffectiveDate DATETIME;
DECLARE @AU_ModifiedBy int
DECLARE @AU_CreatedBy int

SET @AU_EffectiveDate = @C_StartDate;
SET @AU_AccountID = @A_AccountID;
SET @AU_AnnualUsage = @p_annual_usage;

SELECT @AU_UsageReqStatusID =  URS.UsageReqStatusID 
FROM Libertypower.dbo.UsageReqStatus URS with (nolock)
WHERE LOWER(URS.[Status]) = 'pending';
SET @AU_ModifiedBy = @C_ModifiedBy;

SELECT @AU_AccountUsageID = AU.AccountUsageID 
FROM LibertyPower.dbo.AccountUsage AU with (nolock)
WHERE AU.AccountID = @AU_AccountID AND AU.EffectiveDate = @AU_EffectiveDate;

IF @AU_AccountUsageID IS NULL
BEGIN 

	EXECUTE @AU_RC = [Libertypower].[dbo].[usp_AccountUsageInsert] 
	   @AU_AccountID
	  ,@AU_AnnualUsage
	  ,@AU_UsageReqStatusID
	  ,@AU_EffectiveDate
	  ,@AU_ModifiedBy 
	  ,@AU_CreatedBy
	  ,1;

	IF @AU_RC IS NULL OR @AU_RC = 0 OR @AU_RC = -1
		RAISERROR('@AU_RC IS NULL, cannot continue',11,1)
	SET @AU_AccountUsageID = @AU_RC ; 
END
ELSE
BEGIN

	EXECUTE @AU_RC = [Libertypower].[dbo].[usp_AccountUsageUpdate] 
	   @AU_AccountUsageID
	  ,@AU_AccountID
	  ,@AU_AnnualUsage
	  ,@AU_UsageReqStatusID
	  ,@AU_EffectiveDate
	  ,@AU_ModifiedBy
	  ,1


END


-- ====================================================================================================================================================
-- Customer Table
-- ====================================================================================================================================================
DECLARE @CUST_RC int
DECLARE @CUST_CustomerID int
DECLARE @CUST_NameID int
DECLARE @CUST_OwnerNameID int
DECLARE @CUST_AddressID int
DECLARE @CUST_ContactID int
DECLARE @CUST_ExternalNumber varchar(64)
DECLARE @CUST_DBA varchar(128)
DECLARE @CUST_Duns varchar(30)
DECLARE @CUST_SsnClear nvarchar(100)
DECLARE @CUST_SsnEncrypted nvarchar(512)
DECLARE @CUST_TaxId varchar(30)
DECLARE @CUST_EmployerId varchar(30)
DECLARE @CUST_CreditAgencyID int
DECLARE @CUST_CreditScoreEncrypted nvarchar(512)
DECLARE @CUST_BusinessTypeID int
DECLARE @CUST_BusinessActivityID int
DECLARE @CUST_ModifiedBy int
DECLARE @CUST_CreatedBy int

-- The customer MUST HAVE BEEN created already!
SET @CUST_CustomerID  = @A_CustomerID; 

IF @CUST_CustomerID IS NULL OR @CUST_CustomerID = 0 OR @CUST_CustomerID = -1
	RAISERROR('@CUST_CustomerID IS NULL, cannot continue',11,1)

-- GET THE CURRENT VALUES
SELECT 
       @CUST_NameID = [NameID]
      ,@CUST_OwnerNameID = [OwnerNameID]
      ,@CUST_AddressID = [AddressID]
      ,@CUST_ContactID = [ContactID]
      ,@CUST_DBA = [DBA]
      ,@CUST_Duns = [Duns]
      ,@CUST_SsnClear = [SsnClear]
      ,@CUST_SsnEncrypted = [SsnEncrypted]
      ,@CUST_TaxId = [TaxId]
      ,@CUST_EmployerId = [EmployerId]
      ,@CUST_CreditAgencyID = [CreditAgencyID]
      ,@CUST_CreditScoreEncrypted = [CreditScoreEncrypted]
      ,@CUST_BusinessTypeID = [BusinessTypeID]
      ,@CUST_BusinessActivityID = [BusinessActivityID]
      ,@CUST_ModifiedBy = [ModifiedBy]
      ,@CUST_CreatedBy = [CreatedBy]
FROM [Libertypower].[dbo].[Customer] (NOLOCK)
WHERE [CustomerID] = @CUST_CustomerID;

-- SET VALUES:
SELECT @CUST_NameID = AN.AccountNameID		 FROM lp_account.dbo.account_name AN (nolock)	 WHERE AN.account_id = @p_account_id AND AN.name_link    = @p_customer_name_link;
SELECT @CUST_OwnerNameID = AN.AccountNameID	 FROM lp_account.dbo.account_name AN (nolock)	 WHERE AN.account_id = @p_account_id AND AN.name_link    = @p_owner_name_link;
SELECT @CUST_AddressID = A.AccountAddressID	 FROM lp_account.dbo.account_address A (nolock)  WHERE A.account_id  = @p_account_id AND A.address_link  = @p_customer_address_link;
SELECT @CUST_ContactID = AC.AccountContactID FROM lp_account.dbo.account_contact AC (nolock) WHERE AC.account_id = @p_account_id AND AC.contact_link = @p_customer_contact_link;


IF @CUST_NameID IS NULL OR @CUST_NameID = 0 OR @CUST_NameID = -1
	RAISERROR('@@CUST_NameID IS NULL, cannot continue',11,1)

IF @CUST_OwnerNameID IS NULL OR @CUST_OwnerNameID = 0 OR @CUST_OwnerNameID = -1
	RAISERROR('@@CUST_OwnerNameID IS NULL, cannot continue',11,1)

IF @CUST_AddressID IS NULL OR @CUST_AddressID = 0 OR @CUST_AddressID = -1
	RAISERROR('@@CUST_AddressID IS NULL, cannot continue',11,1)

IF @CUST_ContactID IS NULL OR @CUST_ContactID = 0 OR @CUST_ContactID = -1
	RAISERROR('@@CUST_ContactID IS NULL, cannot continue',11,1)

-- SELECT @CUST_CreditAgencyID = CA.CreditAgencyID FROM LibertyPower.dbo.CreditAgency CA (nolock)  WHERE LOWER(CA.Name) = LOWER(LTRIM(RTRIM(@p_credit_agency)));
IF @p_business_type IS NOT NULL
	SELECT @CUST_BusinessTypeID = BT.BusinessTypeID FROM LibertyPower.dbo.BusinessType BT (nolock)  WHERE LOWER(BT.[Type]) = LOWER(LTRIM(RTRIM(@p_business_type)));

IF @p_business_activity IS NOT NULL
	SELECT @CUST_BusinessActivityID = BA.BusinessActivityID FROM LibertyPower.dbo.BusinessActivity BA (nolock)  WHERE LOWER(BA.Activity) = LOWER(LTRIM(RTRIM(@p_business_activity)));

-- Always the customer should already be there
-- This query might return more than one but all should be the same

EXECUTE @CUST_RC = [Libertypower].[dbo].[usp_CustomerUpdate] 
   @CUST_CustomerID
  ,@CUST_NameID
  ,@CUST_OwnerNameID
  ,@CUST_AddressID
  ,NULL -- CUSTOMER PREFERENCE
  ,@CUST_ContactID
  ,@CUST_ExternalNumber
  ,@CUST_DBA
  ,@CUST_Duns
  ,@CUST_SsnClear
  ,@CUST_SsnEncrypted
  ,@CUST_TaxId
  ,@CUST_EmployerId
  ,@CUST_CreditAgencyID
  ,@CUST_CreditScoreEncrypted
  ,@CUST_BusinessTypeID
  ,@CUST_BusinessActivityID
  ,@CUST_ModifiedBy
  ,1
-- ====================================================================================================================================================
-- Account Contract Table
-- ====================================================================================================================================================

DECLARE @AC_RC INT;
DECLARE @AC_AccountContractID INT;
DECLARE @AC_AccountID INT;
DECLARE @AC_ContractID INT;
DECLARE @AC_RequestedStartDate DATETIME;
DECLARE @AC_SendEnrollmentDate DATETIME;
DECLARE @AC_ModifiedBy INT;

SET @AC_AccountID = @A_AccountID;
SET @AC_ContractID = @C_ContractID;
SET @AC_RequestedStartDate = NULL; -- @p_requested_flow_start_date;
SET @AC_SendEnrollmentDate = @p_date_por_enrollment;
SET @AC_ModifiedBy = @C_ModifiedBy;

-- When we have add on accounts in renewal, the inserted account would take care of the AccountContract record so we need to check if that happened

SELECT @AC_AccountContractID =  AC.AccountContractID 
FROM [Libertypower].[dbo].[AccountContract] AC with (nolock)
WHERE  AC.AccountID = @AC_AccountID AND AC.ContractID = @AC_ContractID;

IF @AC_AccountContractID  IS NULL -- This is most likely will always NOT happen since the insertion usually happens in the account table first
BEGIN

	EXECUTE @AC_RC = [Libertypower].[dbo].[usp_AccountContractInsert] 
	   @AC_AccountID
	  ,@AC_ContractID
	  ,@AC_RequestedStartDate
	  ,@AC_SendEnrollmentDate
	  ,@AC_ModifiedBy
	  ,1
	  
	IF @AC_RC IS NULL OR @AC_RC = 0 OR @AC_RC = -1
		RAISERROR('@AC_RC IS NULL, cannot continue',11,1)

	SET @AC_AccountContractID = @AC_RC;
END
--Ticket 1-27221396
--ELSE
--BEGIN

--	EXECUTE @AC_RC = [Libertypower].[dbo].[usp_AccountContractUpdate] 
--	   @AC_AccountContractID
--	  ,@AC_AccountID
--	  ,@AC_ContractID
--	  ,@AC_RequestedStartDate
--	  ,@AC_SendEnrollmentDate
--	  ,@AC_ModifiedBy
--	  ,1 -- SILENT
	  
--	IF @AC_RC IS NULL OR @AC_RC = 0 OR @AC_RC = -1
--		RAISERROR('@AC_RC IS NULL, cannot continue',11,1)

--END


-- ====================================================================================================================================================
-- Account Status Table
-- ====================================================================================================================================================
DECLARE @AS_RC int
DECLARE @AS_AccountStatusID int
DECLARE @AS_AccountContractID int
DECLARE @AS_Status varchar(15)
DECLARE @AS_SubStatus varchar(15)
DECLARE @AS_ModifiedBy INT;
DECLARE @AS_CreatedBy INT;

SET @AS_AccountContractID = @AC_AccountContractID;
SET @AS_Status = @p_status;
SET @AS_SubStatus = @p_sub_status;
SET @AS_ModifiedBy = @C_ModifiedBy;
SET @AS_CreatedBy = @C_ModifiedBy;

-- See if there are records already for this status (most likely)
SELECT @AS_AccountStatusID = ASS.AccountStatusID 
FROM LibertyPower.dbo.AccountStatus ASS (NOLOCK)
WHERE ASS.AccountContractID = @AS_AccountContractID;

IF @AS_AccountStatusID IS NULL
BEGIN

	EXECUTE @AS_RC = [Libertypower].[dbo].[usp_AccountStatusInsert] 
	   @AS_AccountContractID
	  ,@AS_Status
	  ,@AS_SubStatus
	  ,@AS_CreatedBy
	  ,@AS_ModifiedBy 
	  ,1
	  
	IF @AS_RC IS NULL OR @AS_RC = 0 OR @AS_RC = -1
		RAISERROR('@AS_RC IS NULL, cannot continue',11,1)

	SET @AS_AccountStatusID = @AS_RC;
END
ELSE
BEGIN
	EXECUTE @AS_RC = [Libertypower].[dbo].[usp_AccountStatusUpdate] 
	 @AS_AccountStatusID
	,@AS_AccountContractID
	,@AS_Status
	,@AS_SubStatus
	,@AS_ModifiedBy
	,1


END
-- ====================================================================================================================================================
-- AccountContractRate Table
-- ====================================================================================================================================================
DECLARE @ACR_RC INT;
DECLARE @ACR_AccountContractRateID INT;
DECLARE @ACR_AccountContractID INT;
DECLARE @ACR_LegacyProductID CHAR(20);
DECLARE @ACR_Term INT;
DECLARE @ACR_RateID INT;
DECLARE @ACR_Rate decimal(9,5);
DECLARE @ACR_RateCode VARCHAR(50)
DECLARE @ACR_RateStart DATETIME;
DECLARE @ACR_RateEnd DATETIME;
DECLARE @ACR_IsContractedRate BIT;
DECLARE @ACR_HeatIndexSourceID INT;
DECLARE @ACR_HeatRate DECIMAL(9,2);
DECLARE @ACR_TransferRate FLOAT;
DECLARE @ACR_GrossMargin FLOAT;
DECLARE @ACR_CommissionRate FLOAT;
DECLARE @ACR_AdditionalGrossMargin FLOAT;
DECLARE @ACR_ModifiedBy INT;
DECLARE @ACR_CreatedBy INT;

SET @ACR_AccountContractID = @AC_AccountContractID;
SET @ACR_LegacyProductID = @p_product_id;
SET @ACR_Term = @p_term_months;
SET @ACR_RateID = @p_rate_id;
SET @ACR_Rate = CAST(@p_rate AS decimal(9,5));
SET @ACR_RateCode = '';
SET @ACR_RateStart = @p_contract_eff_start_date;
SET @ACR_RateEnd = @p_date_end;
SET @ACR_IsContractedRate = 1;
SET @ACR_HeatIndexSourceID = NULL; -- @p_HeatIndexSourceID;
SET @ACR_HeatRate = NULL; -- @p_HeatRate;
SET @ACR_TransferRate = NULL;
SET @ACR_GrossMargin = NULL;
SET @ACR_CommissionRate = NULL;
SET @ACR_AdditionalGrossMargin = NULL;
SET @ACR_ModifiedBy = @C_ModifiedBy;
SET @ACR_CreatedBy = @C_ModifiedBy;

-- ====================================================================================================================================================
-- Multi-term MD084  **********************************************************************************************************************************
-- Insert account contract rate record for each multi-term
-- ====================================================================================================================================================
DECLARE	@MultiTermTable TABLE (MultiTermID int, ProductCrossPriceID int, StartDate datetime, Term int, MarkupRate decimal(13,5), Price decimal(13,5))
DECLARE	@MultiTermID	int,
		@MultiTermCount	int,
		@MultiTermRate	decimal(9,5),
		@RateDiff		decimal(9,5)

INSERT INTO	@MultiTermTable
EXEC		Libertypower..usp_MultiTermByPriceIDSelect @PriceID

SELECT @MultiTermCount = COUNT(MultiTermID) 
FROM @MultiTermTable
-- ====================================================================================================================================================

-- Remove existing rate records
DELETE FROM LibertyPower.dbo.AccountContractRate
WHERE AccountContractID = @ACR_AccountContractID;

IF @MultiTermCount > 0 -- multi-rate
	BEGIN
-----------------------Multi-Term implementation Start here (PBI3561 Task 4619)-----------------
		DECLARE @StartIndx int
		DECLARE @EndIndx int
		SET @StartIndx=0
-----------------------Multi-Term implementation End here --(PBI3561 Task 4619)-----------------		
		DECLARE @MtCounter	int
		SET	@MtCounter	= 0
		SET	@RateDiff	= 1

		WHILE (SELECT COUNT(MultiTermID) FROM @MultiTermTable) > 0
			BEGIN
				SELECT TOP 1 @MultiTermID = MultiTermID 
				FROM @MultiTermTable ORDER BY StartDate
				
				SELECT	@ACR_RateStart		= StartDate,
						@ACR_RateEnd		= DATEADD(dd, -1, DATEADD(mm, Term, StartDate)),
						@MultiTermRate		= Price, 
						@ACR_Term			= Term,
						@ACR_GrossMargin	= MarkupRate
				FROM	@MultiTermTable
				WHERE	MultiTermID			= @MultiTermID
				
				
				IF (@RatesString is null)
				BEGIN
					IF @MtCounter = 0 -- first term rate can be adjusted by ABC channels
					BEGIN
						SET	@RateDiff = @ACR_Rate / @MultiTermRate
						SET	@MultiTermRate = @ACR_Rate
					END	
					ELSE
					BEGIN -- adjust additional multi-terms if first rate was changed
						SET	@MultiTermRate = @MultiTermRate * @RateDiff
					END
				END
				ELSE
				BEGIN
				-----------------------Multi-Term implementation Start here (PBI3561 Task 4619)-----------------
					SET @EndIndx=CHARINDEX(',', @RatesString, @StartIndx+1 )
					IF (@EndIndx>0)
					BEGIN
						SET	@MultiTermRate = CONVERT(decimal(9,5), SUBSTRING ( @RatesString , @StartIndx , @EndIndx -@StartIndx))
						SET @StartIndx=@EndIndx+1
					END
					ELSE
					BEGIN
						SET	@MultiTermRate = CONVERT(decimal(9,5), SUBSTRING ( @RatesString , @StartIndx, LEN(@RatesString) ))
					END 
					
				-----------------------Multi-Term implementation End here   (PBI3561 Task 4619)-----------------
				END
				
				EXECUTE @ACR_RC = [Libertypower].[dbo].[usp_AccountContractRateInsert] 
				   @ACR_AccountContractID
				  ,@ACR_LegacyProductID
				  ,@ACR_Term 
				  ,@ACR_RateID
				  ,@MultiTermRate
				  ,@ACR_RateCode
				  ,@ACR_RateStart
				  ,@ACR_RateEnd
				  ,@ACR_IsContractedRate
				  ,@ACR_HeatIndexSourceID
				  ,@ACR_HeatRate
				  ,@ACR_TransferRate
				  ,@ACR_GrossMargin
				  ,@ACR_CommissionRate
				  ,@ACR_AdditionalGrossMargin
				  ,@ACR_CreatedBy
				  ,@ACR_ModifiedBy
				  ,1
				  ,@PriceID
				  ,@MultiTermID;

				SET @ACR_AccountContractRateID = @ACR_RC;
				SET @MtCounter = @MtCounter + 1							
				DELETE FROM @MultiTermTable WHERE MultiTermID = @MultiTermID
			END					
	END
ELSE -- single rate
	BEGIN
		EXECUTE @ACR_RC = [Libertypower].[dbo].[usp_AccountContractRateInsert] 
		   @ACR_AccountContractID
		  ,@ACR_LegacyProductID
		  ,@ACR_Term 
		  ,@ACR_RateID
		  ,@ACR_Rate
		  ,@ACR_RateCode
		  ,@ACR_RateStart
		  ,@ACR_RateEnd
		  ,@ACR_IsContractedRate
		  ,@ACR_HeatIndexSourceID
		  ,@ACR_HeatRate
		  ,@ACR_TransferRate
		  ,@ACR_GrossMargin
		  ,@ACR_CommissionRate
		  ,@ACR_AdditionalGrossMargin
		  ,@ACR_CreatedBy
		  ,@ACR_ModifiedBy
		  ,1
		  ,@PriceID
		  ;
		
		IF @ACR_RC IS NULL OR @ACR_RC = 0 OR @ACR_RC = -1
			RAISERROR('@ACR_RC IS NULL, cannot continue',11,1)

		SET @ACR_AccountContractRateID = @ACR_RC;
	END

-- ====================================================================================================================================================
-- AccountContractCommission Table
-- ====================================================================================================================================================


DECLARE @ACC_RC int;
DECLARE @ACC_AccountContractCommissionID INT;
DECLARE @ACC_AccountContractID int
DECLARE @ACC_EvergreenOptionID int
DECLARE @ACC_EvergreenCommissionEnd datetime
DECLARE @ACC_EvergreenCommissionRate float
DECLARE @ACC_ResidualOptionID int
DECLARE @ACC_ResidualCommissionEnd datetime
DECLARE @ACC_InitialPymtOptionID int
DECLARE @ACC_ModifiedBy INT;
DECLARE @ACC_CreatedBy INT;

SET @ACC_AccountContractID = @AC_AccountContractID;
SET @ACC_EvergreenOptionID = @p_evergreen_option_id;
SET @ACC_EvergreenCommissionEnd = @p_evergreen_commission_end;
SET @ACC_EvergreenCommissionRate = @p_evergreen_commission_rate;
SET @ACC_ResidualOptionID = @p_residual_option_id;
SET @ACC_ResidualCommissionEnd = @p_residual_commission_end;
SET @ACC_InitialPymtOptionID = @p_initial_pymt_option_id;
SET @ACC_ModifiedBy = @C_ModifiedBy;
SET @ACC_CreatedBy  = @C_ModifiedBy;

-- See if there are records already for this status (most likely)
SELECT @ACC_AccountContractCommissionID = ACC.AccountContractCommissionID 
FROM LibertyPower.dbo.AccountContractCommission ACC with (nolock)
WHERE ACC.AccountContractID = @ACC_AccountContractID;

IF @ACC_AccountContractCommissionID IS NULL
BEGIN

	EXECUTE @ACC_RC = [Libertypower].[dbo].[usp_AccountContractCommissionInsert] 
	   @ACC_AccountContractID
	  ,@ACC_EvergreenOptionID
	  ,@ACC_EvergreenCommissionEnd
	  ,@ACC_EvergreenCommissionRate
	  ,@ACC_ResidualOptionID
	  ,@ACC_ResidualCommissionEnd
	  ,@ACC_InitialPymtOptionID
	  ,@ACC_ModifiedBy 
	  ,@ACC_CreatedBy
	  ,1;
	 
	IF @ACC_RC IS NULL OR @ACC_RC = 0 OR @ACC_RC = -1
		RAISERROR('@ACC_RC IS NULL, cannot continue',11,1)

	SET @ACC_AccountContractCommissionID = @ACC_RC;
END
ELSE
BEGIN

	EXECUTE @ACC_RC = [Libertypower].[dbo].[usp_AccountContractCommissionUpdate] 
	   @ACC_AccountContractCommissionID
	  ,@ACC_AccountContractID
	  ,@ACC_EvergreenOptionID
	  ,@ACC_EvergreenCommissionEnd
	  ,@ACC_EvergreenCommissionRate
	  ,@ACC_ResidualOptionID
	  ,@ACC_ResidualCommissionEnd
	  ,@ACC_InitialPymtOptionID
	  ,@ACC_ModifiedBy
	  ,1


END	 
	 
 
 
-- ====================================================================================================================================================
-- END OF NEW SCHEMA CHANGES
-- ====================================================================================================================================================

 
 
 
--insert into account_renewal
--([account_id] ,[account_number],[account_type] ,[status] ,[sub_status] ,[customer_id] ,[entity_id] 
--,[contract_nbr],[contract_type] ,[retail_mkt_id] ,[utility_id] ,[product_id] ,[rate_id] ,[rate] 
--,[account_name_link],[customer_name_link] ,[customer_address_link],[customer_contact_link],[billing_address_link] 
--,[billing_contact_link] ,[owner_name_link] ,[service_address_link] ,[business_type] ,[business_activity] ,[additional_id_nbr_type] 
--,[additional_id_nbr] ,[contract_eff_start_date] ,[term_months] ,[date_end] ,[date_deal],[date_created] ,[date_submit] ,[sales_channel_role] 
--,[username] ,[sales_rep] ,[origin] ,[annual_usage] ,[date_flow_start] ,[date_por_enrollment],[date_deenrollment],[date_reenrollment] 
--,[tax_status] ,[tax_rate] ,[credit_score] ,[credit_agency] ,[por_option] ,[billing_type],[chgstamp] ,[rate_code] 
--,SSNClear,SSNEncrypted,CreditScoreEncrypted
--,evergreen_option_id 
--,evergreen_commission_end ,residual_option_id ,residual_commission_end ,initial_pymt_option_id ,sales_manager ,evergreen_commission_rate )
--select @p_account_id,					      -- [account_id] 
--		@p_account_number,				      -- [account_number]
--		@p_account_type,				      -- [account_type] 
--		@p_status,							  -- [status] 
--		@p_sub_status,						  -- [sub_status] 
--		@p_customer_id,					      -- [customer_id] 
--		@p_entity_id,					      -- [entity_id] 
--		@p_contract_nbr,					-- [contract_nbr]
--		@p_contract_type,				      -- [contract_type] 
--		@p_retail_mkt_id,					 -- [retail_mkt_id] 
--		@p_utility_id,						-- [utility_id] 
--		@p_product_id,						-- [product_id] 
--		@p_rate_id,							-- [rate_id] 
--		@p_rate,							-- [rate] 
--		@p_account_name_link,			      -- [account_name_link]
--		@p_customer_name_link,			      -- [customer_name_link] 
--		@p_customer_address_link,		      -- [customer_address_link]
--		@p_customer_contact_link,		      -- [customer_contact_link]
--		@p_billing_address_link,		      -- [billing_address_link] 
--		@p_billing_contact_link,		      -- [billing_contact_link] 
--		@p_owner_name_link,					  -- [owner_name_link] 
--		@p_service_address_link,		      -- [service_address_link] 
--		@p_business_type,					  -- [business_type] 
--		@p_business_activity,			      -- [business_activity] 
--		@p_additional_id_nbr_type,		      -- [additional_id_nbr_type] 
--		@p_additional_id_nbr,			      -- [additional_id_nbr] 
--		@p_contract_eff_start_date,		      -- [contract_eff_start_date] 
--		@p_term_months,						    -- [term_months] 
--		@p_date_end,						    -- [date_end] 
--		@p_date_deal,						   -- [date_deal]
--		@p_date_created,					   -- [date_created] 
--		@p_date_submit,						   -- [date_submit] 
--		ltrim(rtrim(@p_sales_channel_role)),	      -- [sales_channel_role] 
--		@p_username,							  -- [username] 
--		@p_sales_rep,							-- [sales_rep] 
--		@p_origin,								-- [origin] 
--		null, --@p_annual_usage						-- [annual_usage] 
--		@p_date_flow_start,						-- [date_flow_start] 
--		@p_date_por_enrollment,			      -- [date_por_enrollment]
--		@p_date_deenrollment,			      -- [date_deenrollment]
--		@p_date_reenrollment,			      -- [date_reenrollment] 
--		@p_tax_status,				      -- [tax_status] 
--		@p_tax_float,				      -- [tax_rate] 
--		@p_credit_score,			      -- [credit_score] 
--		@p_credit_agency,			      -- [credit_agency] 
--		@p_por_option,				      -- [por_option] 
--		@p_billing_type,			      -- [billing_type]
--		0,								-- [chgstamp] 
--		''							-- [rate_code] 
--		,@p_SSNClear, 
--		@p_SSNEncrypted, 
--		@p_CreditScoreEncrypted
--		,@p_evergreen_option_id			-- evergreen_option_id 
--		,@p_evergreen_commission_end		-- evergreen_commission_end 
--		,@p_residual_option_id			-- residual_option_id 
--		,@p_residual_commission_end		-- residual_commission_end 
--		,@p_initial_pymt_option_id		-- initial_pymt_option_id 
--		,@p_sales_manager				-- sales_manager 
--		,@p_evergreen_commission_rate	-- evergreen_commission_rate 		
		
/*		
select @p_account_id, @p_account_number, @p_account_type, @p_status, @p_sub_status, @p_customer_id,
       @p_entity_id, @p_contract_nbr, @p_contract_type, @p_retail_mkt_id, @p_utility_id, @p_product_id,

       @p_rate_id, @p_rate, @p_account_name_link, @p_customer_name_link, @p_customer_address_link,
       @p_customer_contact_link, @p_billing_address_link, @p_billing_contact_link, @p_owner_name_link,
       @p_service_address_link, @p_business_type, @p_business_activity, @p_additional_id_nbr_type,
       @p_additional_id_nbr, @p_contract_eff_start_date, @p_term_months, @p_date_end, @p_date_deal,
       @p_date_created, @p_date_submit, ltrim(rtrim(@p_sales_channel_role)), @p_username, @p_sales_rep,
       @p_origin, null --@p_annual_usage
       , @p_date_flow_start, @p_date_por_enrollment, @p_date_deenrollment,
       @p_date_reenrollment, @p_tax_status, @p_tax_float, @p_credit_score, @p_credit_agency,
       @p_por_option, @p_billing_type, 0, '', @p_SSNClear, @p_SSNEncrypted, @p_CreditScoreEncrypted -- IT002
*/		
 
if @@error                                         <> 0
or @@rowcount                                       = 0
begin
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000002'
   select @w_return                                 = 1
end
 
if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output
end
 
if @p_result_ind                                    = 'Y'
begin
   select flag_error                                = @w_error,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
end


--mark the custom rate as used (rate_submit_ind = 1)
UPDATE lp_deal_capture..deal_pricing_detail 
set rate_submit_ind = 1, date_modified = getdate(), modified_by = @p_username
WHERE product_id = @p_product_id and rate_id = @p_rate_id
 
select @p_error                                     = @w_error,
       @p_msg_id                                    = @w_msg_id,
       @p_descp                                     = @w_descp
 
goto_return:
return @w_return
GO

/*Merged stored procedure lp_account.dbo.usp_account_deenrollment*/
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
					SELECT value 
					FROM lp_account.dbo.ufn_split_delimited_string (@p_reason_code_sub_array, ',')
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
GO

--rollback
commit