USE [Lp_common]
GO
/****** Object:  StoredProcedure [dbo].[usp_DefaultExpiredProductAndRateSelect]    Script Date: 06/09/2015 14:42:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 02/17/2011
-- Description:	Gets the default expired product 
-- and rate for a determined product
-- (Legacy code from lp_account..usp_AccountExpireProdUpd,
-- but for only one account)
-- SD20695
--PBI 68949: Added the utility field 
--Sara Lakshmanan  June 9 2015
-- =============================================

ALTER PROCEDURE [dbo].[usp_DefaultExpiredProductAndRateSelect]
(
	@ProductId       char(20)
)

AS
BEGIN

	DECLARE @w_default_expire_product_id	char(20),
			@w_default_expire_rate_id		int,
			@w_default_expire_term_months	int,
			@w_default_expire_rate			float,
			@w_Utility_ID			char(15)
	
	-- make sure product has a default expire product,
	-- is active, and has a rate.
	--Added utility for PBI 68949
	SELECT	DISTINCT @w_default_expire_product_id = a.default_expire_product_id, @w_Utility_ID=a.utility_id
	FROM	lp_common..common_product a WITH (NOLOCK)
			INNER JOIN lp_common..common_product_rate b WITH (NOLOCK) 
			ON a.product_id = b.product_id
	WHERE	a.product_id = @ProductId

	IF (LEN(@w_default_expire_product_id) > 0) AND ((SELECT inactive_ind FROM lp_common..common_product WHERE product_id = @w_default_expire_product_id) = 0)
	BEGIN
			SELECT		TOP 1 @w_default_expire_rate_id			= rate_id, 
						@w_default_expire_term_months			= term_months, 
						@w_default_expire_rate					= rate
			FROM		lp_common..common_product_rate
			WHERE		product_id								= @w_default_expire_product_id
			ORDER BY	rate_id
	END
	
	--Added utilityID for PBI 68949
	SELECT @w_default_expire_product_id as ProductId, 
		   @w_default_expire_rate_id as RateId, 
		   @w_default_expire_term_months as Terms, 
		   @w_default_expire_rate as Rate,
		   @w_Utility_ID as UtilityID

	SET NOCOUNT OFF
END 
GO
----------------------------------------------------
USe Libertypower
Go

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'OrdersAPIConfiguration' AND COLUMN_NAME = 'ISCTPURA')
BEGIN

    ALTER TABLE [dbo].[OrdersAPIConfiguration] ADD 
        [ISCTPURA] bit NOT NULL DEFAULT 0
        
END
GO
-----------------------------------------

-----------------------------

USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetOrderAPIConfiguration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetOrderAPIConfiguration]
GO

USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 [usp_GetOrderAPIConfiguration]
 *******************************************************************************
* 7/10/2015  Sara lakshmanan
* This Stored procedure is used to get the ordersAPI configuration Items
Exec [usp_GetOrderAPIConfiguration]
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_GetOrderAPIConfiguration]
AS

BEGIN
	SET NOCOUNT ON;	   
	   Select OrdersAPIConfigurationID,UseEstimationforMeterReadCalendar,ISCTPURA from LIbertyPower..OrdersAPIConfiguration
	SET NOCOUNT OFF;
END
GO


------------------------------







