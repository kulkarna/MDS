USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_transaction_detail_sel_by_category]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_transaction_detail_sel_by_category]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mannagaroo
-- Create date: 7/22/2008
-- Description:	Get transaction detail
-- =============================================
-- 11/24/2009 Gail Mangaroo
-- Added (NOLOCK) optimizer hint and check for residual correction transactions
-- =============================================
-- 12/9/2010 Modified Gail Mangaroo 
-- allow contract_nbr and vendor_id to be ignored 
-- =============================================
-- 6/29/2011 Modified Gail Mangaroo
-- ignore voiding adjustments
-- =============================================
-- 10/21/2011 Gail Mangaroo 
-- Account for compound reason codes
-- =============================================
-- 12/15/2011 Gail Mangaroo 
-- Account for voided chargebacks
-- =============================================
-- =============================================
-- 11/05/2012 Lehem Felican
-- Added default value for account_id
-- =============================================
CREATE PROCEDURE [dbo].[usp_transaction_detail_sel_by_category] 
	
	@p_transaction_type_category varchar(20)
	, @p_account_id varchar(20) = ''
	, @p_contract_nbr varchar(30)
	, @p_vendor_id int 
	, @p_payable_only bit = 1
	, @p_ignore_chbk bit = 0 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	  SELECT  d.* 
	
	  FROM [lp_commissions].[dbo].[transaction_detail] d (NOLOCK)
		JOIN transaction_type t ON t.transaction_type_id = d.transaction_type_id 
 
	  WHERE transaction_type_category = @p_transaction_type_category
			AND (account_id = @p_account_id OR @p_account_id = '')
			AND isnull(void, 0) = 0 
			-- status is not rejected or @p_payable_only = 0 
			AND ( (approval_status_id <> 2) OR  @p_payable_only = 0 )
			AND (vendor_id = @p_vendor_id OR @p_vendor_id = 0) 
			AND (contract_nbr = @p_contract_nbr OR ltrim(rtrim(isnull(@p_contract_nbr, ''))) = '') 

			AND ( @p_payable_only = 0  
					OR @p_ignore_chbk = 1 
					OR NOT EXISTS (--chargebacks
									SELECT chbk.transaction_detail_id 
									FROM lp_commissions..transaction_detail chbk (NOLOCK)
										LEFT JOIN lp_commissions..transaction_detail void (NOLOCK) ON void.assoc_transaction_id = chbk.transaction_detail_id 
											AND void.void = 0 
											AND void.transaction_type_id = 7 
											AND void.reason_code like '%C0012%' -- Void
											
									WHERE ( chbk.transaction_type_id = 2 -- chargeback 
												OR 
											( chbk.transaction_type_id = 7 -- Adjustment 
												AND chbk.reason_code like '%C0012%' -- Void
											)
										   ) 
										AND chbk.assoc_transaction_id =  d.transaction_detail_id 
										AND chbk.approval_status_id <> 2 -- not rejected
										AND isnull(chbk.void, 0) = 0
										AND void.transaction_detail_id is null -- chbk not voided
										
									UNION 
										
									-- residual correction transactions
									SELECT transaction_detail_id FROM transaction_detail (NOLOCK)
									WHERE transaction_type_id = 7 -- adjustment 
										AND assoc_transaction_id =  d.transaction_detail_id 
										AND reason_code like '%C3001%'
										AND approval_status_id <> 2 -- not rejected
										AND isnull(void, 0) = 0  
										AND d.transaction_type_id = 6 -- source transaction is a residual
																			
									)
				) 
		
		ORDER BY date_created 

END
GO

USE [Lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_transaction_detail_sel_by_category]    Script Date: 10/31/2012 14:31:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mannagaroo
-- Create date: 7/22/2008
-- Description:	Get transaction detail
-- =============================================
-- 11/24/2009 Gail Mangaroo
-- Added (NOLOCK) optimizer hint and check for residual correction transactions
-- =============================================
-- 12/9/2010 Modified Gail Mangaroo 
-- allow contract_nbr and vendor_id to be ignored 
-- =============================================
-- 6/29/2011 Modified Gail Mangaroo
-- ignore voiding adjustments
-- =============================================
-- 10/21/2011 Gail Mangaroo 
-- Account for compound reason codes
-- =============================================
-- 12/15/2011 Gail Mangaroo 
-- Account for voided chargebacks
-- =============================================
-- =============================================
-- 11/05/2012 Lehem Felican
-- Added default value for account_id
-- =============================================
ALTER PROCEDURE [dbo].[usp_transaction_detail_sel_by_category] 
	
	@p_transaction_type_category varchar(20)
	, @p_account_id varchar(20) = ''
	, @p_contract_nbr varchar(30)
	, @p_vendor_id int 
	, @p_payable_only bit = 1
	, @p_ignore_chbk bit = 0 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	  SELECT  d.* 
	
	  FROM [lp_commissions].[dbo].[transaction_detail] d (NOLOCK)
		JOIN transaction_type t ON t.transaction_type_id = d.transaction_type_id 
 
	  WHERE transaction_type_category = @p_transaction_type_category
			AND (account_id = @p_account_id OR @p_account_id = '')
			AND isnull(void, 0) = 0 
			-- status is not rejected or @p_payable_only = 0 
			AND ( (approval_status_id <> 2) OR  @p_payable_only = 0 )
			AND (vendor_id = @p_vendor_id OR @p_vendor_id = 0) 
			AND (contract_nbr = @p_contract_nbr OR ltrim(rtrim(isnull(@p_contract_nbr, ''))) = '') 

			AND ( @p_payable_only = 0  
					OR @p_ignore_chbk = 1 
					OR NOT EXISTS (--chargebacks
									SELECT chbk.transaction_detail_id 
									FROM lp_commissions..transaction_detail chbk (NOLOCK)
										LEFT JOIN lp_commissions..transaction_detail void (NOLOCK) ON void.assoc_transaction_id = chbk.transaction_detail_id 
											AND void.void = 0 
											AND void.transaction_type_id = 7 
											AND void.reason_code like '%C0012%' -- Void
											
									WHERE ( chbk.transaction_type_id = 2 -- chargeback 
												OR 
											( chbk.transaction_type_id = 7 -- Adjustment 
												AND chbk.reason_code like '%C0012%' -- Void
											)
										   ) 
										AND chbk.assoc_transaction_id =  d.transaction_detail_id 
										AND chbk.approval_status_id <> 2 -- not rejected
										AND isnull(chbk.void, 0) = 0
										AND void.transaction_detail_id is null -- chbk not voided
										
									UNION 
										
									-- residual correction transactions
									SELECT transaction_detail_id FROM transaction_detail (NOLOCK)
									WHERE transaction_type_id = 7 -- adjustment 
										AND assoc_transaction_id =  d.transaction_detail_id 
										AND reason_code like '%C3001%'
										AND approval_status_id <> 2 -- not rejected
										AND isnull(void, 0) = 0  
										AND d.transaction_type_id = 6 -- source transaction is a residual
																			
									)
				) 
		
		ORDER BY date_created 

END
GO

USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_transaction_detail_sel_by_type]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_transaction_detail_sel_by_type]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mannagaroo
-- Create date: 8/14/2008
-- Description:	Get transaction detail
-- =============================================
-- Modified 10/2/2009 Gail Mangaroo 
-- Added Vendor_Descp field
-- =====================================================
-- 11/24/2009 Gail Mangaroo
-- Added (NOLOCK) optimizer hint and check for residual correction transactions
-- =============================================
-- 3/17/2011 Gail Mangaroo	
-- Added assoc transaction id param
--==============================================
-- 6/29/2011 Modified Gail Mangaroo
-- ignore voiding adjustments
-- =============================================
-- 10/21/2011 Gail Mangaroo 
-- Account for compound reason codes
-- =============================================
-- 5/9/2012 Gail Mangaroo
-- Ignore voided chargebacks
-- =============================================
-- =============================================
-- 10/22/2012 Lehem Felican
-- Added default value of '' for @p_account_id parameter
-- Added to WHERE clause account_id = @p_account_id Or @p_account_id = ''
-- =============================================
CREATE PROCEDURE [dbo].[usp_transaction_detail_sel_by_type] 
	  @p_account_id varchar(30) = ''
	, @p_contract_nbr varchar(30)
	, @p_vendor_id int 
	, @p_transaction_type_id int 
	, @p_payable_only bit = 1
	, @p_ignore_chbk bit = 0 
	, @p_reason_code varchar(50) = null
	, @p_assoc_trans_id int = 0 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT d.* 
	FROM [lp_commissions].[dbo].[transaction_detail] d (NOLOCK)
	
	WHERE transaction_type_id = @p_transaction_type_id
		AND (account_id = @p_account_id Or @p_account_id = '')
		AND isnull(void, 0) = 0 
		-- status is not rejected or @p_payable_only = 0 
		AND ( (approval_status_id <> 2) OR  @p_payable_only = 0 )
		AND vendor_id = @p_vendor_id 
		AND contract_nbr = @p_contract_nbr
		AND ( -- check for a blank reason code as exact match 
			 (len(ltrim(rtrim(@p_reason_code))) = 0 AND len(ltrim(rtrim(d.reason_code))) = 0 )
				OR 
			 -- use pattern matching for non-empty reason codes
			 (len(ltrim(rtrim(@p_reason_code))) > 0 AND d.reason_code like ltrim(rtrim(@p_reason_code)) + '%')
				OR 
			-- return all if reason code not provided 
			  @p_reason_code is null
			)
		AND ( @p_ignore_chbk = 1  
				OR NOT EXISTS (--chargebacks
									SELECT chbk.transaction_detail_id 
									FROM lp_commissions..transaction_detail chbk (NOLOCK)
										LEFT JOIN lp_commissions..transaction_detail void (NOLOCK) ON void.assoc_transaction_id = chbk.transaction_detail_id 
											AND void.void = 0 
											AND void.transaction_type_id = 7 
											AND void.reason_code like '%C0012%' -- Void
											
									WHERE ( chbk.transaction_type_id = 2 -- chargeback 
												OR 
											( chbk.transaction_type_id = 7 -- Adjustment 
												AND chbk.reason_code like '%C0012%' -- Void
											)
										   ) 
										AND chbk.assoc_transaction_id =  d.transaction_detail_id 
										AND chbk.approval_status_id <> 2 -- not rejected
										AND isnull(chbk.void, 0) = 0
										AND void.transaction_detail_id is null -- chbk not voided
										
									UNION 
									-- residual correction transactions
									SELECT transaction_detail_id FROM transaction_detail (NOLOCK)
									WHERE transaction_type_id = 7 -- adjustment 
										AND assoc_transaction_id =  d.transaction_detail_id 
										AND reason_code like '%C3001%'
										AND approval_status_id <> 2 -- not rejected
										AND isnull(void, 0) = 0  
										AND d.transaction_type_id = 6 -- source transaction is a residual
									)
			 ) 
		AND (assoc_transaction_id = @p_assoc_trans_id OR isnull(@p_assoc_trans_id, 0) = 0 )

	ORDER BY [transaction_detail_id]


END 
GO


USE [lp_commissions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/12/2010
-- Description:	Create vendor calculation freq audit
-- =============================================
ALTER Trigger [dbo].[trg_audit_vendor_calculation_freq] ON [dbo].[vendor_calculation_freq] 
FOR INSERT, UPDATE, DELETE AS 

BEGIN 

	INSERT INTO [lp_commissions].[dbo].[zaudit_vendor_calculation_freq]
           ([freq_id]
           ,[vendor_id]
           ,[calculation_freq_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[date_audit]
           ,[date_end]
		   ,[package_id]
		   ,[interval_type_id]
		   ,[interval]

           )

	SELECT [freq_id]
		  ,[vendor_id]
		  ,[calculation_freq_id]
		  ,[date_effective]
		  ,[active]
		  ,[date_created]
		  ,[username]
		  ,[date_modified]
		  ,[modified_by]
		  ,getdate()
		  ,[date_end]
		  ,[package_id]
		  ,[interval_type_id]
		  ,[interval]


	FROM INSERTED 

END   
GO

USE [lp_commissions]
GO
/****** Object:  Trigger [dbo].[trg_audit_vendor_grace_period]    Script Date: 11/29/2012 01:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 6/11/2010
-- Description:	Insert audit record
-- =============================================
ALTER Trigger [dbo].[trg_audit_vendor_grace_period] ON [dbo].[vendor_grace_period] 
FOR INSERT, UPDATE, DELETE AS 

BEGIN 

	INSERT INTO [lp_commissions].[dbo].[zaudit_vendor_grace_period]
           ([option_id]
           ,[vendor_id]
           ,[transaction_type_id]
           ,[grace_period]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[date_audit]
           ,[date_end]
		   ,[package_id]
		   ,[interval_type_id]
		   ,[date_option]
		  )
     
     SELECT [option_id]
      ,[vendor_id]
      ,[transaction_type_id]
      ,[grace_period]
      ,[date_effective]
      ,[active]
      ,[date_created]
      ,[username]
      ,[date_modified]
      ,[modified_by]
      ,getdate()
	  ,[date_end]
      ,[package_id]
      ,[interval_type_id]
      ,[date_option]
  
  
 	FROM INSERTED

END
GO

USE [lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/12/2010
-- Description:	Create vendor payment freq audit
-- =============================================
ALTER Trigger [dbo].[trg_audit_vendor_payment_freq] ON [dbo].[vendor_payment_freq] 
FOR INSERT, UPDATE, DELETE AS 

BEGIN 

	INSERT INTO [lp_commissions].[dbo].[zaudit_vendor_payment_freq]
           ([freq_id]
           ,[vendor_id]
           ,[payment_freq_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[date_audit]
           ,[date_end]
		   ,[package_id]
		   ,[interval_type_id]
		   ,[interval]
		   )

	SELECT [freq_id]
      ,[vendor_id]
      ,[payment_freq_id]
      ,[date_effective]
      ,[active]
      ,[date_created]
      ,[username]
      ,[date_modified]
      ,[modified_by]
      ,getdate()
      ,[date_end]
	   ,[package_id]
	   ,[interval_type_id]
	   ,[interval]
  
  FROM INSERTED



END 
GO

USE [lp_commissions]
GO
/****** Object:  Trigger [dbo].[trg_audit_vendor_payment_option]    Script Date: 11/29/2012 01:48:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/12/2010
-- Description:	Create audit record
-- =============================================
* 6/2/2010 Gail Mangaroo 
* Added term field
**********************************************************************
*/
ALTER Trigger [dbo].[trg_audit_vendor_payment_option] ON [dbo].[vendor_payment_option] 
FOR INSERT, UPDATE, DELETE AS 
BEGIN 

	INSERT INTO [lp_commissions].[dbo].[zaudit_vendor_payment_option]
           ([option_id]
           ,[vendor_id]
           ,[payment_option_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[date_audit]
           , term 
           ,[date_end]
		   ,[package_id]
		   ,[interval_type_id]
           )
     

	SELECT [option_id]
      ,[vendor_id]
      ,[payment_option_id]
      ,[date_effective]
      ,[active]
      ,[date_created]
      ,[username]
      ,[date_modified]
      ,[modified_by]
      ,getdate()
      , term
      ,[date_end]
	  ,[package_id]
	  ,[interval_type_id]
  FROM INSERTED 


END 
GO 



USE [lp_commissions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/12/2010
-- Description:	Create vendor_report_date_option audit
-- =============================================
-- Modified 12/10/2010 Gail Mangaroo 
-- added contract_group_id, grace_period
-- =============================================
ALTER Trigger [dbo].[trg_audit_vendor_report_date_option] ON [dbo].[vendor_report_date_option] 
FOR INSERT, UPDATE, DELETE AS 
BEGIN 


	INSERT INTO [lp_commissions].[dbo].[zaudit_vendor_report_date_option]
           ([option_id]
           ,[vendor_id]
           ,[report_date_option_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[date_audit]
           
           , contract_group_id
           , grace_period 
           
           ,[date_end]
		   ,[package_id]
		   ,[interval_type_id]
           )
     
     SELECT [option_id]
      ,[vendor_id]
      ,[report_date_option_id]
      ,[date_effective]
      ,[active]
      ,[date_created]
      ,[username]
      ,[date_modified]
      ,[modified_by]
      , getdate()

      , contract_group_id
      , grace_period 

	  ,[date_end]
	  ,[package_id]
	  ,[interval_type_id]
		   
  FROM INSERTED 

END 
GO 

USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_audit_vendor_setting_param]'))
	DROP TRIGGER [dbo].[trg_audit_vendor_setting_param]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 11/29/2012
-- Description:	Create vendor setting param audit
-- =============================================
CREATE Trigger [dbo].[trg_audit_vendor_setting_param] ON [dbo].[vendor_setting_param] 
FOR INSERT, UPDATE, DELETE AS 

BEGIN 

	INSERT INTO [Lp_commissions].[dbo].[zaudit_vendor_setting_param]
           ([vendor_setting_param_id]
           ,[setting_type_id]
           ,[setting_id]
           ,[param_id]
           ,[param_value]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[param_operator]
           ,[date_audit]
           )
    
	SELECT [vendor_setting_param_id]
      ,[setting_type_id]
      ,[setting_id]
      ,[param_id]
      ,[param_value]
      ,[active]
      ,[date_created]
      ,[username]
      ,[date_modified]
      ,[modified_by]
      ,[param_operator]
      ,getdate()

  FROM INSERTED
END 
GO

USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_detail_account_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_account_detail_account_sel]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * usp_account_detail_account_sel
 * Get account detail from account table.
 * History
 *******************************************************************************
 * 1/22/2009 Gail Mangaroo.
 * Created.
 *******************************************************************************
 * 12/6/2011 Gail Mangaroo
 * Modified 
 * Added ufn_account_detail_historical_sel to get account_name
 *******************************************************************************
 * 12/13/2011 Gail Mangaroo -- prod 1/28/2012
 * Modified
 * Switch from lp_account..account to LibertyPower..Account
  *******************************************************************************
 * 2/7/2012 Gail Mangaroo 
 * Fixed FlowStart and DeEnrollment sub queries
 *******************************************************************************
 * 2/8/2012 Gail Mangaroo 
 * Fixed FlowStart and DeEnrollment sub queries
 *******************************************************************************
 * Modified 2/21/2012 Gail Mangaroo 
 * Removed @p_account_number param and modified for effeciency
 * Added rate_desc 
 *******************************************************************************
 * Modified 3/1/2012 Gail Mangaroo 
 * Added Account Type ID
 *******************************************************************************
 * Modiifed 3/8/2012 Gail Mangaroo
 * Added MarketID 
 *******************************************************************************
 * Modified 8/22/2012 Gail Mangaroo
 * Fixed join with commission_review re empty strings
 * Fixed Join with account status - only one row will exist now
 * When getting service end date, check if start date <== contract end date
 * Accept vendor_system_name or vendor_name 
 * and added Price
 *******************************************************************************
 * Modified 9/14/2012 Gail Mangaroo 
 * Use LIbertyPower..Name
 * Added ContractStatusID 
 *******************************************************************************
 * 9/26/2012 Gail Mangaroo
 * Modified 
 * Added check for all empty parameters
 *******************************************************************************
 * 11/28/2012 Gail Mangaroo 
 * Added additional fields and multi_rate price
 *******************************************************************************
exec usp_account_detail_account_sel '2009-0023409' , '', '90008363A'

 */
 
CREATE Procedure [dbo].[usp_account_detail_account_sel]
( 
@p_account_id varchar(30)
, @p_account_number varchar(30) = ''
, @p_contract_nbr varchar(30) = ''
, @p_vendor_system_name varchar(50) = ''
, @p_start_date datetime = null
, @p_end_date datetime = null
) 

AS 
BEGIN 
			--drop table #acct
			
			--DECLARE @p_account_id varchar(30)
			--DECLARE  @p_account_number varchar(30) 
			--DECLARE  @p_contract_nbr varchar(30) 
			--DECLARE  @p_vendor_system_name varchar(50)
			--DECLARE  @p_start_date datetime 
			--DECLARE  @p_end_date datetime 

			--SET @p_account_id = '' -- '2009-0023409'
			--SET @p_account_number = ''
			--SET @p_contract_nbr = '' -- '90008362A'
			--SET @p_vendor_system_name = ''
			--SET @p_start_date = null 
			--SET @p_end_date = null 
			
	SET NOCOUNT ON

	CREATE TABLE #acct ( accountID int , contractID int , accountContractID int , startDate datetime , endDate datetime )

	DECLARE @strsQL NVARCHAR(max)
	DECLARE @ParmDefinition NVARCHAR(500)
	DECLARE @strWHERE nvarchar(max) 
	
	SET @strWHERE = ''
	SET @ParmDefinition = N'
	 @p_account_id varchar(30)
	, @p_account_number varchar(30) 
	, @p_contract_nbr varchar(30) 
	, @p_vendor_system_name varchar(50) 
	, @p_start_date datetime 
	, @p_end_date datetime  
	'

	SET @strsQL = 
	'SELECT a.AccountID
		, c.ContractID
		, acc.AccountContractID
		, startDate = (SELECT min(acs_start.startDate) 
								FROM LibertyPower.dbo.AccountService acs_start (NOLOCK) 
								WHERE  acs_start.account_id = a.AccountIDLegacy
									AND (acs_start.EndDate is null OR acs_start.EndDate = ''1/1/1900'' OR acs_start.EndDate >= c.SignedDate)
									AND acs_start.StartDate > ''1/1/1900''
							 )
		, endDate = isnull(( SELECT TOP 1 EndDate 
								from LibertyPower.dbo.AccountService (NOLOCK)
								WHERE account_id = a.AccountIDLegacy 
									AND (EndDate >= c.SignedDate OR EndDate is null OR EndDate = ''1/1/1900'')
								ORDER BY StartDate desc
							), ''1/1/1900'')
		
	FROM LibertyPower.dbo.Account a (NOLOCK) 
		JOIN LibertyPower.dbo.AccountContract acc (NOLOCK) ON a.AccountID = acc.AccountID
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = acc.ContractID
		JOIN lp_Commissions.dbo.vendor v (NOLOCK) ON v.ChannelID  = c.SalesChannelID
		JOIN LibertyPower.dbo.SalesChannel sc (NOLOCK) ON sc.ChannelID  = c.SalesChannelID
	
	WHERE  1 =1 '

	if ltrim(rtrim(isnull(@p_account_id, ''))) <> ''
		SET @strWHERE = @strWHERE + N' AND a.accountIDLegacy =  @p_account_id '

	if ltrim(rtrim(isnull(@p_contract_nbr, ''))) <> ''
		SET @strWHERE = @strWHERE + N' AND c.Number = @p_contract_nbr '
	
	if ltrim(rtrim(isnull(@p_account_number, ''))) <> ''
		SET @strWHERE = @strWHERE + N' AND a.accountNumber = @p_account_number '
		
	if ltrim(rtrim(isnull(@p_vendor_system_name, ''))) <> '' 
		SET @strWHERE = @strWHERE + N' AND ( v.vendor_system_name = @p_vendor_system_name  OR sc.channelname = @p_vendor_system_name) '
	
	if @p_start_date is not null
		SET @strWHERE = @strWHERE + N' AND c.SignedDate >= @p_start_date '
	
	if  @p_end_date is not null
		SET @strWHERE = @strWHERE + N' AND c.SignedDate <= @p_end_date '

	IF len(ltrim(@strWhere)) = 0 -- prevent returning dataset without setting parameters
		SET @strWhere = @strWhere + N' AND 1 = 0 '

	SET @strsql = @strsql + @strWhere	
		
	INSERT INTO #acct 
	EXECUTE sp_executesql  @strsql 
		, @ParmDefinition 
		, 	@p_account_id = @p_account_id
		, 	@p_contract_nbr = @p_contract_nbr
		, 	@p_account_number = @p_account_number
		, 	@p_vendor_system_name = @p_vendor_system_name
		, 	@p_start_date = @p_start_date
		, 	@p_end_date = @p_end_date 

	SELECT  
		account_id			= a.AccountIDLegacy
		, account_number	= a.AccountNumber
		, full_name			= n.name
		, date_deal			= DATEADD(dd,0, DATEDIFF(dd,0,c.SignedDate)) 
		, requested_flow_start_date = c.SignedDate   
		, date_end			= c.EndDate
		, date_start		= c.StartDate
		, sales_rep			= c.salesRep
		, annual_usage		= isnull(au.annualUsage, 0)
		, [status]			= LTRIM(RTRIM(s.Status))
		, sub_status		= LTRIM(RTRIM(s.SubStatus))
		, contract_nbr		= c.Number
		, retail_mkt_id		= m.MarketCode
		, utility_id		= u.UtilityCode
		, term_months		= acr.Term
		, product_id		= acr.LegacyProductID
		, sales_channel_role = v.vendor_system_name
		, vendor_id			= v.vendor_id
		, rate				= acr.Rate
		, rate_id			= acr.RateId 
		, date_flow_start	= temp.StartDate
		, date_deenrolled	= temp.EndDate
		, contract_type		= ct.type + ' ' + cdt.DealType 
		, ContractDealTypeID = c.ContractDealTypeID
		, contract_eff_start_date = acr.RateStart 
		, p.product_descp
		, renewal			=  case when c.ContractDealTypeID = 2 then 1 else 0 end
		, review_ind		= r.review_ind 
		, review_id			= r.commission_review_id 
		, account_type		= at.AccountType
		, status_descp		= es.status_descp 
		
		, evergreen_option_id			= accom.EvergreenOptionID
		, evergreen_commission_end		= accom.evergreenCommissionEnd
		, evergreen_commission_rate		= accom.evergreenCommissionRate   
		, residual_option_id			= accom.ResidualOptionID
		, residual_commission_end		= accom.ResidualCommissionEnd
		, initial_pymt_option_id		= accom.InitialPymtOptionID
		
		, sales_manager		= isnull(mu.Firstname, '') + ' ' + isnull(mu.Lastname, '')
		, rate_descp
		
		, PriceID = acr.PriceID 
		, Price = case when pr.ProductTypeid = 7 then pcpm.Price else pr.price end
		, c.ContractStatusID 
		, acr.ProductCrossPriceMultiId
		
		, a.AccountTypeID 
		, a.CustomerID
		, MarketID = a.RetailMktID
		, a.UtilityID
		, a.AccountNameID

		
	FROM #acct temp 
		JOIN LibertyPower.dbo.Account a (NOLOCK) ON a.AccountID = temp.AccountID
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = temp.ContractID
		JOIN LibertyPower.dbo.ContractType ct (NOLOCK) ON c.ContractTypeID = ct.ContractTypeID
		JOIN LibertyPower.dbo.ContractDealType cdt (NOLOCK) ON c.ContractDealTypeID = cdt.ContractDealTypeID
		JOIN LibertyPower.dbo.AccountType at (NOLOCK) ON at.ID = a.AccountTypeID 
		JOIN LibertyPower.dbo.vw_AccountContractRate acr (NOLOCK) ON acr.AccountContractID = temp.AccountContractID --AND acr.IsContractedRate = 1
		LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON temp.AccountContractID = s.AccountContractID
		LEFT JOIN LibertyPower.dbo.AccountUsage au (NOLOCK) ON a.AccountID = au.AccountID AND  c.StartDate = au.EffectiveDate
		LEFT JOIN LibertyPower.dbo.AccountContractCommission accom (NOLOCK) ON accom.AccountContractID = temp.AccountContractID
		--LEFT JOIN lp_account.dbo.account_name n (NOLOCK) ON a.accountNameId = n.accountNameId
		LEFT JOIN LibertyPower.dbo.Name n (NOLOCK) on a.accountNameid = n.nameid
		LEFT JOIN lp_commissions.dbo.vendor v (NOLOCK) on c.SalesChannelID = v.ChannelID
		LEFT JOIN LibertyPower.dbo.Market m (NOLOCK) ON m.ID = a.RetailMktID 
		LEFT JOIN LibertyPower.dbo.Utility u (NOLOCK) ON u.ID = a.UtilityID 
		LEFT JOIN lp_common.dbo.common_product p (NOLOCK) ON acr.LegacyProductID = p.product_id 
		LEFT JOIN lp_commissions.dbo.commission_review_request r (NOLOCK) ON r.Contract_nbr = c.Number
			and ( r.account_id = a.AccountIDLegacy or isnull(r.account_id, '') = '' )
			and (r.product_id = p.product_id  or isnull(r.product_id, '') = '' )
			and (r.rate_id = acr.rateid  or isnull(r.rate_id, 0) = 0 )
			and r.review_ind = 1 
		LEFT JOIN lp_account.dbo.enrollment_status es (NOLOCK) ON s.status = es.status
		LEFT JOIN LibertyPower.dbo.[User] mu (NOLOCK) ON c.SalesManagerID = mu.UserID
		LEFT JOIN lp_Common.dbo.common_product_rate cpr (NOLOCK) on cpr.product_id = acr.LegacyProductID AND  cpr.rate_id = acr.RateID
		LEFT JOIN LibertyPower.dbo.Price pr (NOLOCK) ON pr.id = acr.priceid
		LEFT JOIN LibertyPower.dbo.ProductCrossPriceMulti pcpm (NOLOCK) ON acr.ProductCrossPriceMultiId = pcpm.ProductCrossPriceMultiId

END 
GO

USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_detail_del_account_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_account_detail_del_account_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * usp_account_detail_del_account_sel

 * Get account detail from account table.
 
 * History

 *******************************************************************************

 * 8/10/2012 Gail Mangaroo.
 * Created.
 
 *******************************************************************************
 * 9/13/2012 Modified Gail Mangaroo 
 * Removed join with Pricing table
 * Used LibertyPower..Name table with 
 ******************************************************************************* 
 * Modified 9/14/2012 Gail Mangaroo 
 * Added ContractStatusID 
 *******************************************************************************
 * 9/26/2012 Gail Mangaroo
 * Modified 
 * Added check for all empty parameters
 *******************************************************************************
  exec usp_account_detail_del_account_sel '2009-0023409' , '', '90008363A'
  
 */
 
CREATE Procedure [dbo].[usp_account_detail_del_account_sel]
( 
@p_account_id varchar(30)
, @p_account_number varchar(30) = ''
, @p_contract_nbr varchar(30) = ''
, @p_vendor_system_name varchar(50) = ''
, @p_start_date datetime = null
, @p_end_date datetime = null
) 

AS 
BEGIN 

			--drop table #acct
			
			--DECLARE @p_account_id varchar(30)
			--DECLARE  @p_account_number varchar(30) 
			--DECLARE  @p_contract_nbr varchar(30) 
			--DECLARE  @p_vendor_system_name varchar(50)
			--DECLARE  @p_start_date datetime 
			--DECLARE  @p_end_date datetime 

			--SET @p_account_id = '' -- '2009-0023409'
			--SET @p_account_number = ''
			--SET @p_contract_nbr = '' -- '90008363A' 
			--SET @p_vendor_system_name = ''
			--SET @p_start_date = null 
			--SET @p_end_date = null 
			
	SET NOCOUNT ON

	CREATE TABLE #acct ( accountID int , contractID int , accountContractID int , startDate datetime , endDate datetime , zAuditAccountContractRateID int ) 
	
	DECLARE @strSql nvarchar(max ) 
	DECLARE @strWHERE nvarchar(max) 
	DECLARE @ParmDefinition NVARCHAR(500);
	
	SET @strWHERE = N''
	SET @ParmDefinition = N'
	 @p_account_id varchar(30)
	, @p_account_number varchar(30) 
	, @p_contract_nbr varchar(30) 
	, @p_vendor_system_name varchar(50) 
	, @p_start_date datetime 
	, @p_end_date datetime  
	'

	SET @strsQL = 
	'SELECT distinct a.AccountID
		, c.ContractID
		, acc.AccountContractID
		, startDate = (SELECT min(acs_start.startDate) 
								FROM LibertyPower.dbo.AccountService acs_start (NOLOCK) 
								WHERE  acs_start.account_id = a.AccountIDLegacy
									AND (acs_start.EndDate is null OR acs_start.EndDate = ''1/1/1900'' OR acs_start.EndDate >= c.SignedDate)
									AND acs_start.StartDate > ''1/1/1900''
							 )
		, endDate = isnull(( SELECT TOP 1 EndDate 
								from LibertyPower.dbo.AccountService (NOLOCK)
								WHERE account_id = a.AccountIDLegacy 
									AND (EndDate >= c.SignedDate OR EndDate is null OR EndDate = ''1/1/1900'')
								ORDER BY StartDate desc
							), ''1/1/1900'')
		
		, zAuditAccountContractRateID = max (zAuditAccountContractRateID ) 

	FROM LibertyPower.dbo.Account a (NOLOCK) 
		JOIN LibertyPower.dbo.zauditAccountContract acc (NOLOCK) ON a.AccountID = acc.AccountID
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = acc.ContractID
		JOIN lp_Commissions.dbo.vendor v (NOLOCK) ON v.ChannelID  = c.SalesChannelID
		JOIN LibertyPower.dbo.zauditAccountContractRate acr (NOLOCK) ON acr.AccountContractID = acc.AccountContractID AND acr.IsContractedRate = 1
	WHERE 1 = 1 '

	if ltrim(rtrim(isnull(@p_account_id, ''))) <> ''
		SET @strWHERE = @strWHERE + ' AND a.accountIDLegacy =  @p_account_id '

	if ltrim(rtrim(isnull(@p_contract_nbr, ''))) <> ''
		SET @strWHERE = @strWHERE + ' AND c.Number = @p_contract_nbr '
	
	if ltrim(rtrim(isnull(@p_account_number, ''))) <> ''
		SET @strWHERE = @strWHERE + ' AND a.accountNumber = @p_account_number '
		
	if ltrim(rtrim(isnull(@p_vendor_system_name, ''))) <> '' 
		SET @strWHERE = @strWHERE + ' AND ( v.vendor_system_name = @p_vendor_system_name  OR sc.channelname = @p_vendor_system_name) '
	
	if @p_start_date is not null
		SET @strWHERE = @strWHERE + ' AND c.SignedDate >= @p_start_date '
	
	if  @p_end_date is not null
		SET @strWHERE = @strWHERE + ' AND c.SignedDate <= @p_end_date '
	
	IF len(ltrim(@strWhere)) = 0 -- prevent returning dataset without setting parameters
		SET @strWhere = @strWhere + N' AND 1 = 0 '
	
	SET @strWHERE = @strWHERE + ' GROUP BY a.accountID , c.ContractID, acc.AccountContractID, a.AccountIDLegacy, c.SignedDate ' 


	SET @strsql = @strsql + @strWHERE
	
	INSERT INTO #acct 
	EXECUTE sp_executesql  @strsql 
		, @ParmDefinition 
		, 	@p_account_id = @p_account_id
		, 	@p_contract_nbr = @p_contract_nbr
		, 	@p_account_number = @p_account_number
		, 	@p_vendor_system_name = @p_vendor_system_name
		, 	@p_start_date = @p_start_date
		, 	@p_end_date = @p_end_date 

	SELECT  
		account_id			= a.AccountIDLegacy
		, account_number	= a.AccountNumber
		, full_name			= n.Name
		, date_deal			= DATEADD(dd,0, DATEDIFF(dd,0,c.SignedDate)) 
		, requested_flow_start_date = c.SignedDate   --a.requested_flow_start_date
		, date_end			= c.EndDate
		, date_start		= c.StartDate
		, sales_rep			= c.salesRep
		, annual_usage		= isnull(au.annualUsage, 0)
		, [status]			= LTRIM(RTRIM(s.Status))
		, sub_status		= LTRIM(RTRIM(s.SubStatus))
		, contract_nbr		= c.Number
		, retail_mkt_id		= m.MarketCode
		, utility_id		= u.UtilityCode
		, term_months		= acr.Term
		, product_id		= acr.LegacyProductID
		, sales_channel_role = v.vendor_system_name
		, vendor_id			= v.vendor_id
		, rate				= acr.Rate
		, rate_id			= acr.RateId 
		, date_flow_start	= temp.StartDate
		, date_deenrolled	= temp.EndDate
		, contract_type		= ct.type + ' ' + cdt.DealType 
		, ContractDealTypeID = c.ContractDealTypeID
		, contract_eff_start_date = acr.RateStart 
		, p.product_descp
		, renewal			=  case when c.ContractDealTypeID = 2 then 1 else 0 end
		, review_ind		= r.review_ind 
		, review_id			= r.commission_review_id 
		, account_type		= at.AccountType
		, status_descp		= es.status_descp 
		
		, evergreen_option_id			= accom.EvergreenOptionID
		, evergreen_commission_end		= accom.evergreenCommissionEnd
		, evergreen_commission_rate		= accom.evergreenCommissionRate   
		, residual_option_id			= accom.ResidualOptionID
		, residual_commission_end		= accom.ResidualCommissionEnd
		, initial_pymt_option_id		= accom.InitialPymtOptionID
		
		, sales_manager		= isnull(mu.Firstname, '') + ' ' + isnull(mu.Lastname, '')
		, rate_descp
		
		, PriceID = acr.PriceID 
		, Price = case when pr.ProductTypeid = 7 then pcpm.Price else pr.price end
		, c.ContractStatusID 
		, acr.ProductCrossPriceMultiId
		
		, a.AccountTypeID 
		, a.CustomerID
		, MarketID = a.RetailMktID
		, a.UtilityID
		, a.AccountNameID
		
	FROM #acct temp 
		JOIN LibertyPower.dbo.Account a (NOLOCK) ON a.AccountID = temp.AccountID
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = temp.ContractID
		JOIN LibertyPower.dbo.ContractType ct (NOLOCK) ON c.ContractTypeID = ct.ContractTypeID
		JOIN LibertyPower.dbo.ContractDealType cdt (NOLOCK) ON c.ContractDealTypeID = cdt.ContractDealTypeID
		JOIN LibertyPower.dbo.AccountType at (NOLOCK) ON at.ID = a.AccountTypeID 
		LEFT JOIN LibertyPower.dbo.zAuditAccountContractRate acr (NOLOCK) on acr.zAuditAccountContractRateID = temp.zAuditAccountContractRateID
		LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON temp.AccountContractID = s.AccountContractID
		LEFT JOIN LibertyPower.dbo.AccountUsage au (NOLOCK) ON a.AccountID = au.AccountID AND  c.StartDate = au.EffectiveDate
		LEFT JOIN LibertyPower.dbo.AccountContractCommission accom (NOLOCK) ON accom.AccountContractID = temp.AccountContractID
		-- LEFT JOIN lp_account.dbo.account_name n (NOLOCK) ON a.accountNameId = n.accountNameId
		LEFT JOIN LibertyPower.dbo.Name n (NOLOCK) on a.accountNameid = n.nameid
		LEFT JOIN lp_commissions.dbo.vendor v (NOLOCK) on c.SalesChannelID = v.ChannelID
		LEFT JOIN LibertyPower.dbo.Market m (NOLOCK) ON m.ID = a.RetailMktID 
		LEFT JOIN LibertyPower.dbo.Utility u (NOLOCK) ON u.ID = a.UtilityID 
		LEFT JOIN lp_common.dbo.common_product p (NOLOCK) ON acr.LegacyProductID = p.product_id 
		LEFT JOIN lp_commissions.dbo.commission_review_request r (NOLOCK) ON r.Contract_nbr = c.Number
			and ( r.account_id = a.AccountIDLegacy or isnull(r.account_id, '') = '' )
			and (r.product_id = p.product_id  or isnull(r.product_id, '') = '' )
			and (r.rate_id = acr.rateid  or isnull(r.rate_id, 0) = 0 )
			and r.review_ind = 1 
		LEFT JOIN lp_account.dbo.enrollment_status es (NOLOCK) ON s.status = es.status
		LEFT JOIN LibertyPower.dbo.[User] mu (NOLOCK) ON c.SalesManagerID = mu.UserID
		LEFT JOIN lp_Common.dbo.common_product_rate cpr (NOLOCK) on cpr.product_id = acr.LegacyProductID AND  cpr.rate_id = acr.RateID
		LEFT JOIN LibertyPower.dbo.Price pr (NOLOCK) ON pr.id = acr.priceid
		LEFT JOIN LibertyPower.dbo.ProductCrossPriceMulti pcpm (NOLOCK) ON acr.ProductCrossPriceMultiId = pcpm.ProductCrossPriceMultiId

	
END 
GO 


USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_detail_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_account_detail_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 7/8/2008
-- Description:	Get account detail
-- =============================================
-- Modified: 6/2/2010 Gail Mangaroo 
-- Added account override fields
-- =============================================
-- Modified: 12/6/2011 Gail Mangaroo
-- Modified 
-- Added ufn_account_detail_historical_sel to get account_name
-- ============================================
-- Modified: 12/13/2011 Gail Mangaroo -- prod 1/28/2012
-- Switch from lp_account.dbo.account to LibertyPower.dbo.Account
-- ============================================
-- Modified: 2/8/2012 Gail Mangaroo 
-- Fixed FlowStart and DeEnrollment sub queries
-- ============================================
-- Modified 2/21/2012 Gail Mangaroo 
-- Removed @p_account_number param and modified for effeciency
-- Added rate_desc 
-- ============================================
-- Modified 3/1/2012 Gail Mangaroo 
-- Added Account Type ID
-- ============================================
-- Modiifed 3/8/2012 Gail Mangaroo
-- Added MarketID 
-- ============================================
-- Modified 8/14/2012 Gail Mangaroo 
-- Changed join with Account status and added Price
-- ============================================
-- exec usp_account_detail_sel '2009-0023409' , '90008363A'
-- ============================================
-- Modified 9/14/2012 Gail Mangaroo 
-- Use LIbertyPower..Name
-- Added ContractStatusID 
-- ============================================
-- 11/28/2012 Gail Mangaroo 
-- Added additional fields and multi_rate price
-- ============================================

CREATE PROC  [dbo].[usp_account_detail_sel] 
( 
@p_account_id varchar(30)
, @p_contract_nbr varchar(30) = ''
) 

AS 
BEGIN 
	SET NOCOUNT ON

	SELECT distinct a.AccountID
		, c.ContractID
		, acc.AccountContractID
		, a.AccountIDLegacy
		, c.SignedDate 
		, startDate = (SELECT min(acs_start.startDate) 
								FROM LibertyPower.dbo.AccountService acs_start (NOLOCK) 
								WHERE  acs_start.account_id = a.AccountIDLegacy
									AND (acs_start.EndDate is null OR acs_start.EndDate = '1/1/1900' OR acs_start.EndDate >= c.SignedDate)
									AND acs_start.StartDate > '1/1/1900'
							 )
		, endDate = isnull(( SELECT TOP 1 EndDate 
								from LibertyPower.dbo.AccountService (NOLOCK)
								WHERE account_id = a.AccountIDLegacy 
									AND (EndDate >= c.SignedDate OR EndDate is null OR EndDate = '1/1/1900')
								ORDER BY StartDate desc
							), '1/1/1900')
							
	INTO #acct
	FROM LibertyPower.dbo.Account a (NOLOCK) 
		JOIN LibertyPower.dbo.AccountContract acc (NOLOCK) ON a.AccountID = acc.AccountID
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = acc.ContractID
	WHERE a.accountIDLegacy = @p_account_id 
		AND c.Number = @p_contract_nbr 
		
		
	SELECT  
		account_id			= a.AccountIDLegacy
		, account_number	= a.AccountNumber
		, full_name			= n.name
		, date_deal			= DATEADD(dd,0, DATEDIFF(dd,0,c.SignedDate)) 
		, requested_flow_start_date = c.SignedDate   --a.requested_flow_start_date
		, date_end			= c.EndDate
		, date_start		= c.StartDate
		, sales_rep			= c.salesRep
		, annual_usage		= isnull(au.annualUsage, 0)
		, [status]			= LTRIM(RTRIM(s.Status))
		, sub_status		= LTRIM(RTRIM(s.SubStatus))
		, contract_nbr		= c.Number
		, retail_mkt_id		= m.MarketCode
		, utility_id		= u.UtilityCode
		, term_months		= acr.Term
		, product_id		= acr.LegacyProductID
		, sales_channel_role	= v.vendor_system_name
		, vendor_id			= v.vendor_id
		, rate				= acr.Rate
		, rate_id			= acr.RateId 
		, date_flow_start	= temp.StartDate
		, date_deenrolled	= temp.EndDate
		, contract_type		= ct.type + ' ' + cdt.DealType 
		, ContractDealTypeID = c.ContractDealTypeID
		, contract_eff_start_date = acr.RateStart 
		, p.product_descp
		, renewal			=  case when c.ContractDealTypeID = 2 then 1 else 0 end
		, review_ind		= r.review_ind 
		, review_id			= r.commission_review_id 
		, account_type		= at.AccountType
		, status_descp		= es.status_descp 
		
		, evergreen_option_id			= accom.EvergreenOptionID
		, evergreen_commission_end		= accom.evergreenCommissionEnd
		, evergreen_commission_rate		= accom.evergreenCommissionRate   
		, residual_option_id			= accom.ResidualOptionID
		, residual_commission_end		= accom.ResidualCommissionEnd
		, initial_pymt_option_id		= accom.InitialPymtOptionID
		
		, sales_manager		= isnull(mu.Firstname, '') + ' ' + isnull(mu.Lastname, '')
		, rate_descp

		, PriceID = acr.PriceID 
		, Price = case when pr.ProductTypeid = 7 then pcpm.Price else pr.price end
		, c.ContractStatusID 
		, acr.ProductCrossPriceMultiId
		
		, a.AccountTypeID 
		, a.CustomerID
		, MarketID = a.RetailMktID
		, a.UtilityID
		, a.AccountNameID
				
	FROM #acct temp 
		JOIN LibertyPower.dbo.Account a (NOLOCK) ON a.AccountID = temp.AccountID
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = temp.ContractID
		JOIN LibertyPower.dbo.ContractType ct (NOLOCK) ON c.ContractTypeID = ct.ContractTypeID
		JOIN LibertyPower.dbo.ContractDealType cdt (NOLOCK) ON c.ContractDealTypeID = cdt.ContractDealTypeID
		JOIN LibertyPower.dbo.AccountType at (NOLOCK) ON at.ID = a.AccountTypeID 
		JOIN LibertyPower.dbo.vw_AccountContractRate acr (NOLOCK) ON acr.AccountContractID = temp.AccountContractID --AND acr.IsContractedRate = 1
		LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON temp.AccountContractID = s.AccountContractID
		LEFT JOIN LibertyPower.dbo.AccountUsage au (NOLOCK) ON a.AccountID = au.AccountID AND  c.StartDate = au.EffectiveDate
		LEFT JOIN LibertyPower.dbo.AccountContractCommission accom (NOLOCK) ON accom.AccountContractID = temp.AccountContractID
		--LEFT JOIN lp_account.dbo.account_name n (NOLOCK) ON a.accountNameId = n.accountNameId
		LEFT JOIN LibertyPower.dbo.Name n (NOLOCK) on a.accountNameid = n.nameid
		LEFT JOIN lp_commissions.dbo.vendor v (NOLOCK) on c.SalesChannelID = v.ChannelID
		LEFT JOIN LibertyPower.dbo.Market m (NOLOCK) ON m.ID = a.RetailMktID 
		LEFT JOIN LibertyPower.dbo.Utility u (NOLOCK) ON u.ID = a.UtilityID 
		LEFT JOIN lp_common.dbo.common_product p (NOLOCK) ON acr.LegacyProductID = p.product_id 
		LEFT JOIN lp_commissions.dbo.commission_review_request r (NOLOCK) ON r.Contract_nbr = c.Number
			and ( r.account_id = a.AccountIDLegacy or isnull(r.account_id, '') = '' )
			and (r.product_id = p.product_id  or isnull(r.product_id, '') = '' )
			and (r.rate_id = acr.rateid  or isnull(r.rate_id, 0) = 0 )
			and r.review_ind = 1 
		LEFT JOIN lp_account.dbo.enrollment_status es (NOLOCK) ON s.status = es.status
		LEFT JOIN LibertyPower.dbo.[User] mu (NOLOCK) ON c.SalesManagerID = mu.UserID
		LEFT JOIN lp_Common.dbo.common_product_rate cpr (NOLOCK) on cpr.product_id = acr.LegacyProductID AND  cpr.rate_id = acr.RateID
		LEFT JOIN LibertyPower.dbo.Price pr (NOLOCK) ON pr.id = acr.priceid
		LEFT JOIN LibertyPower.dbo.ProductCrossPriceMulti pcpm (NOLOCK) ON acr.ProductCrossPriceMultiId = pcpm.ProductCrossPriceMultiId

END
GO


USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_detail_zaudit_account_renewal_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_account_detail_zaudit_account_renewal_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_account_detail_zaudit_account_renewal_sel
 * Get account detail from zAduit_account table.
 * History
 *******************************************************************************
 * 5/22/2009 Gail Mangaroo.
 * Created.
 *******************************************************************************
 * Modified: 6/2/2010 Gail Mangaroo 
 * Added account override fields
  
 * 12/6/2011 Gail Mangaroo
 * Modified 
 * Added ufn_account_detail_historical_sel to get account_name
 *******************************************************************************
  * 8/14/2012 Gail Mangaroo 
 * Add additional fields and optimize
 ******************************************************************************* 
 * 9/17/2012 Gail Mangaroo	
 * Add ContractStatusID
 *******************************************************************************
 * 9/26/2012 Gail Mangaroo
 * Modified 
 * Added check for all empty parameters
 *******************************************************************************
  exec usp_account_detail_zaudit_account_renewal_sel '2009-0023409' , '', '90008362A'
  
 */
CREATE Procedure [dbo].[usp_account_detail_zaudit_account_renewal_sel]
( 
@p_account_id varchar(30)
, @p_account_number varchar(30) = ''
, @p_contract_nbr varchar(30) = ''
, @p_vendor_system_name varchar(50) = ''
, @p_start_date datetime = null
, @p_end_date datetime = null
, @p_status varchar(50) = null 
, @p_sub_status varchar(50) = null 
) 

AS 
BEGIN 
	SET NOCOUNT ON

			--drop table #Audit_Account
			
			--DECLARE @p_account_id varchar(30)
			--DECLARE  @p_account_number varchar(30) 
			--DECLARE  @p_contract_nbr varchar(30) 
			--DECLARE  @p_vendor_system_name varchar(50)
			--DECLARE  @p_start_date datetime 
			--DECLARE  @p_end_date datetime 
			--DECLARE  @p_status varchar(50) 
			--DECLARE  @p_sub_status varchar(50) 

			--SET @p_account_id =  '' --'2009-0023409'
			--SET @p_account_number = ''
			--SET @p_contract_nbr = '' --  '90008362A' 
			--SET @p_vendor_system_name = ''
			--SET @p_start_date = null 
			--SET @p_end_date = null 
			--SET  @p_status  = null 
			--SET  @p_sub_status = null 
			
	DECLARE @strSQL nvarchar(max) 
	DECLARE @strSELECT varchar(max) 
	DECLARE @strWHERE varchar(max) 
	DECLARE @rowCount int 
	DECLARE @zAudit_account_id varchar(50) 

	CREATE TABLE #Audit_Account (zaudit_account_id int, account_id varchar(50)) 
		
	DECLARE @ParmDefinition NVARCHAR(500);
	SET @ParmDefinition = N'
	 @p_account_id varchar(30)
	, @p_account_number varchar(30) 
	, @p_contract_nbr varchar(30) 
	, @p_vendor_system_name varchar(50) 
	, @p_start_date datetime 
	, @p_end_date datetime 
	, @p_status varchar(50)
	, @p_sub_status varchar(50) '
	
	SET @strSELECT = 
	'SELECT max(zaudit_account_id), account_id 			
		FROM lp_account.dbo.zAudit_account_renewal a (NOLOCK)
		WHERE 1 = 1 '

	SET @strWHERE = ''
				
	IF ltrim(rtrim(isnull(@p_account_id, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere	+ N' AND a.account_id = @p_account_id'
	END 
	
	IF ltrim(rtrim(isnull(@p_contract_nbr, ''))) <> ''
	BEGIN
		SET @strWhere = @strWhere + N' AND a.contract_nbr = @p_contract_nbr '
	END
	
	IF ltrim(rtrim(isnull(@p_account_number, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.account_number = @p_account_number '
	END 
	
	IF ltrim(rtrim(isnull(@p_vendor_system_name, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.sales_channel_role = @p_vendor_system_name '
	END 
	
	IF @p_start_date is not null 
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.date_deal >=  @p_start_date '
	END 
	
	IF @p_end_date is not null 
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.date_deal <=  @p_end_date '
	END 
	
	IF ltrim(rtrim(isnull(@p_status, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.[Status] = @p_status '
	END 
	
	IF ltrim(rtrim(isnull(@p_sub_status, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.[sub_status] = @p_sub_status '
	END 

	IF len(ltrim(@strWhere)) = 0 -- prevent returning dataset without setting parameters
		SET @strWhere = @strWhere + N' AND 1 = 0 '
	
	-- Get zaudit account id 
	SET @strSQL = @strSELECT + @strWhere  + ' GROUP BY account_id '
	
	INSERT INTO #Audit_Account
	EXECUTE sp_executesql  @strSQL 
	, 	@ParmDefinition
	, 	@p_account_id = @p_account_id
	, 	@p_contract_nbr = @p_contract_nbr
	, 	@p_account_number = @p_account_number
	, 	@p_vendor_system_name = @p_vendor_system_name
	, 	@p_start_date = @p_start_date
	, 	@p_end_date = @p_end_date
	,   @p_status = @p_status
    ,   @p_sub_status = @p_sub_status
	
	SELECT 
		account_id			= a.account_id
		, account_number	= a.account_number
		, full_name			= (SELECT TOP 1 full_name FROM lp_commissions.dbo.[ufn_account_detail_historical] (a.account_id, a.contract_nbr) )
		, date_deal			= DATEADD(dd,0, DATEDIFF(dd,0,a.date_deal)) 
		, date_start		= a.contract_eff_start_date 
		, requested_flow_start_date = '1/1/1900'
		, date_end			= a.date_end
		, sales_rep			= a.sales_rep
		, annual_usage		= isnull(a.annual_usage, 0)
		, [status]			= LTRIM(RTRIM(a.status))
		, sub_status		= LTRIM(RTRIM(a.sub_status))
		, contract_nbr		= a.contract_nbr
		, retail_mkt_id		= a.retail_mkt_id
		, utility_id		= a.utility_id
		, term_months		= a.term_months
		, product_id		= a.product_id
		, sales_channel_role = a.sales_channel_role 
		, vendor_id			= v.vendor_id
		, rate				= a.rate
		, rate_id			= a.rate_id 
		, date_flow_start	= a.date_flow_start
		, date_deenrolled	= a.date_deenrollment
		, contract_type		= a.contract_type 
		, contractDealTypeID = case when account_type like '%RENEW%' then 2 else 1 end
		, contract_eff_start_date = a.contract_eff_start_date 
		, p.product_descp
		, renewal			=  case when account_type like '%RENEW%' then 1 else 0 end 	
		, review_ind		= r.review_ind 
		, review_id			= r.commission_review_id 
		, account_type		= a.account_type
		, status_descp		= es.status_descp 

		, a.[evergreen_option_id]
		, a.[evergreen_commission_end]
		, a.[residual_option_id]
		, a.[residual_commission_end]
		, a.[initial_pymt_option_id]
		, a.[evergreen_commission_rate] 
		
		, a.[sales_manager]
		, cpr.rate_descp
		
		, PriceID = 0 
		, Price = 0 
		, ContractStatusID = 0 
		, ProductCrossPriceMultiId = 0 
		
		, AccountTypeID  = 0
		, CustomerID = 0
		, MarketID = m.ID 
		, UtilityID = 0
		, AccountNameID = 0
		
	FROM lp_account.dbo.zAudit_account_renewal a (NOLOCK)
		JOIN #Audit_Account aa (NOLOCK) on aa.zaudit_account_id = a.zaudit_account_id 
		LEFT OUTER JOIN lp_commissions.dbo.vendor v (NOLOCK) on a.sales_channel_role = v.vendor_system_name
		JOIN lp_common.dbo.common_product p (NOLOCK) ON a.product_id = p.product_id 
		LEFT OUTER JOIN lp_commissions.dbo.commission_review_request r (NOLOCK) ON r.contract_nbr = a.contract_nbr and r.product_id = a.product_id and r.rate_id = a.rate_id 
		LEFT OUTER JOIN lp_account.dbo.enrollment_status es (NOLOCK) on a.status = es.status
		LEFT OUTER JOIN lp_common.dbo.common_product_rate cpr (NOLOCK) on cpr.product_id = a.product_id and cpr.rate_id = a.rate_id 
		LEFT OUTER JOIN LibertyPower.dbo.accountType act (NOLOCK) on act.AccountType = a.account_type 
		JOIN LibertyPower.dbo.Market m (NOLOCK) on a.retail_mkt_id = m.marketcode and m.inactiveind = 0

END 
GO 


USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_detail_zaudit_account_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_account_detail_zaudit_account_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * usp_account_detail_zaudit_account_sel
 * Get account detail from zAduit_account table.
 * History
 *******************************************************************************
 * 1/22/2009 Gail Mangaroo.
 * Created.
 * 5/22/2009 Modified to return a single record for each account id found
 *******************************************************************************
 * Modified 1/28/2010 - Added Status / Sub_Status params
 *******************************************************************************
 * Modified: 6/2/2010 Gail Mangaroo 
 * Added account override fields
 *******************************************************************************
 * 12/6/2011 Gail Mangaroo
 * Modified 
 * Added ufn_account_detail_historical_sel to get account_name
 *******************************************************************************
 * 8/14/2012 Gail Mangaroo 
 * Add additional fields and optimize
 ******************************************************************************* 
 * 9/17/2012 Gail Mangaroo
 * Add ContractStatusID 
 *******************************************************************************
 * 9/26/2012 Gail Mangaroo
 * Modified 
 * Added check for all empty parameters
 *******************************************************************************
 exec usp_account_detail_zaudit_account_sel '2009-0023409' , '', '90008362A'
 */
 
CREATE Procedure [dbo].[usp_account_detail_zaudit_account_sel]
( 
@p_account_id varchar(30)
, @p_account_number varchar(30) = ''
, @p_contract_nbr varchar(30) = ''
, @p_vendor_system_name varchar(50) = ''
, @p_start_date datetime = null
, @p_end_date datetime = null
, @p_status varchar(50) = null 
, @p_sub_status varchar(50) = null 
) 

AS 
BEGIN 

			--drop table #Audit_Account
			
			--DECLARE @p_account_id varchar(30)
			--DECLARE  @p_account_number varchar(30) 
			--DECLARE  @p_contract_nbr varchar(30) 
			--DECLARE  @p_vendor_system_name varchar(50)
			--DECLARE  @p_start_date datetime 
			--DECLARE  @p_end_date datetime 
			--DECLARE  @p_status varchar(50) 
			--DECLARE  @p_sub_status varchar(50) 

			--SET @p_account_id = '' --  '2009-0023409'
			--SET @p_account_number = ''
			--SET @p_contract_nbr = '' -- '90008362A' 
			--SET @p_vendor_system_name = ''
			--SET @p_start_date = null 
			--SET @p_end_date = null 
			--SET  @p_status  = null 
			--SET  @p_sub_status = null 

	SET NOCOUNT ON

	DECLARE @strSQL nvarchar(max) 
	DECLARE @strSELECT varchar(max) 
	DECLARE @strWHERE varchar(max) 
	DECLARE @rowCount int 
	DECLARE @zAudit_account_id varchar(50) 

	CREATE TABLE #Audit_Account (zaudit_account_id int, account_id varchar(50)) 
		
	DECLARE @ParmDefinition NVARCHAR(500);
	SET @ParmDefinition = N'
	 @p_account_id varchar(30)
	, @p_account_number varchar(30) 
	, @p_contract_nbr varchar(30) 
	, @p_vendor_system_name varchar(50) 
	, @p_start_date datetime 
	, @p_end_date datetime  
	, @p_status varchar(50)
	, @p_sub_status varchar(50) '
	
	SET @strSELECT = 
	'SELECT max(zaudit_account_id), account_id 			
		FROM lp_account.dbo.zAudit_account a (NOLOCK)
		WHERE 1 = 1 '

	SET @strWHERE = ''
				
	IF ltrim(rtrim(isnull(@p_account_id, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere	+ N' AND a.account_id = @p_account_id'
	END 
	
	IF ltrim(rtrim(isnull(@p_contract_nbr, ''))) <> ''
	BEGIN
		SET @strWhere = @strWhere + N' AND a.contract_nbr = @p_contract_nbr '
	END
	
	IF ltrim(rtrim(isnull(@p_account_number, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.account_number = @p_account_number '
	END 
	
	IF ltrim(rtrim(isnull(@p_vendor_system_name, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.sales_channel_role = @p_vendor_system_name '
	END 
	
	IF @p_start_date is not null 
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.date_deal >=  @p_start_date '
	END 
	
	IF @p_end_date is not null 
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.date_deal <=  @p_end_date '
	END 
	
	IF ltrim(rtrim(isnull(@p_status, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.[Status] = @p_status '
	END 
	
	IF ltrim(rtrim(isnull(@p_sub_status, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.[sub_status] = @p_sub_status '
	END 
	
	IF len(ltrim(@strWhere)) = 0 -- prevent returning dataset without setting parameters
		SET @strWhere = @strWhere + N' AND 1 = 0 '
		
	-- Get zaudit account id 
	SET @strSQL = @strSELECT + @strWhere  + ' GROUP BY account_id '
	
	INSERT INTO #Audit_Account
	EXECUTE sp_executesql  @strSQL 
	, 	@ParmDefinition
	, 	@p_account_id = @p_account_id
	, 	@p_contract_nbr = @p_contract_nbr
	, 	@p_account_number = @p_account_number
	, 	@p_vendor_system_name = @p_vendor_system_name
	, 	@p_start_date = @p_start_date
	, 	@p_end_date = @p_end_date
	,   @p_status = @p_status
    ,   @p_sub_status = @p_sub_status
	
	SELECT distinct 
		account_id			= a.account_id
		, account_number	= a.account_number
		, full_name			= (SELECT TOP 1 full_name FROM lp_commissions.dbo.[ufn_account_detail_historical] (a.account_id, a.contract_nbr) )
		, date_deal			= DATEADD(dd,0, DATEDIFF(dd,0,a.date_deal)) 
		, date_start		= a.contract_eff_start_date 
		, requested_flow_start_date = '1/1/1900'
		, date_end			= a.date_end
		, sales_rep			= a.sales_rep
		, annual_usage		= isnull(a.annual_usage, 0)
		, [status]			= LTRIM(RTRIM(a.status))
		, sub_status		= LTRIM(RTRIM(a.sub_status))
		, contract_nbr		= a.contract_nbr
		, retail_mkt_id		= a.retail_mkt_id
		, utility_id		= a.utility_id
		, term_months		= a.term_months
		, product_id		= a.product_id
		, sales_channel_role = a.sales_channel_role 
		, vendor_id			= v.vendor_id
		, rate				= a.rate
		, rate_id			= a.rate_id 
		, date_flow_start	= a.date_flow_start
		, date_deenrolled	= a.date_deenrollment
		, contract_type		= a.contract_type 
		, contractDealTypeID = case when account_type like '%RENEW%' then 2 else 1 end
		, contract_eff_start_date = a.contract_eff_start_date 
		, p.product_descp
		, renewal			=  case when account_type like '%RENEW%' then 1 else 0 end 	
		, review_ind		= r.review_ind 
		, review_id			= r.commission_review_id 
		, account_type		= a.account_type
		, status_descp		= es.status_descp 

		, a.[evergreen_option_id]
		, a.[evergreen_commission_end]
		, a.[residual_option_id]
		, a.[residual_commission_end]
		, a.[initial_pymt_option_id]
		, a.[evergreen_commission_rate] 
	
		, a.sales_manager
		, cpr.rate_descp
				
		, PriceID = 0 
		, Price = 0 
		, ContractStatusID = 0 
		, ProductCrossPriceMultiId = 0 
		
		, AccountTypeID  = 0
		, CustomerID = 0
		, MarketID = m.ID
		, UtilityID = 0
		, AccountNameID = 0
		
	FROM lp_account.dbo.zAudit_account a (NOLOCK)
		JOIN #Audit_Account aa (NOLOCK) on aa.zaudit_account_id = a.zaudit_account_id 
		LEFT OUTER JOIN lp_commissions.dbo.vendor v (NOLOCK) on a.sales_channel_role = v.vendor_system_name
		JOIN lp_common.dbo.common_product p (NOLOCK) ON a.product_id = p.product_id 
		LEFT OUTER JOIN lp_commissions.dbo.commission_review_request r (NOLOCK) ON r.contract_nbr = a.contract_nbr and r.product_id = a.product_id and r.rate_id = a.rate_id 
		LEFT OUTER JOIN lp_account.dbo.enrollment_status es (NOLOCK) on a.status = es.status
		LEFT OUTER JOIN lp_common.dbo.common_product_rate cpr (NOLOCK) on cpr.product_id = a.product_id and cpr.rate_id = a.rate_id 
		LEFT OUTER JOIN LibertyPower.dbo.accountType act (NOLOCK) on act.AccountType = a.account_type 
		JOIN LibertyPower.dbo.Market m (NOLOCK) on a.retail_mkt_id = m.marketcode and m.inactiveind = 0
	
END 
GO 



USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_compensation_package_ins]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_compensation_package_ins]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * [usp_compensation_package_ins]
 * Insert row into [compensation_package] table.
 * History
 *******************************************************************************
 * 10/2012 Gail Mangaroo.
 * Created.
 *******************************************************************************
 */
CREATE PROC [dbo].[usp_compensation_package_ins] 

@p_package_name varchar(150)
, @p_package_descp varchar(max)
, @p_status_id int
, @p_start_date datetime 
, @p_end_date datetime 
, @p_username varchar(150)
 

AS 
BEGIN 

	INSERT INTO [Lp_commissions].[dbo].[compensation_package]
           ([package_name]
           ,[package_descp]
           ,[status_id]
           ,[start_date]
           ,[end_date]
           ,[username]
           ,[date_created]
         )
     
     SELECT
           @p_package_name
			, @p_package_descp
			, @p_status_id
			, @p_start_date
			, @p_end_date
			, @p_username 
			, GETDATE()
			
	RETURN ISNULL(Scope_Identity(), 0)

END 

GO

USE [Lp_commissions]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_compensation_package_sel_by_id]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_compensation_package_sel_by_id]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * [usp_compensation_package_sel_by_id]
 * Get data row from [compensation_package] table.
 * History
 *******************************************************************************
 * 10/2012 Gail Mangaroo.
 * Created.
 *******************************************************************************
 */
CREATE PROC [dbo].[usp_compensation_package_sel_by_id]
(@p_package_id int)
AS 
BEGIN

 SELECT [package_id]
      ,[package_name]
      ,[package_descp]
      ,[status_id]
      ,[start_date]
      ,[end_date]
      ,[username]
      ,[date_created]
      ,[modified_by]
      ,[date_modified]
  FROM [Lp_commissions].[dbo].[Compensation_Package] (NOLOCK)
  WHERE package_id = @p_package_id

END 

GO


USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_compensation_package_sel_list]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_compensation_package_sel_list] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * [usp_compensation_package_sel_list]
 * Get all rows from [compensation_package] table.
 * History
 *******************************************************************************
 * 10/2012 Gail Mangaroo.
 * Created.
 *******************************************************************************
 */
CREATE PROC [dbo].[usp_compensation_package_sel_list] 
AS 
BEGIN

 SELECT [package_id]
      ,[package_name]
      ,[package_descp]
      ,[status_id]
      ,[start_date]
      ,[end_date]
      ,[username]
      ,[date_created]
      ,[modified_by]
      ,[date_modified]
  FROM [Lp_commissions].[dbo].[Compensation_Package] (NOLOCK) 
  
END 

GO


USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_compensation_package_upd]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_compensation_package_upd]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * [usp_compensation_package_upd]
 * Update [compensation_package] table.
 * History
 *******************************************************************************
 * 10/2012 Gail Mangaroo.
 * Created.
 *******************************************************************************
 */
CREATE PROC [dbo].[usp_compensation_package_upd]
@p_package_id int 
, @p_package_name varchar(150)
, @p_package_descp varchar(max)
, @p_status_id int
, @p_start_date datetime 
, @p_end_date datetime 
, @p_username varchar(150)
 

AS 
BEGIN 

UPDATE [Lp_commissions].[dbo].[compensation_package]
   SET [package_name] = @p_package_name
      ,[package_descp] = @p_package_descp
      ,[status_id] = @p_status_id
      ,[start_date] = @p_start_date
      ,[end_date] = @p_end_date
      
      ,[modified_by] = @p_username
      ,[date_modified] = getdate()
 WHERE package_id = @p_package_id
 
 RETURN @@ROWCOUNT
 END 

GO


USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_date_interval_type_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_date_interval_type_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 9/18/2012
-- Description:	Return list of interval types.
-- =============================================
CREATE PROCEDURE [dbo].[usp_date_interval_type_sel] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [interval_id]
      ,[interval_code]
      ,[interval_description]

	FROM [Lp_commissions].[dbo].[date_interval] (NOLOCK)

END
GO

USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_param_operator_sel_list]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_param_operator_sel_list]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 9/18/2012
-- Description:	Return list of interval types.
-- =============================================
CREATE PROC [dbo].[usp_param_operator_sel_list] 
AS 
BEGIN 

	SELECT [param_operator_id]
		  ,[param_operator_code]
		  ,[param_operator_descp]
	FROM [Lp_commissions].[dbo].[param_operator] (NOLOCK) 

END 

GO

USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_processor_estimate_accounts_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_processor_estimate_accounts_sel]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 1/26/2011
-- Description:	Get accounts that require commission estimates
-- =============================================
-- Modified: 5/5/2011 Gail Mangaroo 
-- include accounts that need refreshed estimates
-- =============================================
-- Modified: 1/12/2012 Gail Mangaroo
-- Refresh when rate = 0 or rate is different in transaction_detail 
-- =============================================
-- Modified:1/17/2012 Gail Mangaroo 
-- Correct renewal acct condition
-- =============================================
-- Modified 2/3/2012 Gail Mangarpp 
-- Aletered to use new LibertyPower..Account structure 
-- rename sp 
-- =============================================
-- MOdified 12/10/2012 Gail Mangaroo
-- Compare estimates against account data
-- =============================================
CREATE Procedure [dbo].[usp_processor_estimate_accounts_sel]
(@p_start_date datetime =  null ) 

AS
BEGIN 
		-- default 1 month
		--declare @p_start_date datetime 
		SELECT @p_start_date = isnull(@p_start_date, dateadd(month , -2, getdate()) )
		
		SELECT DISTINCT account_id, contract_nbr, vendor_id, estimate_id, rate, base_amount, amount, comm_rate, comm_base_amount, comm_amt 
		FROM 
		(
			SELECT account_id = ac.accountIdLegacy
				, contract_nbr = cn.Number
				, rate = isnull(e.rate, 0) 
				, v.vendor_id
				, e.estimate_id 
				, comm_rate = isnull(d.rate, 0) 
				, e.amount 
				, comm_amt = isnull(d.amount, 0) 
				, e.base_amount
				, comm_base_amount = isnull(d.base_amount, 0)
			
			FROM LibertyPower..Account ac (NOLOCK) 
				JOIN LibertyPower..AccountContract acn (NOLOCK) ON acn.AccountID = ac.AccountID 
				JOIN LibertyPower..Contract cn (NOLOCK) ON cn.ContractID = acn.ContractID 
				--JOIN LibertyPower..SalesChannel sc (NOLOCK) ON sc.ChannelID = cn.SalesChannelID
				JOIN lp_commissions..vendor v (NOLOCK) ON cn.SalesChannelID = v.ChannelID 
				JOIN LibertyPower..SalesChannelAccountType scat (NOLOCK) on scat.ChannelID = cn.SalesChannelID 
					AND scat.AccountTypeID = ac.AccountTypeID
					AND scat.MarketID = ac.RetailMktID
				JOIN LibertyPower..AccountContractRate acr (NOLOCK)  on acn.accountContractId = acr.AccountContractId 
					AND isContractedRate = 1
				JOIN LibertyPower..AccountUsage asg (NOLOCK)  on asg.AccountID = ac.accountId
				LEFT JOIN lp_commissions..commission_estimate e (NOLOCK) ON e.account_id = ac.accountIdLegacy
						AND e.contract_nbr = cn.Number   
						AND e.vendor_id = v.vendor_id 
				LEFT JOIN lp_commissions..transaction_detail d (NOLOCK) ON d.account_id = ac.accountIdLegacy
						AND d.contract_nbr = cn.Number   
						AND d.vendor_id = v.vendor_id
						AND d.void = 0 
						AND d.transaction_type_id in ( 1,5 ) 
			WHERE 1 = 1
				AND (e.estimate_id is null 
						or e.rate <> d.rate 
						or ( e.base_amount <> d.base_amount AND d.reason_code not like '%c5000%' ) 
						or ( d.rate is null
							AND ( e.rate = 0 
								or e.contract_rate <> acr.Rate 
								or e.base_amount <> asg.annualUsage  
								) 
							)
					) 
				AND cn.SignedDate >= @p_start_date
				--AND a.status not in ( '911000' , '999999' , '999998' ) 
			
			UNION 
			
			SELECT e.account_id, e.contract_nbr, rate = 0 , v.vendor_id, estimate_id, comm_rate = 0 , e.amount , comm_amt = 0 , e.base_amount, comm_base_amount = 0
			FROM lp_commissions..commission_estimate e (NOLOCK)
				JOIN lp_commissions..vendor v (NOLOCK) ON v.vendor_id = e.vendor_id 
			WHERE e.rate is null 
				OR e.init_pymt_opt_def_id is null 
				OR e.res_pymt_opt_def_id is null 
				OR e.evg_pymt_opt_def_id is null     
	 )	as a  
	
END 
GO 


USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_processor_evergreen_accounts_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_processor_evergreen_accounts_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

 * usp_processor_evergreen_accounts_sel

 * Get acounts due for an  evergreen payment
 
 * History

 *******************************************************************************

 * 12/11/2008 Gail Mangaroo.

 * Created.

 *******************************************************************************

-- Modified 6/3/2010
-- Altered to leverage account overrides & rename sp.
-- ===============================================
-- Modified 8/17/2010 Gail Mangaroo
-- Altered to created just the first payment for evergeen 
-- ===============================================
-- Modified 8/5/2011 Gail Mangaroo
-- Altered to exclude voiding adjustment transaction 
-- ===============================================
-- Modified 8/18/2011 Gail Mangaroo 
-- Altered to use isDefault field to detect rollover products/contracts 
-- ===============================================
-- Modified 8/25/2011 Gail Mangaroo
-- Added NOLOCK hints
-- ===============================================
-- Modified 12/7/2012 Gail Mangaroo 
-- Use LibertyPower..Account structure, remove reference to payment option fields on vendor table
-- ===============================================
 */

CREATE Procedure [dbo].[usp_processor_evergreen_accounts_sel]
(@p_period_end_date datetime  = null  )
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @p_period_end_date datetime  
	--SET @p_period_end_date = isnull(@p_period_end_date, getdate()) 

	SELECT DISTINCT 
		account_id = ac.accountIDLegacy 
		, contract_nbr  = cn.Number 
		, date_deal = cn.signedDate 
		, contract_type = ct.[Type]
		, term_months = acr.Term 
		, sales_channel_role = v.vendor_system_name 
		, v.vendor_id 
		, contract_eff_start_date = cn.StartDate 

	FROM LibertyPower..Account ac (NOLOCK) 
		JOIN LibertyPower..AccountContract acn (NOLOCK) ON acn.AccountID = ac.AccountID
		JOIN LibertyPower..Contract cn (NOLOCK) ON acn.ContractID = cn.ContractID
		JOIN LibertyPower..AccountContractRate acr (NOLOCK) ON acr.AccountContractID = acn.AccountContractID 
			AND IsContractedRate = 0 -- rolled over to the variable
		JOIN lp_Commissions..vendor v (NOLOCK) ON v.ChannelID = cn.SalesChannelID
		LEFT JOIN LibertyPower..AccountContractCommission acomm (NOLOCK) ON acomm.AccountContractID = acn.AccountContractID
		LEFT JOIN LibertyPower..AccountStatus s (NOLOCK) ON s.AccountContractID = acn.AccountContractID 
		LEFT JOIN LibertyPower..ContractType ct (NOLOCK) ON ct.contractTypeID = cn.contractTypeID
		LEFT JOIN lp_common.dbo.common_product p (NOLOCK) ON acr.LegacyProductID = p.product_id 
				
		LEFT JOIN transaction_detail d (NOLOCK) on ac.accountIDLegacy  = d.account_id 
			and cn.Number = d.contract_nbr 
			and d.vendor_id = v.vendor_id
			and d.void = 0 
			and d.approval_status_id = 1
			and d.transaction_type_id in (1,5)  
			
		LEFT JOIN transaction_detail chbk (NOLOCK) on d.transaction_detail_id = chbk.assoc_transaction_id 
			and chbk.void = 0 
			and chbk.approval_status_id = 1 
			and (chbk.transaction_type_id = 2 OR ( chbk.transaction_type_id = 7 AND chbk.reason_code like '%C0012%')) 	-- chargeback or voiding adjustment
			
		LEFT JOIN transaction_detail evg (NOLOCK) on ac.accountIDLegacy = evg.account_id 
			and cn.Number = evg.contract_nbr 
			and evg.vendor_id = v.vendor_id
			and evg.void = 0 
			and evg.transaction_type_id = 8
			
	WHERE 1 = 1 
		AND s.[status] in ('905000','906000', '05000', '06000')				-- account is active 
		AND v.inactive_ind  = 0												-- vendor active 
		AND @p_period_end_date > dateadd(month, acr.Term, acr.RateStart )  -- term ended
		AND (p.isDefault = 1 OR p.product_id in (SELECT product_id  
													FROM lp_common..common_product (NOLOCK) 
													WHERE default_expire_product_id =  p.product_id						
												   )
			) -- Rolled over
			
		AND d.transaction_detail_id is not null   -- original commission found
		AND chbk.transaction_detail_id is null 
		AND evg.transaction_detail_id is null -- no evergreen payments yet made
		
		AND (
				(v.allow_account_override = 1 AND isnull(acomm.EvergreenOptionID, 0 ) > 0 )
					OR
				(SELECT TOP 1 isnull(vpo.payment_option_id, 0 ) 
						FROM lp_commissions..vendor_payment_option vpo (NOLOCK)
							JOIN lp_commissions..payment_option po (NOLOCK) on vpo.payment_option_id = po.payment_option_id 
						WHERE vpo.date_effective <= cn.SignedDate 
							AND ( vpo.date_end >= cn.SignedDate OR isnull(vpo.date_end , '1/1/1900' ) = '1/1/1900' )
							AND vpo.active = 1 
							AND po.payment_option_type_id = 3
							AND vendor_id = v.vendor_ID
						ORDER BY vpo.vendor_id , vpo.date_effective desc 
				 ) > 0 
			 )
		AND cn.ContractStatusID <> 2 -- Not Rejected 
END 	
GO


USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_processor_trueup_accounts_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_processor_trueup_accounts_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 8/3/2011
-- Description:	Retrieves all commission/residual payments accounts due for a true up
-- =============================================
-- Modifed 8/8/2011 Gail Mangaroo 
-- Temporarily disable trueing up chargedback accounts 
-- =============================================
-- Modified 8/25/2011 Gail Mangaroo
-- removed 2nd join with transaction request, corrected date field used in selection 
-- =============================================
-- Modified 9/14/2011 Gail Mangaroo
-- Activate TrueUP on chargedback accounts as 8/1/2011
-- =============================================
-- Modified 9/22/2011 Gail Mangaroo
-- Fixed effective date 
-- =============================================
-- Modified 10/16/2011 Gail Mangaroo 
-- temp disable 
-- ==============================================
-- Modified 11/7/2011 Gail Mangaroo 
-- Altered to trueup last transaction (per type) so as to avoid dups 
-- ==============================================
-- Modified 11/10/2011 Gail Mangaroo 
-- enabled
-- =============================================
-- Modified 12/7/2012 Gail Mangaroo 
-- Use LibertyPower..Account and remove reference to payment option fields in vendor tables 
-- =============================================

CREATE PROCEDURE [dbo].[usp_processor_trueup_accounts_sel] 
(@p_period_end_date datetime  = null 
	, @p_exclude_pending bit = 0
	 )
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--drop table #comm_temp
	--declare @p_exclude_pending bit  
	
	SELECT max(comm.transaction_detail_id ) as transaction_detail_id 
				, comm.account_id
				, comm.contract_nbr
				, comm.vendor_id 
				, case when comm.transaction_type_id = 5 then 1 else comm.transaction_type_id end as transaction_type_id 
				, count(comm.transaction_detail_id ) as tran_count 
				, comm.term 
				, comm.date_term_start 
				, comm.date_deal 
				, comm.amount 
				, comm.reason_Code 
				
		INTO #comm_temp 
	
	FROM lp_commissions..transaction_detail comm (NOLOCK) 
		
		LEFT JOIN lp_commissions..transaction_detail void (NOLOCK) ON comm.transaction_detail_id = void.assoc_transaction_id
				AND void.transaction_type_id in ( 2, 7) 
				AND void.void = 0 
				AND void.approval_status_id <> 2 
				AND void.reason_code like '%C0012%'
			
	WHERE  comm.transaction_type_id in ( 1,5 ,6 ) 
		AND comm.void = 0 
		AND comm.approval_status_id <> 2 
		AND void.transaction_detail_id is null						-- original commission not voided
		AND comm.reason_code not like '%c5000%'						-- not ATMS 
		--and comm.account_id = '2011-0067010'
		
	GROUP BY  comm.account_id, comm.contract_nbr, comm.vendor_id, case when comm.transaction_type_id = 5 then 1 else comm.transaction_type_id end 
			, comm.term , comm.date_term_start ,  comm.date_deal , comm.amount , comm.reason_code 
			
	SELECT DISTINCT
		
		comm.account_id 
		, comm.contract_nbr 
		, v.vendor_system_name
		, comm.transaction_detail_id
		
	FROM #comm_temp comm 
		
		JOIN lp_commissions..vendor v (NOLOCK) ON comm.vendor_id = v.vendor_id 
	
		JOIN LibertyPower..account acc (NOLOCK) ON comm.account_id = acc.accountIDLegacy
		JOIN LibertyPower..Contract cn (NOLOCK) ON comm.contract_nbr = cn.Number
		JOIN LibertyPower..accountContract acn (NOLOCK) ON acn.Accountid = acc.accountID 
			AND cn.ContractId = acn.ContractID
		JOIN LibertyPower..accountContractCommission acm (NOLOCK) ON acm.accountContractID = acn.accountContractID
				
		LEFT JOIN lp_commissions..transaction_detail chbk (NOLOCK) ON comm.transaction_detail_id = chbk.assoc_transaction_id
			AND chbk.transaction_type_id in ( 2 ) 
			AND chbk.void = 0 
			AND chbk.approval_status_id <> 2 
			
		LEFT JOIN lp_commissions..transaction_detail trueup (NOLOCK) ON comm.account_id = trueup.account_id 
			AND trueup.contract_nbr = comm.contract_nbr
			AND trueup.vendor_id  = comm.vendor_id
			AND trueup.transaction_type_id in ( 7, 9) 
			AND (trueup.reason_code like '%c2000%' -- end of term reason_code
					OR trueup.reason_code like '%c3000%' -- residual payment reason_code 
					OR trueup.reason_code like '%c3002%' -- trueup payment reason code 
				) 
			AND trueup.void = 0 
			
		LEFT JOIN lp_commissions..transaction_detail void2 (NOLOCK) ON trueup.transaction_detail_id = void2.assoc_transaction_id
			AND void2.transaction_type_id in ( 2, 7) 
			AND void2.void = 0 
			AND void2.approval_status_id <> 2 
			AND void2.reason_code like '%C0012%'
											
		JOIN lp_commissions..vendor_payment_option vpo (NOLOCK) ON vpo.vendor_id = v.vendor_ID
			AND vpo.active = 1 
																		
		JOIN lp_commissions..payment_option po (NOLOCK) ON vpo.payment_option_id = po.payment_option_id 
			AND po.payment_option_type_id = 2
		
		JOIN lp_commissions..payment_option_setting	pos (NOLOCK) ON pos.payment_option_id = po.payment_option_id 
		
		JOIN lp_commissions..payment_option_def	pod (NOLOCK) ON pos.payment_option_def_id = pod.payment_option_def_id
						 
		LEFT JOIN lp_commissions..transaction_request e (NOLOCK) ON comm.account_id = e.account_id 
			AND comm.contract_nbr = e.contract_nbr 
			AND e.transaction_type_code in ( 'TRUEUP' ) 
			AND v.vendor_system_name = e.vendor_system_name
			AND (e.process_status in ( '0000003') or e.date_processed is null )
			
		LEFT JOIN lp_commissions..transaction_request e3 (NOLOCK) ON comm.account_id = e3.account_id 
			AND comm.contract_nbr = e3.contract_nbr 
			AND e3.transaction_type_code in ( 'TRUEUP' ) 
			AND v.vendor_system_name = e3.vendor_system_name
			AND e3.process_status = '0000002' 
								
	WHERE 1 = 1 --- temp disable 
		AND v.inactive_ind  = 0										-- vendor active 
		AND (@p_exclude_pending = 0 OR e.request_id IS NULL)		-- exclude pending transaction_request unless otherwise specified
		AND ((@p_exclude_pending = 0 AND e.request_id IS NOT NULL) 
				OR e3.request_id IS NULL )							-- exclude errors
		AND comm.transaction_detail_id is not null					-- original commission paid
		
		
		AND trueup.transaction_detail_id is null					-- trueup transaction not yet created
		AND void2.transaction_detail_id is null						-- trueup transaction is voided
		
		AND comm.date_deal > case when chbk.transaction_detail_id is null 
					then '1/1/2001' else '8/1/2011' end				-- only true up onchargebacks as of '8/1/2011'
		
		AND ( dateadd ( month , comm.term , case when comm.date_term_start < comm.date_deal 
					then comm.date_deal else comm.date_term_start end 
					) <= getdate()									-- some transactions have an incorrect date_term_start
			
				OR chbk.date_term_end <= getdate()					-- don't wait until term end date if already chargedback; use deenrollment date
			) 
					
		AND abs(comm.amount) <> abs(isnull(chbk.amount, 0))			-- if nothing was paid then no need to true-up
		
			
		 -- account override set
		AND	((v.allow_account_override = 1 and isnull(acm.ResidualOptionID, 0) > 0)  
			  OR 
			  -- vendor option set 
			  ( (SELECT TOP 1 isnull(vpo.payment_option_id, 0 ) 
					FROM lp_commissions..vendor_payment_option vpo (NOLOCK)
						JOIN lp_commissions..payment_option po on vpo.payment_option_id = po.payment_option_id 
					WHERE vpo.date_effective <= comm.date_deal 
						AND ( vpo.date_end > comm.date_deal OR isnull(vpo.date_end, '1/1/1900')  = '1/1/1900' ) 
						AND vpo.active = 1 
						AND po.payment_option_type_id = 2
						AND vendor_id = v.vendor_ID
					ORDER BY vpo.vendor_id , vpo.date_effective desc 
				 )  > 0 
				) 
			)

		
	order by 3,2
		
END
GO


USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_product_rate_type_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_product_rate_type_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 10/18/2012
-- Description:	Returns list of product rate types
-- =============================================
CREATE PROCEDURE [dbo].[usp_product_rate_type_sel] 

AS
BEGIN

	SELECT [product_rate_type_id]
		  ,[product_rate_type_code]
		  ,[product_rate_type_descp]
	  FROM [lp_commissions].[dbo].[product_rate_type] (NOLOCK) 
END
GO

USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_rate_level_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_rate_level_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 10/18/2012
-- Description:	Returns list of rate levels
-- =============================================
CREATE PROCEDURE [dbo].[usp_rate_level_sel] 

AS
BEGIN
	SELECT [rate_level_id]
		  ,[rate_level_code]
		  ,[rate_level_descp]
	 FROM [lp_commissions].[dbo].[rate_level] (NOLOCK)
END
GO


USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_report_detail_meter_read_accounts_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_report_detail_meter_read_accounts_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_report_meter_read_accounts_sel
 * Get meter reads received and accounts that are due for meter reads 
 
 * History
 *******************************************************************************
 * 9/23/2009 Gail Mangaroo.
 * Created.
 *******************************************************************************
 * 10/19/2009
 * Added last meter read and commission stats
 ******************************************************************************
 * 10/28/2009 Gail Mangaroo 
 * Added corrected issue where accounts without meter reads were not showing and 
 * accounts beyond the start deal date showing 
 *******************************************************************************
 * 11/12/2009 Gail Managaroo 
 * Added is_paud fileter and is_pending and no meter read fields
 *******************************************************************************
 exec usp_report_detail_meter_read_accounts_sel '7/1/2007' , '7/30/2007'
 *******************************************************************************
 * 1/15/2010 Gail Mangaroo 
 * Get usage from usage_detail 
 *******************************************************************************
 * 1/20/2010 Gail Mangaroo and rename sp.
 * Added utility ID 
 *******************************************************************************
 * 4/20/2010 Gail Mangaroo
 * Added vendor
 *******************************************************************************
* Modified 5/6/2010 Gail Mangaroo 
* Get vendor names from LibertyPower.dbo.salesChannel
*******************************************************************************
* 1/6/2011 Gail Mangaroo 
* Altered to ignore inactive usage detail records (AMEREN fix) 
*******************************************************************************
* 2/15/2012 Gail Mangaroo 
* Altered to use LibertyPower.dbo.Account 
*******************************************************************************
* 9/25/2012 Gail Mangaroo 
* Altered to use LibertyPower..Name 
*******************************************************************************
* 12/10/2012 Gail Mangaroo 
* Altered to use payment option tables and ignore payment options on vendor table
*******************************************************************************
 */
CREATE Procedure [dbo].[usp_report_detail_meter_read_accounts_sel]
(
@p_period_start_date datetime 
, @p_period_end_date datetime
, @p_show_missing_accts_only bit = 1 
, @p_show_paid_status int = -1  -- -1 means all / 0 Not Paid / 1 Paid
, @p_vendor_id int 
)

AS
BEGIN 

		--drop table #temp_meter_rds 
		--drop table #final_list
		--drop table  #tmp_next_acct  
		
		--declare @p_period_start_date datetime 
		--declare @p_period_end_date datetime
		--declare @p_show_missing_accts_only bit 
		--declare @p_show_paid_status int 
		--declare @p_vendor_id int 

		--set @p_period_start_date = '10/1/2012'
		--set @p_period_end_date = '1/1/2013'
		--set @p_show_missing_accts_only = 0 
		--set @p_show_paid_status  = -1 
		--set @p_vendor_id = 315
		
		
		--DECLARE @acct_nbrs table ( account_number varchar(40) , assoc_account_number varchar(40)) 
	DECLARE @acct varchar(40) 
	DECLARE @acct_ID varchar(40) 
	DECLARE @new_acct varchar(40) 
	DECLARE @date_deal datetime 
	
	DECLARE @service_start datetime 
	DECLARE @service_end datetime
	DECLARE @read_date datetime
	DECLARE @usage float
	DECLARE @comm_date  datetime 
	DECLARE @comm_rate float 
	DECLARE @comm_amt float 
	DECLARE @channelID varchar(50) 
	
	CREATE TABLE #temp_meter_rds 
	(	account_number varchar(30) 
	, esiid varchar(30) 
	, TdspDuns varchar(100)
	, service_start datetime
	, service_end datetime
	, usage float
	, transaction_nbr varchar(100) 
	, purpose_code varchar(100) 
	, header_key int 
	, detail_key int 
	, detail_qty_key int 
	, source_code char(1)
	, date_created datetime 
	, meter_number varchar(100)
	)

	CREATE TABLE #final_list 
	(	account_number varchar(50)
		, SalesChannelID varchar(300)
		, SalesChannel varchar(350)
		, retail_mkt_id varchar(5)
		, ContractNumber varchar(30)
		, AccountNumber varchar(30)
		, CustomerName varchar(300)
		, date_deal datetime
		, FlowStartDate datetime
		, next_read_date datetime
		, rate float
		, TdspDuns varchar(100)
		, service_start datetime
		, service_end datetime
		, usage float
		, TransactionNbr varchar(100)
		, TransactionSetPurposeCode varchar(100)
		, [867_key] int
		, Detail_Key int
		, Detail_Qty_Key int 
		, source varchar(100)
		, datecreated datetime
		, transaction_detail_id int
		, zone varchar(20)
		, last_service_start datetime 
		, last_service_end datetime
		, last_read_date datetime
		, last_usage float
		, last_commission_date datetime
		, last_commission_rate float  
		, last_commission_amount float
		, is_paid bit 
		, is_flowing bit
		, account_id varchar(50)
		, is_pending_pymt bit 
		, no_meter_read bit 
		)

	
	-- Get all accounts due for a meter read within date range  
	-- =======================================================
	SELECT DISTINCT * 
	INTO #tmp_next_acct 
	FROM 
	( 	SELECT m.read_date as next_read_date, account_id = a.accountIdLegacy , account_number = a.accountNumber , utility_id = u.utilityCode
		FROM LibertyPower.dbo.account a (NOLOCK) 
			JOIN LibertyPower.dbo.accountContract ac (NOLOCK) ON ac.AccountID = a.AccountID 
			JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = ac.ContractID
			JOIN LibertyPower.dbo.utility u (NOLOCK) ON a.UtilityID = u.ID
			JOIN lp_commissions.dbo.vendor v (NOLOCK) ON c.SalesChannelID = v.ChannelID  
				AND v.initial_pymt_option_id = 1
				AND c.SignedDate > '9/21/2009'
			LEFT JOIN lp_account.dbo.account_additional_info i (NOLOCK) ON a.accountIdLegacy = i.account_id 
			LEFT JOIN lp_common.dbo.meter_read_calendar m (NOLOCK) on u.utilityCode= m.utility_id 
				AND i.field_04_value = m.read_cycle_id 
		WHERE 
			(( calendar_year BETWEEN YEAR(@p_period_start_date) AND YEAR(@p_period_end_date) 
				AND calendar_month BETWEEN MONTH(@p_period_start_date) AND MONTH(@p_period_end_date ) 
			  ) OR  ltrim(rtrim(isnull(i.field_04_value, ''))) = '' ) 
			 AND (v.vendor_id = @p_vendor_id OR @p_vendor_id = 0 )
		
		) as x


	-- Final Select 
	-- =========================================
	INSERT INTO #final_list 
	
	-- Accounts with meter reads 
	-- ===========================
	SELECT DISTINCT 
		r.account_number 
		, SalesChannelID = upper(sc.ChannelName )
		, SalesChannel = upper(v.vendor_system_name)
		, retail_mkt_id = m.MarketCode 
		, ContractNumber = c.Number
		, AccountNumber = a.AccountNumber
		, CustomerName = arn.name
		, date_deal = c.SignedDate
		, FlowStartDate = c.StartDate
		, n.next_read_date 
		, d.rate 
		, r.TdspDuns
		, r.service_start
		, r.service_end
		, r.usage
		, r.Transaction_Nbr
		, r.Purpose_Code
		, r.[header_key]
		, r.Detail_Key
		, r.Detail_Qty_Key 
		, r.source_code
		, r.date_created
		, u.transaction_detail_id 
		, a.zone
		, last_service_start = d.date_term_start 
		, last_service_end = d.date_term_end
		, last_read_date = r.date_received
		, last_usage = null  
		, last_commission_date = null
		, last_commission_rate = null 
		, last_commission_amount = null
		, is_paid = case when u.header_key is not null and d.approval_status_id in (1,3) then 1 else 0 end -- true if meter read related to a transaction and transaction approved and paid on report
		, is_flowing = case when s.status in ( '911000','999998','999999') then 0 else 1 end
		, account_id = a.accountIdLegacy
		, is_pending_pymt = case when u.header_key is not null and d.invoice_id = 0 and d.approval_status_id in (1,3) then 1 else 0 end -- true if meter read related to a transaction and transaction approved but not yet paid on report
		, no_meter_read = 0 
		
	FROM lp_commissions.dbo.usage_detail r (NOLOCK)
		
		JOIN LibertyPower.dbo.account a (NOLOCK) ON r.account_number = a.accountNumber 
		JOIN LibertyPower.dbo.accountContract ac (NOLOCK) ON ac.AccountID = a.AccountID 
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = ac.ContractID
		JOIN LibertyPower.dbo.utility ut (NOLOCK) ON a.UtilityID = ut.ID AND r.utility_id = ut.utilityCode
		JOIN LibertyPower.dbo.SalesChannel sc (NOLOCK) ON sc.ChannelID = c.SalesChannelID
		JOIN LibertyPower.dbo.market m (NOLOCK) ON a.retailMktID = m.id 
		LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON s.AccountContractID = ac.AccountContractID 
		LEFT JOIN LibertyPower.dbo.Name arn (NOLOCK) ON a.AccountNameID = arn.NameID
		LEFT JOIN #tmp_next_acct n (NOLOCK) ON r.account_number = n.account_number 
		
		JOIN lp_commissions.dbo.vendor v (NOLOCK) ON c.SalesChannelID = v.ChannelID
			--AND v.initial_pymt_option_id = 1

		LEFT JOIN transaction_usage_detail u (NOLOCK) ON r.header_key = u.header_key 
		LEFT JOIN lp_commissions.dbo.transaction_detail d (NOLOCK) ON d.transaction_detail_id = u.transaction_detail_id 
		
	WHERE @p_show_missing_accts_only  = 0 
		AND r.date_received BETWEEN @p_period_start_date AND @p_period_end_date
		AND (v.vendor_id = @p_vendor_id OR @p_vendor_id = 0 ) 
		AND r.inactive = 0
		AND	  -- Todo : Add check for account overrides
			  -- vendor option set 
			  (SELECT TOP 1 isnull(vpo.payment_option_id, 0 ) 
					FROM lp_commissions..vendor_payment_option vpo (NOLOCK)
						JOIN lp_commissions..payment_option po (NOLOCK) on vpo.payment_option_id = po.payment_option_id 
						JOIN lp_commissions..payment_option_setting pos (NOLOCK) on pos.payment_option_id = pos.payment_option_id 
					WHERE vpo.date_effective <= c.SignedDate
						AND ( vpo.date_end > c.SignedDate OR isnull(vpo.date_end, '1/1/1900')  = '1/1/1900' ) 
						AND vpo.active = 1 
						AND po.payment_option_type_id = 1 -- intial payment 
						AND pos.payment_option_def_id = 1 -- ATMS
						AND vendor_id = v.vendor_ID
					ORDER BY vpo.vendor_id , vpo.date_effective desc 
				 )  > 0 
				
	-- UNION 
	
	INSERT INTO #final_list 
	
	--  accounts missing meter reads
	-- ==============================
	SELECT DISTINCT h.account_number  --
		, SalesChannelID = upper(sc.ChannelName )
		, SalesChannel = upper(v.vendor_system_name)
		, retail_mkt_id = m.MarketCode 
		, ContractNumber = c.Number
		, AccountNumber = a.AccountNumber
		, CustomerName = arn.name
		, date_deal = c.SignedDate
		, FlowStartDate = c.StartDate
		, h.next_read_date 
		, null rate
		, null TdspDuns
		, null service_start
		, null service_end
		, null usage
		, null TransactionNbr
		, null TransactionSetPurposeCode
		, null [867_key]
		, null Detail_Key
		, null Detail_Qty_Key
		, null source
		, null datecreated
		, null transaction_detail_id
		, a.zone
		, last_service_start = null 
		, last_service_end = null
		, last_read_date = null
		, last_usage = null  
		, last_commission_date = comm.target_date
		, last_commission_rate = last_d.rate 
		, last_commission_amount = last_d.amount
		, is_paid = 0
		, is_flowing = case when s.status in ( '911000','999998','999999') then 0 else 1 end
		, account_id = a.accountIDLegacy
		, is_pending_pymt = 0 
		, no_meter_read = 1 
		
    FROM #tmp_next_acct h 
			
		LEFT JOIN lp_commissions.dbo.usage_detail r (NOLOCK) ON r.account_number = h.account_number 
				AND r.date_received BETWEEN @p_period_start_date AND @p_period_end_date
				AND h.utility_id = r.utility_id
				AND r.inactive = 0
				
		JOIN LibertyPower.dbo.account a (NOLOCK) ON r.account_number = a.accountNumber 
		JOIN LibertyPower.dbo.accountContract ac (NOLOCK) ON ac.AccountID = a.AccountID 
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = ac.ContractID
		JOIN LibertyPower.dbo.utility u (NOLOCK) ON a.UtilityID = u.ID AND r.utility_id = u.utilityCode
		JOIN LibertyPower.dbo.SalesChannel sc (NOLOCK) ON sc.ChannelID = c.SalesChannelID
		JOIN LibertyPower.dbo.market m (NOLOCK) ON a.retailMktID = m.id 
		LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON s.AccountContractID = ac.AccountContractID 
		LEFT JOIN LibertyPower.dbo.Name arn (NOLOCK) ON a.AccountNameID = arn.NameID
		JOIN lp_commissions.dbo.vendor v (NOLOCK) ON c.SalesChannelID = v.ChannelID
		
		LEFT JOIN ( SELECT account_id , max(transaction_detail_id) as detail_id , target_date = max(r.target_date )
						FROM lp_commissions.dbo.transaction_detail d (NOLOCK) 
							JOIN lp_commissions.dbo.invoice i (NOLOCK) on d.invoice_id = i.invoice_id
							JOIN lp_commissions.dbo.vendor v (NOLOCK) on d.vendor_id = v.vendor_id --AND v.vendor_name = @channelID
							JOIN lp_commissions.dbo.report r (NOLOCK) on i.report_id = r.report_id
							LEFT OUTER JOIN LibertyPower.dbo.SalesChannel AS SC (NOLOCK) ON v.ChannelID = SC.ChannelID 
						WHERE d.void = 0 
							and d.approval_status_id = 1 
							and reason_Code like 'c5000%' 
							and sc.ChannelName = @channelID
						GROUP BY account_id 
				  )  as comm ON comm.account_id = h.account_id 
				  			
		LEFT JOIN transaction_detail last_d (NOLOCK) ON last_d.transaction_detail_id = comm.detail_id 
						
	WHERE r.account_number is null 
			
	UPDATE #final_list SET FlowStartDate = NULL WHERE FlowStartDate = '1/1/1900'
	UPDATE #final_list SET is_flowing = 0 WHERE FlowStartDate IS NULL 
	
		
	SELECT DISTINCT * FROM #final_list 
	WHERE (@p_show_paid_status = -1 or is_paid = @p_show_paid_status )  -- show all or only the specified status

END 
GO

USE [lp_Commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_utility_sel_list]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_utility_sel_list]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 10/5/2012
-- Description:	Get List of utilities.
-- =============================================
CREATE PROC [dbo].[usp_utility_sel_list]
AS 
BEGIN 

	SELECT [ID]
      ,[UtilityCode]
      ,[FullName]
      ,[ShortName]
      ,[MarketID]
     
	FROM [Libertypower].[dbo].[Utility] (NOLOCK) 
  
END 
GO 


USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_calculation_freq_ins]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_calculation_freq_ins]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 4/27/2010 Created
* Gail Mangaroo 
* Create vendor calculation freq
**********************************************************************
* 3/2/2012 - 8/25/2012 Gail Mangaroo 
* Added end date and package id fields
**********************************************************************
*/

CREATE Procedure [dbo].[usp_vendor_calculation_freq_ins]
( 
 @p_vendor_id int 
 , @p_calculation_freq_id int 
 , @p_date_effective datetime 
 , @p_username varchar(100) 
 , @p_active bit = 0 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_interval float = 0 
) 
AS
BEGIN 

	INSERT INTO [lp_commissions].[dbo].[vendor_calculation_freq]
           ([vendor_id]
           ,[calculation_freq_id]
           ,[date_effective]
           ,[date_end] 
           ,[active]
           ,[date_created]
           ,[username]
           ,[interval]
           ,[package_id] 
		   ,[interval_type_id]
           )
     SELECT 
           @p_vendor_id
           ,@p_calculation_freq_id
           ,@p_date_effective
           ,@p_date_end
           ,@p_active
           ,getdate()
           ,@p_username
    	   ,@p_interval
		   ,@p_package_id
    	   ,@p_interval_type_id	 
    	   
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
	
END 
GO

USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_calculation_freq_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_calculation_freq_sel]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 4/27/2010 Created
* Gail Mangaroo 
* Get all vendor calculation freqs
**********************************************************************

*/
CREATE Procedure [dbo].[usp_vendor_calculation_freq_sel]
(@p_vendor_id int
 , @p_package_id int = 0 ) 
AS
BEGIN 
	DECLARE @strParams nvarchar(1000)
	DECLARE @strSQL nvarchar(1000)
	
	SET @strParams = N' @p_vendor_id int , @p_package_id int  '
	SET @strSQL = '
		SELECT *
			FROM [lp_commissions].[dbo].[vendor_calculation_freq] (NOLOCK)
			WHERE active = 1
				AND vendor_id = @p_vendor_id '
	
	IF isnull(@p_package_id,0) <> 0
		SET @strSQL = @strSQL + ' AND package_id = @p_package_id '
  
	EXECUTE sp_executesql  @strSQL
		, @strParams 
		, @p_vendor_id = @p_vendor_id
		, @p_package_id = @p_package_id
		
  
END 
GO

USE lp_commissions
GO 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_calculation_freq_sel_by_id')
	DROP  Procedure  usp_vendor_calculation_freq_sel_by_id
GO

/*
**********************************************************************
* 3/30/2010 Created
* Gail Mangaroo 
* Get all vendor calculation freq setting
**********************************************************************

*/
CREATE Procedure usp_vendor_calculation_freq_sel_by_id
(@p_freq_id int ) 
AS
BEGIN 

	SELECT *
  FROM [lp_commissions].[dbo].[vendor_calculation_freq] (NOLOCK)
  WHERE freq_id = @p_freq_id 
  
END 
GO

USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_calculation_freq_upd]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_calculation_freq_upd]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 4/27/2010 Created
* Gail Mangaroo 
* Update vendor calculation freq
**********************************************************************
* 3/2/2012 Gail Mangaroo 
* Added date_end column
**********************************************************************
* Modified: 8/25/2012 Gail Mangaroo 
* Added package id fields
**********************************************************************
*/

CREATE Procedure [dbo].[usp_vendor_calculation_freq_upd]
( @p_freq_id int 
 , @p_vendor_id int 
 , @p_calculation_freq_id int 
 , @p_date_effective datetime 
 , @p_active bit
 , @p_username varchar(100) 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_interval float = 0 
 )  
AS
BEGIN 

	UPDATE [lp_commissions].[dbo].[vendor_calculation_freq]
	   SET [vendor_id] = @p_vendor_id
		  ,[calculation_freq_id] = @p_calculation_freq_id
		  ,[date_effective] = @p_date_effective
		  ,[date_end] = @p_date_end
		  ,[active] = @p_active
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
		  ,[package_id] = @p_package_id
		  ,[interval_type_id] = @p_interval_type_id
		  ,[interval] = @p_interval
	 
	 WHERE freq_id =  @p_freq_id
	 				 
 	RETURN @@ROWCOUNT
	
END
GO

USE lp_commissions
GO 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_grace_period_ins')
	DROP  Procedure  usp_vendor_grace_period_ins
GO

/*
**********************************************************************
* 6/11/2010 Created
* Gail Mangaroo 
* Create vendor grace period option
**********************************************************************
* 4/4/2012 // 8/16/2012 Gail Managroo 
* Added end date & package_id 
**********************************************************************
*/

CREATE Procedure usp_vendor_grace_period_ins
( 
 @p_vendor_id int 
 , @p_transaction_type_id int 
 , @p_grace_period float 
 , @p_date_effective datetime 
 , @p_username varchar(100) 
 , @p_active bit = 0 
 , @p_end_date datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_date_option int  = 0 
) 
AS
BEGIN 

	INSERT INTO [lp_commissions].[dbo].[vendor_grace_period]
           ([vendor_id]
           ,[transaction_type_id]
           ,[grace_period]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_end]
           ,[package_id] 
           ,[interval_type_id]
           ,[date_option]
           )
     SELECT 
           @p_vendor_id
           ,@p_transaction_type_id
           ,@p_grace_period
           ,@p_date_effective
           ,@p_active
           ,getdate()
           ,@p_username
           ,@p_end_date
           ,@p_package_id
           ,@p_interval_type_id
           ,@p_date_option
  		 
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
	
END 
GO

USE [Lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_grace_period_sel')
	DROP  Procedure  usp_vendor_grace_period_sel
GO


/*
**********************************************************************
* 6/15/2010 Created
* Gail Mangaroo 
* Get all vendor grace period settings
**********************************************************************
* 8/16/2012 Gail Mangaroo 
* Added package_id 
**********************************************************************
*/
CREATE Procedure [dbo].[usp_vendor_grace_period_sel]
(@p_vendor_id int
 , @p_package_id int = 0 ) 
AS
BEGIN 

	DECLARE @params nvarchar(1000)
	DECLARE @strSQL nvarchar(1000)
	
	SET @params = N' @p_vendor_id int , @p_package_id int  '
	SET @strSQL = '
		SELECT *
	FROM [lp_commissions].[dbo].[vendor_grace_period] (NOLOCK) 
	WHERE active = 1
		AND vendor_id = @p_vendor_id '
	
	IF isnull(@p_package_id,0) <> 0
		SET @strSQL = @strSQL + ' AND package_id = @p_package_id '
  
	EXECUTE sp_executesql  @strSQL, @params , @p_vendor_id = @p_vendor_id , @p_package_id = @p_package_id
END 
GO

USE lp_commissions
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_grace_period_sel_by_id')
	DROP  Procedure  usp_vendor_grace_period_sel_by_id
GO

/*
**********************************************************************
* 4/4/2012 Created
* Gail Mangaroo 
* Get vendor grace period settings
**********************************************************************

*/
CREATE Procedure usp_vendor_grace_period_sel_by_id
(@p_option_id int ) 
AS
BEGIN 

SELECT *
  FROM [lp_commissions].[dbo].[vendor_grace_period] (NOLOCK) 
  WHERE option_id = @p_option_id
	  
END 
GO

USE lp_commissions
GO 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_grace_period_upd')
	DROP  Procedure  usp_vendor_grace_period_upd
GO

/*
**********************************************************************
* 6/11/2010 Created
* Gail Mangaroo 
* Update vendor grace period update
**********************************************************************
* 4/4/2012 // 8/16/2012 Gail Managroo 
* Added end date & package_id 
**********************************************************************
*/

CREATE Procedure usp_vendor_grace_period_upd
( @p_option_id int 
 , @p_vendor_id int 
 , @p_transaction_type_id int 
 , @p_grace_period float 
 , @p_date_effective datetime 
 , @p_active bit
 , @p_username varchar(100) 
 , @p_end_date datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_date_option int = 0 
 )  
AS
BEGIN 

	UPDATE [lp_commissions].[dbo].[vendor_grace_period]
	   SET [vendor_id] = @p_vendor_id
	      ,[transaction_type_id] = @p_transaction_type_id
		  ,[grace_period] = @p_grace_period
		  ,[date_effective] = @p_date_effective
		  ,[active] = @p_active
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
		  ,[date_end] = @p_end_date
		  ,[package_id] = @p_package_id
		  ,[interval_type_id] = @p_interval_type_id 
		  ,[date_option] = @p_date_option
		  
	WHERE option_id =  @p_option_id
	 						 
 	RETURN @@ROWCOUNT
	
END
GO

USE [lp_commissions]
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_payment_freq_ins')
	DROP  Procedure  usp_vendor_payment_freq_ins
GO

/*
**********************************************************************
* 4/27/2010 Created
* Gail Mangaroo 
* Create vendor payment freq
**********************************************************************
* 8/16/2012 //  4/3/2012 - Gail Mangaroo 
* Added end date & package id
*********************************************************************
*/

CREATE Procedure usp_vendor_payment_freq_ins
( 
 @p_vendor_id int 
 , @p_payment_freq_id int 
 , @p_date_effective datetime 
 , @p_username varchar(100) 
 , @p_active bit = 0 
 , @p_date_end datetime = null
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_interval float = 0 
) 
AS
BEGIN 

	INSERT INTO [lp_commissions].[dbo].[vendor_payment_freq]
           ([vendor_id]
           ,[payment_freq_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_end]
           ,[interval]
           ,[package_id] 
		   ,[interval_type_id]
           )
     SELECT 
           @p_vendor_id
           ,@p_payment_freq_id
           ,@p_date_effective
           ,@p_active
           ,getdate()
           ,@p_username
           ,@p_date_end
           ,@p_interval
		   ,@p_package_id
    	   ,@p_interval_type_id
					 
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
	
END 
GO

USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_payment_freq_sel_by_vendor]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_payment_freq_sel_by_vendor]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 7/15/2010 Created
* Gail Mangaroo 
* Get all vendor payment freqs
**********************************************************************
* 2/21/2012 Gail Mangaroo 
* Added NOLOCK
**********************************************************************
* 8/16/2012  Gail Mangaroo 
* Added package id
**********************************************************************

*/
CREATE Procedure [dbo].[usp_vendor_payment_freq_sel_by_vendor]
(@p_vendor_id int  
	, @p_package_id int = 0 ) 
AS
BEGIN 

	DECLARE @strParams nvarchar(1000)
	DECLARE @strSQL nvarchar(1000)
	
	SET @strParams = N' @p_vendor_id int , @p_package_id int  '
	SET @strSQL = '
		SELECT *
			FROM [lp_commissions].[dbo].[vendor_payment_freq] (NOLOCK)
			WHERE active = 1
				AND vendor_id = @p_vendor_id '
	
	IF isnull(@p_package_id,0) <> 0
		SET @strSQL = @strSQL + ' AND package_id = @p_package_id '
  
	EXECUTE sp_executesql  @strSQL
		, @strParams 
		, @p_vendor_id = @p_vendor_id
		, @p_package_id = @p_package_id
		
END 
GO

USE [lp_commissions]
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_payment_freq_upd')
	DROP  Procedure  usp_vendor_payment_freq_upd
GO

/*
**********************************************************************
* 4/27/2010 Created
* Gail Mangaroo 
* Update vendor payment freq
**********************************************************************
* 8/16/2012 // 4/3/2012 - Gail Mangaroo 
* Added end date & package id 
*********************************************************************
*/

CREATE Procedure usp_vendor_payment_freq_upd
( @p_freq_id int 
 , @p_vendor_id int 
 , @p_payment_freq_id int 
 , @p_date_effective datetime 
 , @p_active bit
 , @p_username varchar(100) 
 , @p_date_end datetime = null
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_interval float = 0 
 )  
AS
BEGIN 

	UPDATE [lp_commissions].[dbo].[vendor_payment_freq]
	SET [vendor_id] = @p_vendor_id
		  ,[payment_freq_id] = @p_payment_freq_id
		  ,[date_effective] = @p_date_effective
		  ,[active] = @p_active
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
		  ,[date_end] = @p_date_end
		  ,[package_id] = @p_package_id
		  ,[interval_type_id] = @p_interval_type_id
		  ,[interval] = @p_interval
		  
	WHERE freq_id =  @p_freq_id
					 
 	RETURN @@ROWCOUNT
	
END
GO

USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_payment_option_ins]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_payment_option_ins]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 4/8/2010 Created
* Gail Mangaroo 
* Create vendor payment option
**********************************************************************
* 6/2/2010 Gail Mangaroo 
* Added term field
**********************************************************************
* Modified: 4/25/2012 - 8/25/2012 Gail Mangaroo 
* Added end date and group id fields
**********************************************************************
*/


CREATE Procedure [dbo].[usp_vendor_payment_option_ins]
( 
 @p_vendor_id int 
 , @p_payment_option_id int 
 , @p_date_effective datetime 
 , @p_username varchar(100) 
 , @p_active bit = 0 
 , @p_term float = 0 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0
) 
AS
BEGIN 

	INSERT INTO [lp_commissions].[dbo].[vendor_payment_option]
           ([vendor_id]
           ,[payment_option_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[term] 
           ,[date_end]
           ,[package_id]
           ,[interval_type_id]
           )
           
     SELECT 
           @p_vendor_id
           ,@p_payment_option_id
           ,@p_date_effective
           ,@p_active
           ,getdate()
           ,@p_username
           ,@p_term
           ,@p_date_end
           ,@p_package_id
           ,@p_interval_type_id
   					 
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
	
END 

GO

USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_payment_option_sel_by_id]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_payment_option_sel_by_id]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
**********************************************************************
* 8/15/2012 Created
* Gail Mangaroo 
* Get vendor payment options
**********************************************************************
*/
CREATE Procedure [dbo].[usp_vendor_payment_option_sel_by_id]
( @p_option_id int) 
AS
BEGIN 

	SELECT *
	FROM [lp_commissions].[dbo].[vendor_payment_option] vp (NOLOCK) 
	WHERE option_id = @p_option_id
	
END 
GO

USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_payment_option_sel_by_vendor]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_payment_option_sel_by_vendor]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
**********************************************************************
* 4/7/2010 Created
* Gail Mangaroo 
* Get vendor payment options
**********************************************************************
* Modified 8/11/2011 Gail Mangaroo 
* Added order by 
**********************************************************************

*/
CREATE Procedure [dbo].[usp_vendor_payment_option_sel_by_vendor]
( @p_vendor_id int
 , @p_option_type_id int = 0 
 , @p_package_id int = 0 ) 
AS
BEGIN 
	
  	DECLARE @strParams nvarchar(1000)
	DECLARE @strSQL nvarchar(1000)
	
	SET @strParams = N' @p_vendor_id int , @p_package_id int , @p_option_type_id int '
	SET @strSQL = '
		SELECT *
		  FROM [lp_commissions].[dbo].[vendor_payment_option] vp (NOLOCK)
			LEFT JOIN lp_commissions..payment_option po (NOLOCK) ON vp.payment_option_id= po.payment_option_id 
		  WHERE vp.active = 1 
			AND vp.vendor_id = @p_vendor_id  '
			
	IF isnull(@p_package_id,0) <> 0
		SET @strSQL = @strSQL + ' AND vp.package_id = @p_package_id '
  
	IF ISNULL(@p_option_type_id, 0) <> 0
		SET @strSQL = @strSQL + ' AND po.payment_option_type_id = @p_option_type_id '
		
	SET @strSQL = @strSQL + ' ORDER BY date_effective  '
		 
	EXECUTE sp_executesql  @strSQL
		, @strParams 
		, @p_vendor_id = @p_vendor_id
		, @p_package_id = @p_package_id 
		, @p_option_type_id = @p_option_type_id 
		
	
END 
GO


USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_payment_option_upd]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_payment_option_upd]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 4/8/2010 Created
* Gail Mangaroo 
* Update vendor payment option
**********************************************************************
* 6/2/2010 Gail Mangaroo 
* Added term field
**********************************************************************
* Modified: 4/25/2012 - 8/25/2012 Gail Mangaroo 
* Added end date and package id fields
**********************************************************************
*/

CREATE Procedure [dbo].[usp_vendor_payment_option_upd]
( @p_option_id int 
 , @p_vendor_id int 
 , @p_payment_option_id int 
 , @p_date_effective datetime 
 , @p_active bit
 , @p_username varchar(100) 
 , @p_term float = 0 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 )  
AS
BEGIN 

	UPDATE [lp_commissions].[dbo].[vendor_payment_option]
	   SET [vendor_id] = @p_vendor_id
		  ,[payment_option_id] = @p_payment_option_id
		  , date_effective = @p_date_effective
		  ,[active] = @p_active
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
		  
		  ,[term] = @p_term
		  ,[date_end] = @p_date_end
		  ,[package_id] = @p_package_id
		  ,[interval_type_id] = @p_interval_type_id
		  
	 WHERE option_id =  @p_option_id
	 						 
 	 RETURN @@ROWCOUNT
	
END
GO

USE [Lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_rate_sel_by_parent]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_rate_sel_by_parent]
GO


-- ===================================
-- Created By: Gail Mangaroo 
-- Created Date: 11/19/2012
-- ===================================
CREATE PROC [dbo].[usp_vendor_rate_sel_by_parent] 
(
@p_parent_setting_id int 
) 
AS 

BEGIN 
	
	SELECT r.*
	
		,cr.[calculation_rule_id]
		,cr.[calculation_rule_code]
		,cr.[calculation_rule_descp]
		
	FROM [lp_commissions].[dbo].[vendor_rate] r (NOLOCK)
		LEFT JOIN [lp_commissions].[dbo].rate_type rt (NOLOCK) ON r.rate_type_id = rt.rate_type_id 
		LEFT JOIN [lp_commissions].[dbo].calculation_rule cr (NOLOCK) ON cr.calculation_rule_id = rt.calculation_rule_id 
		
	WHERE r.assoc_rate_setting_id = @p_parent_setting_id 
		AND r.inactive_ind = 0 
		
	ORDER BY r.[rate_vendor_type_id], r.[rate_type_id], r.[transaction_type_id]
END
GO

USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_report_date_option_ins]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_report_date_option_ins]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 5/11/2010 Created
* Gail Mangaroo 
* Create vendor report date option
**********************************************************************
* 11/4/2010 Modified - Gail Mangaroo
* Added contract_group_id and grace_period fields
**********************************************************************
* 4/3/2012 Modified - Gail Mangaroo
* Added end date
**********************************************************************
* 8/28/2012 Modified - Gail Mangaroo 
* Added fields and optimized
**********************************************************************
*/

CREATE Procedure [dbo].[usp_vendor_report_date_option_ins]
( 
 @p_vendor_id int 
 , @p_report_date_option_id int 
 , @p_date_effective datetime 
 , @p_username varchar(100) 
 , @p_active bit = 0 
 , @p_contract_group_id int = 0 
 , @p_grace_period float = 0 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
) 
AS
BEGIN 

	INSERT INTO [lp_commissions].[dbo].[vendor_report_date_option]
           ([vendor_id]
           ,[report_date_option_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[contract_group_id] 
           ,[grace_period]
           ,[date_end]
           ,[package_id] 
		   ,[interval_type_id]
           )
     SELECT 
           @p_vendor_id
           ,@p_report_date_option_id
           ,@p_date_effective
           ,@p_active
           ,getdate()
           ,@p_username
           ,@p_contract_group_id
		   ,@p_grace_period
		   ,@p_date_end
		   ,@p_package_id
    	   ,@p_interval_type_id
    					 
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
	
END 
GO


USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_report_date_option_sel_by_vendor]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_report_date_option_sel_by_vendor]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 8/28/2012 Created
* Gail Mangaroo 
* Get all vendor report date option
**********************************************************************
*/
CREATE Procedure [dbo].[usp_vendor_report_date_option_sel_by_vendor]
(@p_vendor_id int
, @p_package_id int = 0 ) 
AS
BEGIN 

	DECLARE @strParams nvarchar(1000)
	DECLARE @strSQL nvarchar(1000)
	
	SET @strParams = N' @p_vendor_id int , @p_package_id int  '
	SET @strSQL = '
		SELECT *
			FROM [lp_commissions].[dbo].[vendor_report_date_option] (NOLOCK)
			WHERE active = 1
				AND vendor_id = @p_vendor_id '
	
	IF isnull(@p_package_id,0) <> 0
		SET @strSQL = @strSQL + ' AND package_id = @p_package_id '
  
	EXECUTE sp_executesql  @strSQL
		, @strParams 
		, @p_vendor_id = @p_vendor_id
		, @p_package_id = @p_package_id
		
END 
GO


USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_report_date_option_sel_by_vendor]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_report_date_option_sel_by_vendor]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
**********************************************************************
* 8/28/2012 Created
* Gail Mangaroo 
* Get all vendor report date option
**********************************************************************
*/
CREATE Procedure [dbo].[usp_vendor_report_date_option_sel_by_vendor]
(@p_vendor_id int
, @p_package_id int = 0 ) 
AS
BEGIN 

	DECLARE @strParams nvarchar(1000)
	DECLARE @strSQL nvarchar(1000)
	
	SET @strParams = N' @p_vendor_id int , @p_package_id int  '
	SET @strSQL = '
		SELECT *
			FROM [lp_commissions].[dbo].[vendor_report_date_option] (NOLOCK)
			WHERE active = 1
				AND vendor_id = @p_vendor_id '
	
	IF isnull(@p_package_id,0) <> 0
		SET @strSQL = @strSQL + ' AND package_id = @p_package_id '
  
	EXECUTE sp_executesql  @strSQL
		, @strParams 
		, @p_vendor_id = @p_vendor_id
		, @p_package_id = @p_package_id
		
END 
GO


USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_report_date_option_upd]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_report_date_option_upd]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
*5/11/2010 Created
* Gail Mangaroo 
* Update vendor report date
**********************************************************************
* 11/4/2010 Modified - Gail Mangaroo
* Added contract_group_id and grace_period fields
**********************************************************************
* 4/3/2012 Modified - Gail Mangaroo
* Added end date
**********************************************************************
* 8/28/2012 Modified - Gail Mangaroo 
* Added fields
**********************************************************************
*/

CREATE Procedure [dbo].[usp_vendor_report_date_option_upd]
( @p_option_id int 
 , @p_vendor_id int 
 , @p_report_date_option_id int 
 , @p_date_effective datetime 
 , @p_active bit
 , @p_username varchar(100) 
 , @p_contract_group_id int = 0 
 , @p_grace_period float = 0 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 )  
AS
BEGIN 

	UPDATE [lp_commissions].[dbo].[vendor_report_date_option]
	   SET [vendor_id] = @p_vendor_id
		  ,[report_date_option_id] = @p_report_date_option_id
		  ,[date_effective] = @p_date_effective
		  ,[active] = @p_active
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
		  ,[contract_group_id] = @p_contract_group_id
		  ,[grace_period] = @p_grace_period
		  ,[date_end] = @p_date_end
		  ,[package_id] = @p_package_id
		  ,[interval_type_id] = @p_interval_type_id
		  
	WHERE option_id =  @p_option_id
	 						 
 	RETURN @@ROWCOUNT
	
END
GO

USE [lp_commissions]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_setting_param_del]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_setting_param_del]
GO


/*
**********************************************************************
* 4/10/2012 Created
* Gail Mangaroo 
* Delete /De-Activate parameter
**********************************************************************

*/

CREATE Procedure [dbo].[usp_vendor_setting_param_del]
( @p_vendor_setting_param_id int 
 , @p_username varchar(50) 
 )  
AS
BEGIN 

	UPDATE [lp_commissions].[dbo].[vendor_setting_param]
	   SET [active] = 0 
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
	 
	 WHERE vendor_setting_param_id =  @p_vendor_setting_param_id
	 	 					 
 	RETURN @@ROWCOUNT

END
GO

USE [lp_commissions]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_setting_param_ins]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_setting_param_ins]
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 4/10/2012
-- Description:	Insert setting params
-- =============================================
CREATE PROCEDURE [dbo].[usp_vendor_setting_param_ins]
(	@p_setting_type_id int 
	, @p_setting_id int 
	, @p_param_id int 
	, @p_param_value varchar(150)
	, @p_param_operator int 
	, @p_active bit
	, @p_username varchar(100)
)
AS
BEGIN 
	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
           ([setting_type_id]
           ,[setting_id]
           ,[param_id]
           ,[param_value]
           ,[param_operator]
           ,[active]
           ,[date_created]
           ,[username]
          )
     VALUES
           (@p_setting_type_id 
		   ,@p_setting_id
           ,@p_param_id
           ,@p_param_value
           ,@p_param_operator
           ,@p_active
           ,getdate()
           ,@p_username
          ) 
     RETURN ISNULL(Scope_Identity(), 0)
END 
GO 

USE [lp_commissions]
GO 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_setting_param_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_setting_param_sel]
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 4/10/2012
-- Description:	Select setting setting params
-- =============================================
CREATE PROCEDURE [dbo].[usp_vendor_setting_param_sel]
	@p_vendor_setting_param_id int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
	FROM [lp_commissions].[dbo].[vendor_setting_param] (NOLOCK) 
	WHERE vendor_setting_param_id = @p_vendor_setting_param_id 
	
END
GO


USE [lp_commissions]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_setting_param_sel_by_type]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_setting_param_sel_by_type]
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 4/10/2012
-- Description:	Select setting setting params
-- =============================================
CREATE PROCEDURE [dbo].[usp_vendor_setting_param_sel_by_type]
	@p_setting_type_id int 
	, @p_setting_id int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
	FROM [lp_commissions].[dbo].[vendor_setting_param] (NOLOCK) 
	WHERE setting_type_id =  @p_setting_type_id 
		AND setting_id = @p_setting_id 
	
END
GO

USE [lp_commissions]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_setting_param_upd]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_setting_param_upd]
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 4/10/2012
-- Description:	Select setting setting params
-- =============================================
CREATE PROCEDURE [dbo].[usp_vendor_setting_param_upd]
(	@p_vendor_setting_param_id int 
	, @p_setting_type_id int 
	, @p_setting_id int 
	, @p_param_id int 
	, @p_param_value varchar(150)
	, @p_param_operator int 
	, @p_active bit
	, @p_username varchar(100)
)
AS
BEGIN 
	UPDATE [lp_commissions].[dbo].[vendor_setting_param]
		SET [setting_type_id] = @p_setting_type_id
			,[setting_id] = @p_setting_id
			,[param_id] = @p_param_id
            ,[param_value] = @p_param_value
            ,[param_operator] = @p_param_operator
            ,[active] = @p_active
            ,[date_modified] = getdate()
            ,[modified_by] = @p_username

    WHERE vendor_setting_param_id = @p_vendor_setting_param_id
    
    RETURN @@ROWCOUNT
END 
GO 





















