

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/14/2008
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ista_usage_ins]

@p_account_number		varchar(50)

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

	CREATE TABLE #ACCOUNTS (account_number varchar(50), start_date datetime, end_date datetime, 
							total_kwh decimal(18, 4), rate_class varchar(20), meter_number varchar(50),
							icap numeric(12, 6), tcap numeric(12, 6))

	INSERT INTO	#ACCOUNTS
	SELECT		AccountNumber, ServicePeriodStart, ServicePeriodEnd, SUM(CAST(Quantity AS int)) AS Quantity, 
				RateClass, MeterNumber, ICAP, TCAP
	FROM		ISTA..Usage WITH (NOLOCK)
	WHERE		AccountNumber = @p_account_number
	GROUP BY	AccountNumber, TdspDuns, ServicePeriodStart, ServicePeriodEnd, MeterNumber, RateClass, ICAP, TCAP

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('before insert ProspectDeals', 0, '')

	-- insert into ProspectDeals
	INSERT INTO	lp_historical_info..ProspectDeals
	SELECT		a.UTILITY, a.ACCOUNT_NUMBER, c.OFFER_ID, '', '', '2', GETDATE(), 'Offer Engine', NULL, NULL, NULL
	FROM		OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
				INNER JOIN OE_OFFER c WITH (NOLOCK) ON b.OFFER_ID = c.OFFER_ID
				INNER JOIN lp_common..common_utility d WITH (NOLOCK) ON a.UTILITY = d.utility_id
	WHERE		a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
	AND			a.ACCOUNT_NUMBER NOT IN (	SELECT	AccountNumber
											FROM	lp_historical_info..ProspectDeals WITH (NOLOCK)
											WHERE	DealID = c.OFFER_ID )

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after insert ProspectDeals', 0, '')

	-- update existing records in ProspectAccounts
	UPDATE	lp_historical_info..ProspectAccounts
	SET		RateClass		= CASE WHEN LEN(z.rate_class) > 0	THEN z.rate_class	ELSE a2.RateClass	END, 
			TotalKWH		= CASE WHEN LEN(z.total_kwh) > 0	THEN z.total_kwh	ELSE a2.TotalKWH	END, 
			TotalDays		= CASE WHEN LEN(z.TotalDays) > 0	THEN z.TotalDays	ELSE a2.TotalDays	END, 
			ICAP			= CASE WHEN z.icap > 0				THEN z.icap			WHEN a2.ICAP IS NULL THEN z.icap	ELSE a2.ICAP		END, 
			TCAP			= CASE WHEN z.tcap > 0				THEN z.tcap			WHEN a2.TCAP IS NULL THEN z.tcap	ELSE a2.TCAP		END, 
			LoadShapeID		= CASE WHEN z.UTILITY = 'PSEG'		THEN ISNULL(z.rate_class, LoadShapeID)					ELSE LoadShapeID	END, 
			Modified		= GETDATE(),
			ModifiedBy		= 'Offer Engine'
	FROM	lp_historical_info..ProspectAccounts a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	a.UTILITY, o.OFFER_ID, o.ACCOUNT_NUMBER, 
				ISNULL((	SELECT	TOP 1 rate_class_lpc 
							FROM	lp_historical_info..UtilityEDIMapping WITH (NOLOCK)
							WHERE	utility_id = a.UTILITY AND rate_class_from_edi = dtl.rate_class ), dtl.rate_class) AS rate_class, 
				DATEDIFF(dd, dtl.start_date, dtl.end_date) AS TotalDays, 
				dtl.total_kwh, dtl.icap, dtl.tcap
		FROM	#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
		WHERE	a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
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
	SELECT		a.UTILITY, '', o.ACCOUNT_NUMBER, '', '', '', dtl2.rate_class, NULL, NULL, '', dtl.icap, dtl.tcap, NULL, NULL, NULL, NULL, NULL, NULL,
				NULL, SUM(dtl.total_kwh),  SUM(DATEDIFF(dd, dtl.start_date, dtl.end_date)), o.OFFER_ID, GETDATE(), 'Offer Engine', NULL, NULL, NULL, NULL,
				NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1
	FROM		#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
				INNER JOIN (SELECT		account_number, MAX(acc.rate_class) AS rc, 
										ISNULL((	SELECT	TOP 1 m.rate_class_lpc 
													FROM	lp_historical_info..UtilityEDIMapping m WITH (NOLOCK)
															INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON m.utility_id = a.UTILITY
													WHERE	m.utility_id = a.UTILITY AND m.rate_class_from_edi = MAX(acc.rate_class) ), MAX(acc.rate_class)) AS rate_class
							FROM		#ACCOUNTS acc
							GROUP BY	account_number, end_date ) dtl2 ON dtl.account_number = dtl2.account_number
	WHERE		a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
	AND			a.ACCOUNT_NUMBER NOT IN (	SELECT	AccountNumber
											FROM	lp_historical_info..ProspectAccounts WITH (NOLOCK)
											WHERE	[Deal ID]	= o.OFFER_ID
											AND		Utility		= a.UTILITY )
	GROUP BY	a.UTILITY, o.ACCOUNT_NUMBER, o.OFFER_ID, dtl2.rate_class, dtl.icap, dtl.tcap

	-- update zone if null
	UPDATE	lp_historical_info..ProspectAccounts
	SET		Zone		= CASE WHEN LEN(z.Zone) > 0 THEN z.Zone ELSE a2.Zone END, 
			Modified	= GETDATE(),
			ModifiedBy	= 'Offer Engine'
	FROM	lp_historical_info..ProspectAccounts a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	a.UTILITY, o.OFFER_ID, o.ACCOUNT_NUMBER, x.zone_mat_price AS Zone
		FROM	#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
				INNER JOIN lp_historical_info..UtilityZoneXRef x WITH (NOLOCK) ON a.UTILITY = x.utility_id
		WHERE	a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
	) z
	ON	a2.Utility			= z.Utility
	AND	a2.[Deal ID]		= z.OFFER_ID
	AND	a2.AccountNumber	= z.ACCOUNT_NUMBER

	-- update load shape id and rate class for PEPCO
	UPDATE	lp_historical_info..ProspectAccounts
	SET		LoadShapeID	=	CASE WHEN a2.Zone IS NULL THEN 
								CASE WHEN LEN(z.LoadProfile) > 0 THEN z.LoadProfile	ELSE a2.Zone END 
							END, 
			RateClass	=	CASE WHEN a2.RateClass IS NULL THEN 
								CASE WHEN LEN(z.RateClass) > 0	THEN z.RateClass	ELSE a2.RateClass	END
							END,
			ModifiedBy	= 'Offer Engine'
	FROM	lp_historical_info..ProspectAccounts a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	s.esiid, m.LoadProfile, m.RateClass 
		FROM	ISTA..tbl_814_header h
				INNER JOIN ISTA..tbl_814_service s WITH (NOLOCK) ON s.[814_key] = h.[814_key]
				INNER JOIN ISTA..tbl_814_service s2 WITH (NOLOCK) ON s2.assignid = h.transactionnbr AND s2.esiid = s.esiid
				INNER JOIN ISTA..tbl_814_service_meter m WITH (NOLOCK) ON m.service_key = s2.service_key
		WHERE	s.esiid IN (	SELECT	DISTINCT AccountNumber
								FROM	lp_historical_info..ProspectAccounts WITH (NOLOCK) 
								WHERE	Utility LIKE 'PEPCO%'
								AND		(LoadShapeID IS NULL OR RateClass IS NULL)
		) 
		AND		h.actioncode = 'HU' AND h.direction = 0
		GROUP BY s.esiid, m.LoadProfile, m.RateClass
	) z
	ON	a2.AccountNumber	= z.esiid

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after insert ProspectAccounts', 0, '')

	-- delete duplicate records from ProspectAccountBillingInfo
	DELETE 
	FROM	lp_historical_info..ProspectAccountBillingInfo 
	FROM	lp_historical_info..ProspectAccountBillingInfo a2 INNER JOIN
	(
		SELECT	a.UTILITY, o.ACCOUNT_NUMBER, dtl.start_date, dtl.end_date, o.OFFER_ID
		FROM	#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
		WHERE	a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
	) z
	ON	a2.Utility			= z.Utility
	AND	a2.AccountNumber	= z.ACCOUNT_NUMBER
	AND	a2.FromDate			= z.start_date
	AND	a2.ToDate			= z.end_date

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after delete ProspectAccountBillingInfo', 0, '')

	-- insert meter reads into ProspectAccountBillingInfo
	INSERT INTO	lp_historical_info..ProspectAccountBillingInfo
	SELECT		o.ACCOUNT_NUMBER, a.UTILITY, dtl.start_date, dtl.end_date, ISNULL(dtl.total_kwh, 0), ISNULL(DATEDIFF(dd, dtl.start_date, dtl.end_date), 0), 
				GETDATE(), 'Offer Engine', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	FROM		#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE		a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
	GROUP BY	o.ACCOUNT_NUMBER, a.UTILITY, dtl.start_date, dtl.end_date, dtl.total_kwh

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after insert ProspectAccountBillingInfo', 0, '')

	-- update ProspectDeals status
	UPDATE	lp_historical_info..ProspectDeals
	SET		Status = '1'
	FROM	lp_historical_info..ProspectDeals a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	a.UTILITY, a.ACCOUNT_NUMBER, c.OFFER_ID
		FROM	OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
				INNER JOIN OE_OFFER c WITH (NOLOCK) ON b.OFFER_ID = c.OFFER_ID
				INNER JOIN lp_common..common_utility d WITH (NOLOCK) ON a.UTILITY = d.utility_id
		WHERE	a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
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
	SELECT		DISTINCT c.OFFER_ID, a.ACCOUNT_NUMBER, a.UTILITY
	FROM		OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
				INNER JOIN OE_OFFER c WITH (NOLOCK) ON b.OFFER_ID = c.OFFER_ID
				INNER JOIN lp_common..common_utility d WITH (NOLOCK) ON a.UTILITY = d.utility_id
	WHERE		a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)

	SELECT TOP 1	@w_usage_id = ID, @w_offer_id = offer_id, @w_account_number = account_number, @w_utility_id = utility_id
	FROM			#USAGE

	SET				@w_usage_count	= @@ROWCOUNT

	WHILE (@w_usage_count > 0) -- begin loop
		BEGIN 
			-- update usage from lp_historical_info
			EXEC	usp_usage_from_lp_historical_info_upd @w_offer_id, @w_utility_id, @w_account_number

			-- check if all usage for offer exists
			CREATE TABLE #tmp (complete smallint)
			INSERT INTO #tmp
			EXEC	@w_usage_complete = usp_check_usage_complete_for_offer @w_offer_id

			-- if all usage for offer exists, then update status of offer
			IF (SELECT * FROM #tmp) = 0
				EXEC usp_offer_status_upd @w_offer_id, @w_status

			DROP TABLE #tmp

			-- begin aggregation of icap, tcap, losses  -------------------------------------
			-- no usage
			IF EXISTS (	SELECT	NULL
						FROM	OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) on a.id = b.oe_account_id
						WHERE	b.offer_id = @w_offer_id AND ANNUAL_USAGE = 0 )
				BEGIN
					SELECT		@w_utility_id = utility, @w_zone = zone, @w_icap = SUM(ICAP), @w_tcap = SUM(TCAP), @w_losses = 0
					FROM		(	SELECT	ac.utility, ac.zone, ac.voltage, ac.ICAP, ac.TCAP, CASE WHEN ac.Losses IS NULL THEN 0 ELSE ac.Losses END AS Losses, ac.annual_usage, sap.offer_id 
									FROM	oe_account ac WITH (NOLOCK) INNER JOIN (	SELECT	oa.ACCOUNT_NUMBER, oa.offer_id 
																						FROM	oe_offer_accounts oa WITH (NOLOCK) INNER JOIN
																								OE_PRICING_REQUEST_OFFER pra WITH (NOLOCK) ON oa.offer_id = pra.offer_id) 
								sap ON ac.ACCOUNT_NUMBER = sap.ACCOUNT_NUMBER) sep
					WHERE		offer_id = @w_offer_id
					GROUP BY	offer_id, utility, zone
				END
			ELSE
				BEGIN
					SELECT		@w_utility_id = utility, @w_zone = zone, @w_icap = SUM(CASE WHEN ICAP = -1 THEN -1 ELSE ICAP END), @w_tcap = SUM(TCAP), @w_losses = SUM(Losses * Annual_Usage) / SUM(Annual_Usage)
					FROM		(	SELECT	ac.utility, ac.zone, ac.voltage, ac.ICAP, ac.TCAP, CASE WHEN ac.Losses IS NULL THEN 0 ELSE ac.Losses END AS Losses, ac.annual_usage, sap.offer_id 
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

			SELECT TOP 1	@w_usage_id = ID, @w_offer_id = offer_id, @w_account_number = account_number, @w_utility_id = utility_id
			FROM			#USAGE

			SET	@w_usage_count = @@ROWCOUNT

--SELECT @w_rec_count = COUNT(ID) FROM #USAGE
--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('loop', @w_rec_count ,'')

		END -- end loop

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('before select OE update', 0, '')

			UPDATE	OE_ACCOUNT
			SET		ANNUAL_USAGE	= z.AnnualUsage,
					USAGE_DATE		= z.UsageDate
			FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
			(SELECT		a.UTILITY, o.ACCOUNT_NUMBER, dtl2.AnnualUsage, dtl2.UsageDate
			FROM		#ACCOUNTS dtl
			INNER JOIN	OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
			INNER JOIN	OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
			INNER JOIN	(	SELECT		account_number, 
										CAST((SUM(total_kwh) * CAST(365 AS float) / CAST(SUM(DATEDIFF(dd, start_date, end_date)) AS float)) AS int) AS AnnualUsage,
										MAX(end_date) AS UsageDate
							FROM		#ACCOUNTS
							GROUP BY	account_number ) dtl2 ON dtl.account_number = dtl2.account_number
			WHERE	a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)) z ON a2.ACCOUNT_NUMBER = z.ACCOUNT_NUMBER

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after update OE', 0, '')

	DROP TABLE #ACCOUNTS
END TRY
BEGIN CATCH
    DECLARE		@ErrorMessage nvarchar(4000),
				@ErrorSeverity int,
				@ErrorState int

    SELECT		@ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()

	EXEC		usp_error_ins 'NONE', 'NONE', 'NONE', 'NONE', @ErrorMessage, 'NONE', 'NONE'
    RAISERROR	(@ErrorMessage, @ErrorSeverity, @ErrorState)
END CATCH


