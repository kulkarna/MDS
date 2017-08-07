



-- =============================================
-- Author:		Rick Deigsler
-- Create date: 6/3/2008
-- Description:	Get EDI usage for accounts awaiting usage, if available.
--				This sproc will be called from EDI file parser app.
-- =============================================
CREATE PROCEDURE [dbo].[usp_edi_usage_sel]

@p_import_date	datetime

AS

SET NOCOUNT ON

DECLARE	@w_offer_id					varchar(50),	@w_utility_id				varchar(50),
		@w_account_number			varchar(50),	@w_customer_name			varchar(255),
		@w_service_address			varchar(255),	@w_service_city				varchar(50),
		@w_service_state			char(2),		@w_zip_code					varchar(25),
		@w_rate_code				varchar(50),	@w_process					varchar(25),
		@w_load_profile				varchar(10),	@w_icap						numeric(12,6),
		@w_tcap						numeric(12,6),	@w_bill_group				int,
		@w_end_billing_period		varchar(50),	@w_total_kwh				int,
		@w_supply_group				varchar(255),	@w_meter_number				varchar(50),
		@w_on_peak_kwh				float,			@w_off_peak_kwh				float,
		@w_billing_demand_kw		float,			@w_monthly_peak_demand_kw	float,
		@w_current_charges			float,			@w_stratum_variable			varchar(50),
		@w_zone						varchar(50),	@w_service_class			varchar(20),
		@w_deal_id					varchar(50),	@w_load_shape_id			varchar(50),
		@w_voltage					varchar(50),	@w_total_days				int, 
		@w_from_date				datetime,		@w_to_date					datetime,
		@w_usage_id					int,			@w_usage_complete			smallint,
		@w_status					varchar(50),	@w_usage_count				int,
		@w_annual_usage				int,			@w_total_usage				float,
		@w_rec_count				int,			@w_losses					decimal(18,9)
		

BEGIN TRY
	-- process type
	SET			@w_process	= 'PROSPECTS'
	-- status of offer when all usage exists
	SET			@w_status	= 'Usage Complete'

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('before insert ProspectDeals', 0, '')

	-- insert into ProspectDeals
	INSERT INTO	lp_historical_info..ProspectDeals
	SELECT		UPPER(a.UTILITY), a.ACCOUNT_NUMBER, c.OFFER_ID, REPLACE(hdr.CustomerName, '''', ''), hdr.ServiceZipCode, 
				'2', GETDATE(), 'Offer Engine', NULL, NULL, NULL
	FROM		OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
				INNER JOIN OE_OFFER c WITH (NOLOCK) ON b.OFFER_ID = c.OFFER_ID
				INNER JOIN lp_common..common_utility d WITH (NOLOCK) ON a.UTILITY = d.utility_id
				INNER JOIN lp_historical_info..UsageExtractHeader hdr WITH (NOLOCK) ON a.ACCOUNT_NUMBER = hdr.AccountNumber
	WHERE		a.ACCOUNT_NUMBER IN (SELECT AccountNumber FROM lp_historical_info..UsageExtractHeader WITH (NOLOCK) WHERE DateModified >= @p_import_date)
	AND			a.ACCOUNT_NUMBER NOT IN (	SELECT	AccountNumber
											FROM	lp_historical_info..ProspectDeals WITH (NOLOCK)
											WHERE	DealID = c.OFFER_ID )

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after insert ProspectDeals', 0, '')

	-- update existing records in ProspectAccounts
	UPDATE	lp_historical_info..ProspectAccounts
	SET		CustomerName	= CASE WHEN LEN(z.CustomerName) > 0			THEN z.CustomerName			ELSE a2.CustomerName	END, 
			ServiceAddress	= CASE WHEN LEN(z.ServiceAddress) > 0		THEN z.ServiceAddress		ELSE a2.ServiceAddress	END, 
			ZipCode			= CASE WHEN LEN(z.ServiceZipCode) > 0		THEN z.ServiceZipCode		ELSE a2.ZipCode			END, 
			LoadShapeID		= CASE WHEN LEN(z.LoadShapeID) > 0			THEN z.LoadShapeID			ELSE a2.LoadShapeID		END, 
			Zone			= CASE WHEN LEN(z.ZONE) > 0					THEN z.ZONE					ELSE a2.Zone			END, 
			RateClass		= CASE WHEN LEN(z.RateClass) > 0			THEN z.RateClass			ELSE a2.RateClass		END, 
			StratumVariable	= CASE WHEN LEN(z.StratumVariable) > 0		THEN z.StratumVariable		ELSE a2.StratumVariable	END, 
			ICAP			= CASE WHEN LEN(z.InstalledCapacity) > 0	THEN z.InstalledCapacity	ELSE a2.ICAP			END, 
			TCAP			= CASE WHEN LEN(z.TransmissionCapacity) > 0	THEN z.TransmissionCapacity	ELSE a2.TCAP			END, 
			TotalKWH		= CASE WHEN LEN(z.TotalUsageKWh) > 0		THEN z.TotalUsageKWh		ELSE a2.TotalKWH		END, 
			TotalDays		= CASE WHEN LEN(z.TotalDays) > 0			THEN z.TotalDays			ELSE a2.TotalDays		END, 
			Modified		= GETDATE(),
			ModifiedBy		= 'Offer Engine'
	FROM	lp_historical_info..ProspectAccounts a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	a.UTILITY, CASE WHEN LEN(hdr.CongestionZone) > 0 THEN hdr.CongestionZone ELSE a.ZONE END AS ZONE, o.OFFER_ID, o.ACCOUNT_NUMBER, REPLACE(hdr.CustomerName, '''', '') AS CustomerName, LEFT(LTRIM(RTRIM(ISNULL(REPLACE(hdr.ServiceAddress, '''', ''), '') + ' ' + ISNULL(hdr.ServiceCity, '') + ' ' + ISNULL(hdr.ServiceState, '') + ' ' + ISNULL(hdr.ServiceZipCode, ''))), 255) AS ServiceAddress, hdr.ServiceZipCode, 
				CASE WHEN a.UTILITY = 'DELDE' THEN
					(SELECT ISNULL(load_shape_id, hdr.LoadShapeID) FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND hdr.LoadShapeID = m.load_shape_id_from_edi) 
				ELSE				
					CASE 
						WHEN (SELECT load_shape_id FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND hdr.RateClass = m.rate_class_from_edi) IS NOT NULL 
						THEN (SELECT load_shape_id FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND hdr.RateClass = m.rate_class_from_edi) 
						WHEN a.UTILITY = 'PSEG' 
						THEN hdr.RateClass 
						ELSE hdr.LoadShapeID 
					END 
				END
				AS LoadShapeID, 
				hdr.RateClass, hdr.StratumVariable, CAST(hdr.InstalledCapacity AS numeric(12,6)) AS InstalledCapacity, CAST(hdr.TransmissionCapacity AS numeric(12,6)) AS TransmissionCapacity, DATEDIFF(dd, dtl.FromDate, dtl.ToDate) AS TotalDays, 
				CAST(dtl.OnPeakUsageKWh AS varchar(25)) AS OnPeakUsageKWh, CAST(dtl.OffPeakUsageKWh AS varchar(25)) AS OffPeakUsageKWh, dtl.TotalUsageKWh, CAST(dtl.BillingDemandKW AS float) AS BillingDemandKW	
		FROM	lp_historical_info..UsageExtractHeader hdr WITH (NOLOCK) 
				INNER JOIN lp_historical_info..UsageExtractDetail dtl WITH (NOLOCK) ON hdr.ID = dtl.HeaderID
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON hdr.AccountNumber = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
		WHERE	a.ACCOUNT_NUMBER IN (SELECT AccountNumber FROM lp_historical_info..UsageExtractHeader WITH (NOLOCK) WHERE DateModified >= cast('6/6/08' as datetime))
		AND		a.ACCOUNT_NUMBER IN (	SELECT	AccountNumber
										FROM	lp_historical_info..ProspectAccounts WITH (NOLOCK)
										WHERE	[Deal ID]	= o.OFFER_ID
										AND		Utility		= a.UTILITY )
	) z
	ON	a2.Utility			= z.Utility
	AND	a2.[Deal ID]		= z.OFFER_ID
	AND	a2.AccountNumber	= z.ACCOUNT_NUMBER

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after update ProspectAccounts', 0, '')

	-- insert new records into ProspectAccounts
	INSERT INTO	lp_historical_info..ProspectAccounts
	SELECT		UPPER(a.UTILITY), REPLACE(hdr.CustomerName, '''', '') AS CustomerName, o.ACCOUNT_NUMBER, LEFT(LTRIM(RTRIM(ISNULL(REPLACE(hdr.ServiceAddress, '''', ''), '') + ' ' + ISNULL(hdr.ServiceCity, '') + ' ' + ISNULL(hdr.ServiceState, '') + ' ' + ISNULL(hdr.ServiceZipCode, ''))), 255) AS ServiceAddress, hdr.ServiceZipCode, 
				CASE WHEN a.UTILITY = 'DELDE' THEN
					(SELECT ISNULL(load_shape_id, hdr.LoadShapeID) FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND hdr.LoadShapeID = m.load_shape_id_from_edi) 
				ELSE				
					CASE 
						WHEN (SELECT load_shape_id FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND hdr.RateClass = m.rate_class_from_edi) IS NOT NULL 
						THEN (SELECT load_shape_id FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND hdr.RateClass = m.rate_class_from_edi) 
						WHEN a.UTILITY = 'PSEG' 
						THEN hdr.RateClass 
						ELSE hdr.LoadShapeID 
					END
				END 
				AS LoadShapeID, 
				hdr.RateClass, NULL, NULL, hdr.StratumVariable, CAST(hdr.InstalledCapacity AS numeric(12,6)), CAST(hdr.TransmissionCapacity AS numeric(12,6)), NULL, NULL, NULL, 
				CASE WHEN LEN(hdr.CongestionZone) > 0 THEN hdr.CongestionZone ELSE a.ZONE END AS ZONE, NULL, NULL,
				NULL, dtl2.TotalUsageKWh,  dtl2.TotalDays, o.OFFER_ID, GETDATE(), 'Offer Engine', NULL, NULL, NULL, NULL,
				NULL, NULL, CAST(dtl2.OnPeakUsageKWh AS varchar(25)), CAST(dtl2.OffPeakUsageKWh AS varchar(25)), 
				CAST(dtl2.BillingDemandKW AS float), CAST(dtl2.BillingDemandKW AS float), NULL, NULL, 1
	FROM		lp_historical_info..UsageExtractHeader hdr WITH (NOLOCK) 
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON hdr.AccountNumber = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
				INNER JOIN (SELECT		HeaderID, SUM(DATEDIFF(dd, FromDate, ToDate)) AS TotalDays, 
										SUM(TotalUsageKWh) AS TotalUsageKWh, SUM(OnPeakUsageKWh) AS OnPeakUsageKWh,
										SUM(OffPeakUsageKWh) AS OffPeakUsageKWh, SUM(BillingDemandKW) AS BillingDemandKW
							FROM		lp_historical_info..UsageExtractDetail WITH (NOLOCK)
							GROUP BY	HeaderID ) dtl2 ON hdr.ID = dtl2.HeaderID
	WHERE		a.ACCOUNT_NUMBER IN (SELECT AccountNumber FROM lp_historical_info..UsageExtractHeader WITH (NOLOCK) WHERE DateModified >= @p_import_date)
	AND			a.ACCOUNT_NUMBER NOT IN (	SELECT	AccountNumber
											FROM	lp_historical_info..ProspectAccounts WITH (NOLOCK)
											WHERE	[Deal ID]	= o.OFFER_ID
											AND		Utility		= a.UTILITY )

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after insert ProspectAccounts', 0, '')

	-- delete duplicate records from ProspectAccountBillingInfo
	DELETE 
	FROM	lp_historical_info..ProspectAccountBillingInfo 
	FROM	lp_historical_info..ProspectAccountBillingInfo a2 INNER JOIN
	(
		SELECT	a.UTILITY, o.ACCOUNT_NUMBER, dtl.FromDate, dtl.ToDate, o.OFFER_ID
		FROM	lp_historical_info..UsageExtractHeader hdr WITH (NOLOCK) 
				INNER JOIN lp_historical_info..UsageExtractDetail dtl WITH (NOLOCK) ON hdr.ID = dtl.HeaderID
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON hdr.AccountNumber = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
		WHERE	a.ACCOUNT_NUMBER IN (SELECT AccountNumber FROM lp_historical_info..UsageExtractHeader WITH (NOLOCK) WHERE DateModified >= @p_import_date)
	) z
	ON	a2.Utility			= z.Utility
	AND	a2.AccountNumber	= z.ACCOUNT_NUMBER
	AND	a2.FromDate			= z.FromDate
	AND	a2.ToDate			= z.ToDate

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after delete ProspectAccountBillingInfo', 0, '')

	-- insert meter reads into ProspectAccountBillingInfo
	INSERT INTO	lp_historical_info..ProspectAccountBillingInfo
	SELECT		o.ACCOUNT_NUMBER, UPPER(a.UTILITY), dtl.FromDate, dtl.ToDate, ISNULL(dtl.TotalUsageKWh, 0), DATEDIFF(dd, dtl.FromDate, dtl.ToDate), 
				GETDATE(), 'Offer Engine', NULL, NULL, NULL, CAST(dtl.OnPeakUsageKWh AS varchar(25)), CAST(dtl.OffPeakUsageKWh AS varchar(25)),
				CAST(dtl.BillingDemandKW AS float), CAST(dtl.BillingDemandKW AS float), NULL, NULL
	FROM		lp_historical_info..UsageExtractHeader hdr WITH (NOLOCK) 
				INNER JOIN lp_historical_info..UsageExtractDetail dtl WITH (NOLOCK) ON hdr.ID = dtl.HeaderID
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON hdr.AccountNumber = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE		a.ACCOUNT_NUMBER IN (SELECT AccountNumber FROM lp_historical_info..UsageExtractHeader WITH (NOLOCK) WHERE DateModified >= @p_import_date)

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after insert ProspectAccountBillingInfo', 0, '')

	-- update ProspectDeals status
	UPDATE	lp_historical_info..ProspectDeals
	SET		Status = '1'
	FROM	lp_historical_info..ProspectDeals a2 INNER JOIN
	(
		SELECT	a.UTILITY, a.ACCOUNT_NUMBER, c.OFFER_ID
		FROM	OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
				INNER JOIN OE_OFFER c WITH (NOLOCK) ON b.OFFER_ID = c.OFFER_ID
				INNER JOIN lp_common..common_utility d WITH (NOLOCK) ON a.UTILITY = d.utility_id
				INNER JOIN lp_historical_info..UsageExtractHeader hdr WITH (NOLOCK) ON a.ACCOUNT_NUMBER = hdr.AccountNumber
		WHERE	a.ACCOUNT_NUMBER IN (SELECT AccountNumber FROM lp_historical_info..UsageExtractHeader WITH (NOLOCK) WHERE DateModified >= @p_import_date)
		AND		a.ACCOUNT_NUMBER IN (	SELECT	AccountNumber
										FROM	lp_historical_info..ProspectDeals WITH (NOLOCK)
										WHERE	DealID = c.OFFER_ID )
	) z
	ON	a2.Utility			= z.Utility
	AND	a2.DealID			= z.OFFER_ID
	AND	a2.AccountNumber	= z.ACCOUNT_NUMBER
	AND a2.Status = '2'

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after update status ProspectDeals', 0, '')

-- begin update usage and status of offer(s) in OE
	CREATE TABLE #USAGE	(ID int IDENTITY(1,1) NOT NULL, offer_id varchar(50), account_number varchar(50), utility_id varchar(50))

	INSERT INTO	#USAGE
	SELECT		DISTINCT c.OFFER_ID, a.ACCOUNT_NUMBER, UPPER(a.UTILITY)
	FROM		OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
				INNER JOIN OE_OFFER c WITH (NOLOCK) ON b.OFFER_ID = c.OFFER_ID
				INNER JOIN lp_common..common_utility d WITH (NOLOCK) ON a.UTILITY = d.utility_id
				INNER JOIN lp_historical_info..UsageExtractHeader hdr WITH (NOLOCK) ON a.ACCOUNT_NUMBER = hdr.AccountNumber
	WHERE		a.ACCOUNT_NUMBER IN (SELECT AccountNumber FROM lp_historical_info..UsageExtractHeader WITH (NOLOCK) WHERE DateModified >= @p_import_date)

	SELECT TOP 1	@w_usage_id = ID, @w_offer_id = offer_id, @w_account_number = account_number, @w_utility_id = UPPER(utility_id)
	FROM			#USAGE

	SET				@w_usage_count	= @@ROWCOUNT

	WHILE (@w_usage_count > 0) -- begin loop
		BEGIN 
			-- update usage from lp_historical_info
			EXEC	usp_usage_from_lp_historical_info_upd @w_offer_id, @w_utility_id, @w_account_number

			-- check if all usage for offer exists
			EXEC	@w_usage_complete = usp_check_usage_complete_for_offer @w_offer_id

			-- if all usage for offer exists, then update status of offer
			IF @w_usage_complete = 0
				EXEC usp_offer_status_upd @w_offer_id, @w_status

			-- begin aggregation of icap, tcap, losses  -------------------------------------
			-- no usage
			IF EXISTS (	SELECT	NULL
						FROM	OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) on a.id = b.oe_account_id
						WHERE	b.offer_id = @w_offer_id AND ANNUAL_USAGE = 0 )
				BEGIN
					SELECT		@w_utility_id = UPPER(utility), @w_zone = zone, @w_icap = SUM(ICAP), @w_tcap = SUM(TCAP), @w_losses = 0
					FROM		(	SELECT	ac.utility, ac.zone, ac.voltage, ac.ICAP, ac.TCAP, ac.Losses, ac.annual_usage, sap.offer_id 
									FROM	oe_account ac WITH (NOLOCK) INNER JOIN (	SELECT	oa.ACCOUNT_NUMBER, oa.offer_id 
																						FROM	oe_offer_accounts oa WITH (NOLOCK) INNER JOIN
																								OE_PRICING_REQUEST_OFFER pra WITH (NOLOCK) ON oa.offer_id = pra.offer_id) 
								sap ON ac.ACCOUNT_NUMBER = sap.ACCOUNT_NUMBER) sep
					WHERE		offer_id = @w_offer_id
					GROUP BY	offer_id, utility, zone
				END
			ELSE
				BEGIN
					SELECT		@w_utility_id = UPPER(utility), @w_zone = zone, @w_icap = SUM(CASE WHEN ICAP = -1 THEN -1 ELSE ICAP END), @w_tcap = SUM(TCAP), @w_losses = SUM(Losses * Annual_Usage) / SUM(Annual_Usage)
					FROM		(	SELECT	ac.utility, ac.zone, ac.voltage, ac.ICAP, ac.TCAP, ac.Losses, ac.annual_usage, sap.offer_id 
									FROM	oe_account ac WITH (NOLOCK) INNER JOIN (	SELECT	oa.ACCOUNT_NUMBER, oa.offer_id 
																						FROM	oe_offer_accounts oa WITH (NOLOCK) INNER JOIN
																								OE_PRICING_REQUEST_OFFER pra WITH (NOLOCK) ON oa.offer_id = pra.offer_id) 
								sap ON ac.ACCOUNT_NUMBER = sap.ACCOUNT_NUMBER) sep
					WHERE		offer_id = @w_offer_id
					GROUP BY	offer_id, utility, zone
				END

			EXEC usp_aggregates_by_offer_id_ins @w_offer_id, @w_utility_id, @w_zone, @w_icap, @w_tcap, @w_losses, 1
			-- end aggregation of icap, tcap, losses  ---------------------------------------

			DELETE FROM	#USAGE
			WHERE		ID = @w_usage_id

			SELECT TOP 1	@w_usage_id = ID, @w_offer_id = offer_id, @w_account_number = account_number, @w_utility_id = UPPER(utility_id)
			FROM			#USAGE

			SET	@w_usage_count = @@ROWCOUNT

--SELECT @w_rec_count = COUNT(ID) FROM #USAGE
--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('loop', @w_rec_count ,'')

		END -- end loop

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('before select OE update', 0, '')

--			-- update usage in OE
--			SELECT		@w_icap = a.ICAP, @w_tcap = a.TCAP, @w_service_class = a.RateClass, @w_load_shape_id = a.LoadShapeID,
--						@w_total_usage	= SUM(b.Total_kWh), @w_total_days = SUM(b.DaysUsed)
--			FROM		lp_historical_info..ProspectAccounts a WITH (NOLOCK)
--						INNER JOIN lp_historical_info..ProspectAccountBillingInfo b WITH (NOLOCK) ON a.AccountNumber = b.AccountNumber
--			WHERE		b.AccountNumber = @w_account_number AND b.Utility = @w_utility_id
--			GROUP BY	a.ICAP, a.TCAP, a.RateClass, a.LoadShapeID
--
--			SET		@w_annual_usage = CAST((@w_total_usage * CAST(365 AS float) / CAST(@w_total_days AS float)) AS int)


			UPDATE	OE_ACCOUNT
			SET		ANNUAL_USAGE	= z.AnnualUsage, 
					USAGE_DATE		= z.UsageDate,
					ZONE			= CASE WHEN LEN(z.CongestionZone) > 0		THEN z.CongestionZone		ELSE a2.ZONE END, 
					ICAP			= CASE WHEN LEN(z.InstalledCapacity) > 0	THEN z.InstalledCapacity	ELSE a2.ICAP END, 
					TCAP			= CASE WHEN LEN(z.TransmissionCapacity) > 0	THEN z.TransmissionCapacity	ELSE a2.TCAP END,
					RATE_CLASS		= CASE WHEN LEN(z.RateClass) > 0			THEN z.RateClass			ELSE a2.RATE_CLASS END,
					LOAD_SHAPE_ID	= CASE WHEN LEN(z.LoadShapeID) > 0			THEN z.LoadShapeID			ELSE a2.LOAD_SHAPE_ID END
			FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
			(SELECT	a.UTILITY, o.ACCOUNT_NUMBER, 
					CASE WHEN a.UTILITY = 'DELDE' THEN
						(SELECT ISNULL(load_shape_id, hdr.LoadShapeID) FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND hdr.LoadShapeID = m.load_shape_id_from_edi) 
					ELSE					
						CASE 
							WHEN (SELECT load_shape_id FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND hdr.RateClass = m.rate_class_from_edi) IS NOT NULL 
							THEN (SELECT load_shape_id FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND hdr.RateClass = m.rate_class_from_edi) 
							WHEN a.UTILITY = 'PSEG' 
							THEN hdr.RateClass 
							ELSE hdr.LoadShapeID 
						END 
					END
					AS LoadShapeID, hdr.CongestionZone, hdr.RateClass, dtl2.AnnualUsage, dtl2.UsageDate, 
					CAST(hdr.InstalledCapacity AS numeric(12,6)) AS InstalledCapacity, 
					CAST(hdr.TransmissionCapacity AS numeric(12,6)) AS TransmissionCapacity
			FROM	lp_historical_info..UsageExtractHeader hdr WITH (NOLOCK) 
					INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON hdr.AccountNumber = a.ACCOUNT_NUMBER
					INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
					INNER JOIN (SELECT		HeaderID, CAST((SUM(TotalUsageKWh) * CAST(365 AS float) / CAST(SUM(DATEDIFF(dd, FromDate, ToDate)) AS float)) AS int) AS AnnualUsage, MAX(ToDate) AS UsageDate
								FROM		lp_historical_info..UsageExtractDetail WITH (NOLOCK)
								GROUP BY	HeaderID ) dtl2 ON hdr.ID = dtl2.HeaderID
			WHERE	a.ACCOUNT_NUMBER IN (SELECT AccountNumber FROM lp_historical_info..UsageExtractHeader WITH (NOLOCK) WHERE DateModified >= @p_import_date)) z ON a2.ACCOUNT_NUMBER = z.ACCOUNT_NUMBER

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after update OE', 0, '')

	DROP TABLE #USAGE
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage nvarchar(4000),
			@ErrorSeverity int,
			@ErrorState int

    SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()

	EXEC	usp_error_ins 'NONE', 'NONE', 'NONE', 'NONE', @ErrorMessage, 'NONE', 'NONE'
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
END CATCH















