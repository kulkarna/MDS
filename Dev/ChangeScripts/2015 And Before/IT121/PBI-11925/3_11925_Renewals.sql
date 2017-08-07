
------------------------------------------------------------------
--1. Added requested flow start date for updating
-------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_account_upd]    Script Date: 08/13/2013 13:14:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[usp_contract_account_upd]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30),
 @p_account_number_new                              varchar(30),
 @p_account_name									varchar(50),
 @p_address                                         char(50),
 @p_suite                                           char(10),
 @p_city                                            char(28),
 @p_state                                           char(02),
 @p_zip                                             char(10),
 @p_first_name								       char(50),
 @p_last_name								        char(50),
 @p_phone_number	                                 char(50),
 @p_billing_address                                 char(50),
 @p_billing_suite                                           char(10),
 @p_billing_city                                            char(28),
 @p_billing_state                                           char(02),
 @p_billing_zip                                             char(10),
 @p_error                                           char(01)		= '',
 @p_msg_id                                          char(08)		= '',
 @p_descp                                           varchar(250)	= '',
 @p_result_ind                                      char(01)		= 'Y',
 @p_zone											varchar(20),
 @p_isRowSelectedforSave											bit=1)

as

SET NOCOUNT ON

select @p_account_number                            = upper(@p_account_number)

declare @w_address_link                             int
declare @w_billing_address_link                     int
declare @w_name_link								int
declare @w_contact_link								int
declare @w_utility_id								char(15)
 
select @w_address_link	= service_address_link,
	   @w_billing_address_link	= billing_address_link,
	   @w_name_link		= account_name_link,
	   @w_contact_link = customer_contact_link,
	   @w_utility_id	= utility_id
from lp_deal_capture..deal_contract_account with (NoLock)
where contract_nbr		= @p_contract_nbr
and	  account_number	= @p_account_number
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(25)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ''
select @w_return                                    = 0
select @w_descp_add                                 = ''
declare @w_application                              varchar(20)

declare @w_RequestedFlowStartDate Datetime

if @w_return                                       <> 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000001'
   select @w_return                                 = 1
   select @w_descp_add                              = '(Account ID)'
   goto goto_select
end


	exec @w_return = lp_deal_capture.dbo.usp_contract_address_val @p_username,
											  'I',
											  'ALL',
											  @p_contract_nbr,
											  @p_account_number,
											  @p_address,
											  @p_city,
											  @p_state,
											  @p_zip,
											  @w_application output,
											  @w_error output,
											  @w_msg_id output,
											  @w_descp_add output
											  
	exec @w_return = lp_deal_capture.dbo.usp_contract_address_val @p_username,
											  'I',
											  'ALL',
											  @p_contract_nbr,
											  @p_account_number,
											  @p_billing_address,
											  @p_billing_city,
											  @p_billing_state,
											  @p_billing_zip,
											  @w_application output,
											  @w_error output,
											  @w_msg_id output,
											  @w_descp_add output
											  										  

	if @w_return <> 0
	begin
	   goto goto_select
	end
	
if (rtrim(ltrim(@p_account_number)) <> rtrim(ltrim(@p_account_number_new)))
begin	
	exec @w_return = usp_contract_account_val @p_username,
											  'I',
											  'ALL',
											  @p_contract_nbr,
											  @p_account_number_new,
											  @w_application output,
											  @w_error output,
											  @w_msg_id output,
											  @w_utility_id



	if @w_return <> 0
	begin
	   goto goto_select
	end
end
update lp_deal_capture..deal_contract_account
set account_number	= @p_account_number_new,
	zone			= @p_zone,
	isForSave=@p_isRowSelectedforSave
	--Added on JUly 12 2013 IsForSave Chkbox
where	contract_nbr = @p_contract_nbr
and		account_number = @p_account_number

--Added Aug 07 2013- requested flow start date added
set @w_RequestedFlowStartDate=(Select requested_flow_start_date 
from  lp_deal_capture..deal_contract with (NoLock) where contract_nbr = @p_contract_nbr )

update lp_deal_capture..deal_contract_account
set requested_flow_start_date	= @w_RequestedFlowStartDate 
where	contract_nbr = @p_contract_nbr
and		account_number = @p_account_number



	
update lp_deal_capture..deal_address 
set address	= @p_address,
	suite	= @p_suite,
	city	= @p_city,
	state	= @p_state,
	zip		= @p_zip
where contract_nbr = @p_contract_nbr
and address_link = @w_address_link

update lp_deal_capture..deal_contact
set first_name = @p_first_name,
	last_name = @p_last_name,	
	phone = @p_phone_number
where contract_nbr = @p_contract_nbr
and contact_link = @w_contact_link

update lp_deal_capture..deal_address 
set address	= @p_billing_address,
	suite	= @p_billing_suite,
	city	= @p_billing_city,
	state	= @p_billing_state,
	zip		= @p_billing_zip
where contract_nbr = @p_contract_nbr
and address_link = @w_billing_address_link

update lp_deal_capture..deal_name 
set full_name	= @p_account_name	
where	contract_nbr = @p_contract_nbr
		and name_link = @w_name_link
       
       
       
if @@error <> 0 or @@rowcount = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000001'
   select @w_return                                 = 1
   select @w_descp_add                              = '(Account ID)'
   goto goto_select
end

select @w_return                                    = 0

goto_select:

if @w_error <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id, 
                                    @w_descp output,
                                    @w_application
   select @w_descp = ltrim(rtrim(@w_descp)) 
                   + ' ' 
                   + @w_descp_add 
end
 
if @p_result_ind = 'Y'
begin
   select flag_error = @w_error,
          code_error = @w_msg_id,
          message_error = @w_descp,
		  account_number = @p_account_number
   goto goto_return
end
 
select @p_error = @w_error,
       @p_msg_id = @w_msg_id,
       @p_descp = @w_descp,
	   @p_account_number = @p_account_number
 
goto_return:
return @w_return

SET NOCOUNT OFF

GO





----------------------------------------------------------------
--2. Copy the table from renewal database
------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  Table [dbo].[deal_params]    Script Date: 08/13/2013 12:40:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[deal_params]') AND type in (N'U'))
DROP TABLE [dbo].[deal_params]
GO

USE [Lp_deal_capture]
GO

CREATE TABLE [dbo].[deal_params](
	[param_text] [varchar](50) NOT NULL,
	[param_value] [varchar](50) NOT NULL
) ON [PRIMARY]

GO

----------------------------------
--3. Insert Data to the new table
-----------------------------------------------------------
If not exists (Select param_text from Lp_deal_capture..deal_params where param_text='renew_days_max_prod_fixed' )
Begin

Insert into Lp_deal_capture..deal_params
(param_text,param_value) Values
('renew_days_max_prod_fixed',	'30')
End
GO

If not exists (Select param_text from Lp_deal_capture..deal_params where param_text='renew_days_max_prod_var' )
Begin

Insert into Lp_deal_capture..deal_params
(param_text,param_value) Values
('renew_days_max_prod_var',	'180')
End

GO
---------------------------------------------------------------------------
--4. New Proc on LibertyPower to fetch the Account contract by Account NUmber and ContractID
------------------------------------------------------------------------


USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountContractByContractIdandAccountNoSelect]    Script Date: 08/13/2013 14:09:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountContractByContractIdandAccountNoSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountContractByContractIdandAccountNoSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountContractByContractIdandAccountNoSelect]    Script Date: 08/13/2013 14:09:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*
*
* PROCEDURE:	[usp_AccountContractByContractIdandAccountNoSelect]
*
* DEFINITION:  Select from  AccountContract Table given the ContractId and AccountNumber
*
* RETURN CODE: 
*
* REVISIONS:	Aug 13 2013 Sara lakshmanan
*/

Create PROCEDURE [dbo].[usp_AccountContractByContractIdandAccountNoSelect]
	@ContractID	INT,
	@accountNumber varchar(50)
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	SELECT AC.*
	FROM  LibertyPower.dbo.AccountContract AC (NOLOCK) inner Join libertypower..Account A (NOLOCK) on  AC.AccountID=A.AccountID
	WHERE   AC.ContractID= @ContractID  and A.AccountNumber  = @accountNumber;
	
END


GO


