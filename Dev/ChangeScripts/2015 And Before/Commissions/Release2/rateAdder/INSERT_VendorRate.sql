USE [Lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_vendor_rate_setting_ins]    Script Date: 01/17/2013 14:03:30 ******/
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
