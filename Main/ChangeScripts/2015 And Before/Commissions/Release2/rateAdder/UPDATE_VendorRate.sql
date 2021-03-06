USE [Lp_commissions]
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
