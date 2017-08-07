
---------------------------------------------------------------------------
/*
Change scripts for PBI: 11925 Create business logic to automate Renewal Entry in "submit new deals" page
5 procs added and 1 modified
newly added Procs:
----------------
LP_Deal_capture :
   usp_SelectSalesChannelByUsername
   usp_contract_renewal_contract_upd
   usp_contract_renewal_account_ins
Libertypower:
    usp_AccountContractByContractIdSelect
    usp_AccountStatusByAccountContractIdSelect
  
Modified:
----------
LibertyPower :
    usp_CustomerSelect
*/

--------------------------------------------------------------------------------
--01- New Proc: lp_Deal_Capture :  usp_SelectSalesChannelByUsername
-------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_SelectSalesChannelByUsername]    Script Date: 08/01/2013 10:26:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SelectSalesChannelByUsername]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SelectSalesChannelByUsername]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_SelectSalesChannelByUsername]    Script Date: 08/01/2013 10:26:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Added: Sara Lakshmanan July 25 2013
-- procedure to find the Sales Channel for a login User
-- If the user is an Internal User default the sales channel to OutboundTeleSales
-- Project IT121
-- =============================================


CREATE procedure [dbo].[usp_SelectSalesChannelByUsername] 
@p_username					nchar(100)
as
Begin
SET NOCOUNT ON

Declare @w_UserType varchar(50)
Declare @w_ChannelName  varchar(200)

SELECT @w_UserType=UserType , 
       @w_ChannelName='Sales Channel/' +ChannelName
  FROM
       LIbertyPower..[User] us WITH ( nolock) 
       LEFT JOIN LIbertypower..SalesChannelUser SCU WITH ( nolock )
	  ON us.UserID  = SCU.UserID
	  LEFT JOIN LIbertypower..SalesChannel SC WITH ( nolock )
       ON SCU.ChannelID     =  SC.ChannelID
	  WHERE us.UserName  =  @p_username;


If @w_UserType = 'INTERNAL'
Begin
Select @w_ChannelName='Sales Channel/' +ChannelName from libertypower..SalesChannel with (nolock) where ChannelID=357
End

Select @w_ChannelName
SET NOCOUNT OFF
END

GO


---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--02- New Proc: lp_Deal_Capture :  usp_contract_renewal_contract_upd
-------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_renewal_contract_upd]    Script Date: 08/01/2013 10:34:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_contract_renewal_contract_upd]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_contract_renewal_contract_upd]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_renewal_contract_upd]    Script Date: 08/01/2013 10:34:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Add		: Sara Lakshmanan
-- Date		: 07/25/2013
-- Description	: Copied the Proc from Renewal to Deal capture and altered the parameters
-- =============================================

CREATE PROCEDURE [dbo].[usp_contract_renewal_contract_upd]

@p_username					nchar(100),
@p_contract_nbr				char(12),
@p_retail_mkt_id			int,
@p_utility_id				char(15) = '',
@p_product_id				char(20) = '',
--@p_rate_id					int = 0,
--@p_rate						float = 0,
--@p_customer_name_link       int,
--@p_customer_address_link    int,
--@p_customer_contact_link    int,
--@p_billing_address_link     int,
--@p_billing_contact_link     int,
--@p_owner_name_link          int,
--@p_service_address_link     int,
--@p_business_type			varchar(35) = '',
--@p_business_activity		varchar(35) = '',
--@p_additional_id_nbr		varchar(30) = '',
--@p_date_end					datetime,
--@p_term_months				int = 0,
@p_sales_channel_role		nvarchar(50) = '',
@p_business_type			varchar(35) = '',
@p_business_activity		varchar(35) = ''--,
--@p_sales_rep				varchar(100) = '',
--@p_date_submit				datetime = '19000101'
--,@p_SSNClear					nvarchar	(100) = ''		-- IT002
--,@p_SSNEncrypted				nvarchar	(512) = ''		-- IT002
--,@p_CreditScoreEncrypted		nvarchar	(512) = ''		-- IT002
--,@p_additional_id_nbr_type		varchar		(10)  = 'NONE'	-- IT002
--,@p_contract_eff_start_date		datetime = null
   
AS
SET NOCOUNT ON

--DECLARE @w_contract_eff_start_date	datetime
DECLARE @w_retailmarket					char(2)

Set @w_retailmarket =(Select top 1  MarketCode from LibertyPower..Market with (NoLock) where ID =@p_retail_mkt_id) 
----SET @w_contract_eff_start_date = DATEADD(dd, 1, @p_date_end)
--IF @p_contract_eff_start_date is not null
--	SET @w_contract_eff_start_date = @p_contract_eff_start_date
--ELSE
--	SET @w_contract_eff_start_date = (SELECT contract_eff_start_date FROM lp_common..common_product_rate WHERE product_id = @p_product_id AND rate_id = @p_rate_id)

--IF @w_contract_eff_start_date IS NULL
--	BEGIN
--		SET @w_contract_eff_start_date = GETDATE()
--	END
--SET @w_date_end = DATEADD(mm, @p_term_months, DATEADD(dd, -1, @w_contract_eff_start_date))




UPDATE
	deal_contract
SET
     enrollment_type=1,
	retail_mkt_id = @w_retailmarket,
	utility_id = @p_utility_id,
	product_id = @p_product_id,
	--rate_id = @p_rate_id,
	--rate = @p_rate,
	--customer_name_link = @p_customer_name_link,
	--customer_address_link = @p_customer_address_link,
	--customer_contact_link = @p_customer_contact_link,
	--billing_address_link = @p_billing_address_link,
	--billing_contact_link = @p_billing_contact_link,
	--owner_name_link = @p_owner_name_link,
	--service_address_link = @p_service_address_link,
	business_type = @p_business_type,
	business_activity = @p_business_activity,
	--additional_id_nbr = @p_additional_id_nbr,
	--date_end = @w_date_end,
	--contract_eff_start_date = @w_contract_eff_start_date,
	--term_months = @p_term_months,
	sales_channel_role = @p_sales_channel_role,
	--sales_rep = @p_sales_rep,
	date_submit = GETDATE()
	--,SSNClear				= @p_SSNClear					-- IT002
	--,SSNEncrypted			= @p_SSNEncrypted				-- IT002
	--,CreditScoreEncrypted	= @p_CreditScoreEncrypted		-- IT002
	--,additional_id_nbr_type = @p_additional_id_nbr_type		-- IT002
	,deal_type=2
WHERE
	contract_nbr = @p_contract_nbr

SET NOCOUNT OFF


GO


--------------------------------------------------------------------
--------------------------------------------------------------------------------
--03- New Proc: lp_Deal_Capture :  usp_contract_renewal_account_ins
-------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_renewal_account_ins]    Script Date: 08/01/2013 10:37:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_contract_renewal_account_ins]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_contract_renewal_account_ins]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_renewal_account_ins]    Script Date: 08/01/2013 10:37:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Added: Sara 07/24/2013
--Copied from renewal to deal capture and altered few fields
-- =============================================

CREATE PROCEDURE [dbo].[usp_contract_renewal_account_ins]

@p_contract_nbr                 char(12),
@p_account_number               varchar(30),
@p_account_id                   char(12),
@p_account_type			  int,
@p_account_nameID               int

AS

Set NoCount ON

DECLARE @w_contract_eff_start_date	datetime
DECLARE @w_date_end					datetime

DECLARE @w_product_id                   char(20)
DECLARE @w_rate_id                      int
DECLARE @w_rate                         float
DECLARE @w_inactive_ind					tinyint


--IF @p_account_eff_start_date is not null
--	SET @w_contract_eff_start_date = @p_account_eff_start_date
--ELSE
--	Begin
--		SET @w_contract_eff_start_date = DATEADD(dd, 1, @p_date_end)
---- per Douglas 6/5/2007, changed back to above line
----SET @w_contract_eff_start_date = (SELECT contract_eff_start_date FROM lp_common..common_product_rate WHERE product_id = @p_product_id AND rate_id = @p_rate_id)
--	End
	
--SET @w_date_end = DATEADD(mm, @p_term_months, DATEADD(dd, -1, @w_contract_eff_start_date))

--SET @w_product_id	= @p_product_id
--SET @w_rate_id		= @p_rate_id
--SET @w_rate			= @p_rate

---- determine if product is still active
--IF 
--(SELECT	inactive_ind
--FROM	lp_common..common_product
--WHERE	product_id = @p_product_id) = 1
--	BEGIN
--		SET @w_product_id	= ' '
--		SET @w_rate_id		= 0
--		SET @w_rate			= 0
--	END

IF NOT EXISTS(	SELECT	account_number
				FROM	deal_contract_account with (NoLock)
				WHERE	account_number	= @p_account_number
				AND		contract_nbr	= @p_contract_nbr )
	BEGIN
	print 'DEBUG: From usp_contract_renewal_account_ins, just before insert into deal_contract_account.'
    INSERT INTO [lp_deal_capture].[dbo].[deal_contract_account]
           ([contract_nbr]
           ,[contract_type]
           ,[account_number]
           ,[status]
           ,[account_id]
           ,[retail_mkt_id]
           ,[utility_id]
           ,[product_id]
           ,[rate_id]
           ,[rate]
           ,[account_name_link]
           ,[customer_name_link]
           ,[customer_address_link]
           ,[customer_contact_link]
           ,[billing_address_link]
           ,[billing_contact_link]
           ,[owner_name_link]
           ,[service_address_link]
           ,[business_type]
           ,[business_activity]
           ,[additional_id_nbr_type]
           ,[additional_id_nbr]
           ,[contract_eff_start_date]
           ,[term_months]
           ,[date_end]
           ,[date_deal]
           ,[date_created]
           ,[date_submit]
           ,[sales_channel_role]
           ,[username]
           ,[sales_rep]
           ,[origin]
          -- ,[annual_usage]
           ,[grace_period]
           ,[chgstamp]
         --  ,[renew]
			,[SSNClear]					-- IT002
			,[SSNEncrypted]				-- IT002
			,[CreditScoreEncrypted]		-- IT002
			--,[sales_manager]				--  Added Ticket # 1-1025061
			,[evergreen_option_id]			--  Added Ticket # 1-1025061
			,[residual_commission_end]		--  Added Ticket # 1-1025061
			,[evergreen_commission_rate]	--  Added Ticket # 1-1025061
			,[residual_option_id]			--  Added Ticket # 1-1025061
			,[evergreen_commission_end]		--  Added Ticket # 1-1025061
			,[initial_pymt_option_id]		--  Added Ticket # 1-1025061
			,account_type, enrollment_type
       )
     
		SELECT
			@p_contract_nbr, contract_type, @p_account_number, 'DRAFT', @p_account_id, retail_mkt_id,
			utility_id, product_id, rate_id, rate,@p_account_nameId,customer_name_link,
			customer_address_link, customer_contact_link, billing_address_link, billing_contact_link,
			owner_name_link, service_address_link, business_type, business_activity, additional_id_nbr_type,
			additional_id_nbr, contract_eff_start_date, term_months, date_end, GETDATE(), GETDATE(),
			GETDATE(), sales_channel_role, username, '', 'ONLINE',
			-- @p_annual_usage,
			  0, chgstamp,
			--   1			,
			   SSNClear, SSNEncrypted, CreditScoreEncrypted -- IT002	

			/*Ticket # 1-1025061 Begin */
			--,@p_sales_mgr 
			,
			evergreen_option_id ,residual_commission_end
			,evergreen_commission_rate ,residual_option_id
			,evergreen_commission_end ,initial_pymt_option_id, @p_account_type,1
			from deal_contract with (NoLock) where contract_nbr=@p_contract_nbr
			/*Ticket # 1-1025061 End */
			
Set NoCount OFF

	END



GO



----------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--04- Modified Proc: [LibertyPower] : usp_CustomerSelect
-------------------------------------------------------------------------------------

USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerSelect]    Script Date: 08/01/2013 10:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------
--Modified : Sara lakshmanan July 25 2013
--Added BusinessType and BusinessActivity
--IT121- Renewal in DealCapture Page
---------------------------------------------------

ALTER PROCEDURE [dbo].[usp_CustomerSelect]
	@CustomerID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		C.CustomerID,
		C.NameID,
		N1.Name as CustomerName,
		C.OwnerNameID,
		N2.Name as OwnerName,
		C.AddressID,
		C.CustomerPreferenceID,
		C.ContactID,
		C.DBA,
		C.Duns,
		C.SsnClear,
		C.SsnEncrypted,
		C.TaxId,
		C.EmployerId,
		C.CreditAgencyID,
		C.CreditScoreEncrypted,
		C.BusinessTypeID,
		C.BusinessActivityID,
		C.ExternalNumber,
		C.Modified,
		C.ModifiedBy,
		C.DateCreated,
		C.CreatedBy,
		B1.Type,
		B2.Activity
	From 
		LibertyPower.dbo.Customer C with (nolock)
		Left Outer Join Name N1 with (nolock) On C.NameID = N1.NameID
		Left Outer Join Name N2 with (nolock) On C.OwnerNameID = N2.NameID
		Left Outer Join BusinessType B1 with (nolock) on C.BusinessTypeID= B1.BusinessTypeID
		Left Outer Join BusinessActivity B2 with (nolock) on C.BusinessActivityID=B2.BusinessActivityID
	Where 
		CustomerID = @CustomerID 
		SET NOCOUNT OFF;
END
GO

----------------------------------------------------------------------------
--------------------------------------------------------------------------------
--05- New Proc: [LibertyPower] :usp_AccountContractByContractIdSelect
-------------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountContractByContractIdSelect]    Script Date: 08/01/2013 10:56:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountContractByContractIdSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountContractByContractIdSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountContractByContractIdSelect]    Script Date: 08/01/2013 10:56:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
*
* PROCEDURE:	[usp_AccountContractByContractIdSelect]
*
* DEFINITION:  Selects a record from AccountContract Table By ContractID
*
* RETURN CODE: returns all the AccountContract Information
*
* REVISIONS:	sara lakshamanan 7/26/2013
*/

CREATE PROCEDURE [dbo].[usp_AccountContractByContractIdSelect]
	@ContractID	INT
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	SELECT *
	FROM  LibertyPower.dbo.AccountContract (NOLOCK)
	WHERE ContractID  = @ContractID  ;
	

Set NOCOUNT OFF;
END

GO

--------------------------------------------------------
--------------------------------------------------------------------------------
--06- New Proc: [LibertyPower] :usp_AccountStatusByAccountContractIdSelect
-------------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountStatusByAccountContractIdSelect]    Script Date: 08/01/2013 10:57:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountStatusByAccountContractIdSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountStatusByAccountContractIdSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountStatusByAccountContractIdSelect]    Script Date: 08/01/2013 10:57:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
*
* PROCEDURE:	usp_AccountStatusByAccountContractIdSelect
*
* DEFINITION:  Selects all records from AccountStatus by AccountContractID
*
* RETURN CODE: 
*
* REVISIONS:	7/26/2013 Sara New
*/


Create PROCEDURE [dbo].[usp_AccountStatusByAccountContractIdSelect]
 @AccountContractID INT
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	SELECT *
	FROM [dbo].[AccountStatus] WITH (NOLOCK)
	WHERE AccountContractID = @AccountContractID
	;

SET NOCOUNT OFF
END



GO


------------------------------------------------------------------------------------

