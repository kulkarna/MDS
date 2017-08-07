/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    tables:
        [dbo].[OE_ACCOUNT]

     Make VM3LPCNOCSQL1.OfferEngineDB Equal (local).OfferEngineDB

   AUTHOR:	[Insert Author Name]

   DATE:	11/27/2012 4:05:02 PM

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
----SET ANSI_PADDING ON
GO
USE [OfferEngineDB]
GO

BEGIN TRAN
GO

-- Add Default Constraint DF_OE_ACCOUNT_ICAP to [dbo].[OE_ACCOUNT]
Print 'Add Default Constraint DF_OE_ACCOUNT_ICAP to [dbo].[OE_ACCOUNT]'
GO
ALTER TABLE [dbo].[OE_ACCOUNT]
	ADD
	CONSTRAINT [DF_OE_ACCOUNT_ICAP]
	DEFAULT ((-1)) FOR [ICAP]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint DF_OE_ACCOUNT_TCAP to [dbo].[OE_ACCOUNT]
Print 'Add Default Constraint DF_OE_ACCOUNT_TCAP to [dbo].[OE_ACCOUNT]'
GO
ALTER TABLE [dbo].[OE_ACCOUNT]
	ADD
	CONSTRAINT [DF_OE_ACCOUNT_TCAP]
	DEFAULT ((-1)) FOR [TCAP]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF
GO


USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountExistsInOfferEngine]    Script Date: 10/30/2013 18:47:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountExistsInOfferEngine]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountExistsInOfferEngine]
GO

USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountExistsInOfferEngine]    Script Date: 10/30/2013 18:47:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku Joseph John
-- Create date: 10/30/2013 6:30 PM
-- Description:	Checks if account exists in offer engine
-- =============================================
CREATE PROCEDURE [dbo].[usp_AccountExistsInOfferEngine]
	-- Add the parameters for the stored procedure here
	@AccountNumber VARCHAR(50), 
	@UtilityCode VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (EXISTS(SELECT ID FROM OE_ACCOUNT (NOLOCK) WHERE ACCOUNT_NUMBER = @AccountNumber AND UTILITY=@UtilityCode))
		SELECT 1 AS 'Exists'
	ELSE
		SELECT 0 AS 'Exists'
END

GO


USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_AccountSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_AccountSelect]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Modified 10/27/2010 - Rick Deigsler
-- Added IsExisting to select	
CREATE PROCEDURE dbo.usp_AccountSelect @AccountNumber varchar( 50 )
AS 
BEGIN
	SET NOCOUNT ON;
	
	SELECT a.ID ,
          a.ACCOUNT_NUMBER ,
          a.ACCOUNT_ID ,
          a.MARKET ,
          a.UTILITY ,
          a.METER_TYPE ,
          a.RATE_CLASS ,
          a.VOLTAGE ,
          a.ZONE ,
          a.VAL_COMMENT ,
          ISNULL( a.TCAP , -1 )AS TCAP ,
          ISNULL( a.ICAP , -1 )AS ICAP ,
          a.LOAD_SHAPE_ID ,
          a.LOSSES ,
          a.ANNUAL_USAGE ,
          a.USAGE_DATE ,
          a.NAME_KEY ,
          CASE
          WHEN acc.AccountNumber IS NULL THEN 'false'
              ELSE 'true'
          END AS IsExisting
     FROM
          OE_ACCOUNT a WITH ( NOLOCK ) LEFT JOIN Libertypower..Utility u WITH ( NOLOCK )
          ON a.UTILITY
           = u.UtilityCode
                                       LEFT JOIN Libertypower..Account acc WITH ( NOLOCK )
          ON a.ACCOUNT_NUMBER
           = acc.AccountNumber
         AND u.ID
           = acc.UtilityID
     WHERE a.ACCOUNT_NUMBER
         = @AccountNumber
     ORDER BY UTILITY , a.ACCOUNT_NUMBER;
     
     SET NOCOUNT OFF;
END

GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_accounts_by_offer_id_sel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_accounts_by_offer_id_sel]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/26/2008
-- Description:
--
-- Modified 10/27/2010 - Rick Deigsler
-- Added IsExisting to select	
-- =============================================
CREATE PROCEDURE [dbo].[usp_accounts_by_offer_id_sel]

@p_offer_id		varchar(50)

AS
BEGIN
SET NOCOUNT ON;

SELECT		a.ID, 
			ISNULL(a.BillingAccountNumber,'') AS BillingAccountNumber, 
			ISNULL(a.ACCOUNT_NUMBER,'') AS ACCOUNT_NUMBER, 
			ISNULL(a.ACCOUNT_ID,'') AS ACCOUNT_ID, 
			ISNULL(a.MARKET,'') AS MARKET, 
			ISNULL(a.UTILITY,'') AS UTILITY, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'MeterType',GETDATE()),'') AS METER_TYPE, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'RateClass',GETDATE()),'') AS RATE_CLASS, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Voltage',GETDATE()),'') AS VOLTAGE, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Zone',GETDATE()) ,'') AS ZONE, 
			ISNULL(a.VAL_COMMENT,'') AS VAL_COMMENT, 
			CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Tcap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS TCAP, 
			CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'ICap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS ICAP,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadShapeID',GETDATE()),'') AS LOAD_SHAPE_ID,  
			CAST(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LossFactor',GETDATE()) AS DECIMAL(18,9)) AS LOSSES, 
			ISNULL(a.ANNUAL_USAGE,0) AS ANNUAL_USAGE,
			USAGE_DATE,
			CASE WHEN acc.AccountNumber IS NULL THEN 'false' ELSE 'true' END AS IsExisting,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'TarrifCode',GETDATE()),'') AS TarrifCode,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadProfile',GETDATE()),'') AS LOAD_PROFILE,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Grid',GETDATE()),'') AS Grid,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LbmpZone',GETDATE()),'') AS LbmpZone,
			ISNULL(a.IsAnnualUsageEstimated, 0) AS IsAnnualUsageEstimated,
			ISNULL(a.EstimatedAnnualUsage, 0) AS EstimatedAnnualUsage	
FROM		OE_ACCOUNT a WITH (NOLOCK) 
			INNER JOIN dbo.OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
			LEFT JOIN Libertypower.dbo.Utility u WITH (NOLOCK) ON a.UTILITY = u.UtilityCode
			LEFT JOIN Libertypower.dbo.Account acc WITH (NOLOCK) ON a.ACCOUNT_NUMBER = acc.AccountNumber and u.ID = acc.UtilityID
WHERE		b.OFFER_ID = @p_offer_id
ORDER BY	a.UTILITY, a.ACCOUNT_NUMBER

SET NOCOUNT OFF;
END

GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_accounts_by_offer_id_sel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_accounts_by_offer_id_sel]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/26/2008
-- Description:
--
-- Modified 10/27/2010 - Rick Deigsler
-- Added IsExisting to select	
-- =============================================
CREATE PROCEDURE [dbo].[usp_accounts_by_offer_id_sel]

@p_offer_id		varchar(50)

AS
BEGIN
SET NOCOUNT ON;

SELECT		a.ID, 
			ISNULL(a.BillingAccountNumber,'') AS BillingAccountNumber, 
			ISNULL(a.ACCOUNT_NUMBER,'') AS ACCOUNT_NUMBER, 
			ISNULL(a.ACCOUNT_ID,'') AS ACCOUNT_ID, 
			ISNULL(a.MARKET,'') AS MARKET, 
			ISNULL(a.UTILITY,'') AS UTILITY, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'MeterType',GETDATE()),'') AS METER_TYPE, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'RateClass',GETDATE()),'') AS RATE_CLASS, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Voltage',GETDATE()),'') AS VOLTAGE, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Zone',GETDATE()) ,'') AS ZONE, 
			ISNULL(a.VAL_COMMENT,'') AS VAL_COMMENT, 
			CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Tcap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS TCAP, 
			CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'ICap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS ICAP,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadShapeID',GETDATE()),'') AS LOAD_SHAPE_ID,  
			CAST(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LossFactor',GETDATE()) AS DECIMAL(18,9)) AS LOSSES, 
			ISNULL(a.ANNUAL_USAGE,0) AS ANNUAL_USAGE,
			USAGE_DATE,
			CASE WHEN acc.AccountNumber IS NULL THEN 'false' ELSE 'true' END AS IsExisting,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'TarrifCode',GETDATE()),'') AS TarrifCode,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadProfile',GETDATE()),'') AS LOAD_PROFILE,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Grid',GETDATE()),'') AS Grid,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LbmpZone',GETDATE()),'') AS LbmpZone,
			ISNULL(a.IsAnnualUsageEstimated, 0) AS IsAnnualUsageEstimated,
			ISNULL(a.EstimatedAnnualUsage, 0) AS EstimatedAnnualUsage	
FROM		OE_ACCOUNT a WITH (NOLOCK) 
			INNER JOIN dbo.OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
			LEFT JOIN Libertypower.dbo.Utility u WITH (NOLOCK) ON a.UTILITY = u.UtilityCode
			LEFT JOIN Libertypower.dbo.Account acc WITH (NOLOCK) ON a.ACCOUNT_NUMBER = acc.AccountNumber and u.ID = acc.UtilityID
WHERE		b.OFFER_ID = @p_offer_id
ORDER BY	a.UTILITY, a.ACCOUNT_NUMBER

SET NOCOUNT OFF;
END

GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_accounts_by_pricing_request_id_sel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_accounts_by_pricing_request_id_sel]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/22/2008
-- Description:	
-- =============================================
-- Author:		Maurício Nogueira
-- Create date: 7/19/2010
-- Description:	
--
-- Modified 10/27/2010 - Rick Deigsler
-- Added IsExisting to select	
-- =============================================
CREATE PROCEDURE dbo.usp_accounts_by_pricing_request_id_sel @p_pricing_request_id varchar( 50 )
AS 
BEGIN
	SET NOCOUNT ON;

	SELECT a.ID ,
          ISNULL( a.BillingAccountNumber , '' )AS BillingAccountNumber ,
          -- INF83 TR006 / 05/08/2009 hbm
          a.ACCOUNT_NUMBER ,
          ISNULL( a.ACCOUNT_ID , '' )AS ACCOUNT_ID ,
          ISNULL( a.MARKET , '' )AS MARKET ,
          ISNULL( a.UTILITY , '' )AS UTILITY ,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'MeterType',GETDATE()),'') AS METER_TYPE ,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'RateClass',GETDATE()),'') AS RATE_CLASS, 
		  ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Voltage',GETDATE()),'') AS VOLTAGE, 
		  ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Zone',GETDATE()) ,'') AS ZONE, 
          ISNULL( a.VAL_COMMENT , '' )AS VAL_COMMENT ,
          CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Tcap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS TCAP, 
		  CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'ICap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS ICAP,
		  ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadShapeID',GETDATE()),'') AS LOAD_SHAPE_ID,  
		  CAST(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LossFactor',GETDATE()) AS DECIMAL(18,9)) AS LOSSES, 
          ISNULL( a.ANNUAL_USAGE , 0 )AS ANNUAL_USAGE ,
          USAGE_DATE ,
          ISNULL( c.METER_NUMBER , '' )AS METER_NUMBER ,
          ISNULL( d.ADDRESS , '' )AS ADDRESS ,
          ISNULL( d.SUITE , '' )AS SUITE ,
          ISNULL( d.CITY , '' )AS CITY ,
          ISNULL( d.STATE , '' )AS STATE ,
          ISNULL( d.ZIP , '' )AS ZIP ,
          CASE
          WHEN acc.AccountNumber IS NULL THEN 'false'
              ELSE 'true'
          END AS IsExisting ,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'TarrifCode',GETDATE()),'') AS TarrifCode,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadProfile',GETDATE()),'') AS LOAD_PROFILE,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Grid',GETDATE()),'') AS Grid,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LbmpZone',GETDATE()),'') AS LbmpZone,
          ISNULL( a.NAME_KEY , '' )AS NAME_KEY ,
          ISNULL( acc.EntityID , '' )AS EntityID ,
          ISNULL( a.IsAnnualUsageEstimated , 0 )AS IsAnnualUsageEstimated ,
          ISNULL( a.EstimatedAnnualUsage , 0 )AS EstimatedAnnualUsage
     FROM
          OE_ACCOUNT a WITH ( NOLOCK ) INNER JOIN dbo.OE_PRICING_REQUEST_ACCOUNTS b WITH ( NOLOCK )
          ON a.ID
           = b.OE_ACCOUNT_ID
                                       LEFT OUTER JOIN dbo.OE_ACCOUNT_METERS c WITH ( NOLOCK )
          ON b.OE_ACCOUNT_ID
           = c.OE_ACCOUNT_ID
                                       LEFT OUTER JOIN dbo.OE_ACCOUNT_ADDRESS d WITH ( NOLOCK )
          ON b.OE_ACCOUNT_ID
           = d.OE_ACCOUNT_ID
                                       LEFT JOIN Libertypower.dbo.Utility u WITH ( NOLOCK )
          ON a.UTILITY
           = u.UtilityCode
                                       LEFT JOIN Libertypower.dbo.Account acc WITH ( NOLOCK )
          ON a.ACCOUNT_NUMBER
           = acc.AccountNumber
         AND u.ID
           = acc.UtilityID
     WHERE b.PRICING_REQUEST_ID
         = @p_pricing_request_id
     ORDER BY a.UTILITY , a.ACCOUNT_NUMBER;

	SET NOCOUNT OFF;
END
GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_accounts_by_pricing_request_id_sel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_accounts_by_pricing_request_id_sel]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/22/2008
-- Description:	
-- =============================================
-- Author:		Maurício Nogueira
-- Create date: 7/19/2010
-- Description:	
--
-- Modified 10/27/2010 - Rick Deigsler
-- Added IsExisting to select	
-- =============================================
CREATE PROCEDURE dbo.usp_accounts_by_pricing_request_id_sel @p_pricing_request_id varchar( 50 )
AS 
BEGIN
	SET NOCOUNT ON;

	SELECT a.ID ,
          ISNULL( a.BillingAccountNumber , '' )AS BillingAccountNumber ,
          -- INF83 TR006 / 05/08/2009 hbm
          a.ACCOUNT_NUMBER ,
          ISNULL( a.ACCOUNT_ID , '' )AS ACCOUNT_ID ,
          ISNULL( a.MARKET , '' )AS MARKET ,
          ISNULL( a.UTILITY , '' )AS UTILITY ,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'MeterType',GETDATE()),'') AS METER_TYPE ,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'RateClass',GETDATE()),'') AS RATE_CLASS, 
		  ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Voltage',GETDATE()),'') AS VOLTAGE, 
		  ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Zone',GETDATE()) ,'') AS ZONE, 
          ISNULL( a.VAL_COMMENT , '' )AS VAL_COMMENT ,
          CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Tcap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS TCAP, 
		  CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'ICap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS ICAP,
		  ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadShapeID',GETDATE()),'') AS LOAD_SHAPE_ID,  
		  CAST(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LossFactor',GETDATE()) AS DECIMAL(18,9)) AS LOSSES, 
          ISNULL( a.ANNUAL_USAGE , 0 )AS ANNUAL_USAGE ,
          USAGE_DATE ,
          ISNULL( c.METER_NUMBER , '' )AS METER_NUMBER ,
          ISNULL( d.ADDRESS , '' )AS ADDRESS ,
          ISNULL( d.SUITE , '' )AS SUITE ,
          ISNULL( d.CITY , '' )AS CITY ,
          ISNULL( d.STATE , '' )AS STATE ,
          ISNULL( d.ZIP , '' )AS ZIP ,
          CASE
          WHEN acc.AccountNumber IS NULL THEN 'false'
              ELSE 'true'
          END AS IsExisting ,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'TarrifCode',GETDATE()),'') AS TarrifCode,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadProfile',GETDATE()),'') AS LOAD_PROFILE,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Grid',GETDATE()),'') AS Grid,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LbmpZone',GETDATE()),'') AS LbmpZone,
          ISNULL( a.NAME_KEY , '' )AS NAME_KEY ,
          ISNULL( acc.EntityID , '' )AS EntityID ,
          ISNULL( a.IsAnnualUsageEstimated , 0 )AS IsAnnualUsageEstimated ,
          ISNULL( a.EstimatedAnnualUsage , 0 )AS EstimatedAnnualUsage
     FROM
          OE_ACCOUNT a WITH ( NOLOCK ) INNER JOIN dbo.OE_PRICING_REQUEST_ACCOUNTS b WITH ( NOLOCK )
          ON a.ID
           = b.OE_ACCOUNT_ID
                                       LEFT OUTER JOIN dbo.OE_ACCOUNT_METERS c WITH ( NOLOCK )
          ON b.OE_ACCOUNT_ID
           = c.OE_ACCOUNT_ID
                                       LEFT OUTER JOIN dbo.OE_ACCOUNT_ADDRESS d WITH ( NOLOCK )
          ON b.OE_ACCOUNT_ID
           = d.OE_ACCOUNT_ID
                                       LEFT JOIN Libertypower.dbo.Utility u WITH ( NOLOCK )
          ON a.UTILITY
           = u.UtilityCode
                                       LEFT JOIN Libertypower.dbo.Account acc WITH ( NOLOCK )
          ON a.ACCOUNT_NUMBER
           = acc.AccountNumber
         AND u.ID
           = acc.UtilityID
     WHERE b.PRICING_REQUEST_ID
         = @p_pricing_request_id
     ORDER BY a.UTILITY , a.ACCOUNT_NUMBER;

	SET NOCOUNT OFF;
END
GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_AccountUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_AccountUpdate]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_AccountUpdate
 * Updates account data
 *
 * History
 *******************************************************************************
 * 9/1/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountUpdate]

@p_UtilityCode			varchar(50),			
@p_account_number		varchar(50),
@p_meter_type			varchar(50)	= '',
@p_icap					decimal(18,9)	= -1,
@p_tcap					decimal(18,9)	= -1,
@p_losses				decimal(18,9)	= 0,
@p_load_shape_id		varchar(50)		= '',
@p_voltage				varchar(50)		= '',
@p_rate_class			varchar(50)		= '',
@p_zone					varchar(50)		= '',
@p_meter_number			varchar(50)		= '',
@p_BillingAccount		varchar(50)		= '',
@p_TarrifCode			varchar(50)	= '',
@p_LoadProfile			varchar(50)	= '',
@p_Grid				varchar(50)	= '',
@p_LbmpZone			varchar(50)	= ''

AS		
BEGIN
	SET NOCOUNT ON;
	DECLARE	@w_has_error	int,
			@w_utility_id	varchar(50),
			@w_id			int

	SET	@w_has_error	= 0

	SET	@p_meter_type		= LTRIM(RTRIM(UPPER(@p_meter_type)))
	SET	@p_icap				= LTRIM(RTRIM(@p_icap))
	SET	@p_tcap				= LTRIM(RTRIM(@p_tcap))
	SET	@p_losses			= LTRIM(RTRIM(@p_losses))
	SET	@p_load_shape_id	= LTRIM(RTRIM(@p_load_shape_id))
	SET	@p_voltage			= LTRIM(RTRIM(@p_voltage))
	SET	@p_rate_class		= LTRIM(RTRIM(@p_rate_class))
	SET	@p_zone				= LTRIM(RTRIM(@p_zone))
	SET	@p_meter_number		= LTRIM(RTRIM(REPLACE(@p_meter_number, '''', '')))
	SET	@p_BillingAccount	= LTRIM(RTRIM(UPPER(REPLACE(@p_BillingAccount, '''', ''))))
	SET @p_TarrifCode = LTRIM(RTRIM(UPPER(REPLACE(@p_TarrifCode, '''', ''))))
	SET @p_LoadProfile = LTRIM(RTRIM(UPPER(REPLACE(@p_LoadProfile, '''', ''))))
	SET @p_Grid = LTRIM(RTRIM(UPPER(REPLACE(@p_Grid, '''', ''))))
	SET @p_LbmpZone = LTRIM(RTRIM(UPPER(REPLACE(@p_LbmpZone, '''', ''))))


	BEGIN TRAN account_upd

	-- for DUQ, set zone to 'DUQ'
	--IF @p_UtilityCode = 'DUQ'
	--	SET	@p_zone = 'DUQ'
		
	-- bandaid for new zip to zone
	--SET	@p_zone =	CASE	WHEN @p_zone = 'HOUSTON' THEN 'HZ'
	--						WHEN @p_zone = 'SOUTH' THEN 'SZ'
	--						WHEN @p_zone = 'NORTH' THEN 'NZ'
	--						WHEN @p_zone = 'WEST' THEN 'WZ'
	--						ELSE @p_zone
	--				END	

		UPDATE	OE_ACCOUNT
		SET		ACCOUNT_NUMBER	= CASE WHEN LEN(@p_account_number) > 0							THEN @p_account_number			ELSE ACCOUNT_NUMBER	END, 
				METER_TYPE		= CASE WHEN LEN(@p_meter_type) > 0								THEN UPPER(@p_meter_type)		ELSE METER_TYPE		END, 
				ICAP			= CASE WHEN LEN(@p_icap) > 0 AND @p_icap <> -1					THEN @p_icap					ELSE ICAP			END,
				TCAP			= CASE WHEN LEN(@p_tcap) > 0 AND @p_tcap <> -1					THEN @p_tcap					ELSE TCAP			END,
				LOSSES			= CASE WHEN LEN(@p_losses) > 0 AND @p_losses <> 0				THEN @p_losses					ELSE LOSSES			END,
				LOAD_SHAPE_ID	= CASE WHEN LEN(@p_load_shape_id) > 0							THEN UPPER(@p_load_shape_id)	ELSE LOAD_SHAPE_ID	END,
				VOLTAGE			= CASE WHEN LEN(@p_voltage) > 0									THEN UPPER(@p_voltage)			ELSE VOLTAGE		END, 
				RATE_CLASS		= CASE WHEN LEN(@p_rate_class) > 0								THEN @p_rate_class				ELSE RATE_CLASS		END, 
				ZONE			= CASE WHEN LEN(@p_zone) > 0									THEN @p_zone					ELSE ZONE			END, 
				BillingAccountNumber	= CASE WHEN LEN(@p_BillingAccount) > 0					THEN @p_BillingAccount			ELSE BillingAccountNumber	END,
				TarrifCode		= CASE WHEN LEN(@p_TarrifCode) > 0								THEN @p_TarrifCode				ELSE TarrifCode	END,
				LOAD_PROFILE		= CASE WHEN LEN(@p_LoadProfile) > 0							THEN @p_LoadProfile				ELSE LOAD_PROFILE	END,
				Grid		= CASE WHEN LEN(@p_Grid) > 0										THEN @p_Grid					ELSE Grid	END,
				LbmpZone		= CASE WHEN LEN(@p_LbmpZone) > 0								THEN @p_LbmpZone				ELSE LbmpZone	END
				
		WHERE	UTILITY			= @p_UtilityCode
		AND		ACCOUNT_NUMBER	= @p_account_number
		
		SELECT	@w_id = SCOPE_IDENTITY()

		IF @@ERROR <> 0
			SET @w_has_error = 1

		UPDATE	OE_ACCOUNT_ADDRESS
		SET		ACCOUNT_NUMBER	= @p_account_number
		WHERE	OE_ACCOUNT_ID = @w_id

		IF @@ERROR <> 0
			SET @w_has_error = 1

		UPDATE	OE_ACCOUNT_METERS
		SET		ACCOUNT_NUMBER	= @p_account_number,
				METER_NUMBER	= CASE WHEN LEN(@p_meter_number) > 0 THEN @p_meter_number ELSE METER_NUMBER END
		WHERE	OE_ACCOUNT_ID = @w_id

		IF @@ERROR <> 0
			SET @w_has_error = 1

		UPDATE	OE_OFFER_ACCOUNTS
		SET		ACCOUNT_NUMBER	= @p_account_number
		WHERE	OE_ACCOUNT_ID = @w_id

		IF @@ERROR <> 0
			SET @w_has_error = 1

		UPDATE	OE_PRICING_REQUEST_ACCOUNTS
		SET		ACCOUNT_NUMBER	= @p_account_number
		WHERE	OE_ACCOUNT_ID = @w_id

		IF @@ERROR <> 0
			SET @w_has_error = 1

		IF @@ERROR <> 0
			SET @w_has_error = 1

	IF @w_has_error = 0
		BEGIN
			COMMIT TRAN account_upd
			SELECT 0
		END
	ELSE
		BEGIN
			ROLLBACK TRAN account_upd
			SELECT 1
		END

	SET NOCOUNT OFF;
END
GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_AccountUsageInsert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_AccountUsageInsert]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
/*******************************************************************************
 * usp_AccountUsageInsert
 * Insert usage for account
 *
 * History
 *******************************************************************************
 * 5/8/2009 - Rick Deigsler
 * Created.
 *
 * Modified 5/11/2010 - Rick Deigsler
 * Added voltage conversion for California utilities and rate class parameter
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountUsageInsert]                                                                                     
	@AccountNumber	varchar(50),
	@UtilityCode	varchar(50),
	@FromDate		datetime,
	@ToDate			datetime,
	@TotalKwh		int,
	@DaysUsed		int,
	@MeterNumber	varchar(50),
	@MeterType		varchar(50) = '',
	@LoadProfile	varchar(50),
	@LoadShapeId	varchar(50),
	@Zone			varchar(50),
	@Voltage		varchar(50),
	@Icap			decimal(18,9),
	@Tcap			decimal(18,9),
	@Idr			varchar(50),
	@ZipCode		varchar(25),
	@UserName		varchar(50),
	@RateClass		varchar(50) = ''
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@AccountId		int,
			@VoltageTemp	varchar(20),
			@Today			datetime

	SELECT	@AccountId		= ID
	FROM	OE_ACCOUNT WITH (NOLOCK)
	WHERE	ACCOUNT_NUMBER	= @AccountNumber
	AND		UTILITY			= @UtilityCode	


	SET	@FromDate = CAST(DATEPART(mm, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @FromDate) AS varchar(4))
	SET	@ToDate = CAST(DATEPART(mm, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @ToDate) AS varchar(4))
	SET	@Today	= GETDATE()
	
	--Zone doesn't need to be updated as it overrides whatever zone we set when we inserted the account into the DB for the ERCOT accounts
	/*-- bandaid for new zip to zone
	SET	@Zone =	CASE	WHEN @Zone = 'HOUSTON' THEN 'HZ'
						WHEN @Zone = 'SOUTH' THEN 'SZ'
						WHEN @Zone = 'NORTH' THEN 'NZ'
						WHEN @Zone = 'WEST' THEN 'WZ'
						ELSE @Zone
				END
	*/
	-- O&R is always zone G
	--IF @UtilityCode = 'O&R'
	--	SET	@Zone = 'G'
		
	--IF @UtilityCode = 'PGE'
	--	BEGIN
	--		SET	@Zone = 'PGE'
	--		SET	@Voltage = CASE WHEN @Voltage = 'P' THEN 'Primary' WHEN @Voltage = 'T' THEN 'Transmission' ELSE 'Secondary' END
	--	END
		
	--IF @UtilityCode = 'SCE'
	--	BEGIN
	--		SET	@Zone = 'SCE'
	--		SET	@VoltageTemp = REPLACE(@Voltage, ' V', '')
	--		IF ISNUMERIC(@VoltageTemp) = 1
	--			BEGIN
	--				IF CAST(@VoltageTemp AS int) < 2000
	--					SET	@Voltage = 'Secondary'
	--				IF CAST(@VoltageTemp AS int) BETWEEN 2000 AND 50000
	--					SET	@Voltage = 'Primary'
	--				IF CAST(@VoltageTemp AS int) > 50000
	--					SET	@Voltage = 'Sub Transmission'												
	--			END
	--	END
		
	--IF @UtilityCode = 'SDGE'
	--	BEGIN
	--		SET	@Zone = 'SDGE'
	--		SET	@Voltage = CASE WHEN @Voltage = 'P' THEN 'Primary' WHEN @Voltage = 'T' THEN 'Transmission' WHEN @Voltage = 'Sub Trans' THEN 'Sub Transmission' ELSE 'Secondary' END
	--	END	
		
	--IF LEN(@LoadProfile) > 0 AND LEN(@MeterType) = 0
	--		SET	@MeterType = CASE WHEN @LoadProfile = 'true' THEN 'IDR' ELSE 'NON-IDR' END		

	-- update account
	SET	@UtilityCode		= UPPER(@UtilityCode)
	SET	@Icap				= LTRIM(RTRIM(@Icap))
	SET	@Tcap				= LTRIM(RTRIM(@Tcap))
	SET	@LoadShapeId		= LTRIM(RTRIM(@LoadShapeId))
	SET	@Voltage			= LTRIM(RTRIM(@Voltage))
	SET	@Zone				= LTRIM(RTRIM(@Zone))
	SET	@MeterNumber		= LTRIM(RTRIM(REPLACE(@MeterNumber, '''', '')))
	SET	@RateClass			= LTRIM(RTRIM(@RateClass))
	SET	@LoadProfile		= LTRIM(RTRIM(@LoadProfile))

	UPDATE	OE_ACCOUNT
	SET		METER_TYPE		= CASE WHEN LEN(@MeterType) > 0					THEN @MeterType				ELSE METER_TYPE		END,
			ICAP			= CASE WHEN LEN(@Icap) > 0 AND @Icap <> -1		THEN @Icap					ELSE ICAP			END,
			TCAP			= CASE WHEN LEN(@Tcap) > 0 AND @Tcap <> -1		THEN @Tcap					ELSE TCAP			END,
			--LOAD_SHAPE_ID	= CASE WHEN LEN(@LoadShapeId) > 0				THEN UPPER(@LoadShapeId)	ELSE LOAD_SHAPE_ID	END,
			VOLTAGE			= CASE WHEN LEN(@Voltage) > 0					THEN UPPER(@Voltage)		ELSE VOLTAGE		END, 
			--Zone doesn't need to be updated as it overrides whatever zone we set when we inserted the account into the DB for the ERCOT accounts
			ZONE			= CASE WHEN LEN(@Zone) > 0	THEN @Zone					ELSE ZONE			END,			
			RATE_CLASS		= CASE WHEN LEN(@RateClass) > 0					THEN @RateClass				ELSE RATE_CLASS		END,
			LOAD_PROFILE	= CASE WHEN LEN(@LoadProfile) > 0				THEN @LoadProfile			ELSE LOAD_PROFILE	END,
			NeedUsage	= 0
	WHERE	ID = @AccountId


	-- update zip
	IF EXISTS (SELECT NULL FROM OE_ACCOUNT_ADDRESS WITH (NOLOCK) WHERE OE_ACCOUNT_ID = @AccountId)
		UPDATE OE_ACCOUNT_ADDRESS SET ZIP = CASE WHEN LEN(LTRIM(RTRIM(@ZipCode))) > 0 THEN @ZipCode ELSE ZIP END WHERE OE_ACCOUNT_ID = @AccountId
	ELSE IF @AccountId IS NOT NULL
		INSERT INTO OE_ACCOUNT_ADDRESS (OE_ACCOUNT_ID, ACCOUNT_NUMBER, ZIP) VALUES (@AccountId, @AccountNumber, @ZipCode)

	-- insert usage		
	EXEC LibertyPower..usp_InsertConsolidatedUsage @AccountNumber = @AccountNumber, @UtilityCode = @UtilityCode, @UsageSource = 6, 
			@UsageType = 3, @FromDate = @FromDate, @ToDate = @ToDate, @TotalKwh = @TotalKwh, @DaysUsed = @DaysUsed, 
			@MeterNumber = @MeterNumber, @UserName = @UserName, @OnPeakKwh = NULL, @OffPeakKwh = NULL, @BillingDemandKw = NULL,
			@MonthlyPeakDemandKw = NULL, @IntermediateKwh = NULL, @MonthlyOffPeakDemandKw = NULL, @modified = @Today,
			@active = 1, @reasonCode = 4

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power


GO
USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_aggregated_icap_tcap_losses_by_offer_sel]    Script Date: 07/13/2013 16:36:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_aggregated_icap_tcap_losses_by_offer_sel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_aggregated_icap_tcap_losses_by_offer_sel]
GO

USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_aggregated_icap_tcap_losses_by_offer_sel]    Script Date: 07/13/2013 16:36:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_aggregated_icap_tcap_losses_by_offer_sel]

@p_offer_id			varchar(50)

AS
BEGIN
	SET NOCOUNT ON;
		SELECT		offer_id, utility, zone, SUM(CASE WHEN ICAP = -1 THEN -1 ELSE ICAP END) as ICAP, SUM(TCAP) AS TCAP, SUM(ISNULL(Losses, 0) * Annual_Usage) / SUM(Annual_Usage) AS Losses 
		FROM		(	SELECT	ac.ACCOUNT_NUMBER, ac.utility, Libertypower.dbo.GetDeterminantValue(ac.utility, ac.ACCOUNT_NUMBER, 'Zone', getdate()) as zone, ac.voltage, ac.ICAP, ac.TCAP, ac.Losses, ac.annual_usage, sap.offer_id 
						FROM	oe_account ac WITH (NOLOCK) INNER JOIN (	SELECT	oa.ACCOUNT_NUMBER, oa.offer_id, a.UTILITY 
																			FROM	oe_offer_accounts oa WITH (NOLOCK) INNER JOIN
																					OE_PRICING_REQUEST_OFFER pra WITH (NOLOCK) ON oa.offer_id = pra.offer_id
																					inner join oe_account a on a.ID = oa.OE_ACCOUNT_ID
																			WHERE	oa.ACCOUNT_NUMBER NOT IN -- Do not price zero usage accounts
																			(
																				SELECT	DISTINCT z.AccountNumber
																				FROM
																				(
																					SELECT	u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate,
																							CAST(DATEPART(yyyy, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(4)) + '-' + RIGHT('0' + CAST(DATEPART(mm, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(2)), 2) + '-01' AS MinDate,
																							MAX(u.ToDate) AS MaxDate
																					FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
																							INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
																							INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
																					WHERE	o.OFFER_ID = @p_offer_id
																					GROUP BY u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate
																				)z	
																				WHERE z.FromDate BETWEEN z.MinDate AND z.MaxDate
																				GROUP BY z.AccountNumber, z.ToDate, z.FromDate
																				HAVING SUM(z.TotalKwh) = 0	
																			)																						
																		) sap ON ac.ACCOUNT_NUMBER = sap.ACCOUNT_NUMBER and ac.UTILITY = sap.UTILITY) sep
		WHERE		offer_id = @p_offer_id
		GROUP BY	offer_id, utility, zone
		HAVING		SUM(Annual_Usage) > 0
--	END









	SET NOCOUNT OFF;
END


GO


USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMeterNumber]    Script Date: 07/12/2013 20:18:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetMeterNumber]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetMeterNumber]
GO

USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMeterNumber]    Script Date: 07/12/2013 20:18:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku Joseph John
-- Create date: 07-12-2013
-- Description:	Gets meter number by account number
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetMeterNumber]
	-- Add the parameters for the stored procedure here
	@p_account_number		varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT oam.METER_NUMBER  
	FROM OE_ACCOUNT_METERS oam WITH (NOLOCK)  
	JOIn OE_ACCOUNT oa WITH (NOLOCK) on oa.ID=oam.OE_Account_ID
	WHERE oa.ACCOUNT_NUMBER = @p_account_number
	
	SET NOCOUNT OFF;
END

GO


USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_pricing_request_account_ins]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_pricing_request_account_ins]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_pricing_request_account_ins] @p_pricing_request_id varchar( 50 ) ,
                                                    @p_account_number varchar( 50 ) ,
                                                    @p_retail_mkt_id varchar( 25 ) = '' ,
                                                    @p_utility_id varchar( 50 ) = '' ,
                                                    @p_meter_type varchar( 50 ) = '' ,
                                                    @p_meter_number varchar( 50 ) = '' ,
                                                    @p_voltage varchar( 50 ) = '' ,
                                                    @p_address varchar( 50 ) = '' ,
                                                    @p_suite varchar( 50 ) = '' ,
                                                    @p_city varchar( 50 ) = '' ,
                                                    @p_state varchar( 50 ) = '' ,
                                                    @p_zip varchar( 25 ) = '' ,
                                                    @p_zone varchar( 50 ) = '' ,
                                                    @p_rate_class varchar( 50 ) = '' ,
                                                    @p_icap decimal( 18 , 9 ) ,
                                                    @p_tcap decimal( 18 , 9 ) ,
                                                    @p_load_shape_id varchar( 50 ) = '' ,
                                                    @p_losses decimal( 18 , 9 ) = null ,
                                                    @p_name_key varchar( 50 ) = '' ,
                                                    @p_BillingAccount varchar( 50 ) = '' ,
                                                    @p_TarriffCode varchar( 50 ) = '' ,
                                                    @p_LoadProfile varchar( 50 ) = '' ,
                                                    @p_Grid varchar( 50 ) = '' ,
                                                    @p_LbmpZone varchar( 50 ) = ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
	   @w_oe_account_id int ,
	   @w_losses decimal( 18 , 9 ) ,
	   @w_utilityIDR bit ,
	   @w_metery_type varchar( 15 );
	SET @p_account_number = LTRIM( RTRIM( UPPER( REPLACE( @p_account_number , '''' , '' ))));
	SET @p_retail_mkt_id = LTRIM( RTRIM( UPPER( @p_retail_mkt_id )));
	SET @p_utility_id = LTRIM( RTRIM( UPPER( @p_utility_id )));
	SET @p_meter_type = LTRIM( RTRIM( UPPER( @p_meter_type )));
	SET @p_meter_number = LTRIM( RTRIM( REPLACE( @p_meter_number , '''' , '' )));
	SET @p_voltage = LTRIM( RTRIM( @p_voltage ));
	SET @p_address = LTRIM( RTRIM( @p_address ));
	SET @p_suite = LTRIM( RTRIM( @p_suite ));
	SET @p_city = LTRIM( RTRIM( @p_city ));
	SET @p_state = LTRIM( RTRIM( @p_state ));
	SET @p_zip = LTRIM( RTRIM( REPLACE( @p_zip , '''' , '' )));
	SET @p_zone = LTRIM( RTRIM( REPLACE( @p_zone , '''' , '' )));
	SET @p_rate_class = LTRIM( RTRIM( @p_rate_class ));
	SET @p_load_shape_id = LTRIM( RTRIM( @p_load_shape_id ));
	-- CKE removed stripping single quotes per ticket 1-4057025
	-- SET	@p_name_key			= LTRIM(RTRIM(REPLACE(@p_name_key, '''', '')))
	SET @p_name_key = LTRIM( RTRIM( @p_name_key ));
	SET @p_BillingAccount = LTRIM( RTRIM( UPPER( REPLACE( @p_BillingAccount , '''' , '' ))));
	SET @p_TarriffCode = LTRIM( RTRIM( UPPER( REPLACE( @p_TarriffCode , '''' , '' ))));
	SET @p_LoadProfile = LTRIM( RTRIM( UPPER( REPLACE( @p_LoadProfile , '''' , '' ))));
	SET @p_Grid = LTRIM( RTRIM( UPPER( REPLACE( @p_Grid , '''' , '' ))));
	SET @p_LbmpZone = LTRIM( RTRIM( UPPER( REPLACE( @p_LbmpZone , '''' , '' ))));

			SET @w_losses = @p_losses;
			SET @p_meter_type = @w_metery_type
	-- account data  -----------------------------------------------------------------------
	IF NOT EXISTS( SELECT NULL
					 FROM OE_ACCOUNT WITH ( NOLOCK )
					 WHERE ACCOUNT_NUMBER
						 = @p_account_number
					   AND UTILITY
						 = @p_utility_id )
		BEGIN
			INSERT INTO OE_ACCOUNT( ACCOUNT_NUMBER ,
									ACCOUNT_ID ,
									MARKET ,
									UTILITY ,
									METER_TYPE ,
									RATE_CLASS ,
									VOLTAGE ,
									ZONE ,
									VAL_COMMENT ,
									TCAP ,
									ICAP ,
									LOSSES ,
									ANNUAL_USAGE ,
									LOAD_SHAPE_ID ,
									NAME_KEY ,
									BillingAccountNumber ,
									NeedUsage ,
									TarrifCode ,
									LOAD_PROFILE ,
									Grid ,
									LbmpZone )
			VALUES( @p_account_number ,
					NULL ,
					@p_retail_mkt_id ,
					@p_utility_id ,
					@p_meter_type ,
					@p_rate_class ,
					@p_voltage,
					@p_zone ,
					NULL ,
					@p_tcap ,
					@p_icap ,
					@w_losses ,
					0 ,
					@p_load_shape_id ,
					CASE
					WHEN @p_name_key IS NULL
					  OR LEN( @p_name_key )
					   = 0 THEN ''
						ELSE UPPER( @p_name_key )
					END ,
					CASE
					WHEN @p_BillingAccount IS NULL
					  OR LEN( @p_BillingAccount )
					   = 0 THEN ''
						ELSE @p_BillingAccount
					END ,
					1 ,
					@p_TarriffCode ,
					@p_LoadProfile ,
					@p_Grid ,
					@p_LbmpZone );
			SET @w_oe_account_id = SCOPE_IDENTITY( );
		END;
	ELSE
		BEGIN
			UPDATE OE_ACCOUNT
			SET MARKET = CASE
						 WHEN LEN( @p_retail_mkt_id )
							> 0 THEN @p_retail_mkt_id
							 ELSE MARKET
						 END ,
				UTILITY = CASE
						  WHEN LEN( @p_utility_id )
							 > 0 THEN @p_utility_id
							  ELSE UTILITY
						  END ,
				METER_TYPE = CASE
							 WHEN LEN( @p_meter_type )
								> 0 THEN UPPER( @p_meter_type )
								 ELSE METER_TYPE
							 END ,
				VOLTAGE = CASE
						  WHEN LEN( @p_voltage )
							 > 0 THEN @p_voltage
							  ELSE VOLTAGE
						  END ,
				ZONE = CASE
						WHEN  LEN( @p_zone ) > 0 THEN @p_zone
						   ELSE ZONE
					   END ,
				RATE_CLASS = CASE
							 WHEN LEN( @p_rate_class )
								> 0 THEN @p_rate_class
								 ELSE RATE_CLASS
							 END ,
				ICAP = CASE
					   WHEN LEN( @p_icap ) > 0
						AND @p_icap <> -1 THEN @p_icap
						   ELSE ICAP
					   END ,
				TCAP = CASE
					   WHEN LEN( @p_tcap ) > 0
						AND @p_tcap <> -1 THEN @p_tcap
						   ELSE TCAP
					   END ,
				LOSSES = @p_losses,
				LOAD_SHAPE_ID = CASE
								WHEN LEN( @p_load_shape_id )
								   > 0 THEN @p_load_shape_id
									ELSE LOAD_SHAPE_ID
								END ,
				NAME_KEY = CASE
						   WHEN LEN( @p_name_key )
							  > 0 THEN UPPER( @p_name_key )
							   ELSE NAME_KEY
						   END ,
				BillingAccountNumber = CASE
									   WHEN LEN( @p_BillingAccount )
										  > 0 THEN @p_BillingAccount
										   ELSE BillingAccountNumber
									   END ,
				NeedUsage = 1 ,
				TarrifCode = CASE
							 WHEN LEN( @p_TarriffCode )
								> 0 THEN @p_TarriffCode
								 ELSE TarrifCode
							 END ,
				LOAD_PROFILE = CASE
							   WHEN LEN( @p_LoadProfile )
								  > 0 THEN @p_LoadProfile
								   ELSE LOAD_PROFILE
							   END ,
				Grid = CASE
					   WHEN LEN( @p_Grid ) > 0 THEN @p_Grid
						   ELSE Grid
					   END ,
				LbmpZone = CASE
						   WHEN LEN( @p_LbmpZone )
							  > 0 THEN @p_LbmpZone
							   ELSE LbmpZone
						   END
			  WHERE ACCOUNT_NUMBER
				  = @p_account_number
				AND UTILITY
				  = @p_utility_id;
			SELECT @w_oe_account_id = ID
			  FROM OE_ACCOUNT WITH ( NOLOCK )
			  WHERE ACCOUNT_NUMBER
				  = @p_account_number
				AND UTILITY
				  = @p_utility_id;
		END;
	-- account meter (if applicable)  --------------------------------------------------------
	IF LEN( RTRIM( LTRIM( @p_meter_number )))
	 > 0
	AND @w_oe_account_id IS NOT NULL
	AND NOT EXISTS( SELECT NULL
					  FROM OE_ACCOUNT_METERS WITH ( NOLOCK )
					  WHERE ACCOUNT_NUMBER
						  = @p_account_number
						AND OE_ACCOUNT_ID
						  = @w_oe_account_id )
		BEGIN
			INSERT INTO OE_ACCOUNT_METERS( OE_ACCOUNT_ID ,
										   ACCOUNT_NUMBER ,
										   METER_NUMBER )
			VALUES( @w_oe_account_id ,
					@p_account_number ,
					@p_meter_number );
		END;
	ELSE
		BEGIN
			UPDATE OE_ACCOUNT_METERS
			SET METER_NUMBER = CASE
							   WHEN LEN( @p_meter_number )
								  > 0 THEN @p_meter_number
								   ELSE METER_NUMBER
							   END
			  WHERE OE_ACCOUNT_ID
				  = @w_oe_account_id;
		END;
	-- address data  -----------------------------------------------------------------------
	IF @w_oe_account_id IS NOT NULL
	AND NOT EXISTS( SELECT NULL
					  FROM OE_ACCOUNT_ADDRESS WITH ( NOLOCK )
					  WHERE OE_ACCOUNT_ID
						  = @w_oe_account_id )
		BEGIN
			INSERT INTO OE_ACCOUNT_ADDRESS( OE_ACCOUNT_ID ,
											ACCOUNT_NUMBER ,
											ADDRESS ,
											SUITE ,
											CITY ,
											STATE ,
											ZIP )
			VALUES( @w_oe_account_id ,
					@p_account_number ,
					@p_address ,
					@p_suite ,
					@p_city ,
					@p_state ,
					@p_zip );
		END;
	ELSE
		BEGIN
			UPDATE OE_ACCOUNT_ADDRESS
			SET ADDRESS = CASE
						  WHEN LEN( @p_address )
							 > 0 THEN @p_address
							  ELSE ADDRESS
						  END ,
				SUITE = CASE
						WHEN LEN( @p_suite )
						   > 0 THEN @p_suite
							ELSE SUITE
						END ,
				CITY = CASE
					   WHEN LEN( @p_city ) > 0 THEN @p_city
						   ELSE CITY
					   END ,
				STATE = CASE
						WHEN LEN( @p_state )
						   > 0 THEN @p_state
							ELSE STATE
						END ,
				ZIP = CASE
					  WHEN LEN( @p_zip ) > 0 THEN @p_zip
						  ELSE ZIP
					  END
			  WHERE OE_ACCOUNT_ID
				  = @w_oe_account_id;
		END;
	-- account for pricing request  ---------------------------------------------------------
	IF @w_oe_account_id IS NOT NULL
	AND NOT EXISTS( SELECT NULL
					  FROM OE_PRICING_REQUEST_ACCOUNTS WITH ( NOLOCK )
					  WHERE PRICING_REQUEST_ID
						  = @p_pricing_request_id
						AND ACCOUNT_NUMBER
						  = @p_account_number )
		BEGIN
			INSERT INTO OE_PRICING_REQUEST_ACCOUNTS( OE_ACCOUNT_ID ,
													 PRICING_REQUEST_ID ,
													 ACCOUNT_ID ,
													 ACCOUNT_NUMBER )
			VALUES( @w_oe_account_id ,
					@p_pricing_request_id ,
					NULL ,
					@p_account_number );
		END;
	UPDATE OE_PRICING_REQUEST
	SET TOTAL_NUMBER_OF_ACCOUNTS = ( SELECT COUNT( ACCOUNT_NUMBER )
									   FROM OE_PRICING_REQUEST_ACCOUNTS
									   WHERE PRICING_REQUEST_ID
										   = @p_pricing_request_id )
	  WHERE REQUEST_ID
		  = @p_pricing_request_id;
	
	SET NOCOUNT OFF;
END

GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_pricing_request_account_upd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_pricing_request_account_upd]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/3/2008
-- Description:	
-- Modified 5/8/2009 - Rick Deigsler
-- Remove ProspectAccounts update
-- =============================================
CREATE PROCEDURE dbo.usp_pricing_request_account_upd @p_id int ,
                                                    @p_account_number varchar( 50 ) ,
                                                    @p_meter_type varchar( 50 ) = '' ,
                                                    @p_icap decimal( 18 , 9 ) = -1 ,
                                                    @p_tcap decimal( 18 , 9 ) = -1 ,
                                                    --IT059 Release 6 Sprint 1
                                                    --@p_losses				decimal(18,9)	= 0,
                                                    @p_losses decimal( 18 , 9 ) = -1 ,
                                                    @p_load_shape_id varchar( 50 ) = '' ,
                                                    @p_voltage varchar( 50 ) = '' ,
                                                    @p_rate_class varchar( 50 ) = '' ,
                                                    @p_zone varchar( 50 ) = '' ,
                                                    @p_annual_usage int = 0 ,
                                                    @p_meter_number varchar( 50 ) = '' ,
                                                    @p_BillingAccount varchar( 50 ) = '' ,
                                                    @p_TarrifCode varchar( 50 ) = '' ,
                                                    @p_LoadProfile varchar( 50 ) = '' ,
                                                    @p_Grid varchar( 50 ) = '' ,
                                                    @p_LbmpZone varchar( 50 ) = ''
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE
	   @w_has_error int ,
	   @w_utility_id varchar( 50 );
	SET @w_has_error = 0;
	SET @p_meter_type = LTRIM( RTRIM( UPPER( @p_meter_type )));
	SET @p_icap = LTRIM( RTRIM( @p_icap ));
	SET @p_tcap = LTRIM( RTRIM( @p_tcap ));
	SET @p_load_shape_id = LTRIM( RTRIM( @p_load_shape_id ));
	SET @p_voltage = LTRIM( RTRIM( @p_voltage ));
	SET @p_rate_class = LTRIM( RTRIM( @p_rate_class ));
	SET @p_zone = LTRIM( RTRIM( @p_zone ));
	SET @p_annual_usage = LTRIM( RTRIM( @p_annual_usage ));
	SET @p_meter_number = LTRIM( RTRIM( REPLACE( @p_meter_number , '''' , '' )));
	SET @p_BillingAccount = LTRIM( RTRIM( UPPER( REPLACE( @p_BillingAccount , '''' , '' ))));
	SET @p_TarrifCode = LTRIM( RTRIM( UPPER( REPLACE( @p_TarrifCode , '''' , '' ))));
	SET @p_LoadProfile = LTRIM( RTRIM( UPPER( REPLACE( @p_LoadProfile , '''' , '' ))));
	SET @p_Grid = LTRIM( RTRIM( UPPER( REPLACE( @p_Grid , '''' , '' ))));
	SET @p_LbmpZone = LTRIM( RTRIM( UPPER( REPLACE( @p_LbmpZone , '''' , '' ))));
	BEGIN TRAN account_upd;
	SELECT @w_utility_id = UTILITY
	  FROM OE_ACCOUNT
	  WHERE ACCOUNT_NUMBER
		  = @p_account_number;

	UPDATE OE_ACCOUNT
	SET ACCOUNT_NUMBER = CASE
						 WHEN LEN( @p_account_number )
							> 0 THEN @p_account_number
							 ELSE ACCOUNT_NUMBER
						 END ,
		METER_TYPE = CASE
					 WHEN LEN( @p_meter_type )
						> 0 THEN UPPER( @p_meter_type ) 
						 ELSE METER_TYPE
					 END ,
		ICAP = CASE
			   WHEN LEN( @p_icap ) > 0
				AND @p_icap <> -1 THEN @p_icap
				   ELSE ICAP
			   END ,
		TCAP = CASE
			   WHEN LEN( @p_tcap ) > 0
				AND @p_tcap <> -1 THEN @p_tcap
				   ELSE TCAP
			   END ,
		LOSSES =  CASE
    				 WHEN @p_losses = -1
			 THEN NULL
			 ELSE @p_losses
			 END,
		LOAD_SHAPE_ID = CASE
						WHEN LEN( @p_load_shape_id )
						   > 0 THEN UPPER( @p_load_shape_id )
							ELSE LOAD_SHAPE_ID
						END ,
		VOLTAGE = CASE
				  WHEN LEN( @p_voltage )
					 > 0 THEN @p_voltage --IT059       Release 6 Sprint 1
					  ELSE VOLTAGE
				  END ,
		RATE_CLASS = CASE
					 WHEN LEN( @p_rate_class )
						> 0 THEN @p_rate_class
						 ELSE RATE_CLASS
					 END ,
		ZONE = CASE
			   WHEN LEN( @p_zone ) > 0 THEN @p_zone
				   ELSE ZONE
			   END ,
		ANNUAL_USAGE = CASE
					   WHEN LEN( @p_annual_usage )
						  > 0
						AND @p_annual_usage
						 <> 0 THEN @p_annual_usage
						   ELSE ANNUAL_USAGE
					   END ,
		BillingAccountNumber = CASE
							   WHEN LEN( @p_BillingAccount )
								  > 0 THEN @p_BillingAccount
								   ELSE BillingAccountNumber
							   END ,
		TarrifCode = CASE
					 WHEN LEN( @p_TarrifCode )
						> 0 THEN @p_TarrifCode
						 ELSE TarrifCode
					 END ,
		LOAD_PROFILE = CASE
					   WHEN LEN( @p_LoadProfile )
						  > 0 THEN @p_LoadProfile
						   ELSE LOAD_PROFILE
					   END ,
		Grid = CASE
			   WHEN LEN( @p_Grid ) > 0 THEN @p_Grid
				   ELSE Grid
			   END ,
		LbmpZone = CASE
				   WHEN LEN( @p_LbmpZone )
					  > 0 THEN @p_LbmpZone
					   ELSE LbmpZone
				   END
	  WHERE ID = @p_id;
	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;
	UPDATE OE_ACCOUNT_ADDRESS
	SET ACCOUNT_NUMBER = @p_account_number
	  WHERE OE_ACCOUNT_ID
		  = @p_id;
	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;
	UPDATE OE_ACCOUNT_METERS
	SET ACCOUNT_NUMBER = @p_account_number ,
		METER_NUMBER = CASE
					   WHEN LEN( @p_meter_number )
						  > 0 THEN @p_meter_number
						   ELSE METER_NUMBER
					   END
	  WHERE OE_ACCOUNT_ID
		  = @p_id;
	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;

	UPDATE OE_OFFER_ACCOUNTS
	SET ACCOUNT_NUMBER = @p_account_number
	  WHERE OE_ACCOUNT_ID
		  = @p_id;

	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;

	UPDATE OE_PRICING_REQUEST_ACCOUNTS
	SET ACCOUNT_NUMBER = @p_account_number
	  WHERE OE_ACCOUNT_ID
		  = @p_id;

	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;
	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;
	IF @w_has_error = 0
		BEGIN
			COMMIT TRAN account_upd;
			SELECT 0;
		END;
	ELSE
		BEGIN
			ROLLBACK TRAN account_upd;
			SELECT 1;
		END;
	
	SET NOCOUNT OFF;
END
GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_pricing_request_account_upd_ex]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_pricing_request_account_upd_ex]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_pricing_request_account_upd_ex] @p_id int ,
                                                    @p_account_number varchar( 50 ) ,
                                                    @p_meter_type varchar( 50 ) = '' ,
                                                    @p_icap decimal( 18 , 9 ) = -1 ,
                                                    @p_tcap decimal( 18 , 9 ) = -1 ,
                                                    @p_losses decimal( 18 , 9 ) = -1 ,
                                                    @p_load_shape_id varchar( 50 ) = '' ,
                                                    @p_voltage varchar( 50 ) = '' ,
                                                    @p_rate_class varchar( 50 ) = '' ,
                                                    @p_zone varchar( 50 ) = '' ,
                                                    @p_annual_usage int = 0 ,
                                                    @p_meter_number varchar( 50 ) = '' ,
                                                    @p_BillingAccount varchar( 50 ) = '' ,
                                                    @p_TarrifCode varchar( 50 ) = '' ,
                                                    @p_LoadProfile varchar( 50 ) = '' ,
                                                    @p_Grid varchar( 50 ) = '' ,
                                                    @p_LbmpZone varchar( 50 ) = ''
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE
	   @w_has_error int ,
	   @w_utility_id varchar( 50 );
	SET @w_has_error = 0;
	SET @p_meter_type = LTRIM( RTRIM( UPPER( @p_meter_type )));
	SET @p_icap = LTRIM( RTRIM( @p_icap ));
	SET @p_tcap = LTRIM( RTRIM( @p_tcap ));
	SET @p_load_shape_id = LTRIM( RTRIM( @p_load_shape_id ));
	SET @p_voltage = LTRIM( RTRIM( @p_voltage ));
	SET @p_rate_class = LTRIM( RTRIM( @p_rate_class ));
	SET @p_zone = LTRIM( RTRIM( @p_zone ));
	SET @p_annual_usage = LTRIM( RTRIM( @p_annual_usage ));
	SET @p_meter_number = LTRIM( RTRIM( REPLACE( @p_meter_number , '''' , '' )));
	SET @p_BillingAccount = LTRIM( RTRIM( UPPER( REPLACE( @p_BillingAccount , '''' , '' ))));
	SET @p_TarrifCode = LTRIM( RTRIM( UPPER( REPLACE( @p_TarrifCode , '''' , '' ))));
	SET @p_LoadProfile = LTRIM( RTRIM( UPPER( REPLACE( @p_LoadProfile , '''' , '' ))));
	SET @p_Grid = LTRIM( RTRIM( UPPER( REPLACE( @p_Grid , '''' , '' ))));
	SET @p_LbmpZone = LTRIM( RTRIM( UPPER( REPLACE( @p_LbmpZone , '''' , '' ))));
	BEGIN TRAN account_upd;
	SELECT @w_utility_id = UTILITY
	  FROM OE_ACCOUNT
	  WHERE ACCOUNT_NUMBER
		  = @p_account_number;

	UPDATE OE_ACCOUNT
	SET ACCOUNT_NUMBER = CASE
						 WHEN LEN( @p_account_number )
							> 0 THEN @p_account_number
							 ELSE ACCOUNT_NUMBER
						 END ,
		METER_TYPE = UPPER( @p_meter_type ) ,
		ICAP =  @p_icap ,
		TCAP =  @p_tcap ,
		LOSSES =  CASE
    				 WHEN @p_losses = -1
			 THEN NULL
			 ELSE @p_losses
			 END,
		LOAD_SHAPE_ID = CASE
						WHEN LEN( @p_load_shape_id )
						   > 0 THEN UPPER( @p_load_shape_id )
							ELSE LOAD_SHAPE_ID
						END ,
		VOLTAGE = CASE
				  WHEN LEN( @p_voltage )
					 > 0 THEN @p_voltage --IT059       Release 6 Sprint 1
					  ELSE VOLTAGE
				  END ,
		RATE_CLASS = CASE
					 WHEN LEN( @p_rate_class )
						> 0 THEN @p_rate_class
						 ELSE RATE_CLASS
					 END ,
		ZONE = CASE
			   WHEN LEN( @p_zone ) > 0 THEN @p_zone
				   ELSE ZONE
			   END ,
		ANNUAL_USAGE = CASE
					   WHEN LEN( @p_annual_usage )
						  > 0
						AND @p_annual_usage
						 <> 0 THEN @p_annual_usage
						   ELSE ANNUAL_USAGE
					   END ,
		BillingAccountNumber = CASE
							   WHEN LEN( @p_BillingAccount )
								  > 0 THEN @p_BillingAccount
								   ELSE BillingAccountNumber
							   END ,
		TarrifCode = CASE
					 WHEN LEN( @p_TarrifCode )
						> 0 THEN @p_TarrifCode
						 ELSE TarrifCode
					 END ,
		LOAD_PROFILE = CASE
					   WHEN LEN( @p_LoadProfile )
						  > 0 THEN @p_LoadProfile
						   ELSE LOAD_PROFILE
					   END ,
		Grid = CASE
			   WHEN LEN( @p_Grid ) > 0 THEN @p_Grid
				   ELSE Grid
			   END ,
		LbmpZone = CASE
				   WHEN LEN( @p_LbmpZone )
					  > 0 THEN @p_LbmpZone
					   ELSE LbmpZone
				   END
	  WHERE ID = @p_id;
	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;
	UPDATE OE_ACCOUNT_ADDRESS
	SET ACCOUNT_NUMBER = @p_account_number
	  WHERE OE_ACCOUNT_ID
		  = @p_id;
	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;
	UPDATE OE_ACCOUNT_METERS
	SET ACCOUNT_NUMBER = @p_account_number ,
		METER_NUMBER = CASE
					   WHEN LEN( @p_meter_number )
						  > 0 THEN @p_meter_number
						   ELSE METER_NUMBER
					   END
	  WHERE OE_ACCOUNT_ID
		  = @p_id;
	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;

	UPDATE OE_OFFER_ACCOUNTS
	SET ACCOUNT_NUMBER = @p_account_number
	  WHERE OE_ACCOUNT_ID
		  = @p_id;

	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;

	UPDATE OE_PRICING_REQUEST_ACCOUNTS
	SET ACCOUNT_NUMBER = @p_account_number
	  WHERE OE_ACCOUNT_ID
		  = @p_id;

	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;
	IF @@ERROR <> 0
		BEGIN
			SET @w_has_error = 1;
		END;
	IF @w_has_error = 0
		BEGIN
			COMMIT TRAN account_upd;
			SELECT 0;
		END;
	ELSE
		BEGIN
			ROLLBACK TRAN account_upd;
			SELECT 1;
		END;
	SET NOCOUNT OFF;
END
GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_ProspectAccountsSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_ProspectAccountsSelect]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************
 * usp_ProspectAccountsSelect
 * Select prospect account data for offer id
 *
 *******************************************************************************
 * 5/11/2009 - Rick Deigsler
 * Created.
 *
 * Modified 5/20/2010 - Rick Deigsler
 * Added offer id parameter to usp_NstarUtilityCodeUpdate call
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProspectAccountsSelect] @OfferId varchar( 50 )
AS
BEGIN
    SET NOCOUNT ON;
    -- SD Ticket 13295
    -- Updates utility code in offer engine with utility code in usage.
    -- Pricing uploads all NSTAR accounts as NSTAR-BOS.    
    EXEC usp_NstarUtilityCodeUpdate @OfferId;
    SELECT DISTINCT a.UTILITY ,
           p.CUSTOMER_NAME AS CustomerName ,
           a.ACCOUNT_NUMBER AS AccountNumber ,
           ad.ADDRESS AS ServiceAddress ,
           ad.Zip AS ZipCode ,
           a.RATE_CODE AS RateCode ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadProfile',GETDATE()) AS LoadProfile ,
           a.SUPPLY_GROUP AS SupplyGroup ,
           m.METER_NUMBER AS MeterNumber ,
           CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'ICap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS ICAP,
           CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Tcap',GETDATE()) , -1 ) AS DECIMAL(18,9))AS TCAP ,
           a.BILL_GROUP AS BillGroup ,
           a.STRATUM_VARIABLE AS StratumVariable ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Voltage',GETDATE()) AS VOLTAGE ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Zone',GETDATE()) AS ZONE ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'RateClass',GETDATE()) AS RateClass ,
           o.OFFER_ID AS OfferId ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadShapeID',GETDATE()) AS LoadShapeID ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'MeterType',GETDATE()) AS MeterType ,
           a.MARKET AS RetailMarketCode ,
           a.IsIcapEsimated ,
           a.ID AS OE_ACCOUNT_ID,
           CAST(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LossFactor',GETDATE()) AS DECIMAL(18,9)) AS Losses
      FROM
           OE_OFFER_ACCOUNTS o WITH ( NOLOCK ) INNER JOIN OE_ACCOUNT a WITH ( NOLOCK )
           ON o.oe_account_id
            = a.id
                                               LEFT JOIN OE_ACCOUNT_ADDRESS ad WITH ( NOLOCK )
           ON a.ACCOUNT_NUMBER
            = ad.ACCOUNT_NUMBER
                                               INNER JOIN OE_PRICING_REQUEST_OFFER po WITH ( NOLOCK )
           ON po.OFFER_ID
            = o.OFFER_ID
                                               INNER JOIN OE_PRICING_REQUEST p WITH ( NOLOCK )
           ON p.REQUEST_ID
            = po.REQUEST_ID
                                               LEFT JOIN( 
                                                          SELECT TOP 1 ACCOUNT_NUMBER ,
                                                                       METER_NUMBER
                                                            FROM OE_ACCOUNT_METERS WITH ( NOLOCK ))m
           ON a.ACCOUNT_NUMBER
            = m.ACCOUNT_NUMBER
                                              
      WHERE o.OFFER_ID
          = @OfferId;
    SET NOCOUNT OFF;
END;

GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_usage_data_by_offer_sel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_usage_data_by_offer_sel]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/29/2008
-- Description:	Get all usage data for offer
-- =============================================
CREATE PROCEDURE dbo.usp_usage_data_by_offer_sel @p_offer_id varchar( 50 )
AS 
BEGIN
	SET NOCOUNT ON;

	SELECT ISNULL( p.CUSTOMER_NAME , '' )AS CustomerName ,
          ISNULL( u.AccountNumber , '' )AS AccountNumber ,
          ISNULL( u.UtilityCode , '' )AS Utility ,
          ISNULL( u.FromDate , '' )AS FromDate ,
          ISNULL( u.ToDate , '' )AS ToDate ,
          ISNULL( u.TotalKwh , 0 )AS Total_kWh ,
          ISNULL( u.DaysUsed , 0 )AS DaysUsed ,
          ISNULL( mt.METER_NUMBER , '' )AS MeterNumber ,
          ISNULL( u.OnPeakKWH , 0 )AS OnPeakKWH ,
          ISNULL( u.OffPeakKWH , 0 )AS OffPeakKWH ,
          ISNULL( u.BillingDemandKW , 0 )AS BillingDemandKW ,
          ISNULL( u.MonthlyPeakDemandKW , 0 )AS MonthlyPeakDemandKW ,
          ISNULL( u.UsageType , 0 )AS UsageType ,
          ISNULL( a.LOAD_SHAPE_ID , '' )AS LoadShapeID ,
          ISNULL( a.RATE_CLASS , '' )AS RateClass ,
          ISNULL( a.RATE_CODE , '' )AS RateCode ,
          '' AS Rider ,
          ISNULL( a.STRATUM_VARIABLE , '' )AS StratumVariable ,
          --IT059 Release 6 Sprint 1
          --ISNULL(a.ICAP, 0) AS ICAP,  
          --ISNULL(a.TCAP, 0) AS TCAP, 
          ISNULL( a.ICAP , -1 )AS ICAP ,
          ISNULL( a.TCAP , -1 )AS TCAP ,
          '' AS POLRType ,
          ISNULL( a.BILL_GROUP , '' )AS BillGroup ,
          ISNULL( a.VOLTAGE , '' )AS Voltage ,
          ISNULL( a.ZONE , '' )AS Zone ,
          ISNULL( a.MARKET , '' )AS ISO ,
          ISNULL( a.LOAD_PROFILE , '' )AS LoadProfile ,
          ISNULL( a.METER_TYPE , '' )AS IDR ,
          ISNULL( o.OFFER_ID , '' )AS DealID ,
          ISNULL( a.SUPPLY_GROUP , '' )AS SupplyGroup ,
          ISNULL( ad.ADDRESS , '' )AS ServiceAddress ,
          ISNULL( ad.Zip , '' )AS ZipCode
     FROM
          Libertypower..UsageConsolidated u WITH ( NOLOCK ) INNER JOIN Libertypower..OfferUsageMapping m WITH ( NOLOCK )
          ON u.ID = m.UsageId
         AND u.UsageType
           = m.UsageType
                                                            INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH ( NOLOCK )
          ON m.OfferAccountsId
           = o.ID
                                                            INNER JOIN OfferEngineDB..OE_ACCOUNT a WITH ( NOLOCK )
          ON o.ACCOUNT_NUMBER
           = a.ACCOUNT_NUMBER
                                                            LEFT JOIN OE_ACCOUNT_ADDRESS ad WITH ( NOLOCK )
          ON a.ACCOUNT_NUMBER
           = ad.ACCOUNT_NUMBER
                                                            INNER JOIN OE_PRICING_REQUEST_OFFER po WITH ( NOLOCK )
          ON po.OFFER_ID
           = o.OFFER_ID
                                                            INNER JOIN OE_PRICING_REQUEST p WITH ( NOLOCK )
          ON p.REQUEST_ID
           = po.REQUEST_ID
                                                            LEFT JOIN( 
                                                                       SELECT TOP 1 ACCOUNT_NUMBER ,
                                                                                    METER_NUMBER
                                                                         FROM OE_ACCOUNT_METERS WITH ( NOLOCK ))mt
          ON a.ACCOUNT_NUMBER
           = mt.ACCOUNT_NUMBER
     WHERE o.OFFER_ID
         = @p_offer_id
   UNION
   SELECT ISNULL( p.CUSTOMER_NAME , '' )AS CustomerName ,
          ISNULL( u.AccountNumber , '' )AS AccountNumber ,
          ISNULL( u.UtilityCode , '' )AS Utility ,
          ISNULL( u.FromDate , '' )AS FromDate ,
          ISNULL( u.ToDate , '' )AS ToDate ,
          ISNULL( u.TotalKwh , 0 )AS Total_kWh ,
          ISNULL( u.DaysUsed , 0 )AS DaysUsed ,
          ISNULL( mt.METER_NUMBER , '' )AS MeterNumber ,
          '0' AS OnPeakKWH ,
          '0' AS OffPeakKWH ,
          0 AS BillingDemandKW ,
          0 AS MonthlyPeakDemandKW ,
          ISNULL( u.UsageType , 0 )AS UsageType ,
          ISNULL( a.LOAD_SHAPE_ID , '' )AS LoadShapeID ,
          ISNULL( a.RATE_CLASS , '' )AS RateClass ,
          ISNULL( a.RATE_CODE , '' )AS RateCode ,
          '' AS Rider ,
          ISNULL( a.STRATUM_VARIABLE , '' )AS StratumVariable ,
          --IT059 Release 6 Sprint 1
          --ISNULL(a.ICAP, 0) AS ICAP,  
          --ISNULL(a.TCAP, 0) AS TCAP, 
          ISNULL( a.ICAP , -1 )AS ICAP ,
          ISNULL( a.TCAP , -1 )AS TCAP ,
          '' AS POLRType ,
          ISNULL( a.BILL_GROUP , '' )AS BillGroup ,
          ISNULL( a.VOLTAGE , '' )AS Voltage ,
          ISNULL( a.ZONE , '' )AS Zone ,
          ISNULL( a.MARKET , '' )AS ISO ,
          ISNULL( a.LOAD_PROFILE , '' )AS LoadProfile ,
          ISNULL( a.METER_TYPE , '' )AS IDR ,
          ISNULL( o.OFFER_ID , '' )AS DealID ,
          ISNULL( a.SUPPLY_GROUP , '' )AS SupplyGroup ,
          ISNULL( ad.ADDRESS , '' )AS ServiceAddress ,
          ISNULL( ad.Zip , '' )AS ZipCode
     FROM
          Libertypower..EstimatedUsage u WITH ( NOLOCK ) INNER JOIN Libertypower..OfferUsageMapping m WITH ( NOLOCK )
          ON u.ID = m.UsageId
         AND u.UsageType
           = m.UsageType
                                                         INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH ( NOLOCK )
          ON m.OfferAccountsId
           = o.ID
                                                         INNER JOIN OfferEngineDB..OE_ACCOUNT a WITH ( NOLOCK )
          ON o.ACCOUNT_NUMBER
           = a.ACCOUNT_NUMBER
                                                         LEFT JOIN OE_ACCOUNT_ADDRESS ad WITH ( NOLOCK )
          ON a.ACCOUNT_NUMBER
           = ad.ACCOUNT_NUMBER
                                                         INNER JOIN OE_PRICING_REQUEST_OFFER po WITH ( NOLOCK )
          ON po.OFFER_ID
           = o.OFFER_ID
                                                         INNER JOIN OE_PRICING_REQUEST p WITH ( NOLOCK )
          ON p.REQUEST_ID
           = po.REQUEST_ID
                                                         LEFT JOIN( 
                                                                    SELECT TOP 1 ACCOUNT_NUMBER ,
                                                                                 METER_NUMBER
                                                                      FROM OE_ACCOUNT_METERS WITH ( NOLOCK ))mt
          ON a.ACCOUNT_NUMBER
           = mt.ACCOUNT_NUMBER
     WHERE o.OFFER_ID
         = @p_offer_id; 

	SET NOCOUNT OFF;
END
GO
USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_usage_from_lp_historical_info_upd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_usage_from_lp_historical_info_upd]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/5/2008
-- Description:	
--
-- Modified 5/8/2009 - Rick Deigsler
-- Pull from Offer Engine
-- Modified 9/22/2009 - Eduardo Patino (Ticket 9481)
-- =============================================
CREATE PROCEDURE [dbo].[usp_usage_from_lp_historical_info_upd]

@p_offer_id					varchar(50),
@p_utility_id				varchar(50),
@p_account_number			varchar(50)

AS
BEGIN
	SET NOCOUNT ON;
	SET		@p_utility_id		= LTRIM(RTRIM(@p_utility_id))
	SET		@p_account_number	= LTRIM(RTRIM(@p_account_number))

	DECLARE	@w_annual_usage		bigint,
			@w_total_usage		float,
			@w_total_days		float,
			@w_max_endate		datetime,
			@w_voltage			varchar(50),
			@w_364_range		datetime,
			@w_losses			decimal(18,9)

	select	top 1 @w_364_range = dateadd (day, -363, todate)
	FROM
	(
		SELECT	ToDate
		FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
				INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
		WHERE	o.OFFER_ID			= @p_offer_id
		AND		o.ACCOUNT_NUMBER	= @p_account_number
		UNION
		SELECT	ToDate
		FROM	LibertyPower..EstimatedUsage u WITH (NOLOCK)
				INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
		WHERE	o.OFFER_ID			= @p_offer_id
		AND		o.ACCOUNT_NUMBER	= @p_account_number				
	)z
	ORDER BY todate DESC

	SELECT	@w_voltage = Voltage
	FROM	OE_ACCOUNT WITH (NOLOCK)
	WHERE	ACCOUNT_NUMBER	= @p_account_number
	AND		UTILITY		= @p_utility_id


	SELECT	@w_max_endate = MAX(z.ToDate), @w_total_usage = SUM(z.TotalKwh), @w_total_days = SUM(z.DaysUsed)
	FROM
	(
		SELECT	ToDate, TotalKwh, DaysUsed
		FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
				INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
		WHERE	o.OFFER_ID			= @p_offer_id 
			AND	o.ACCOUNT_NUMBER	= @p_account_number
			AND	ToDate >= @w_364_range
		GROUP BY ToDate, TotalKwh, DaysUsed
		UNION
		SELECT	ToDate, TotalKwh, DaysUsed
		FROM	LibertyPower..EstimatedUsage u WITH (NOLOCK)
				INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
		WHERE	o.OFFER_ID			= @p_offer_id 
			AND	o.ACCOUNT_NUMBER	= @p_account_number
			AND	ToDate >= @w_364_range
		GROUP BY ToDate, TotalKwh, DaysUsed				
	)z

	IF @w_total_days > 0 AND @w_total_usage > 0
		SET	@w_annual_usage = CAST((CAST(@w_total_usage AS decimal(18,5)) * (CAST(365 AS decimal(18,5)) / CAST(@w_total_days AS decimal(18,5)))) AS int)
	ELSE
		SET	@w_annual_usage = 0

	-- value modifications  ----------------------
	--IF @w_voltage = '1'
	--	SET @w_voltage = CASE WHEN @p_utility_id = 'NIMO' THEN 'Secondary' ELSE 'Primary' END
	--IF @w_voltage = '2'
	--	SET @w_voltage = CASE WHEN @p_utility_id = 'NIMO' THEN 'Primary' ELSE 'Secondary' END
	--IF @w_voltage IS NULL OR LEN(@w_voltage) = 0
	--	SET @w_voltage = 'Secondary'
	----------------------------------------------

	SET	@w_annual_usage		= LTRIM(RTRIM(@w_annual_usage))
	SET	@w_voltage			= LTRIM(RTRIM(@w_voltage))

	--SELECT	@w_losses = (CASE WHEN Losses IS NULL OR LEN(Losses) = 0 THEN 0 ELSE Losses END)
	--FROM	lp_historical_info..LossesByUtilityVoltage c WITH (NOLOCK) 
	--WHERE	c.utility_id = @p_utility_id AND c.voltage = CASE WHEN @w_voltage IS NULL OR LEN(@w_voltage) = 0 THEN 'Secondary' ELSE @w_voltage END

	--INSERT INTO zErrors (RequestID, OfferID, AccountNumber, Utility, ErrorMessage, Username, [Filename], DateInsert)
	--SELECT		'NONE', @p_offer_id, @p_account_number, @p_utility_id, 'usage update - max end date', cast(@w_max_endate as varchar(50)), 'NONE', GETDATE()

	UPDATE	OE_ACCOUNT
	SET		ANNUAL_USAGE	= CASE WHEN LEN(@w_annual_usage) > 0	THEN @w_annual_usage				ELSE ANNUAL_USAGE	END, 
			--LOSSES			= CASE WHEN LEN(@w_losses) > 0			THEN @w_losses						ELSE LOSSES			END,
			USAGE_DATE		= CASE WHEN @w_max_endate IS NOT NULL	THEN @w_max_endate					ELSE USAGE_DATE		END
	WHERE	ACCOUNT_NUMBER	= @p_account_number AND UTILITY = @p_utility_id

	SET NOCOUNT OFF;
END
GO
