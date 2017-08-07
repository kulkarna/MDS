USE [Libertypower]
GO
/* PBI1004/1_addColumn_[Libertypower].dbo.MultiTermWinServiceData.sql */
IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'MultiTermWinServiceData'             
	AND		COLUMN_NAME = 'ReenrollmentFollowingMeterDate'
) 
	BEGIN
		ALTER TABLE dbo.MultiTermWinServiceData
		ADD ReenrollmentFollowingMeterDate DateTime Null;
	END
GO

/* PBI3569/AddMultiTermCustomProducts.sql */
IF NOT EXISTS (SELECT 1 FROM Libertypower..ProductBrand WHERE Name = 'Custom SmartStep')
	BEGIN
		DECLARE	@ProductBrandID	int,
				@Today			datetime

		SET	@Today = GETDATE()

		INSERT	INTO Libertypower..ProductBrand
		SELECT	7, 'Custom SmartStep', 1, 0, 3, 1, 'libertypower\rideigsler',	@Today, 1

		SET	@ProductBrandID = SCOPE_IDENTITY()

		INSERT	INTO Lp_common..common_product
		SELECT	LTRIM(RTRIM(product_id)) + '_MT', 'Custom SmartStep', product_category, product_sub_category, utility_id, frecuency, 
				db_number, term_months, @Today, 'libertypower\rideigsler', inactive_ind, @Today, 0, default_expire_product_id, 
				requires_profitability, is_flexible, account_type_id, IsCustom, IsDefault, @ProductBrandID
		FROM	Lp_common..common_product
		WHERE	product_descp			= 'CUSTOM FIXED'
		AND		product_sub_category	= 'CUSTOM'
		AND		account_type_id			= 1
		AND		inactive_ind			= 0

		DECLARE	@ProductID		varchar(20),
				@RoleID			int

		DECLARE @ProductIDTable TABLE (ProductID varchar(20))
		DECLARE @RoleIDTable TABLE (RoleID int)

		INSERT	INTO @ProductIDTable
		SELECT	DISTINCT product_id
		FROM	Lp_common..common_product
		WHERE	product_descp			= 'Custom SmartStep'
		AND		product_sub_category	= 'CUSTOM'
		AND		account_type_id			= 1
		AND		inactive_ind			= 0

		WHILE (SELECT COUNT(ProductID) FROM @ProductIDTable) > 0
			BEGIN
				INSERT	INTO @RoleIDTable
				SELECT	DISTINCT role_id
				FROM	Lp_security..security_role_product
				ORDER BY role_id

				SELECT TOP 1 @ProductID = ProductID FROM @ProductIDTable

				WHILE (SELECT COUNT(RoleID) FROM @RoleIDTable) > 0
					BEGIN
						SELECT TOP 1 @RoleID = RoleID FROM @RoleIDTable

						IF NOT EXISTS (SELECT 1 FROM Lp_security..security_role_product WHERE role_id = @RoleID AND product_id = @ProductID)
							BEGIN
								INSERT	INTO Lp_security..security_role_product
								SELECT	@RoleID, @ProductID, 0, 0, 0, 0
							END

						DELETE FROM @RoleIDTable WHERE RoleID = @RoleID
					END
				DELETE FROM @ProductIDTable WHERE ProductID = @ProductID
			END
	END
	
GO

/* PBI3614/AddDailyPricingTemplateConfigurationColumns.sql */
IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'DailyPricingTemplateConfiguration'             
	AND		COLUMN_NAME = 'PromoMessage'
) 
	BEGIN
		ALTER TABLE DailyPricingTemplateConfiguration
		ADD PromoMessage varchar(1000)
	END

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'DailyPricingTemplateConfiguration'             
	AND		COLUMN_NAME = 'PromoImageFileGuid'
) 
	BEGIN
		ALTER TABLE DailyPricingTemplateConfiguration
		ADD PromoImageFileGuid varchar(100)
	END
GO

/* PBI3614/AddDailyPricingTemplateTagsColumn.sql */
IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'DailyPricingTemplateTags'             
	AND		COLUMN_NAME = 'PromoMessage'
) 
	BEGIN
		ALTER TABLE DailyPricingTemplateTags
		ADD PromoMessage varchar(1000)
	END
GO

UPDATE	DailyPricingTemplateTags
SET		PromoMessage = '[promotional_message]'
GO

/* PBI3614/AddFileManagerRecords.sql */
IF NOT EXISTS (SELECT 1 FROM Libertypower..FileManager WHERE ContextKey = 'TemplateTextFields')
	BEGIN
		DECLARE	@ID	int

		INSERT	INTO Libertypower..FileManager
		SELECT	'TemplateTextFields', 'Pricing Sheet Text', GETDATE(), 3

		SET	@ID = SCOPE_IDENTITY()

		INSERT	INTO Libertypower..ManagerRoot
		SELECT	@ID, 'D:\Test\ManagedFiles\Import\TemplateTextFields\', 1, GETDATE(), 3
	END
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMultiTermWinServiceDataReadyToSubmitToIstaByStatusId]    Script Date: 02/04/2013 17:41:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Lev A. Rosenblum>
-- Create date: <09/07/2012>
-- Description:	<Select Records from MultiTermWinService table to be submitted to ISTA>
-- Description:	<Pulling just records having StartToSubmitDate<=today>
-- =============================================
-- Modified by Lev Rosenblum at 11/5/2012 rework for PBI1015
-- Process just records having currently accountStatus not in de-enrolled status 
-- =============================================

ALTER PROCEDURE [dbo].[usp_GetMultiTermWinServiceDataReadyToSubmitToIstaByStatusId] 
(
	@ProcessStatusId int
	,@SubmittionDate datetime
)

AS

DECLARE @DeEnrollmentAccountContractStatusNumber varchar(15)
, @MultiTermWinServiceStatusId int

SET @DeEnrollmentAccountContractStatusNumber='911000'--'account DE-ENROLLED'
SET @MultiTermWinServiceStatusId=8--MultiTermWinServiceStatus.Name='NotSubmittedToESTADueToDeEnrollment'

BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION;
	BEGIN TRY

		UPDATE dbo.MultiTermWinServiceData
		SET MultiTermWinServiceStatusId = @MultiTermWinServiceStatusId
		FROM dbo.MultiTermWinServiceData mtwsd with (nolock)
			INNER JOIN dbo.AccountContractRate acr with (nolock) 
				ON acr.AccountContractRateID=mtwsd.ToBeExpiredAccountContactRateId
			INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
				ON accsts.AccountContractID=acr.AccountContractID
		WHERE MultiTermWinServiceStatusId=@ProcessStatusId
			AND StartToSubmitDate<=@SubmittionDate
			AND accsts.[Status]=@DeEnrollmentAccountContractStatusNumber
			

		SELECT mtwsd.ID, mtwsd.LeadTime, mtwsd.StartToSubmitDate, mtwsd.ToBeExpiredAccountContactRateId, mtwsd.MeterReadDate, mtwsd.NewAccountContractRateId
				, mtwsd.RateEndDateAjustedByService, mtwsd.MultiTermWinServiceStatusId, mtwsd.ServiceLastRunDate
				, mtwsd.DateCreated, mtwsd.CreatedBy, mtwsd.DateModified, mtwsd.ModifiedBy, mtwsd.ReenrollmentFollowingMeterDate, convert(bit,1) as UpdateSucceeded
		FROM dbo.MultiTermWinServiceData mtwsd with (nolock) 
		WHERE MultiTermWinServiceStatusId=@ProcessStatusId
			AND StartToSubmitDate<=@SubmittionDate

		COMMIT TRANSACTION;
			
	END TRY
	
	BEGIN CATCH

		SELECT mtwsd.ID, mtwsd.LeadTime, mtwsd.StartToSubmitDate, mtwsd.ToBeExpiredAccountContactRateId, mtwsd.MeterReadDate, mtwsd.NewAccountContractRateId
				, mtwsd.RateEndDateAjustedByService, mtwsd.MultiTermWinServiceStatusId, mtwsd.ServiceLastRunDate
				, mtwsd.DateCreated, mtwsd.CreatedBy, mtwsd.DateModified, mtwsd.ModifiedBy, mtwsd.ReenrollmentFollowingMeterDate, convert(bit,0) as UpdateSucceeded
		FROM dbo.MultiTermWinServiceData mtwsd with (nolock) 
			INNER JOIN dbo.AccountContractRate acr with (nolock) 
				ON acr.AccountContractRateID=mtwsd.ToBeExpiredAccountContactRateId
			INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
				ON accsts.AccountContractID=acr.AccountContractID
		WHERE MultiTermWinServiceStatusId=@ProcessStatusId
			AND StartToSubmitDate<=@SubmittionDate
			AND accsts.[Status]!=@DeEnrollmentAccountContractStatusNumber

		ROLLBACK TRANSACTION;
	END CATCH
	
END
GO


/****** Object:  StoredProcedure [dbo].[usp_AddMultiTermRecordsToBeProcessedByService]    Script Date: 01/30/2013 14:11:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Lev A. Rosenblum>
-- Create date: <09/04/2012>
-- Modified date: <10/03/2012>
-- Description:	<Add records for multi-term producttype to be processed by win. service>
-- =============================================
-- Modified by Lev Rosenblum 
-- Modified date: <11/15/2012>
-- Removed input parameter @ProductTypeID
-- Select just records having ProductBrand.IsMultiTerm=1
-- =============================================
-- Modified by Lev Rosenblum 
-- Modified date: <1/30/2013>
-- Extra creteria has been added to implement task 4700 (PBI1004)
-- =============================================
ALTER PROCEDURE [dbo].[usp_AddMultiTermRecordsToBeProcessedByService] 
(
	@NumberDaysInAdvance int
	, @NumberDaysAfterMeterDateToIstaSubmission int
	, @UserId int
	, @DefaultLeadTimePeriod int=5	--applied to accounts having BillingTypeID=3 and missing LeadTime in our table
	, @StandardLeadTimePeriod int=0 --applied to accounts having BillingTypeID!=3
)
AS

DECLARE @IsMultiTerm bit
SET @IsMultiTerm=1;

DECLARE @ApprovedContractStatusID int
DECLARE @EnrolledAccountContractStatusNumber1 varchar(15), @EnrolledAccountContractStatusNumber2 varchar(15)
, @DeEnrollmentAccountContractStatusNumber varchar(15), @ReEnrollmentAccountContractStatusNumber varchar(15)
, @ReEnrollmentAccountContractSubStatusNumber varchar(15);

SET @ApprovedContractStatusID=3 --'APPROVED'
SET @EnrolledAccountContractStatusNumber1='905000'--'ENROLLED'
SET @EnrolledAccountContractStatusNumber2='906000'--'ENROLLED'
SET @DeEnrollmentAccountContractStatusNumber='11000'--'Processing DE-ENROLLMENT'
SET @ReEnrollmentAccountContractStatusNumber='13000'--'Re-enrolled'
SET @ReEnrollmentAccountContractSubStatusNumber='80'--'Re-enrolled'

BEGIN

INSERT INTO dbo.MultiTermWinServiceData
(LeadTime, StartToSubmitDate, ToBeExpiredAccountContactRateId, MeterReadDate, NewAccountContractRateId, MultiTermWinServiceStatusId, DateCreated, CreatedBy) 

SELECT  
	(SELECT (Case WHEN a.BillingTypeID!=3 THEN @StandardLeadTimePeriod 
					WHEN a.BillingTypeID=3 and lp_urlt.LeadTime IS NULL THEN @DefaultLeadTimePeriod 
					ELSE lp_urlt.LeadTime END) as LeadTime
		FROM  LibertyPower..Utility lp_u 
			Left Outer Join LibertyPower..UtilityRateLeadTime lp_urlt
			ON lp_urlt.UtilityID=lp_u.ID
		WHERE lp_u.ID=a.UtilityID
		) as LeadTime
	, DATEADD(d, @NumberDaysAfterMeterDateToIstaSubmission,IsNull(lp_c_mrc.read_date,acr.RateEnd)) as StartToSubmitDate
	, acr.AccountContractRateID as ToBeExpiredAccountContactRateId
	
	, IsNull(lp_c_mrc.read_date,acr.RateEnd) as MeterRateEndDate
	
	, (	SELECT AccountContractRateID
		FROM LibertyPower..AccountContractRate lpACR
		WHERE lpACR.AccountContractID=ac.AccountContractID
		and lpACR.RateStart=DATEADD(d,1,acr.RateEnd)
		) as NewAccountContractRateId
	, 1 as MultyTermWinServiceStatusId
	, Convert(DateTime,Convert(char(10),GETDATE(),101)) as CurrDate
	, @UserId as UserId
	
FROM LibertyPower..Account a with (nolock)
	INNER JOIN LibertyPower..Utility u with (nolock)
		on u.ID=a.UtilityID
	INNER JOIN LibertyPower..AccountContract ac with (nolock)
		on a.AccountID=ac.AccountID
	INNER JOIN LibertyPower..[Contract] c with (nolock)
		on c.ContractID=ac.ContractID
	INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
		on accsts.AccountContractID=ac.AccountContractID 
	INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
		on ac.AccountContractID = acr.AccountContractID
	INNER JOIN LibertyPower..Price p with (nolock)
		on p.ID=acr.PriceID
	INNER JOIN LibertyPower..ProductBrand pb with (nolock)
		ON pb.ProductBrandID=p.ProductBrandID
	INNER JOIN LibertyPower..ProductType pt with (nolock)
		ON pt.ProductTypeID=pb.ProductTypeID
	LEFT OUTER JOIN 
		(
			--Select just unique read_date per read_cycle_id, utility_id, calendar_month, calendar_year combination
			SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
			FROM Lp_common.dbo.meter_read_calendar with (nolock)
			GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
		) lp_c_mrc
		ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=YEAR(acr.RateEnd) and lp_c_mrc.calendar_month=MONTH(acr.RateEnd)
		
WHERE pb.IsMultiTerm=@IsMultiTerm
	and pt.Active=1
	and acr.RateStart<=GETDATE()
	and acr.RateEnd>GETDATE()
	and c.ContractStatusID=@ApprovedContractStatusID 
	and (accsts.[Status]=@EnrolledAccountContractStatusNumber1 
		or accsts.[Status]=@EnrolledAccountContractStatusNumber2 
		or accsts.[Status]=@DeEnrollmentAccountContractStatusNumber)
		or (accsts.[Status]=@ReEnrollmentAccountContractStatusNumber AND accsts.SubStatus=@ReEnrollmentAccountContractSubStatusNumber)

	and DATEADD(d,@NumberDaysInAdvance,Convert(DateTime,Convert(char(10),GETDATE(),101))) >= Convert(DateTime,Convert(char(10),acr.RateEnd,101))
	and (SELECT AccountContractRateID 
		FROM LibertyPower..AccountContractRate lpACR with (nolock)
		WHERE lpACR.AccountContractID=ac.AccountContractID
		and lpACR.RateStart=DATEADD(d,1,acr.RateEnd)
		) IS NOT NULL --SELECTED Just Records which not expired but changed in accordinally with Multi-Term rules 
	and acr.AccountContractRateID	NOT IN
	(SELECT ToBeExpiredAccountContactRateId FROM LibertyPower..MultiTermWinServiceData with (nolock))
END
GO

/****** Object:  StoredProcedure [dbo].[usp_PriceInsert]    Script Date: 01/10/2013 08:11:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PriceInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PriceInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PriceInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_DailyPricingSalesChannelPricesInsert
 * Inserts price record for specified sales channel
 *
 * History
 *******************************************************************************
 * 12/7/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 3/13/2013 - Lev Rosenblum
 * Merge VM4 version and newer version created by Rick Deigsler
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceInsert]
	@ChannelID				int, 
	@ChannelGroupID			int, 
	@ChannelTypeID			int, 
	@ProductCrossPriceSetID	int, 
	@ProductTypeID			int, 
	@MarketID				int, 
	@UtilityID				int, 
	@SegmentID				int, 
	@ZoneID					int, 
	@ServiceClassID			int, 
	@StartDate				datetime, 
	@Term					int, 
	@Price					decimal(18,10), 
	@CostRateEffectiveDate	datetime, 
	@CostRateExpirationDate	datetime, 
	@IsTermRange			tinyint, 
	@DateCreated			datetime,
	@PriceTier				tinyint,
	@ProductBrandID			int,
	@GrossMargin			decimal(18,10),
	@ProductCrossPriceID	int	= 0
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	bigint

	SET	@CostRateEffectiveDate = DATEADD(dd, 0, DATEDIFF(dd, 0, @CostRateEffectiveDate))
    
	INSERT INTO	LibertyPower..Price (ChannelID, ChannelGroupID, ChannelTypeID, ProductCrossPriceSetID, 
				ProductTypeID, MarketID, UtilityID, SegmentID, ZoneID, ServiceClassID, StartDate, Term, Price, CostRateEffectiveDate, 
				CostRateExpirationDate, IsTermRange, DateCreated, PriceTier, ProductBrandID, GrossMargin, ProductCrossPriceID)
	VALUES		(@ChannelID, @ChannelGroupID, @ChannelTypeID, @ProductCrossPriceSetID, @ProductTypeID, @MarketID, @UtilityID, @SegmentID, @ZoneID, 
				@ServiceClassID, @StartDate, @Term, ROUND(@Price, 5), @CostRateEffectiveDate, @CostRateExpirationDate, @IsTermRange, @DateCreated, @PriceTier, 
				@ProductBrandID, @GrossMargin, @ProductCrossPriceID) 

	SET  @ID = SCOPE_IDENTITY()
					
	SELECT	p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID, 
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode, 
			s.service_rate_class AS ServiceClassCode, s.service_rate_class AS ServiceClassDisplayName, p.PriceTier, p.ProductBrandID, p.GrossMargin
			, p.ProductCrossPriceID, pb.ProductBrandId, pb.IsMultiTerm
	FROM	LibertyPower..Price p WITH (NOLOCK)
			INNER JOIN	Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID
			INNER JOIN	Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID
			INNER JOIN	Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID
			INNER JOIN	Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID
			INNER JOIN Libertypower..ProductBrand pb WITH (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
			INNER JOIN	Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID
			LEFT JOIN	lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
			LEFT JOIN	lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
	WHERE	p.ID = @ID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
' 
END
GO


/****** Object:  StoredProcedure [dbo].[usp_PriceUpdate]    Script Date: 01/10/2013 15:05:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PriceUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PriceUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PriceUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_PriceInsert
 * Inserts price record for specified sales channel
 *
 * History
 *******************************************************************************
 * 8/21/2012 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceUpdate]
	@ID						int,
	@ChannelID				int, 
	@ChannelGroupID			int, 
	@ChannelTypeID			int, 
	@ProductCrossPriceSetID	int, 
	@ProductTypeID			int, 
	@MarketID				int, 
	@UtilityID				int, 
	@SegmentID				int, 
	@ZoneID					int, 
	@ServiceClassID			int, 
	@StartDate				datetime, 
	@Term					int, 
	@Price					decimal(18,10), 
	@CostRateEffectiveDate	datetime, 
	@CostRateExpirationDate	datetime, 
	@IsTermRange			tinyint, 
	@DateCreated			datetime,
	@PriceTier				tinyint,
	@ProductBrandID			int,
	@GrossMargin			decimal(18,10),
	@ProductCrossPriceID	int	= 0
AS
BEGIN
    SET NOCOUNT ON;

	SET	@CostRateEffectiveDate = DATEADD(dd, 0, DATEDIFF(dd, 0, @CostRateEffectiveDate))
    
	UPDATE	Libertypower..Price 
	SET		ChannelID				= @ChannelID, 
			ChannelGroupID			= @ChannelGroupID,
			ChannelTypeID			= @ChannelTypeID,
			ProductCrossPriceSetID	= @ProductCrossPriceSetID,
			ProductTypeID			= @ProductTypeID,
			MarketID				= @MarketID,
			UtilityID				= @UtilityID, 
			SegmentID				= @SegmentID,
			ZoneID					= @ZoneID,
			ServiceClassID			= @ServiceClassID,
			StartDate				= @StartDate, 
			Term					= @Term, 
			Price					= @Price,
			CostRateEffectiveDate	= @CostRateEffectiveDate,
			CostRateExpirationDate	= @CostRateExpirationDate,
			IsTermRange				= @IsTermRange, 
			PriceTier				= @PriceTier,
			ProductBrandID			= @ProductBrandID,
			GrossMargin				= @GrossMargin,
			ProductCrossPriceID		= @ProductCrossPriceID
	WHERE ID = @ID
    	
	SELECT	p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID, 
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode, 
			s.service_rate_class AS ServiceClassCode, s.service_rate_class AS ServiceClassDisplayName, p.PriceTier, p.ProductBrandID, p.GrossMargin, p.ProductCrossPriceID
	FROM	LibertyPower..Price p WITH (NOLOCK)
			INNER JOIN	Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID
			INNER JOIN	Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID
			INNER JOIN	Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID
			INNER JOIN	Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID
			INNER JOIN	Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID
			LEFT JOIN	lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
			LEFT JOIN	lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
	WHERE	p.ID = @ID 

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

' 
END
GO

/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateConfigurationSelect]    Script Date: 1/4/2013 11:15:02 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateConfigurationSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DailyPricingTemplateConfigurationSelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateConfigurationSelect]    Script Date: 1/4/2013 11:15:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateConfigurationSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_DailyPricingTemplateConfigurationSelect
 * Gets template configuration data
 *
 * History
 *******************************************************************************
 * 6/17/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 1/3/2013 - Modified - Rick Deigsler
 * Added 2 new columns for promo messages
 *******************************************************************************
 * 3/13/2013 - merged with production version
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingTemplateConfigurationSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ID, SegmentID, ChannelTypeID, ChannelGroupID, MarketID, UtilityID, HeaderStatement, 
			SizeRequirement, SubmissionStatement, CustomerClassStatement, ProductTaxStatement,
			ConfidentialityStatement, Header, Footer1, Footer2, 
			ISNULL(PromoMessage, '''') AS PromoMessage, ISNULL(PromoImageFileGuid, '''') AS PromoImageFileGuid
	FROM	DailyPricingTemplateConfiguration WITH (NOLOCK)

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
EXEC sp_addextendedproperty N'VirtualFolder_Path', N'DailyPricing', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_DailyPricingTemplateConfigurationSelect', NULL, NULL
GO

/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateConfigurationUpdate]    Script Date: 1/3/2013 1:39:32 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateConfigurationUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DailyPricingTemplateConfigurationUpdate]
GO
/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateConfigurationUpdate]    Script Date: 1/3/2013 1:39:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateConfigurationUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_DailyPricingTemplateConfigurationUpdate
 * Updates template text field data
 *
 * History
 *******************************************************************************
 * 7/20/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 1/3/2013 - Modified - Rick Deigsler
 * Added 2 new columns for promo messages
 *******************************************************************************
 * 3/13/2013 - merged with production version by Lev Rosenblum 
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingTemplateConfigurationUpdate]
	@SegmentID					int,
	@ChannelTypeID				int,
	@ChannelGroupID				int,
	@MarketID					int,
	@UtilityID					int,
	@HeaderStatement			varchar(1000),
	@SizeRequirement			varchar(500),
	@SubmissionStatement		varchar(1000),
	@CustomerClassStatement		varchar(1000),
	@ProductTaxStatement		varchar(500),
	@ConfidentialityStatement	varchar(1000),
	@Header						varchar(1000),
	@Footer1					varchar(1000),
	@Footer2					varchar(1000),
	@PromoMessage				varchar(1000),
	@PromoImageFileGuid			varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

	IF EXISTS (	SELECT	NULL
				FROM	DailyPricingTemplateConfiguration WITH (NOLOCK)
				WHERE	SegmentID		= @SegmentID
				AND		ChannelTypeID	= @ChannelTypeID
				AND		ChannelGroupID	= @ChannelGroupID
				AND		MarketID		= @MarketID
				AND		UtilityID		= @UtilityID
				)
		BEGIN
			UPDATE	DailyPricingTemplateConfiguration
			SET		SegmentID					= @SegmentID,
					ChannelTypeID				= @ChannelTypeID,
					ChannelGroupID				= @ChannelGroupID,
					MarketID					= @MarketID,
					UtilityID					= @UtilityID,
					HeaderStatement				= @HeaderStatement,
					SizeRequirement				= @SizeRequirement,
					SubmissionStatement			= @SubmissionStatement,
					CustomerClassStatement		= @CustomerClassStatement,
					ProductTaxStatement			= @ProductTaxStatement,
					ConfidentialityStatement	= @ConfidentialityStatement,
					Header						= @Header,
					Footer1						= @Footer1,
					Footer2						= @Footer2,
					PromoMessage				= @PromoMessage,
					PromoImageFileGuid			= @PromoImageFileGuid
			WHERE	SegmentID					= @SegmentID
					AND		ChannelTypeID		= @ChannelTypeID
					AND		ChannelGroupID		= @ChannelGroupID
					AND		MarketID			= @MarketID
					AND		UtilityID			= @UtilityID					
		END
	ELSE
		BEGIN
			INSERT INTO	DailyPricingTemplateConfiguration (SegmentID, ChannelTypeID, 
						ChannelGroupID, MarketID, UtilityID, HeaderStatement, SizeRequirement, 
						SubmissionStatement, CustomerClassStatement, ProductTaxStatement,
						ConfidentialityStatement, Header, Footer1, Footer2, PromoMessage, PromoImageFileGuid)
			VALUES		(@SegmentID, @ChannelTypeID, @ChannelGroupID, @MarketID, @UtilityID, @HeaderStatement, 
						@SizeRequirement, @SubmissionStatement, @CustomerClassStatement, @ProductTaxStatement,
						@ConfidentialityStatement, @Header, @Footer1, @Footer2, @PromoMessage, @PromoImageFileGuid)
		END

	SELECT SegmentID, ChannelTypeID, ChannelGroupID, MarketID, UtilityID, HeaderStatement,
	SizeRequirement, SubmissionStatement, CustomerClassStatement, ProductTaxStatement,
	ConfidentialityStatement, Header, Footer1, Footer2, PromoMessage, PromoImageFileGuid
	FROM DailyPricingTemplateConfiguration WITH (NOLOCK)
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
EXEC sp_addextendedproperty N'VirtualFolder_Path', N'DailyPricing', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_DailyPricingTemplateConfigurationUpdate', NULL, NULL
GO

/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateTagsSelect]    Script Date: 1/4/2013 11:15:02 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateTagsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DailyPricingTemplateTagsSelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateTagsSelect]    Script Date: 1/4/2013 11:15:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateTagsSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_DailyPricingTemplateTagsSelect
 * Gets template tag data
 *
 * History
 *******************************************************************************
 * 7/20/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 3/13/2013 - merged with production version by Lev Rosenblum
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingTemplateTagsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ID, SheetTemplate, SheetName, HeaderTag, Footer1Tag, Footer2Tag, ExpirationTag, 
			HeaderStatementTag, SubmissionStatementTag, CustomerClassStatementTag, 
			ProductTaxStatementTag, ConfidentialityStatementTag, SizeRequirementTag, MarketTag, 
			UtilityTag, SegmentTag, ChannelTypeTag, ZoneTag, ServiceClassTag, StartDateTag, 
			TermTag, PriceTag, SalesChannelTag, DateTimeTag, WorkbookAllowEditing, WorkbookPassword, PromoMessage
	  FROM	LibertyPower..DailyPricingTemplateTags WITH (NOLOCK)    


    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
EXEC sp_addextendedproperty N'VirtualFolder_Path', N'DailyPricing', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_DailyPricingTemplateTagsSelect', NULL, NULL
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]    Script Date: 01/22/2013 08:52:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_AccountContractRateByAcctNoUtilityIDSelect
 * Gets account contract rate record(s) for specified account number and utility ID
 *
 * History
 *******************************************************************************
 * 10/26/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]
	@AccountNumber	varchar(30),
	@UtilityID		int,
	@IsRenewal		bit	= 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	acr.AccountContractRateID, acr.AccountContractID, acr.LegacyProductID, acr.Term, acr.RateID, acr.Rate, 
			acr.RateCode, acr.RateStart, acr.RateEnd, acr.IsContractedRate, acr.HeatIndexSourceID, acr.HeatRate, 
			acr.TransferRate, acr.GrossMargin, acr.CommissionRate, acr.AdditionalGrossMargin, acr.Modified, 
			acr.ModifiedBy, acr.DateCreated, acr.CreatedBy, acr.PriceID, acr.ProductCrossPriceMultiID
    FROM	Libertypower..AccountContractRate acr WITH (NOLOCK)
			INNER JOIN Libertypower..AccountContract ac WITH (NOLOCK) ON acr.AccountContractID = ac.AccountContractID
			INNER JOIN Libertypower..Account a WITH (NOLOCK) ON a.AccountID = ac.AccountID
	WHERE	a.AccountNumber			= @AccountNumber
	AND		a.UtilityID				= @UtilityID
	AND		acr.IsContractedRate	= 1
	AND		ac.ContractID			= CASE WHEN @IsRenewal = 0 THEN a.CurrentContractID ELSE a.CurrentRenewalContractID END

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power

' 
END
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountContractRateUpdate]    Script Date: 01/22/2013 11:20:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountContractRateUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountContractRateUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountContractRateUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
*
* PROCEDURE:	[usp_AccountContractRateUpdate]
*
* DEFINITION:  Updates a record into AccountContractRate Table
*
* RETURN CODE: 
*
* REVISIONS:	
10/12/2012 Gabor - Add @ProductCrossPriceMultiID
6/24/2011 Jaime Forero
-- =============================================
-- Modified Rick Deigsler 10/17/2012
-- Added MD084 multi-term check/update
-- =============================================
-- Merge with Prod Version byLev Rosenblum 3/13/2013
-- =============================================
*/

CREATE PROCEDURE [dbo].[usp_AccountContractRateUpdate]
	 @AccountContractRateID	INT = NULL
	,@AccountContractID		INT 
	,@LegacyProductID		CHAR(20) 
    ,@Term					INT 
	,@RateID				INT
	,@Rate					FLOAT
	,@RateCode				VARCHAR(50)
	,@RateStart				DATETIME
	,@RateEnd				DATETIME
	,@IsContractedRate		BIT
	,@HeatIndexSourceID		INT = NULL
	,@HeatRate				DECIMAL(9,2) = NULL
	,@TransferRate			FLOAT = NULL
	,@GrossMargin			FLOAT = NULL
	,@CommissionRate		FLOAT = NULL
	,@AdditionalGrossMargin	FLOAT = NULL
	,@ModifiedBy			INT
	,@IsSilent				BIT = 0
	,@PriceID				bigint = NULL
	,@ProductCrossPriceMultiID bigint = NULL
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	IF @AccountContractRateID IS NULL OR @AccountContractID IS NULL
		RAISERROR (''Missing required values: @AccountContractRateID or @AccountContractID'' , 11, 1);
	
	--IF @AccountContractRateID IS NULL AND @AccountContractID IS NULL
	--	RAISERROR (''Need at least one of the 2: @AccountContractRateID or @AccountContractID'' , 11, 1);
	
	--IF @AccountContractRateID IS NULL
	--BEGIN 
	--	SELECT @AccountContractRateID = ACR.AccountContractRateID FROM Libertypower.dbo.AccountContractRate ACR WHERE ACR.AccountContractID = @AccountContractID;
	--END
	
	SET @Rate = CONVERT(DECIMAL(10,5), @Rate)

	------ Multi-term MD084 ---------------------------------------------------------------------
	IF @ProductCrossPriceMultiID IS NOT NULL
	BEGIN
		DECLARE @ProductCrossPriceMultiIDCurrent bigint
		SELECT @ProductCrossPriceMultiIDCurrent = ProductCrossPriceMultiID
		FROM Libertypower..AccountContractRate WITH (NOLOCK)
		WHERE AccountContractRateID = @AccountContractRateID
		IF @ProductCrossPriceMultiIDCurrent <> @ProductCrossPriceMultiID
		BEGIN
			DECLARE @ACR_RateStart DATETIME;
			DECLARE @ACR_RateEnd DATETIME;
			DECLARE @ACR_Rate FLOAT;
			DECLARE @ACR_Term INT;
			DECLARE @ACR_GrossMargin FLOAT;	
					
			SELECT	@ACR_RateStart				= StartDate,
					@ACR_RateEnd				= DATEADD(dd, -1, DATEADD(mm, Term, StartDate)),
					@ACR_Rate					= Price,
					@ACR_Term					= Term,
					@ACR_GrossMargin			= MarkupRate
			FROM	Libertypower..ProductCrossPriceMulti WITH (NOLOCK)
			WHERE	ProductCrossPriceMultiID	= @ProductCrossPriceMultiID

			IF @ACR_RateStart IS NOT NULL
			BEGIN
				SET	@RateStart		= @ACR_RateStart
				SET	@RateEnd		= @ACR_RateEnd
				SET	@Rate			= CASE WHEN @Rate > @ACR_Rate THEN @Rate ELSE @ACR_Rate END -- PBI 4702
				SET	@Term			= @ACR_Term
				SET	@GrossMargin	= @ACR_GrossMargin
			END
		END
	END
----------------------------------------------------------------------------------------------
	
	UPDATE [LibertyPower].[dbo].[AccountContractRate]
    SET  [AccountContractID] = @AccountContractID
		,[LegacyProductID] = @LegacyProductID
		,[Term] = @Term
		,[RateID] = @RateID
		,[Rate] = @Rate
		,[RateCode] = ISNULL(@RateCode,RateCode)
		,[RateStart] = @RateStart
		,[RateEnd] = @RateEnd
		,[IsContractedRate] = ISNULL(@IsContractedRate,[IsContractedRate] )
		,[HeatIndexSourceID] = @HeatIndexSourceID
		,[HeatRate] = @HeatRate
		,[TransferRate] = @TransferRate
		,[GrossMargin] = @GrossMargin
		,[CommissionRate] = @CommissionRate
		,[AdditionalGrossMargin] = @AdditionalGrossMargin
		,[Modified] = GETDATE()
		,[ModifiedBy] = @ModifiedBy
		,[PriceID] = ISNULL(@PriceID, [PriceID])
		,[ProductCrossPriceMultiID] = ISNULL(@ProductCrossPriceMultiID, ProductCrossPriceMultiID)
     WHERE AccountContractRateID = @AccountContractRateID 
	;
	
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountContractRateSelect @AccountContractRateID  ;
	
	RETURN @AccountContractRateID;
	
END
' 
END
GO

/*2_create_storedProc_[LibertyPower].[dbo].[usp_IsMultiTermProductBrandAssociatedWithCurrentAccount].sql*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lev Rosenblum 
-- Create date: 2/7/2013
-- Description:	Verify that product brand assosiated with account isMultiTerm or not
-- =============================================
CREATE PROCEDURE dbo.usp_IsMultiTermProductBrandAssociatedWithCurrentAccount
(
	@AccountIdLegacy char(12)
	, @CurrentDate datetime = getdate
)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @CurrContractId int, @CurrAccountId int, @ApprovedContractStatusId int, @IsMultiTerm bit
	SET @ApprovedContractStatusId=3;
	SET @IsMultiTerm=0;

	SELECT @CurrContractId=MAX(c.ContractID), @CurrAccountId=a.AccountId
	FROM [Libertypower].dbo.[Contract] c with (nolock)
	INNER JOIN [Libertypower].dbo.AccountContract ac with (nolock) ON ac.ContractID=c.ContractID
	INNER JOIN [Libertypower].dbo.Account a with (nolock) ON a.AccountID=ac.AccountID

	WHERE a.AccountIdLegacy=@AccountIdLegacy
	and c.ContractStatusID = @ApprovedContractStatusId
	and c.StartDate <= @CurrentDate
	GROUP BY a.AccountId

	SET @IsMultiTerm =
	(
		SELECT TOP 1 pb.IsMultiTerm
		FROM dbo.ProductBrand pb with (nolock)
			INNER JOIN dbo.Price prc with (nolock) ON prc.ProductBrandID=pb.ProductBrandID
			INNER JOIN dbo.AccountContractRate acr with (nolock) ON acr.PriceID=prc.ID
			INNER JOIN dbo.AccountContract ac with (nolock) ON ac.AccountContractID=acr.AccountContractID
		WHERE ac.AccountID=@CurrAccountId and  ac.ContractID=@CurrContractId
	)

	Return @IsMultiTerm;
END
GO


/*3_create_storedProc_[LibertyPower].[dbo].[usp_AddRecordsToServicePriocessingTableAtReenrollment].sql*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Created by Lev Rosenblum 
-- Created date: <1/30/2013>
-- Add Records To ServicePriocessing Table At Reenrollment [task 4700 (PBI1004)]
-- =============================================
CREATE PROCEDURE [dbo].[usp_AddRecordsToServiceProcessingTableAtReenrollment] 
(
	@NumberDaysAfterMeterDateToIstaSubmission int
	, @UserId int
	, @AccountContractRateId int
	, @ReenrollmentDate datetime = getdate
	, @DefaultLeadTimePeriod int=5	--applied to accounts having BillingTypeID=3 and missing LeadTime in our table
	, @StandardLeadTimePeriod int=0 --applied to accounts having BillingTypeID!=3

)
AS

DECLARE @IsMultiTerm bit
SET @IsMultiTerm=1;

DECLARE @ApprovedContractStatusID int
DECLARE @ReEnrollmentAccountContractStatusNumber varchar(15)
, @ReEnrollmentAccountContractSubStatusNumber varchar(15);

SET @ApprovedContractStatusID=3 --'APPROVED'
SET @ReEnrollmentAccountContractStatusNumber='13000'--'Re-enrolled'
SET @ReEnrollmentAccountContractSubStatusNumber='80'--'Re-enrolled'

BEGIN

INSERT INTO dbo.MultiTermWinServiceData
(LeadTime, StartToSubmitDate, ToBeExpiredAccountContactRateId, MeterReadDate, NewAccountContractRateId, MultiTermWinServiceStatusId, DateCreated, CreatedBy) 

SELECT  
	(SELECT (Case WHEN a.BillingTypeID!=3 THEN @StandardLeadTimePeriod 
					WHEN a.BillingTypeID=3 and lp_urlt.LeadTime IS NULL THEN @DefaultLeadTimePeriod 
					ELSE lp_urlt.LeadTime END) as LeadTime
		FROM  LibertyPower..Utility lp_u with (nolock)
			Left Outer Join LibertyPower..UtilityRateLeadTime lp_urlt
			ON lp_urlt.UtilityID=lp_u.ID
		WHERE lp_u.ID=a.UtilityID
		) as LeadTime
	, DATEADD(d, @NumberDaysAfterMeterDateToIstaSubmission, IsNull(lp_c_mrc.read_date,acr.RateEnd)) as StartToSubmitDate
	, acr.AccountContractRateID as ToBeExpiredAccountContactRateId
	
	, IsNull(lp_c_mrc.read_date,acr.RateEnd) as MeterRateEndDate
	
	, (	SELECT AccountContractRateID
		FROM LibertyPower..AccountContractRate lpACR with (nolock)
		WHERE lpACR.AccountContractID=ac.AccountContractID
		and lpACR.RateStart=DATEADD(d,1,acr.RateEnd)
		) as NewAccountContractRateId
	, 3 as MultiTermWinServiceStatusId
	, Convert(DateTime,Convert(char(10),GETDATE(),101)) as CurrDate
	, @UserId as UserId
	
FROM LibertyPower..Account a 
	INNER JOIN LibertyPower..Utility u with (nolock)
		on u.ID=a.UtilityID
	INNER JOIN LibertyPower..AccountContract ac with (nolock)
		on a.AccountID=ac.AccountID
	INNER JOIN LibertyPower..[Contract] c with (nolock)
		on c.ContractID=ac.ContractID
	INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
		on accsts.AccountContractID=ac.AccountContractID 
	INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
		on ac.AccountContractID = acr.AccountContractID
	INNER JOIN LibertyPower..Price p with (nolock)
		on p.ID=acr.PriceID
	INNER JOIN LibertyPower..ProductBrand pb with (nolock)
		ON pb.ProductBrandID=p.ProductBrandID
	INNER JOIN LibertyPower..ProductType pt with (nolock)
		ON pt.ProductTypeID=pb.ProductTypeID
	LEFT OUTER JOIN 
		(
			--Select just unique read_date per read_cycle_id, utility_id, calendar_month, calendar_year combination
			SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
			FROM Lp_common.dbo.meter_read_calendar with (nolock)
			GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
		) lp_c_mrc
		ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=YEAR(acr.RateEnd) and lp_c_mrc.calendar_month=MONTH(acr.RateEnd)
		
WHERE pb.IsMultiTerm=@IsMultiTerm
	and pt.Active=1
	and acr.RateStart<=@ReenrollmentDate
	and acr.RateEnd>@ReenrollmentDate
	and c.ContractStatusID=@ApprovedContractStatusID 
	-------------------------------------------------------------------------------
	-- TODO: should we check status of account or not (Verify with Eric)
	-- Temporay removed (just for test only) condition due to no posibility to change account status into account status table
	-- and (accsts.[Status]=@ReEnrollmentAccountContractStatusNumber AND accsts.SubStatus=@ReEnrollmentAccountContractSubStatusNumber)	
	-------------------------------------------------------------------------------
	and (SELECT AccountContractRateID 
		FROM LibertyPower..AccountContractRate lpACR with (nolock)
		WHERE lpACR.AccountContractID=ac.AccountContractID
		and lpACR.RateStart=DATEADD(d,1,acr.RateEnd)
		) IS NOT NULL --SELECTED Just Records which not expired but changed in accordinally with Multi-Term rules 
	and acr.AccountContractRateID	NOT IN
	(SELECT ToBeExpiredAccountContactRateId FROM LibertyPower..MultiTermWinServiceData with (nolock))
	and acr.AccountContractRateID=@AccountContractRateId
END
GO

/*4_create_storedProc_[LibertyPower].[dbo].[usp_AddRecordsToServicePriocessingTableAtReenrollmentOverloaded].sql*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Created by Lev Rosenblum 
-- Created date: <1/31/2013>
-- Add Records To ServicePriocessing Table At Reenrollment [task 4700 (PBI1004)]
-- =============================================

CREATE PROCEDURE [dbo].[usp_AddRecordsToServiceProcessingTableAtReenrollmentOverloaded] 
(
	@NumberDaysAfterMeterDateToIstaSubmission int
	, @UserId int
	, @AccountContractRateId int
	, @ReenrollmentFollowingMeterDate datetime
	, @ReenrollmentDate datetime=getdate
	, @DefaultLeadTimePeriod int=5	--applied to accounts having BillingTypeID=3 and missing LeadTime in our table
	, @StandardLeadTimePeriod int=0 --applied to accounts having BillingTypeID!=3

)
AS

DECLARE @IsMultiTerm bit
SET @IsMultiTerm=1;

DECLARE @ApprovedContractStatusID int
DECLARE @ReEnrollmentAccountContractStatusNumber varchar(15)
, @ReEnrollmentAccountContractSubStatusNumber varchar(15);

SET @ApprovedContractStatusID=3 --'APPROVED'
SET @ReEnrollmentAccountContractStatusNumber='13000'--'Re-enrolled'
SET @ReEnrollmentAccountContractSubStatusNumber='80'--'Re-enrolled'

BEGIN

INSERT INTO dbo.MultiTermWinServiceData
(LeadTime, StartToSubmitDate, ToBeExpiredAccountContactRateId, MeterReadDate, NewAccountContractRateId, MultiTermWinServiceStatusId, DateCreated, CreatedBy, ReenrollmentFollowingMeterDate) 

SELECT  
	(SELECT (Case WHEN a.BillingTypeID!=3 THEN @StandardLeadTimePeriod 
					WHEN a.BillingTypeID=3 and lp_urlt.LeadTime IS NULL THEN @DefaultLeadTimePeriod 
					ELSE lp_urlt.LeadTime END) as LeadTime
		FROM  LibertyPower..Utility lp_u with (nolock)
			Left Outer Join LibertyPower..UtilityRateLeadTime lp_urlt
			ON lp_urlt.UtilityID=lp_u.ID
		WHERE lp_u.ID=a.UtilityID
		) as LeadTime
	, DATEADD(d, @NumberDaysAfterMeterDateToIstaSubmission, @ReenrollmentFollowingMeterDate) as StartToSubmitDate
	
	, (	SELECT AccountContractRateID
		FROM LibertyPower..AccountContractRate lpACR
		WHERE lpACR.AccountContractID=ac.AccountContractID
		and lpACR.RateEnd=DATEADD(d,-1,acr.RateStart)
		) as ToBeExpiredAccountContactRateId
		
	, acr.RateEnd as MeterRateEndDate
	, acr.AccountContractRateID as NewAccountContractRateId
	, 3 as MultyTermWinServiceStatusId
	, Convert(DateTime,Convert(char(10),GETDATE(),101)) as CurrDate
	, @UserId as UserId
	, @ReenrollmentFollowingMeterDate
	
FROM LibertyPower..Account a with (nolock)
	INNER JOIN LibertyPower..Utility u with (nolock)
		on u.ID=a.UtilityID
	INNER JOIN LibertyPower..AccountContract ac with (nolock)
		on a.AccountID=ac.AccountID
	INNER JOIN LibertyPower..[Contract] c with (nolock)
		on c.ContractID=ac.ContractID
	INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
		on accsts.AccountContractID=ac.AccountContractID 
	INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
		on ac.AccountContractID = acr.AccountContractID
		
WHERE acr.RateStart<=@ReenrollmentDate
	and acr.RateEnd>@ReenrollmentDate
	and c.ContractStatusID=@ApprovedContractStatusID 
	-------------------------------------------------------------------------------
	-- TODO: should we check status of account or not (Verify with Eric)
	-- Temporay removed (just for test only) condition due to no posibility to change account status into account status table
	-- and (accsts.[Status]=@ReEnrollmentAccountContractStatusNumber AND accsts.SubStatus=@ReEnrollmentAccountContractSubStatusNumber)	
	-------------------------------------------------------------------------------
	and acr.AccountContractRateID	NOT IN
	(
		SELECT NewAccountContractRateId
		FROM LibertyPower..MultiTermWinServiceData with (nolock)
	)
	and acr.AccountContractRateID=@AccountContractRateId
END
GO


/*Create stored Procedure dbo.usp_AddRecordForReEnrolledAccountToMultiTermProcessingTable*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lev Rosenblum
-- Create date: 2/01/2012
-- Description:	Add Re-Enrolled Account To Multi-Term service Processing Table
-- =============================================

CREATE PROCEDURE [dbo].[usp_AddRecordForReEnrolledAccountToMultiTermProcessingTable]
(
	@AccountIdLegacy varchar(12)
	, @ReenrollmentDate datetime
	, @SubmitterUserId int=1770
)

AS

DECLARE @CurrContractId int;
DECLARE @CurrAccountId int;
DECLARE @DaysAfterMeterDateDefault int;
DECLARE @DeenrollmentDate DateTime;
DECLARE @ContractStatusId int;

SET @DaysAfterMeterDateDefault=2;
SET @ContractStatusId=3;


BEGIN
	SET NOCOUNT ON;
	BEGIN TRAN
	BEGIN TRY 
		--Get De-enrollment date:
		SELECT @DeenrollmentDate=Max(AccSrvc.EndDate)
		FROM dbo.AccountService as AccSrvc with (nolock)
		WHERE AccSrvc.account_id=@AccountIdLegacy

		DECLARE @AccountContractId int
		DECLARE @DeenrollmentSubTermEndDate DateTime
		DECLARE @ReenrollmentSubTermEndDate DateTime
		DECLARE @ReenrollmentSubTermStartDate DateTime
		DECLARE @DeenrollmentAccountContactRateId int
		DECLARE @ReenrollmentAccountContactRateId int

		SELECT @DeenrollmentSubTermEndDate=ACR.RateEnd,  @DeenrollmentAccountContactRateId=ACR.AccountContractRateId
		FROM [Libertypower].dbo.[AccountContractRate] ACR with (nolock)
		INNER JOIN [Libertypower].dbo.[AccountContract] AC with (nolock) ON AC.AccountContractID=ACR.AccountContractID
		INNER JOIN
		(
		  SELECT MAX(c.ContractID) as CurrContractId, a.AccountId as CurrAccountId
		  FROM [Libertypower].dbo.[Contract] c with (nolock)
			INNER JOIN [Libertypower].dbo.AccountContract ac with (nolock) ON ac.ContractID=c.ContractID
			INNER JOIN [Libertypower].dbo.Account a with (nolock) ON a.AccountID=ac.AccountID
			
		  WHERE a.AccountIdLegacy=@AccountIdLegacy
			and c.ContractStatusID = @ContractStatusId 
			and c.StartDate <= @ReenrollmentDate
		  Group By a.AccountId
		) Crnt ON Crnt.CurrContractId=AC.ContractId AND Crnt.CurrAccountId=AC.AccountId
		WHERE ACR.RateStart<=@DeenrollmentDate and ACR.RateEnd>@DeenrollmentDate
		
		--SELECT @DeenrollmentSubTermEndDate as DeenrollmentSubTermEndDate, @DeenrollmentAccountContactRateId as DeenrollmentAccountContactRateId
		
		  
		SELECT @ReenrollmentSubTermStartDate = ACR.RateStart, @ReenrollmentSubTermEndDate=ACR.RateEnd,  @ReenrollmentAccountContactRateId=ACR.AccountContractRateId, @AccountContractId=ACR.AccountContractId
		FROM [Libertypower].dbo.[AccountContractRate] ACR with (nolock)
		INNER JOIN [Libertypower].dbo.[AccountContract] AC with (nolock) ON AC.AccountContractID=ACR.AccountContractID
		INNER JOIN
		(
		  SELECT MAX(c.ContractID) as CurrContractId, a.AccountId as CurrAccountId
		  FROM [Libertypower].dbo.[Contract] c with (nolock)
			INNER JOIN [Libertypower].dbo.AccountContract ac with (nolock) ON ac.ContractID=c.ContractID
			INNER JOIN [Libertypower].dbo.Account a with (nolock) ON a.AccountID=ac.AccountID
			
		  WHERE a.AccountIdLegacy=@AccountIdLegacy
			and c.ContractStatusID = 3 
			and c.StartDate <= @ReenrollmentDate
		  Group By a.AccountId
		) Crnt ON Crnt.CurrContractId=AC.ContractId AND Crnt.CurrAccountId=AC.AccountId
		WHERE ACR.RateStart<=@ReenrollmentDate and ACR.RateEnd>@ReenrollmentDate
		
		--SELECT @ReenrollmentSubTermStartDate as ReenrollmentSubTermStartDate, @ReenrollmentSubTermEndDate as ReenrollmentSubTermEndDate
		--, @ReenrollmentAccountContactRateId as ReenrollmentAccountContactRateId, @AccountContractId as AccountContractId
		

		DECLARE @FollowingReenrollmentMeterDate as DateTime
		DECLARE @MeterDateForReenrollmentSubTermStartDate as DateTime
		DECLARE @MeterDateForReenrollmentSubTermEndDate as DateTime
		DECLARE @FollowingAccountContactRateId int
		 
		-- Make adjustment of RateEnd Date of following after ReenrollmentDate and following (if it is exists) RateStart Date into AccountContractRate table
		SELECT @MeterDateForReenrollmentSubTermStartDate=lp_c_mrc.read_date
		FROM LibertyPower..Account a with (nolock)
			INNER JOIN LibertyPower..Utility u with (nolock)
				on u.ID=a.UtilityID
			INNER JOIN LibertyPower..AccountContract ac with (nolock)
				on a.AccountID=ac.AccountID
			INNER JOIN LibertyPower..[Contract] c with (nolock)
				on c.ContractID=ac.ContractID
			INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
				on accsts.AccountContractID=ac.AccountContractID 
			INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
				on ac.AccountContractID = acr.AccountContractID 
			LEFT OUTER JOIN 
			(
				SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
				FROM Lp_common.dbo.meter_read_calendar with (nolock)
				GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
			) lp_c_mrc
			ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=YEAR(ACR.RateStart) and lp_c_mrc.calendar_month=MONTH(ACR.RateStart)
		WHERE acr.AccountContractRateID=@ReenrollmentAccountContactRateId

		DECLARE @Msg varchar(200);
		IF (@MeterDateForReenrollmentSubTermStartDate is null)
		BEGIN
			SET @Msg='The meter date does not exists for ReenrollmentSubTermStartDate=' + Convert(varchar(10),@ReenrollmentSubTermStartDate,101) + '.'
			RAISERROR (@Msg , 11, 1);
		END

		SELECT @MeterDateForReenrollmentSubTermEndDate=lp_c_mrc.read_date
		FROM LibertyPower..Account a with (nolock)
			INNER JOIN LibertyPower..Utility u with (nolock)
				on u.ID=a.UtilityID
			INNER JOIN LibertyPower..AccountContract ac with (nolock)
				on a.AccountID=ac.AccountID
			INNER JOIN LibertyPower..[Contract] c with (nolock)
				on c.ContractID=ac.ContractID
			INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
				on accsts.AccountContractID=ac.AccountContractID 
			INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
				on ac.AccountContractID = acr.AccountContractID 
			LEFT OUTER JOIN 
			(
				SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
				FROM Lp_common.dbo.meter_read_calendar with (nolock)
				GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
			) lp_c_mrc
			ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=YEAR(ACR.RateEnd) and lp_c_mrc.calendar_month=MONTH(ACR.RateEnd)
		WHERE acr.AccountContractRateID=@ReenrollmentAccountContactRateId

		IF (@MeterDateForReenrollmentSubTermEndDate is null)
		BEGIN
			SET @Msg='The meter date does not exists for ReenrollmentSubTermEndDate=' + Convert(varchar(10),@ReenrollmentSubTermEndDate,101) +'.'
			RAISERROR ( @Msg, 11, 1);
		END
		
		--Used just test. Should be removed [Lev Rosenblum 2/6/2013]
		--SELECT @MeterDateForReenrollmentSubTermStartDate as MeterDateForReenrollmentSubTermStartDate, @MeterDateForReenrollmentSubTermEndDate as MeterDateForReenrollmentSubTermEndDate
		--, @ReenrollmentSubTermEndDate as ReenrollmentSubTermEndDate, @DeenrollmentAccountContactRateId as DeenrollmentAccountContactRateId, @ReenrollmentAccountContactRateId as ReenrollmentAccountContactRateId
		--, @AccountContractId as AccountContractId

			
		IF (@DeenrollmentAccountContactRateId <= @ReenrollmentAccountContactRateId)
		BEGIN
			IF (@MeterDateForReenrollmentSubTermEndDate!=@ReenrollmentSubTermEndDate)
			BEGIN
				DECLARE @AccountContractRateId int
				
				SELECT @AccountContractRateId=Min(AccountContractRateId)
				FROM LibertyPower.dbo.AccountContractRate with (nolock)
				WHERE AccountContractID=@AccountContractId and RateStart>@ReenrollmentSubTermEndDate
				
				--TODO: Add later in BEGIN/COMMIT/ROLLBACK transaction
				---------------------------------------------------------
				UPDATE LibertyPower.dbo.AccountContractRate
				SET RateEnd=@MeterDateForReenrollmentSubTermEndDate
				WHERE AccountContractRateId=@ReenrollmentAccountContactRateId		
				IF (@AccountContractRateId>0)
				BEGIN
					UPDATE LibertyPower.dbo.AccountContractRate
					SET RateStart=DATEADD(d,1,@MeterDateForReenrollmentSubTermEndDate)
					WHERE AccountContractRateId=@AccountContractRateId	
				END
				---------------------------------------------------------	
			END
		--  ELSE
		--		Do Nothing
		END
		--ELSE
		--	Imposiable case


		
		 /* Below the RateEnd and RateStart date are corresponding the MeterDates */ 

		DECLARE @FollowingMeterDate DateTime;
		SELECT @FollowingMeterDate=lp_c_mrc.read_date
		FROM LibertyPower..Account a with (nolock)
			INNER JOIN LibertyPower..Utility u with (nolock)
				on u.ID=a.UtilityID
			INNER JOIN LibertyPower..AccountContract ac with (nolock)
				on a.AccountID=ac.AccountID
			INNER JOIN LibertyPower..[Contract] c with (nolock)
				on c.ContractID=ac.ContractID
			INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
				on accsts.AccountContractID=ac.AccountContractID 
			INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
				on ac.AccountContractID = acr.AccountContractID 
			LEFT OUTER JOIN 
			(
				SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
				FROM Lp_common.dbo.meter_read_calendar with (nolock)
				GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
			) lp_c_mrc
			ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=YEAR(@ReenrollmentDate) and lp_c_mrc.calendar_month=MONTH(@ReenrollmentDate)
		WHERE acr.AccountContractRateID=@ReenrollmentAccountContactRateId
		
		IF (@FollowingMeterDate<@ReenrollmentDate)
		BEGIN
			DECLARE @CalendarYear int
			DECLARE @CalendarMonth int
			SET @CalendarMonth=MONTH(@ReenrollmentDate)
			IF (@CalendarMonth<12)
			BEGIN
				SET @CalendarMonth=@CalendarMonth + 1
				SET @CalendarYear=Year(@ReenrollmentDate)
			END
			ELSE
			BEGIN
				SET @CalendarMonth=1
				SET @CalendarYear=Year(@ReenrollmentDate)+1
			END
			
			SELECT @FollowingMeterDate=lp_c_mrc.read_date
			FROM LibertyPower..Account a with (nolock)
				INNER JOIN LibertyPower..Utility u with (nolock)
					on u.ID=a.UtilityID
				INNER JOIN LibertyPower..AccountContract ac with (nolock)
					on a.AccountID=ac.AccountID
				INNER JOIN LibertyPower..[Contract] c with (nolock)
					on c.ContractID=ac.ContractID
				INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
					on accsts.AccountContractID=ac.AccountContractID 
				INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
					on ac.AccountContractID = acr.AccountContractID 
				LEFT OUTER JOIN 
				(
					SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
					FROM Lp_common.dbo.meter_read_calendar with (nolock)
					GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
				) lp_c_mrc
				ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=@CalendarYear and lp_c_mrc.calendar_month=@CalendarMonth
			WHERE acr.AccountContractRateID=@ReenrollmentAccountContactRateId
		END
		
		IF (@FollowingMeterDate IS NULL)
		BEGIN
			SET @Msg='The following meter date does not exists for reenrollmentdate=' + Convert(varchar(10),@ReenrollmentDate,101) +'.';
			RAISERROR (@Msg, 11, 1);
		END
		 
		IF (@DeenrollmentAccountContactRateId=@ReenrollmentAccountContactRateId)
		BEGIN
			IF (DateDiff(d, @FollowingMeterDate, @ReenrollmentSubTermEndDate)<=1) 
			BEGIN
				IF NOT EXISTS
				(
					SELECT ACR.AccountContractRateId
					FROM [Libertypower].dbo.AccountContractRate ACR with (nolock)
						INNER JOIN [Libertypower].dbo.MultiTermWinServiceData MTWSD with (nolock)
							ON MTWSD.ToBeExpiredAccountContactRateId=ACR.AccountContractRateID
					WHERE ACR.AccountContractId=@AccountContractId
				)
				BEGIN
				 EXEC [Libertypower].[dbo].[usp_AddRecordsToServiceProcessingTableAtReenrollment] 
				 @NumberDaysAfterMeterDateToIstaSubmission=@DaysAfterMeterDateDefault, @UserId=@SubmitterUserId
				 , @AccountContractRateId = @ReenrollmentAccountContactRateId, @ReenrollmentDate=@ReenrollmentDate
				END
				--ELSE --TODO: DoNothing
			END
			--ELSE --TODO: DoNothing
		END
		ELSE
		BEGIN	
			IF (DateDiff(d, @FollowingMeterDate, @ReenrollmentSubTermEndDate)<=1)
			BEGIN 
				BEGIN
					IF NOT EXISTS
					(
						SELECT ACR.AccountContractRateId
						FROM [Libertypower].dbo.AccountContractRate ACR with (nolock)
							INNER JOIN [Libertypower].dbo.MultiTermWinServiceData MTWSD with (nolock)
								ON MTWSD.ToBeExpiredAccountContactRateId=ACR.AccountContractRateId
						WHERE ACR.AccountContractId=@AccountContractId
							-- 
					)
					BEGIN
					 EXEC [Libertypower].[dbo].[usp_AddRecordsToServiceProcessingTableAtReenrollment] 
					 @NumberDaysAfterMeterDateToIstaSubmission=@DaysAfterMeterDateDefault, @UserId=@SubmitterUserId
					 , @AccountContractRateId = @ReenrollmentAccountContactRateId, @ReenrollmentDate=@ReenrollmentDate
					END
					--ELSE --TODO: DoNothing
				END
			END
			ELSE
			BEGIN
				BEGIN
					IF NOT EXISTS
					(
						SELECT ACR.AccountContractRateId
						FROM [Libertypower].dbo.AccountContractRate ACR with (nolock)
							INNER JOIN [Libertypower].dbo.MultiTermWinServiceData MTWSD with (nolock)
								ON MTWSD.NewAccountContractRateId=ACR.AccountContractRateId
						WHERE ACR.AccountContractId=@AccountContractId
							-- 
					)
					BEGIN
					 EXEC [Libertypower].[dbo].[usp_AddRecordsToServiceProcessingTableAtReenrollmentOverloaded] 
					 @NumberDaysAfterMeterDateToIstaSubmission=@DaysAfterMeterDateDefault, @UserId=@SubmitterUserId
					 , @AccountContractRateId = @ReenrollmentAccountContactRateId, @ReenrollmentFollowingMeterDate=@FollowingMeterDate, @ReenrollmentDate=@ReenrollmentDate
					END
					--ELSE --TODO: DoNothing
				END
			END
		END
		COMMIT TRAN
		Return 0;
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage,@ErrorSeverity, @ErrorState);
		Return 1;
	END CATCH
END
GO

/*Create stored procedure LibertyPower.dbo.usp_GetCustomMultiTermPrices*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Lev Rosenblum
-- Create date: <2/17/2013,>
-- Description:	<usp_Get Custom Multi Term Prices>
-- =============================================
CREATE PROCEDURE dbo.usp_GetCustomMultiTermPrices
	@ChannelID				INT
	,@ContractSignDate		DateTime
	,@MarketID				INT
	,@UtilityID				INT
	,@ProductBrandID		INT
	,@AccountTypeID			INT 

AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
	p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID
	, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID, p.ServiceClassID, p.StartDate, p.Term
	, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated
	, p.PriceTier, p.ProductBrandID, p.GrossMargin, p.ProductCrossPriceID  
	, m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName
	, ct.Name AS ChannelType, z.zone AS ZoneCode, pb.IsMultiTerm, dp.account_name AS RateDescription 
	, s.service_rate_class AS ServiceClassCode, s.service_rate_class  AS ServiceClassDisplayName
	, ISNULL(CAST(dpd.rate_submit_ind AS INT),2) AS LegacyStatus, dpd.ContractRate	   
	FROM Libertypower..Price p WITH (NOLOCK) 
		INNER JOIN Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID   
		INNER JOIN Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID  
		INNER JOIN Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID  
		INNER JOIN Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID  
		INNER JOIN Libertypower..ProductBrand pb WITH (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
		INNER JOIN Libertypower..ProductType pt WITH (NOLOCK) ON pt.ProductTypeID = pb.ProductTypeID
		LEFT JOIN lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id  
		LEFT JOIN lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id 
		LEFT JOIN lp_deal_capture..deal_pricing_detail dpd WITH (NOLOCK) ON p.ID = dpd.PriceID
		LEFT JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK) ON dpd.deal_pricing_id = dp.deal_pricing_id
	WHERE p.ChannelID		= @ChannelID  
	AND p.CostRateEffectiveDate =@ContractSignDate 
	AND p.MarketID			= @MarketID
	AND p.UtilityID			= @UtilityID
	AND p.ProductBrandID	= @ProductBrandID 
	AND p.SegmentID			= @AccountTypeID 
	AND pb.IsCustom = 1 
	AND	p.ProductCrossPriceSetID = 0
	AND dpd.rate_submit_ind = 0
END
GO

/*Create stored procedure LibertyPower.dbo.usp_GetAccountTypeIdByProductAccountTypeId */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lev Rosenblum
-- Create date: 2/14/2013
-- Description:	Get AccountTypeId By ProductAccountTypeId
-- =============================================
CREATE PROCEDURE dbo.usp_GetAccountTypeIdByProductAccountTypeId 
	@ProductAccountTypeId int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT [ID]
    FROM dbo.AccountType with (nolock)
    WHERE ProductAccountTypeId=@ProductAccountTypeId
END
GO

/*Create stored procedure LibertyPower.dbo.usp_PriceDetailSelect*/
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_PriceDetailSelect]
@PriceID INT
AS
BEGIN
DECLARE @ChannelID INT
DECLARE @ChannelGroupID INT
DECLARE @ChannelTypeID INT
DECLARE @MarketID INT
DECLARE @UtilityID INT
DECLARE @SegmentID INT
DECLARE @ProductTypeID INT
DECLARE @StartDate DATETIME
DECLARE @EffDate DATETIME
DECLARE @Term INT
DECLARE @PriceTier INT
DECLARE @ServiceClassID INT
DECLARE @ZoneID INT
SELECT @ChannelID = ChannelID, @ChannelGroupID = ChannelGroupID, @ChannelTypeID = ChannelTypeID, @MarketID = MarketID,
@UtilityID = UtilityID, @SegmentID = SegmentID, @ProductTypeID = ProductTypeID, @StartDate = StartDate, @EffDate = CostRateEffectiveDate,
@Term = Term, @PriceTier = PriceTier, @ServiceClassID = ServiceClassID, @ZoneID = ZoneID
FROM Libertypower.dbo.Price WITH (NOLOCK)
WHERE ID = @PriceID
------------------------------------------------------------------------------
---- Create a small Markup table with just the data we need.
------------------------------------------------------------------------------
DECLARE @MarkupRuleSetID INT
SELECT @MarkupRuleSetID = max(ProductMarkupRuleSetID)
FROM LibertyPower.dbo.ProductMarkupRuleSet m with (nolock)
WHERE EffectiveDate < @EffDate
SELECT *
INTO #Markup
FROM LibertyPower.dbo.ProductMarkupRule with (nolock)
WHERE ProductMarkupRuleSetID = @MarkupRuleSetID
AND ChannelGroupID = @ChannelGroupID
AND ChannelTypeID = @ChannelTypeID
AND MarketID = @MarketID
AND UtilityID = @UtilityID
AND SegmentID = @SegmentID
AND ProductTypeID = @ProductTypeID
AND PriceTier = @PriceTier
AND ServiceClassID = @ServiceClassID
AND ZoneID = @ZoneID
------------------------------------------------------------------------------
---- Create a small Cost table with just the data we need.
------------------------------------------------------------------------------
DECLARE @CostRuleSetID INT
SELECT @CostRuleSetID = max(ProductCostRuleSetID)
FROM LibertyPower.dbo.ProductCostRuleSet with (nolock)
WHERE EffectiveDate < @EffDate
SELECT *
INTO #Cost
FROM LibertyPower.dbo.ProductCostRule with (nolock)
WHERE ProductCostRuleSetID = @CostRuleSetID
AND MarketID = @MarketID
AND UtilityID = @UtilityID
AND Term = @Term
AND StartDate = @StartDate
AND ProductTypeID = @ProductTypeID
AND PriceTier = @PriceTier
AND ServiceClassID = @ServiceClassID
AND ZoneID = @ZoneID
------------------------------------------------------------------------------
---- Create a small Setup table with just the data we need.
------------------------------------------------------------------------------
DECLARE @SetupSetID INT
SELECT @SetupSetID = max(ProductCostRuleSetupSetID)
FROM LibertyPower.dbo.ProductCostRuleSetupSet with (nolock)
WHERE UploadedDate < @EffDate
SELECT *
INTO #Setup
FROM LibertyPower.dbo.ProductCostRuleSetup with (nolock)
WHERE ProductCostRuleSetupSetID = @SetupSetID
AND Market = @MarketID
AND Utility = @UtilityID
AND Segment = @SegmentID
AND ProductType = @ProductTypeID
AND PriceTier = @PriceTier
AND ServiceClass = @ServiceClassID
AND Zone = @ZoneID
------------------------------------------------------------------------------
---- This query will contain a recreation of the Price values.
------------------------------------------------------------------------------
SELECT ProductCostRuleID, ProductMarkupRuleID, c.Rate as CostRate, m.Rate as MarkupRate , s.PorRate, s.GrtRate, s.SutRate
FROM #Markup m 
JOIN #Cost c  ON m.ServiceClassID = c.ServiceClassID
AND m.ZoneID = c.ZoneID
AND m.PriceTier = c.PriceTier
AND c.Term BETWEEN m.MinTerm AND m.MaxTerm
JOIN #Setup s ON m.ServiceClassID = s.ServiceClass
AND m.ZoneID = s.Zone
AND m.PriceTier = s.PriceTier
END
GO


