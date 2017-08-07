-- =============================================
-- Author:		Rick Deigsler
-- Create date: 6/3/2008
-- Description:	Get ISTA usage for accounts awaiting usage, if available.
--				This sproc will be called from job daily.
-- =============================================
CREATE PROCEDURE [dbo].[usp_ista_usage_sel]

AS

SET NOCOUNT ON

DECLARE	@w_offer_id					varchar(50),	@w_utility_id				varchar(50),
		@w_account_number			varchar(50),	@w_customer_name			varchar(255),
		@w_service_address			varchar(255),	@w_service_city				varchar(50),
		@w_service_state			char(2),		@w_zip_code					varchar(25),
		@w_rate_code				varchar(50),	@w_process					varchar(25),
		@w_load_profile				varchar(10),	@w_icap						numeric(12,6),
		@w_tcap						numeric(12,6),	@w_bill_group				int,
		@w_end_billing_period		varchar(50),	@w_total_kwh				bigint,
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
		@w_annual_usage				bigint,			@w_total_usage				float,
		@w_rec_count				int,			@w_losses					decimal(18,9)
		

	-- process type
	SET			@w_process	= 'PROSPECTS'
	-- status of offer when all usage exists
	SET			@w_status	= 'Usage Complete'

	CREATE TABLE #METERREADS (account_number varchar(50), start_date datetime, end_date datetime, 
							  total_kwh bigint)

	CREATE TABLE #METERREADSTEMP (account_number varchar(50), start_date datetime, end_date datetime, 
							  total_kwh bigint)


	CREATE TABLE #ACCOUNTS (account_number varchar(50), start_date datetime, end_date datetime, 
							total_kwh bigint, rate_class varchar(20), meter_number varchar(50),
							icap numeric(12, 6), tcap numeric(12, 6), load_shape_id varchar(100), 
							zone varchar(100))

	CREATE TABLE #ACCOUNTSTOPROCESS (ACCOUNT_NUMBER varchar(50))
	
	-- only select accounts newer than 1 month so as to not create needless processing
	INSERT INTO	#ACCOUNTSTOPROCESS
	SELECT	DISTINCT a.ACCOUNT_NUMBER
	FROM	dbo.OE_ACCOUNT a WITH (NOLOCK) 
			INNER JOIN	dbo.OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
			INNER JOIN	dbo.OE_OFFER c WITH (NOLOCK) ON b.OFFER_ID = c.OFFER_ID
	WHERE	c.Status = 'Open' AND c.DATE_CREATED > DATEADD(mm, -1, GETDATE())

	INSERT INTO	#METERREADSTEMP	
	SELECT DISTINCT z.esiid, z.ServicePeriodStart, z.ServicePeriodEnd, SUM(z.Quantity)
	FROM
	(
		SELECT	DISTINCT h.esiid, d.ServicePeriodStart, d.ServicePeriodEnd, CAST(ROUND(CAST(q.Quantity AS decimal(18,6)), 0) AS bigint) AS Quantity
		FROM	ISTA..tbl_867_header h
				LEFT JOIN ISTA..tbl_867_nonintervaldetail d ON d.[867_key] = h.[867_key]
				LEFT JOIN ISTA..tbl_867_nonintervaldetail_qty q ON q.[nonintervaldetail_key] = d.[nonintervaldetail_key]
		WHERE	h.esiid IN (SELECT	ACCOUNT_NUMBER
							FROM	#ACCOUNTSTOPROCESS)
		AND		q.UOM = 'KH'
		AND		q.MeasurementSignificanceCode IN ('22', '46', '51')
		AND		d.ServicePeriodStart IS NOT NULL 
		AND		LEN(d.ServicePeriodStart) > 0
		AND		d.ServicePeriodEnd IS NOT NULL 
		AND		LEN(d.ServicePeriodEnd) > 0
--		AND		h.ProcessFlag > 0
		GROUP BY	h.esiid, d.ServicePeriodStart, d.ServicePeriodEnd, q.Quantity
	) z 
	GROUP BY z.esiid, z.ServicePeriodStart, z.ServicePeriodEnd

	INSERT INTO	#METERREADSTEMP	
	SELECT DISTINCT z.esiid, z.ServicePeriodStart, z.ServicePeriodEnd, SUM(z.Quantity)
	FROM
	(
		SELECT	DISTINCT h.esiid, d.ServicePeriodStart, d.ServicePeriodEnd, CAST(ROUND(CAST(q.Quantity AS decimal(18,6)), 0) AS bigint) AS Quantity
		FROM	ISTA..tbl_867_header h
				LEFT JOIN ISTA..tbl_867_nonintervaldetail d ON d.[867_key] = h.[867_key]
				LEFT JOIN ISTA..tbl_867_nonintervaldetail_qty q ON q.[nonintervaldetail_key] = d.[nonintervaldetail_key]
		WHERE	h.esiid IN (SELECT	ACCOUNT_NUMBER
							FROM	#ACCOUNTSTOPROCESS)
		AND		h.esiid NOT IN (SELECT DISTINCT account_number FROM #METERREADSTEMP)
		AND		q.UOM = 'KH'
		AND		q.MeasurementSignificanceCode IN ('41', '42', '43')
		AND		d.ServicePeriodStart IS NOT NULL 
		AND		LEN(d.ServicePeriodStart) > 0
		AND		d.ServicePeriodEnd IS NOT NULL 
		AND		LEN(d.ServicePeriodEnd) > 0
--		AND		h.ProcessFlag > 0
		GROUP BY	h.esiid, d.ServicePeriodStart, d.ServicePeriodEnd, q.Quantity
	) z 
	GROUP BY z.esiid, z.ServicePeriodStart, z.ServicePeriodEnd

	INSERT INTO	#METERREADSTEMP	
	SELECT DISTINCT z.esiid, z.ServicePeriodStart, z.ServicePeriodEnd, SUM(z.Quantity)
	FROM
	(
		SELECT	DISTINCT h.esiid, q.ServicePeriodStart, q.ServicePeriodEnd, CAST(ROUND(CAST(q.Quantity AS decimal(18,6)), 0) AS bigint) AS Quantity
		FROM	ISTA..tbl_867_header h
				LEFT JOIN ISTA..tbl_867_nonintervalsummary d ON d.[867_key] = h.[867_key]
				LEFT JOIN ISTA..tbl_867_nonintervalsummary_qty q ON q.[nonintervalsummary_key] = d.[nonintervalsummary_key]
		WHERE	h.esiid IN (SELECT	ACCOUNT_NUMBER
							FROM	#ACCOUNTSTOPROCESS)
		AND		h.esiid NOT IN (SELECT DISTINCT account_number FROM #METERREADSTEMP)
		AND		q.CompositeUOM = 'KH'
		AND		q.MeasurementSignificanceCode IN ('22', '46', '51')
		AND		q.ServicePeriodStart IS NOT NULL 
		AND		LEN(q.ServicePeriodStart) > 0
		AND		q.ServicePeriodEnd IS NOT NULL 
		AND		LEN(q.ServicePeriodEnd) > 0
--		AND		h.ProcessFlag > 0
		GROUP BY	h.esiid, q.ServicePeriodStart, q.ServicePeriodEnd, q.Quantity
	) z 
	GROUP BY z.esiid, z.ServicePeriodStart, z.ServicePeriodEnd

	INSERT INTO	#METERREADSTEMP	
	SELECT DISTINCT z.esiid, z.ServicePeriodStart, z.ServicePeriodEnd, SUM(z.Quantity)
	FROM
	(
		SELECT	DISTINCT h.esiid, q.ServicePeriodStart, q.ServicePeriodEnd, CAST(ROUND(CAST(q.Quantity AS decimal(18,6)), 0) AS bigint) AS Quantity
		FROM	ISTA..tbl_867_header h
				LEFT JOIN ISTA..tbl_867_nonintervalsummary d ON d.[867_key] = h.[867_key]
				LEFT JOIN ISTA..tbl_867_nonintervalsummary_qty q ON q.[nonintervalsummary_key] = d.[nonintervalsummary_key]
		WHERE	h.esiid IN (SELECT	ACCOUNT_NUMBER
							FROM	#ACCOUNTSTOPROCESS)
		AND		h.esiid NOT IN (SELECT DISTINCT account_number FROM #METERREADSTEMP)
		AND		q.CompositeUOM = 'KH'
		AND		q.MeasurementSignificanceCode IN ('41', '42', '43')
		AND		q.ServicePeriodStart IS NOT NULL 
		AND		LEN(q.ServicePeriodStart) > 0
		AND		q.ServicePeriodEnd IS NOT NULL 
		AND		LEN(q.ServicePeriodEnd) > 0
--		AND		h.ProcessFlag > 0
		GROUP BY	h.esiid, q.ServicePeriodStart, q.ServicePeriodEnd, q.Quantity
	) z 
	GROUP BY z.esiid, z.ServicePeriodStart, z.ServicePeriodEnd


	INSERT INTO	#METERREADS	
	SELECT		DISTINCT u.account_number, u.[start_date], u.end_date,  SUM(CAST(u.total_kwh AS float)) AS TotalKWH
	FROM
	(
		SELECT		account_number, [start_date], end_date, total_kwh
		FROM		#METERREADSTEMP
		GROUP BY	account_number, [start_date], end_date, total_kwh
	) u
	GROUP BY	u.account_number, u.[start_date], u.end_date, u.total_kwh


	INSERT INTO	#ACCOUNTS
	SELECT		a.esiid, a.ServiceStart, a.ServiceEnd, SUM(a.Quantity) AS Quantity, ISNULL(ISNULL(ISNULL(a.RateClass1, a.RateClass2), a.RateClass3), a.RateClass4), a.MeterNumber,
				a.ICAP, a.TCAP, a.LoadProfile, a.Zone
	FROM		(	SELECT	DISTINCT a.esiid,
							CONVERT(datetime, mr.start_date,101) AS ServiceStart,
							CONVERT(datetime, mr.end_date,101) AS ServiceEnd,
							CONVERT(float, mr.total_kwh) AS Quantity,
							c1.RateClass AS RateClass1, m.MeterNumber,  
							CONVERT(numeric(12,6), ISNULL(i.ICAP, 0)) AS ICAP, CONVERT(numeric(12,6), ISNULL(t.TCAP, 0), 0) AS TCAP, 
							c2.RateClass AS RateClass2, c3.RateClass AS RateClass3, lrc.LDCRateClass AS RateClass4, 
							lp.LoadProfile, ISNULL(sd.Zone, si.ServiceIndicator) AS Zone
					FROM	ISTA..tbl_867_Header a WITH (NOLOCK)  
							INNER JOIN #METERREADS mr ON a.esiid = mr.account_number
							LEFT JOIN ISTA..vw_ISTAICAP i WITH (NOLOCK) ON a.esiid = i.esiid
							LEFT JOIN ISTA..vw_ISTATCAP t WITH (NOLOCK) ON a.esiid = t.esiid
							LEFT JOIN ISTA..vw_ISTALDCRateClass lrc WITH (NOLOCK) ON a.esiid = lrc.esiid
							LEFT JOIN ISTA..vw_ISTALoadProfile lp WITH (NOLOCK) ON a.esiid = lp.esiid
							LEFT JOIN ISTA..vw_ISTAMeterNumber m WITH (NOLOCK) ON a.esiid = m.esiid
							LEFT JOIN ISTA..vw_ISTAServiceIndicator si WITH (NOLOCK) ON a.esiid = si.esiid 
							LEFT JOIN ISTA..vw_ISTARateClass1 c1 WITH (NOLOCK) ON a.esiid = c1.esiid	
							LEFT JOIN ISTA..vw_ISTARateClass2 c2 WITH (NOLOCK) ON a.esiid = c2.esiid
							LEFT JOIN ISTA..vw_ISTARateClass3 c3 WITH (NOLOCK) ON a.esiid = c3.esiid		
							LEFT JOIN ISTA..tblMarketFile f WITH (NOLOCK) ON f.MarketFileId = a.MarketFileId
							LEFT JOIN ISTA..tbl_867_scheduledeterminants sd ON sd.[867_key] = A.[867_key]
					WHERE	a.esiid IN ( SELECT DISTINCT account_number FROM #METERREADS )
					AND		mr.start_date IS NOT NULL 
					AND		LEN(mr.start_date) > 0
					AND		mr.end_date IS NOT NULL 
					AND		LEN(mr.end_date) > 0
					AND		((ISNUMERIC(i.ICAP) = 1) OR (i.ICAP IS NULL))
					AND		((ISNUMERIC(t.TCAP) = 1) OR (t.TCAP IS NULL))
					--AND		sd.Zone IS NOT NULL
--					AND		TransactionSetPurposeCode = '52'  omitted per Douglas to get either HU or Billed Usage
				) a
	GROUP BY	a.esiid, a.ServiceStart, a.ServiceEnd, a.MeterNumber, a.RateClass1, a.ICAP, a.TCAP, 
				a.RateClass1, a.RateClass2, a.RateClass3, a.RateClass4, a.LoadProfile, a.Zone
	ORDER BY	a.esiid, a.ServiceStart

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('before insert ProspectDeals', 0, '')

BEGIN TRY
	-- insert into ProspectDeals
	INSERT INTO	lp_historical_info..ProspectDeals
	SELECT		UPPER(a.UTILITY), a.ACCOUNT_NUMBER, c.OFFER_ID, '', '', '2', GETDATE(), 'Offer Engine', NULL, NULL, NULL
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
			LoadShapeID		= CASE WHEN z.UTILITY = 'PPL'		THEN z.rate_class	WHEN z.UTILITY = 'PSEG'		THEN ISNULL(z.rate_class, LoadShapeID) WHEN z.load_shape_id IS NOT NULL THEN z.load_shape_id ELSE LoadShapeID	END, 
			Zone			= ISNULL(z.zone, a2.ZONE),
			Modified		= GETDATE(),
			ModifiedBy		= 'Offer Engine'
	FROM	lp_historical_info..ProspectAccounts a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	a.UTILITY, o.OFFER_ID, o.ACCOUNT_NUMBER, 
				ISNULL((	SELECT	TOP 1 rate_class_lpc 
							FROM	lp_historical_info..UtilityEDIMapping WITH (NOLOCK)
							WHERE	utility_id = a.UTILITY AND rate_class_from_edi = dtl.rate_class ), dtl.rate_class) AS rate_class, 
				DATEDIFF(dd, dtl.start_date, dtl.end_date) AS TotalDays, 
				dtl.total_kwh, dtl.icap, dtl.tcap, 
				CASE WHEN a.UTILITY = 'DELDE' THEN 
					(	SELECT	TOP 1 ISNULL(MAX(m.load_shape_id), dtl.load_shape_id)
						FROM	lp_historical_info..UtilityEDIMapping m WITH (NOLOCK)
						WHERE	m.load_shape_id_from_edi = dtl.load_shape_id
						AND		m.utility_id = (SELECT TOP 1 Utility FROM lp_historical_info..ProspectAccounts WITH (NOLOCK) WHERE AccountNumber = dtl.account_number) 
					)
				ELSE
					CASE 
						WHEN (SELECT MAX(load_shape_id) FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND dtl.rate_class = m.rate_class_from_edi) IS NOT NULL 
						THEN (SELECT MAX(load_shape_id) FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND dtl.rate_class = m.rate_class_from_edi) 
						WHEN a.UTILITY = 'PSEG' 
						THEN dtl.rate_class
						ELSE dtl.load_shape_id
					END 
				END AS load_shape_id, 
				dtl.zone
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
		SELECT		UPPER(a.UTILITY), '', o.ACCOUNT_NUMBER, '', '', MAX(dtl2.load_shape_id) AS load_shape_id, MAX(dtl2.rate_class) AS rate_class, NULL, NULL, '', MAX(dtl.icap) AS icap, MAX(dtl.tcap) AS tcap, NULL, NULL, NULL, 
					dtl2.zone, 
					NULL, NULL,
					NULL, SUM(dtl.total_kwh),  SUM(DATEDIFF(dd, dtl.start_date, dtl.end_date)), o.OFFER_ID, GETDATE(), 'Offer Engine', NULL, NULL, NULL, NULL,
					NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1
		FROM		#ACCOUNTS dtl
					INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
					INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
					INNER JOIN (SELECT		DISTINCT acc.account_number, MAX(acc.rate_class) AS rc, 
											ISNULL((	SELECT	MAX(m.rate_class_lpc) 
														FROM	lp_historical_info..UtilityEDIMapping m WITH (NOLOCK)
																INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON m.utility_id = a.UTILITY
														WHERE	m.utility_id = a.UTILITY AND m.rate_class_from_edi = MAX(acc.rate_class) ), MAX(acc.rate_class)) AS rate_class, 
											CASE WHEN oa.UTILITY = 'DELDE' THEN 
												(	SELECT	TOP 1 ISNULL(MAX(m.load_shape_id), acc.load_shape_id)
													FROM	lp_historical_info..UtilityEDIMapping m WITH (NOLOCK)
													WHERE	m.load_shape_id_from_edi = acc.load_shape_id
													AND		m.utility_id = (SELECT TOP 1 Utility FROM lp_historical_info..ProspectAccounts WITH (NOLOCK) WHERE AccountNumber = acc.account_number) 
												)
											ELSE
												CASE 
													WHEN (SELECT MAX(load_shape_id) FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE oa.UTILITY = m.utility_id AND acc.rate_class = m.rate_class_from_edi) IS NOT NULL 
													THEN (SELECT MAX(load_shape_id) FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE oa.UTILITY = m.utility_id AND acc.rate_class = m.rate_class_from_edi) 
													WHEN oa.UTILITY = 'PSEG' 
													THEN acc.rate_class
													ELSE acc.load_shape_id
												END 
											END AS load_shape_id, 
											acc.zone
								FROM		#ACCOUNTS acc
											INNER JOIN OE_ACCOUNT oa WITH (NOLOCK) ON acc.account_number = oa.ACCOUNT_NUMBER
								GROUP BY	acc.account_number, end_date, acc.load_shape_id, acc.zone, oa.UTILITY, acc.rate_class ) dtl2 ON dtl.account_number = dtl2.account_number
		WHERE		a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
		AND			a.ACCOUNT_NUMBER NOT IN (	SELECT	AccountNumber
												FROM	lp_historical_info..ProspectAccounts WITH (NOLOCK)
												WHERE	[Deal ID]	= o.OFFER_ID
												AND		Utility		= a.UTILITY )
		GROUP BY	a.UTILITY, o.ACCOUNT_NUMBER, o.OFFER_ID, dtl2.rate_class, dtl.icap, dtl.tcap, dtl2.load_shape_id, dtl2.zone

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
	SELECT		o.ACCOUNT_NUMBER, UPPER(a.UTILITY), dtl.start_date, dtl.end_date, ISNULL(dtl.total_kwh, 0), ISNULL(DATEDIFF(dd, dtl.start_date, dtl.end_date), 0), 
				GETDATE(), 'Offer Engine', NULL, NULL, dtl.meter_number, NULL, NULL, NULL, NULL, NULL, NULL
	FROM		#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE		a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
	AND			dtl.start_date IS NOT NULL
	AND			dtl.end_date IS NOT NULL
	GROUP BY	o.ACCOUNT_NUMBER, a.UTILITY, dtl.start_date, dtl.end_date, dtl.total_kwh, dtl.meter_number

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
	
END TRY	
BEGIN CATCH
    DECLARE		@ErrorMessage nvarchar(4000),
				@ErrorSeverity int,
				@ErrorState int

    SELECT		@ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()

	EXEC		usp_error_ins 'NONE', 'NONE', 'NONE', 'NONE', @ErrorMessage, 'NONE', 'NONE'
    --RAISERROR	(@ErrorMessage, @ErrorSeverity, @ErrorState)
END CATCH

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after update status ProspectDeals', 0, '')


	-- update rate class, icap, tcap, load shape id, and zone
	UPDATE	OE_ACCOUNT
	SET		RATE_CLASS		= CASE WHEN LEN(z.rate_class) > 0	THEN z.rate_class	ELSE a2.RATE_CLASS	END, 
			ICAP			= CASE WHEN z.icap > 0				THEN z.icap			WHEN a2.ICAP IS NULL THEN z.icap	ELSE a2.ICAP		END, 
			TCAP			= CASE WHEN z.tcap > 0				THEN z.tcap			WHEN a2.TCAP IS NULL THEN z.tcap	ELSE a2.TCAP		END, 
			LOAD_SHAPE_ID	= CASE WHEN z.UTILITY = 'PSEG' OR z.UTILITY = 'PPL'		THEN ISNULL(z.rate_class, a2.LOAD_SHAPE_ID) WHEN z.load_shape_id IS NOT NULL THEN z.load_shape_id ELSE a2.LOAD_SHAPE_ID	END, 
			ZONE			= CASE WHEN a2.UTILITY = 'DUQ'		THEN 'DUQ'			ELSE ISNULL(z.zone, a2.ZONE) END
	FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	a.UTILITY, o.OFFER_ID, o.ACCOUNT_NUMBER, 
				ISNULL((	SELECT	TOP 1 rate_class_lpc 
							FROM	lp_historical_info..UtilityEDIMapping WITH (NOLOCK)
							WHERE	utility_id = a.UTILITY AND rate_class_from_edi = dtl.rate_class ), dtl.rate_class) AS rate_class, 
				DATEDIFF(dd, dtl.start_date, dtl.end_date) AS TotalDays, 
				dtl.total_kwh, dtl.icap, dtl.tcap, 
				CASE WHEN a.UTILITY = 'DELDE' THEN 
					(	SELECT	TOP 1 ISNULL(MAX(m.load_shape_id), dtl.load_shape_id)
						FROM	lp_historical_info..UtilityEDIMapping m WITH (NOLOCK)
						WHERE	m.load_shape_id_from_edi = dtl.load_shape_id
						AND		m.utility_id = (SELECT TOP 1 UTILITY FROM OE_ACCOUNT WITH (NOLOCK) WHERE ACCOUNT_NUMBER = dtl.account_number) 
					)
				ELSE
					CASE 
						WHEN (SELECT MAX(load_shape_id) FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND dtl.rate_class = m.rate_class_from_edi) IS NOT NULL 
						THEN (SELECT MAX(load_shape_id) FROM lp_historical_info..UtilityEDIMapping m WITH (NOLOCK) WHERE a.UTILITY = m.utility_id AND dtl.rate_class = m.rate_class_from_edi) 
						ELSE dtl.load_shape_id
					END 
				END AS load_shape_id, 
				dtl.zone
		FROM	#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
		WHERE	a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
	) z
	ON	a2.UTILITY			= z.Utility
	AND	a2.ACCOUNT_NUMBER	= z.ACCOUNT_NUMBER


	-- update zone if null
	UPDATE	OE_ACCOUNT
	SET		ZONE = CASE WHEN LEN(z.Zone) > 0 THEN z.Zone ELSE a2.ZONE END
	FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	a.UTILITY, o.OFFER_ID, o.ACCOUNT_NUMBER, x.zone_mat_price AS Zone
		FROM	#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
				INNER JOIN lp_historical_info..UtilityZoneXRef x WITH (NOLOCK) ON a.UTILITY = x.utility_id
		WHERE	a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
	) z
	ON	a2.UTILITY			= z.Utility
	AND	a2.ACCOUNT_NUMBER	= z.ACCOUNT_NUMBER


	-- update load shape id and rate class for PEPCO
	UPDATE	OE_ACCOUNT
	SET		LOAD_SHAPE_ID	=	CASE WHEN a2.ZONE IS NULL THEN 
								CASE WHEN LEN(z.LoadProfile) > 0 THEN z.LoadProfile	ELSE a2.ZONE END 
							END, 
			RATE_CLASS	=	CASE WHEN a2.RATE_CLASS IS NULL THEN 
								CASE WHEN LEN(z.RateClass) > 0	THEN z.RateClass	ELSE a2.RATE_CLASS	END
							END
	FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	s.esiid, m.LoadProfile, m.RateClass 
		FROM	ISTA..tbl_814_header h
				INNER JOIN ISTA..tbl_814_service s WITH (NOLOCK) ON s.[814_key] = h.[814_key]
				INNER JOIN ISTA..tbl_814_service s2 WITH (NOLOCK) ON s2.assignid = h.transactionnbr AND s2.esiid = s.esiid
				INNER JOIN ISTA..tbl_814_service_meter m WITH (NOLOCK) ON m.service_key = s2.service_key
		WHERE	s.esiid IN (	SELECT	DISTINCT ACCOUNT_NUMBER
								FROM	OE_ACCOUNT WITH (NOLOCK) 
								WHERE	UTILITY LIKE 'PEPCO%'
								AND		(LOAD_SHAPE_ID IS NULL OR RATE_CLASS IS NULL)
		) 
		AND		h.actioncode = 'HU' AND h.direction = 0
		GROUP BY s.esiid, m.LoadProfile, m.RateClass
	) z
	ON	a2.ACCOUNT_NUMBER	= z.esiid

	-- update zone to retail market id for these markets (CT, RI, ME)
	UPDATE	OE_ACCOUNT
	SET		ZONE = CASE WHEN LEN(z.Zone) > 0 THEN z.Zone ELSE a2.ZONE END
	FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	a.UTILITY, a.ACCOUNT_NUMBER, d.retail_mkt_id AS Zone
		FROM	#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN lp_common..common_utility d WITH (NOLOCK) ON a.UTILITY = d.utility_id
		WHERE	d.retail_mkt_id IN ('CT','RI','ME')
	) z
	ON	a2.UTILITY			= z.Utility
	AND	a2.ACCOUNT_NUMBER	= z.ACCOUNT_NUMBER
	
	-- begin update missing zones for Massachusetts  ----------------------------------------------
	CREATE TABLE #MAUTILITIES (UtilityCode varchar(50))
	
	INSERT INTO	#MAUTILITIES
	SELECT	DISTINCT utility_id
	FROM	lp_common..common_utility
	WHERE	retail_mkt_id = 'MA'
	
	-- update zone based on zip code cross reference
	UPDATE	OE_ACCOUNT
	SET		ZONE = CASE WHEN LEN(z.Zone) > 0 THEN z.Zone ELSE a2.ZONE END
	FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
	(	
		SELECT	a.ACCOUNT_NUMBER, x.Zone
		FROM	#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN OE_ACCOUNT_ADDRESS ad WITH (NOLOCK) ON ad.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
				INNER JOIN lp_historical_info..ZoneUtilityZipXRef x WITH (NOLOCK) ON x.Zip = ad.ZIP
				INNER JOIN #MAUTILITIES u ON a.UTILITY = u.UtilityCode
		WHERE	a.ZONE IS NULL OR LEN(a.ZONE) = 0
	)z
	ON	a2.ACCOUNT_NUMBER	= z.ACCOUNT_NUMBER		
	
	-- translate zone from lookup table
	UPDATE	OE_ACCOUNT
	SET		ZONE = CASE WHEN LEN(z.Zone) > 0 THEN z.Zone ELSE a2.ZONE END
	FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	a.UTILITY, a.ACCOUNT_NUMBER, x.CorrectZone AS Zone
		FROM	#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN lp_historical_info..ZoneXRef x WITH (NOLOCK) ON x.OrigZone = a.Zone
				INNER JOIN #MAUTILITIES u ON a.UTILITY = u.UtilityCode				
	) z
	ON	a2.UTILITY			= z.Utility
	AND	a2.ACCOUNT_NUMBER	= z.ACCOUNT_NUMBER	
	
	-- update zone based on defaults
	UPDATE	OE_ACCOUNT
	SET		ZONE = CASE WHEN LEN(z.Zone) > 0 THEN z.Zone ELSE a2.ZONE END
	FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
	(	
		SELECT	a.ACCOUNT_NUMBER, x.Zone
		FROM	#ACCOUNTS dtl
				INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
				INNER JOIN lp_historical_info..UtilityZoneXRef x WITH (NOLOCK) ON x.utility_id = a.UTILITY
				INNER JOIN #MAUTILITIES u ON a.UTILITY = u.UtilityCode
		WHERE	a.ZONE IS NULL OR LEN(a.ZONE) = 0
	)z
	ON	a2.ACCOUNT_NUMBER	= z.ACCOUNT_NUMBER		
	-- end update missing zones for Massachusetts  ------------------------------------------------


	-- begin update usage and status of offer(s) in OE
	CREATE TABLE #OFFERIDS	(OfferId varchar(50))
	CREATE TABLE #USAGE		(ID int IDENTITY(1,1) NOT NULL, offer_id varchar(50), account_number varchar(50), utility_id varchar(50))

	INSERT INTO	#OFFERIDS
	SELECT		DISTINCT c.OFFER_ID
	FROM		OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
				INNER JOIN OE_OFFER c WITH (NOLOCK) ON b.OFFER_ID = c.OFFER_ID
	WHERE		c.OFFER_ID > 'OF-07000'
	AND			c.Status = 'Open'
	AND			a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)
	
	INSERT INTO	#USAGE
	SELECT		DISTINCT c.OFFER_ID, a.ACCOUNT_NUMBER, UPPER(a.UTILITY)
	FROM		OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
				INNER JOIN OE_OFFER c WITH (NOLOCK) ON b.OFFER_ID = c.OFFER_ID
				INNER JOIN lp_common..common_utility d WITH (NOLOCK) ON a.UTILITY = d.utility_id
	WHERE		c.OFFER_ID > 'OF-07000'
	AND			c.Status = 'Open'				
	AND			a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)

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
-- 7/23/2008 - omitted per SD Ticket # 5174			
			-- no usage
--			IF EXISTS (	SELECT	NULL
--						FROM	OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) on a.id = b.oe_account_id
--						WHERE	b.offer_id = @w_offer_id AND ANNUAL_USAGE = 0 )
--				BEGIN
--					SELECT		@w_utility_id = UPPER(utility), @w_zone = zone, @w_icap = SUM(ICAP), @w_tcap = SUM(TCAP), @w_losses = 0
--					FROM		(	SELECT	ac.utility, ac.zone, ac.voltage, ac.ICAP, ac.TCAP, CASE WHEN ac.Losses IS NULL THEN 0 ELSE ac.Losses END AS Losses, ac.annual_usage, sap.offer_id 
--									FROM	oe_account ac WITH (NOLOCK) INNER JOIN (	SELECT	oa.ACCOUNT_NUMBER, oa.offer_id 
--																						FROM	oe_offer_accounts oa WITH (NOLOCK) INNER JOIN
--																								OE_PRICING_REQUEST_OFFER pra WITH (NOLOCK) ON oa.offer_id = pra.offer_id) 
--								sap ON ac.ACCOUNT_NUMBER = sap.ACCOUNT_NUMBER) sep
--					WHERE		offer_id = @w_offer_id
--					GROUP BY	offer_id, utility, zone
--				END
--			ELSE
--				BEGIN
					SELECT		@w_utility_id = UPPER(utility), @w_zone = zone, @w_icap = SUM(CASE WHEN ICAP = -1 THEN -1 ELSE ICAP END), @w_tcap = SUM(TCAP), @w_losses = CASE WHEN SUM(Annual_Usage) = 0 THEN 0 ELSE (SUM(Losses * Annual_Usage) / SUM(Annual_Usage)) END
					FROM		(	SELECT	ac.utility, ac.zone, ac.voltage, ac.ICAP, ac.TCAP, CASE WHEN ac.Losses IS NULL THEN 0 ELSE ac.Losses END AS Losses, ac.annual_usage, sap.offer_id 
									FROM	oe_account ac WITH (NOLOCK) INNER JOIN (	SELECT	oa.ACCOUNT_NUMBER, oa.offer_id 
																						FROM	oe_offer_accounts oa WITH (NOLOCK) INNER JOIN
																								OE_PRICING_REQUEST_OFFER pra WITH (NOLOCK) ON oa.offer_id = pra.offer_id) 
								sap ON ac.ACCOUNT_NUMBER = sap.ACCOUNT_NUMBER) sep
					WHERE		offer_id = @w_offer_id
					GROUP BY	offer_id, utility, zone
--				END

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
					USAGE_DATE		= z.UsageDate
			FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
			(SELECT		a.UTILITY, o.ACCOUNT_NUMBER, dtl2.AnnualUsage, dtl2.UsageDate
			FROM		#ACCOUNTS dtl
			INNER JOIN	OE_ACCOUNT a WITH (NOLOCK) ON dtl.account_number = a.ACCOUNT_NUMBER
			INNER JOIN	OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
			INNER JOIN	(	SELECT		account_number, 
										CAST((SUM(total_kwh) * CAST(365 AS float) / CAST(SUM(DATEDIFF(dd, start_date, end_date)) AS float)) AS bigint) AS AnnualUsage,
										MAX(end_date) AS UsageDate
							FROM		#ACCOUNTS
							WHERE		[start_date] <> end_date
							GROUP BY	account_number ) dtl2 ON dtl.account_number = dtl2.account_number
			WHERE	a.ACCOUNT_NUMBER IN (SELECT DISTINCT account_number FROM #ACCOUNTS)) z ON a2.ACCOUNT_NUMBER = z.ACCOUNT_NUMBER

--INSERT INTO	zEDI_TRACKING (loop, row_count, account_number) VALUES ('after update OE', 0, '')

	DROP TABLE #ACCOUNTS

	-- insert any new usage records into lookup table
	INSERT INTO ISTA..Usage
	SELECT	a.esiid, TdspDuns, a.[867_key], b.ServicePeriodStart, b.ServicePeriodEnd, c.Quantity,
			b.MeterNumber, ISNULL(ISNULL(ISNULL(b.UtilityRateServiceClass, v.RateClass), ud.UtilityRateServiceClass), sd.LDC_Rate_Class) AS RateClass, 
			ISNULL(sd.Capacity_Obligation, 0) AS ICAP, ISNULL(sd.Transmission_Obligation, 0) AS TCAP, 
			b.ServiceIndicator, sd.Load_Profile
	FROM	ISTA..tbl_867_Header a WITH (NOLOCK)  
			LEFT JOIN ISTA..tbl_867_scheduledeterminants sd on sd.[867_key] = a.[867_key]
			LEFT JOIN ISTA..tbl_867_NonIntervalDetail b WITH (NOLOCK) on a.[867_key]=b.[867_key] 
			LEFT JOIN ISTA..tbl_867_NonIntervalDetail_Qty c WITH (NOLOCK) on b.NonIntervalDetail_Key = c.NonIntervalDetail_Key
			LEFT JOIN ISTA..vw_ISTARateClass1 v ON a.esiid = v.esiid	
			LEFT JOIN ISTA..tbl_867_UnmeterDetail ud on ud.[867_key] = a.[867_key]
			LEFT JOIN ISTA..tbl_867_UnmeterDetail_Qty uq on uq.UnmeterDetail_Key = ud.UnmeterDetail_Key
			LEFT JOIN ISTA..tblMarketFile f on f.MarketFileId = a.MarketFileId
	WHERE	a.esiid NOT IN (SELECT AccountNumber FROM ISTA..Usage)
	AND		c.UOM = 'KH'
	
	-- return a dataset containing the offer ids that had usage acquired
	SELECT	OfferId
	FROM	#OFFERIDS

