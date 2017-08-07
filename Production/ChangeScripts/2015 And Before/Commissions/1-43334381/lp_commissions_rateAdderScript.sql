USE [Lp_commissions]
GO

SET ANSI_PADDING OFF
GO

-- Create table to hold additional rate calculation type
IF NOT EXISTS(SELECT * FROM sysobjects WHERE name='rate_type_addcalc' AND xtype='U')
	CREATE TABLE [dbo].[rate_type_addcalc](
		[rate_type_addcalc_id] [int] IDENTITY(1,1) NOT NULL,
		[rate_type_addcalc_code] [varchar](15) NOT NULL,
		[rate_type_addcalc_descp] [varchar](50) NOT NULL,
		[calculation_rule_id] [int] NOT NULL,
	 CONSTRAINT [PK_rate_type_addcalc] PRIMARY KEY CLUSTERED 
	(
		[rate_type_addcalc_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
GO

-- Add columns to trx details
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo'
                 AND  TABLE_NAME = 'transaction_detail'))
BEGIN
    ALTER TABLE [dbo].[transaction_detail] ADD [AdditionalRateTypeCalcId]	INT		NULL
	ALTER TABLE [dbo].[transaction_detail] ADD [AdditionalRateTypeId]		INT		NULL
	ALTER TABLE [dbo].[transaction_detail] ADD [AdditionalRateAmount]		FLOAT	NULL
END

GO

-- Add columns to vendor rates
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo'
                 AND  TABLE_NAME = 'vendor_rate'))
BEGIN
	ALTER TABLE [dbo].[vendor_rate] ADD [AdditionalRateTypeCalcId]	INT		NULL
	ALTER TABLE [dbo].[vendor_rate] ADD [AdditionalRateTypeId]		INT		NULL
	ALTER TABLE [dbo].[vendor_rate] ADD [AdditionalRateAmount]		FLOAT	NULL
END

GO

-- Add columns to trx details
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo'
                 AND  TABLE_NAME = 'zAudit_transaction_detail'))
BEGIN
	ALTER TABLE [dbo].[zAudit_transaction_detail] ADD [AdditionalRateTypeCalcId]	INT		NULL
	ALTER TABLE [dbo].[zAudit_transaction_detail] ADD [AdditionalRateTypeId]		INT		NULL
	ALTER TABLE [dbo].[zAudit_transaction_detail] ADD [AdditionalRateAmount]		FLOAT	NULL
END

GO

-- Add columns to vendor rates
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo'
                 AND  TABLE_NAME = 'zAudit_vendor_rate'))
BEGIN
	ALTER TABLE [dbo].[zAudit_vendor_rate] ADD [AdditionalRateTypeCalcId]	INT		NULL
	ALTER TABLE [dbo].[zAudit_vendor_rate] ADD [AdditionalRateTypeId]		INT		NULL
	ALTER TABLE [dbo].[zAudit_vendor_rate] ADD [AdditionalRateAmount]		FLOAT	NULL
END

GO


----------------------------------------- SEPARATE -----------------------------------------


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 3/6/2012
-- Description:	Inserts a new record into vendor_rate 
-- =============================================
-- =============================================
-- Author:		Lehem Felican
-- Create date: 1/14/2013
-- Description:	Added 3 AdditionalRate params to upd

ALTER PROCEDURE [dbo].[usp_vendor_rate_setting_ins]
(	@p_vendor_id int 
	, @p_rate_vendor_type_id int 
	, @p_transaction_type_id int 
	, @p_rate_type_id int 
	, @p_product_rate_type_id int 
	, @p_rate float
	, @p_vendor_pct float
	, @p_house_pct	float
	, @p_rate_cap float 
	, @p_pro_rate_term bit 
	, @p_date_effective datetime 
	, @p_date_end datetime 
	, @p_rate_level int 
	, @p_priority int
	, @p_assoc_rate_setting_id int
	, @p_payment_cap float
	, @p_payment_cap_level int 
	, @p_inactive_ind bit
	, @p_username varchar(50) 
	, @p_AdditionalRateTypeCalcId int = 0
	, @p_AdditionalRateTypeId int = 0
	, @p_AdditionalRateAmount float = 0
	) 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO [lp_commissions].[dbo].[vendor_rate]
           ( [vendor_id]
           ,[rate_vendor_type_id]
           ,[transaction_type_id]
           ,[rate_type_id]
           ,[product_rate_type_id]
           ,[rate]
           ,[vendor_pct]
           ,[house_pct]
           ,[rate_cap]
           ,[pro_rate_term]
           ,[date_effective]
           ,[end_date]
           ,[rate_level_id]
           ,[rate_setting_rank]
           ,[assoc_rate_setting_id]
           , payment_cap  
		   , payment_cap_level_id 
           ,[inactive_ind]
           ,[date_created]
           ,[username]
           , AdditionalRateTypeCalcId
			, AdditionalRateTypeId
			, AdditionalRateAmount
          ) 
           
           
     VALUES
           (@p_vendor_id  
			, @p_rate_vendor_type_id  
			, @p_transaction_type_id  
			, @p_rate_type_id  
			, @p_product_rate_type_id  
			, @p_rate 
			, @p_vendor_pct 
			, @p_house_pct	
			, @p_rate_cap  
			, @p_pro_rate_term  
			, @p_date_effective  
			, @p_date_end  
			, @p_rate_level  
			, @p_priority 
			, @p_assoc_rate_setting_id 
			, @p_payment_cap 
		    , @p_payment_cap_level
			, @p_inactive_ind 
			, getdate()
			, @p_username
			, @p_AdditionalRateTypeCalcId
			, @p_AdditionalRateTypeId
			, @p_AdditionalRateAmount  )

	RETURN ISNULL(Scope_Identity(), 0)
          
END
GO

/****** Object:  StoredProcedure [dbo].[usp_transaction_detail_ins]    Script Date: 01/17/2013 09:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 6/30/2008
-- Description:	Inserts new transaction detail record and returns the new transaction_detail_id
-- =============================================
-- 9/10/2009 Gail Mangaroo Added Term Start and End Dates 
-- =============================================
-- 12/19/2009 Gail Mangaroo Added batch_id, is_primary, comments, contract_term_start and contract_end fields 
-- =============================================
-- 4/12/2010 Gail Mangaroo Added payment_opiton_id and payment_option_seting fields
--=============================================
-- 11/23/2011 Gail Mangaroo Changed data type of @p_contract_term param to allow decimal
-- ============================================
-- =============================================
-- Author:		Lehem Felican
-- Create date: 1/14/2013
-- Description:	Added 3 AdditionalRate params to update query
-- =============================================
ALTER PROCEDURE [dbo].[usp_transaction_detail_ins] 
	-- Add the parameters for the stored procedure here
	@p_account_id varchar(30)  
	, @p_contract_nbr varchar(30)
	, @p_product_id varchar(30)
	, @p_utility_id varchar(30)
	, @p_retail_mkt_id varchar(5)
	, @p_vendor_id int
	, @p_date_deal datetime 
	, @p_date_flow_requested datetime 
	, @p_transaction_type_id int
	, @p_approval_status_id int 

	, @p_base_amount money
	, @p_rate float
	, @p_term float 
	, @p_vendor_pct float 
	, @p_house_pct float
	, @p_pro_rate_term bit 
	, @p_amount money

	, @p_rate_setting_id int
	, @p_calculation_rule_id int 
	, @p_date_due datetime 
	, @p_void int
 
	, @p_source varchar(50)
	, @p_reason_code varchar(50)
	, @p_transaction_summary_id int
	, @p_invoice_id int 
	, @p_calculation_freq_id int 
	, @p_assoc_transaction_id int = null

	, @p_username varchar(50)
	
	, @p_rate_requested float 
	, @p_rate_split_point float
	, @p_exception_ind bit 
	, @p_primary_vendor_id int = 0
	, @p_contract_term float = 0 
	, @p_payment_option_id int = 0 
	, @p_nonreversible bit = 0
	
	, @p_pro_rate_factor float = 1
	, @p_rate_cap float = 0 
	, @p_is_custom_rate bit = 0 
	
	, @p_term_start datetime = null 
	, @p_term_end datetime = null 
	
	, @p_transaction_batch_id varchar(50)
	, @p_comments varchar(150) = null 
	, @p_is_primary  bit = 0 
	
	, @p_contract_term_start datetime = null 
	, @p_contract_term_end datetime = null 
	
	, @p_payment_option_setting_id int = 0 
	, @p_payment_option_def_id int = 0
	, @p_report_date_option_id int = 0
	
	, @p_AdditionalRateTypeCalcId int = 0
	, @p_AdditionalRateTypeId int = 0
	, @p_AdditionalRateAmount float = 0
	
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [lp_commissions].[dbo].[transaction_detail]
           ([account_id]
           ,[contract_nbr]
           ,[product_id]
           ,[utility_id]
           ,[retail_mkt_id]
           ,[vendor_id]
           ,[date_deal]
           ,[date_flow_requested]

           ,[transaction_type_id]
           ,[approval_status_id]

           ,[base_amount]
           ,[rate]
           ,[term]
           ,[vendor_pct]
           ,[house_pct]
           ,[pro_rate_term]
           ,[amount]
           ,[rate_setting_id]
           ,[calculation_rule_id]

           ,[date_due]
           ,[void]
           ,[source]
           ,[reason_code]

           ,[transaction_summary_id]
           ,[invoice_id]
           ,[calculation_freq_id]
           ,[assoc_transaction_id]
           
			,[date_created]
           ,[username]

	
			, rate_requested 
			, rate_split_point 
			, exception_ind  
			, primary_vendor_id
			
			, contract_term
			, payment_option_id
			, nonreversible
			
			, pro_rate_factor 
			, rate_cap 
			, is_custom_rate 
			
			, date_term_start
			, date_term_end 
			
			, transaction_batch_id 
			, comments 
			, is_primary  
			
			, date_contract_term_start
			, date_contract_term_end
			
			,payment_option_setting_id
			,payment_option_def_id
			,report_date_option_id
			
			, AdditionalRateTypeCalcId
			, AdditionalRateTypeId
			, AdditionalRateAmount
           )

     VALUES
           (@p_account_id
           ,@p_contract_nbr
			,@p_product_id 
           ,@p_utility_id
			,@p_retail_mkt_id
           ,@p_vendor_id 
			,@p_date_deal
			,@p_date_flow_requested

			,@p_transaction_type_id
			,@p_approval_status_id

           ,@p_base_amount
           ,@p_rate
			, @p_term 
			, @p_vendor_pct 
			, @p_house_pct 
			, @p_pro_rate_term 
			, @p_amount
           ,@p_rate_setting_id
           ,@p_calculation_rule_id
           
			,@p_date_due
           ,@p_void
           ,@p_source
           ,@p_reason_code 

           ,@p_transaction_summary_id
			, @p_invoice_id
			, @p_calculation_freq_id 
			, @p_assoc_transaction_id

           ,getdate()
           ,@p_username

	
			, @p_rate_requested  
			, @p_rate_split_point 
			, @p_exception_ind 
			, @p_primary_vendor_id
		   
		   , @p_contract_term
		   , @p_payment_option_id
		   , @p_nonreversible
		   
		   , @p_pro_rate_factor 
		   , @p_rate_cap 
		   , @p_is_custom_rate 
		   
		   , @p_term_start 
		   , @p_term_end 
		   
		   	, @p_transaction_batch_id 
			, @p_comments 
			, @p_is_primary 
			
			, @p_contract_term_start
			, @p_contract_term_end
			
			, @p_payment_option_setting_id
			, @p_payment_option_def_id
			, @p_report_date_option_id 
			
			, @p_AdditionalRateTypeCalcId
			, @p_AdditionalRateTypeId
			, @p_AdditionalRateAmount
		)

	RETURN ISNULL(Scope_Identity(), 0)
	
END
GO

/****** Object:  StoredProcedure [dbo].[usp_vendor_rate_setting_upd]    Script Date: 01/15/2013 14:08:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 3/6/2012
-- Description:	Updates vendor rate record.
-- =============================================
-- =============================================
-- Author:		Lehem Felican
-- Create date: 1/14/2013
-- Description:	Added 3 AdditionalRate params to update query
-- =============================================
ALTER PROCEDURE [dbo].[usp_vendor_rate_setting_upd]
(	@p_rate_setting_id int 
	, @p_vendor_id int 
	, @p_rate_vendor_type_id int 
	, @p_transaction_type_id int 
	, @p_rate_type_id int 
	, @p_product_rate_type_id int 
	, @p_rate float
	, @p_vendor_pct float
	, @p_house_pct	float
	, @p_rate_cap float 
	, @p_pro_rate_term bit 
	, @p_date_effective datetime 
	, @p_date_end datetime 
	, @p_rate_level int 
	, @p_priority int
	, @p_assoc_rate_setting_id int
	, @p_payment_cap float
	, @p_payment_cap_level int 
	, @p_inactive_ind bit
	, @p_username varchar(50) 
	
	, @p_AdditionalRateTypeCalcId int = 0
	, @p_AdditionalRateTypeId int = 0
	, @p_AdditionalRateAmount float = 0
	) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE [lp_commissions].[dbo].[vendor_rate]
	SET [vendor_id] = @p_vendor_id
           ,[rate_vendor_type_id] = @p_rate_vendor_type_id
           ,[transaction_type_id] = @p_transaction_type_id
           ,[rate_type_id] = @p_rate_type_id
           ,[product_rate_type_id] = @p_product_rate_type_id
           ,[rate] = @p_rate
           ,[vendor_pct] = @p_vendor_pct
           ,[house_pct] = @p_house_pct
           ,[rate_cap] = @p_rate_cap
           ,[pro_rate_term] = @p_pro_rate_term
           ,[date_effective] = @p_date_effective
           ,[end_date] = @p_date_end
           ,[rate_level_id] = @p_rate_level
           ,[rate_setting_rank] = @p_priority
           ,[assoc_rate_setting_id] = @p_assoc_rate_setting_id
           , payment_cap = @p_payment_cap 
		   , payment_cap_level_id = @p_payment_cap_level
           ,[inactive_ind] = @p_inactive_ind
           ,[date_modified] =  getdate()
           ,[modified_by] = @p_username
           
           , AdditionalRateTypeCalcId    = @p_AdditionalRateTypeCalcId 
		   , AdditionalRateTypeId		 = @p_AdditionalRateTypeId
		   , AdditionalRateAmount		 = @p_AdditionalRateAmount
      
	WHERE rate_setting_id = @p_rate_setting_id

	RETURN @@RowCount
END
GO

/****** Object:  StoredProcedure [dbo].[usp_transaction_detail_upd]    Script Date: 01/17/2013 09:44:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 6/30/2008
-- Description:	Update Transaction Detail Record
-- =============================================
-- 9/10/2009 Gail Mangaroo 
-- Added term start and end params
-- =============================================
-- 12/19/2009 Gail Mangaroo Added batch_id, is_primary, comments, contract_term_start and contract_end fields 
-- =============================================
-- 4/12/2010 Gail Mangaroo Added payment_opiton_id and payment_option_seting fields
--=============================================
-- =============================================
-- Author:		Lehem Felican
-- Create date: 1/14/2013
-- Description:	Added 3 AdditionalRate params to update query
-- =============================================

ALTER PROCEDURE [dbo].[usp_transaction_detail_upd] 	
	@p_transaction_detail_id int
	, @p_account_id varchar(30)  
	, @p_contract_nbr varchar(30)
	, @p_product_id varchar(30)
	, @p_utility_id varchar(30)
	, @p_retail_mkt_id varchar(5)
	, @p_vendor_id int
	, @p_date_deal datetime 
	, @p_date_flow_requested datetime 
	, @p_transaction_type_id int
	, @p_approval_status_id int 

	, @p_base_amount money
	, @p_rate float
	, @p_term float 
	, @p_vendor_pct float 
	, @p_house_pct float
	, @p_pro_rate_term bit 
	, @p_amount money

	, @p_rate_setting_id int
	, @p_calculation_rule_id int 
	, @p_date_due datetime 
	, @p_void int
 
	, @p_source varchar(50)
	, @p_reason_code varchar(50)
	, @p_transaction_summary_id int
	, @p_invoice_id int 
	, @p_calculation_freq_id int 
	, @p_assoc_transaction_id int = null

	, @p_username varchar(50)

	, @p_rate_requested float
	, @p_rate_split_point float
	, @p_exception_ind bit 
	, @p_primary_vendor_id int 
	, @p_contract_term float
	, @p_payment_option_id int 
	, @p_nonreversible bit
	
	, @p_pro_rate_factor float = null 
	, @p_rate_cap float = null 
	, @p_is_custom_rate bit = null 
	
	, @p_term_start datetime 
	, @p_term_end datetime 
	
	, @p_transaction_batch_id varchar(50)
	, @p_comments varchar(150) = null 
	, @p_is_primary  bit = 0 
	
	, @p_contract_term_start datetime = null 
	, @p_contract_term_end datetime = null 
	
	, @p_payment_option_setting_id int = 0 
	, @p_payment_option_def_id int = 0
	, @p_report_date_option_id int = 0
	
	, @p_AdditionalRateTypeCalcId int = 0
	, @p_AdditionalRateTypeId int = 0
	, @p_AdditionalRateAmount float = 0
AS
	
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [lp_commissions].[dbo].[transaction_detail]
	   SET [account_id] = @p_account_id
		  ,[contract_nbr] = @p_contract_nbr
		  ,[product_id] = @p_product_id
		  ,[utility_id] = @p_utility_id
		  ,[retail_mkt_id] = @p_retail_mkt_id
		  ,[vendor_id] = @p_vendor_id
		  ,[date_deal] = @p_date_deal
		  ,[date_flow_requested] = @p_date_flow_requested
		  ,[transaction_type_id] = @p_transaction_type_id
		  ,[approval_status_id] = @p_approval_status_id
		  ,[base_amount] = @p_base_amount
		  ,[rate] = @p_rate
		  ,[term] = @p_term
		  ,[vendor_pct] = @p_vendor_pct
		  ,[house_pct] = @p_house_pct
		  ,[pro_rate_term] = @p_pro_rate_term
		  ,[amount] = @p_amount
		  ,[rate_setting_id] = @p_rate_setting_id
		  ,[calculation_rule_id] = @p_calculation_rule_id
		  ,[date_due] = @p_date_due
		  ,[void] = @p_void
		  ,[source] = @p_source
		  ,[reason_code] = @p_reason_code
		  ,[transaction_summary_id] = @p_transaction_summary_id
		  ,[invoice_id] = @p_invoice_id
		  ,[calculation_freq_id] = @p_calculation_freq_id
		  ,[assoc_transaction_id] = @p_assoc_transaction_id
		 
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username

			, rate_requested = @p_rate_requested 
			, rate_split_point = @p_rate_split_point
			, exception_ind = @p_exception_ind
			, primary_vendor_id = @p_primary_vendor_id
			, contract_term = @p_contract_term 
			, payment_option_id = @p_payment_option_id
			, nonreversible = @p_nonreversible
			, pro_rate_factor = isnull(@p_pro_rate_factor , pro_rate_factor)
			, rate_cap = isnull(@p_rate_cap, rate_cap ) 
			, is_custom_rate = isnull(@p_is_custom_rate  , is_custom_rate ) 
			
			, date_term_start = @p_term_start 
			, date_term_end = @p_term_end 
			
			, transaction_batch_id  = @p_transaction_batch_id
			, comments = @p_comments
			, is_primary = @p_is_primary
		   
			, date_contract_term_start = @p_contract_term_start 
			, date_contract_term_end = @p_contract_term_end
		   
			, payment_option_setting_id  = @p_payment_option_setting_id
			, payment_option_def_id =  @p_payment_option_def_id 
			, report_date_option_id  = @p_report_date_option_id 
			
			, AdditionalRateTypeCalcId   = @p_AdditionalRateTypeCalcId 
			, AdditionalRateTypeId		 = @p_AdditionalRateTypeId
			, AdditionalRateAmount		 = @p_AdditionalRateAmount
			
	WHERE transaction_detail_id = @p_transaction_detail_id

	RETURN @@ROWCOUNT
END
GO

/****** Object:  Trigger [dbo].[trg_audit_transaction_detail]    Script Date: 01/23/2013 14:04:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 10/02/2008
-- Description:	Insert audit record
-- =============================================
-- 12/19/2009 Gail Mangaroo Added batch_id, is_primary, comments, contract_term_start and contract_end fields 
-- =============================================
-- 4/12/2010 Gail Mangaroo 
-- Added payment_option_setting_id, payment_option_def_id
-- =============================================
ALTER TRIGGER [dbo].[trg_audit_transaction_detail]
   ON  [dbo].[transaction_detail]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO [lp_commissions].[dbo].[zAudit_transaction_detail]
           ([transaction_detail_id]
           ,[account_id]
           ,[contract_nbr]
           ,[product_id]
           ,[utility_id]
           ,[retail_mkt_id]
           ,[vendor_id]
           ,[date_deal]
           ,[date_flow_requested]
           ,[transaction_type_id]
           ,[approval_status_id]
           ,[base_amount]
           ,[rate]
           ,[term]
           ,[contract_term]
           ,[vendor_pct]
           ,[house_pct]
           ,[pro_rate_term]
           ,[amount]
           ,[rate_setting_id]
           ,[rate_requested]
           ,[rate_split_point]
           ,[calculation_rule_id]
           ,[date_due]
           ,[void]
           ,[source]
           ,[reason_code]
           ,[transaction_summary_id]
           ,[invoice_id]
           ,[calculation_freq_id]
           ,[assoc_transaction_id]
           ,[exception_ind]
           , payment_option_id 
           , primary_vendor_id
           , nonreversible
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[date_audit]
           ,[pro_rate_factor]
		   ,[is_custom_rate]
		   ,[rate_cap]
		   ,[date_term_start] 
		   ,[date_term_end]
		   ,transaction_batch_id 
		   ,comments 
		   ,is_primary 
		   ,date_contract_term_start 
			,date_contract_term_end 
			,payment_option_setting_id
			,payment_option_def_id
			,report_date_option_id 
			,AdditionalRateTypeCalcId
			,AdditionalRateTypeId
			,AdditionalRateAmount
	)
     
	SELECT  [transaction_detail_id]
           ,[account_id]
           ,[contract_nbr]
           ,[product_id]
           ,[utility_id]
           ,[retail_mkt_id]
           ,[vendor_id]
           ,[date_deal]
           ,[date_flow_requested]
           ,[transaction_type_id]
           ,[approval_status_id]
           ,[base_amount]
           ,[rate]
           ,[term]
           ,[contract_term]
           ,[vendor_pct]
           ,[house_pct]
           ,[pro_rate_term]
           ,[amount]
           ,[rate_setting_id]
           ,[rate_requested]
           ,[rate_split_point]
           ,[calculation_rule_id]
           ,[date_due]
           ,[void]
           ,[source]
           ,[reason_code]
           ,[transaction_summary_id]
           ,[invoice_id]
           ,[calculation_freq_id]
           ,[assoc_transaction_id]
           ,[exception_ind]
           , payment_option_id 
           , primary_vendor_id
           , nonreversible
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,getdate()
           ,[pro_rate_factor]
		   ,[is_custom_rate]
		   ,[rate_cap]
		   ,[date_term_start] 
		   ,[date_term_end]
		   ,transaction_batch_id 
		   ,comments 
		   ,is_primary 
		   ,date_contract_term_start 
		   ,date_contract_term_end   
			,payment_option_setting_id
			,payment_option_def_id
			,report_date_option_id
			,AdditionalRateTypeCalcId
			,AdditionalRateTypeId
			,AdditionalRateAmount
			
	FROM INSERTED 

END
GO

/****** Object:  Trigger [dbo].[trg_audit_vendor_rate]    Script Date: 01/23/2013 14:07:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 10/02/2008
-- Description:	Insert audit record
-- =============================================
-- 3/23/2010 Gail Mangaroo - Added payment_option_def_Id 
-- =============================================
-- 5/20/2010 Gail Mangaroo - Added usage range fields 
-- =============================================
ALTER TRIGGER [dbo].[trg_audit_vendor_rate]
   ON  [dbo].[vendor_rate]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO [lp_commissions].[dbo].[zAudit_vendor_rate]
           ([rate_setting_id]
           ,[rate_type_id]
           ,[rate]
           ,[vendor_pct]
           ,[house_pct]
           ,[rate_vendor_type_id]
           ,[vendor_id]
           ,[product_id]
           ,[product_category]
           ,[product_sub_category]
           ,[retail_mkt_id]
           ,[transaction_type_id]
           ,[pro_rate_term]
           ,[inactive_ind]
           , term_months
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[date_audit]
           , account_type
           , rate_cap 
           , payment_option_def_id 
           , date_effective 
           , contract_usage_range_start
           , contract_usage_range_end
           ,AdditionalRateTypeCalcId
			,AdditionalRateTypeId
			,AdditionalRateAmount
			)
	SELECT [rate_setting_id]
           ,[rate_type_id]
           ,[rate]
           ,[vendor_pct]
           ,[house_pct]
           ,[rate_vendor_type_id]
           ,[vendor_id]
           ,[product_id]
           ,[product_category]
           ,[product_sub_category]
           ,[retail_mkt_id]
           ,[transaction_type_id]
           ,[pro_rate_term]
           ,[inactive_ind]
           ,term_months
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
			,getdate()
			, account_type
			, rate_cap
			, payment_option_def_id 
			, date_effective 
           , contract_usage_range_start
           , contract_usage_range_end
           ,AdditionalRateTypeCalcId
			,AdditionalRateTypeId
			,AdditionalRateAmount
	FROM INSERTED 
END
GO