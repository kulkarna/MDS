USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountPropertyHistoryInsertFromQuerysV4]    Script Date: 2/3/2017 9:41:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_AccountPropertyHistoryInsertFromQuerysV4
 * <Purpose,,>
 *
 * History
 *******************************************************************************
 * 03/16/2015 - Jose Munoz - SWCS
 * Created.
 *******************************************************************************
 * 09/28/2015 - Manoj Thanath
 * Modify.
 *******************************************************************************
 * 02/03/2017 - Jose Munoz - SWCS
 * Modify.
 * PBI 135129 Add Billing Group to Account Property History Table 
 * Add the values for BillGroup in the APH table 
 *******************************************************************************
 
exec workspace..usp_AccountPropertyHistoryInsertFromQuerysV4 '05540428870001', 'CMP', 0


exec workspace..usp_AccountPropertyHistoryInsertFromQuerysV4 '10433865', 'BANGOR', 0

CMP A/C – 05540428870001
Bangor A/C – 0002444910124295

 */

ALTER PROCEDURE [dbo].[usp_AccountPropertyHistoryInsertFromQuerysV4]
    (@p_AccountNumber			VARCHAR(30)
	,@p_UtilityCode				VARCHAR(15)
    ,@p_FlagInsert				BIT = 0)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @ProcessDate		DATETIME
		,@UserName				VARCHAR(30)
		,@LockStatus			VARCHAR(60)
		,@Source				VARCHAR(60)
		,@FlagIsTexasAccount	BIT
		,@StrMessage			VARCHAR(255)


 	DECLARE @Values TABLE (Row		INT IDENTITY(1,1)
				,UtilityCode		VARCHAR(15)
				,AccountNumber		VARCHAR(30)
				,FieldName			VARCHAR(60)
				,FieldValues		VARCHAR(200)
				,EffectiveDate		DATETIME
				,Control			INT)

	DECLARE @CurrentAPH TABLE (UtilityID		VARCHAR(80)
				,AccountNumber					VARCHAR(50)
				,FieldName						VARCHAR(60)
				,FieldValue						VARCHAR(200)
				,EffectiveDate					DATETIME)
	
	SELECT 	@ProcessDate		= GETDATE()
		,@UserName				= SUSER_SNAME()
		,@LockStatus			= 'Unknown' 
		,@Source				= 'APHEvent_usp_AccountPropertyHistoryInsertFromQuerysV4'
		,@FlagIsTexasAccount	= 0

	/* Validate if account exists in the one PR */
	IF EXISTS (SELECT NULL FROM offerenginedb.dbo.oe_pricing_Request (NOLOCK) OPR 
				INNER JOIN offerenginedb.dbo.OE_PRICING_REQUEST_OFFER (NOLOCK) OPRO ON OPRO.REQUEST_ID = OPR.REQUEST_ID
				INNER JOIN OFFERENGINEDB.DBO.OE_OFFER_ACCOUNTS (NOLOCK) OOA ON OPRO.OFFER_ID = OOA.OFFER_ID 
				INNER JOIN OFFERENGINEDB.DBO.OE_ACCOUNT (NOLOCK) OA 
				ON OOA.OE_ACCOUNT_ID	= OA.ID
				WHERE OA.ACCOUNT_NUMBER = @p_AccountNumber
				AND OA.UTILITY			= @p_UtilityCode)
	BEGIN
		IF EXISTS (	SELECT MK.MarketCode FROM Libertypower..Market MK (NOLOCK)
					INNER JOIN libertypower..Utility UT (NOLOCK) 
					ON UT.MarketID			= MK.EnableTieredPricing
					WHERE UT.UtilityCode	= @p_UtilityCode
					AND MK.MarketCode		= 'TX')
			SET @FlagIsTexasAccount = 1

		/* Utility */
		INSERT INTO @Values 
		SELECT TOP 1 EA.UtilityCode
			,EA.AccountNumber
			,'Utility'
			,EA.UtilityCode
			,@ProcessDate
			,0
		FROM lp_transactions..EdiAccount EA (NOLOCK) 
		WHERE EA.AccountNumber		= @p_AccountNumber
		AND EA.UtilityCode			= @p_UtilityCode
		ORDER BY EA.ID DESC

		/* LoadProfile */
		INSERT INTO @Values 
		SELECT TOP 1 EA.UtilityCode
			,EA.AccountNumber
			,'LoadProfile'
			,EA.LoadProfile
			,CASE WHEN (EA.EffectiveDate IS NULL OR EA.EffectiveDate = '19800101') THEN @ProcessDate ELSE EA.EffectiveDate END AS EffectiveDate 
			,0
		FROM lp_transactions..EdiAccount EA (NOLOCK) 
		WHERE EA.AccountNumber		= @p_AccountNumber
		AND EA.UtilityCode			= @p_UtilityCode
		AND EA.LoadProfile <> '' 
		AND EA.LoadProfile IS NOT NULL 
		ORDER BY EA.ID DESC

		IF @@ROWCOUNT = 0
		BEGIN
			INSERT INTO @Values 
			SELECT TOP 1 EA.UtilityCode
				,EA.AccountNumber
				,'LoadProfile'
				,APH.FieldValue
				,CASE WHEN (EA.EffectiveDate IS NULL OR EA.EffectiveDate = '19800101') THEN @ProcessDate ELSE EA.EffectiveDate END AS EffectiveDate 
				,0
			FROM lp_transactions..EdiAccount EA (NOLOCK) 
			INNER JOIN Libertypower..AccountPropertyHistory APH (NOLOCK)
			ON APH.UtilityID			= EA.UtilityCode
			AND APH.AccountNumber		= EA.AccountNumber
			WHERE EA.AccountNumber		= @p_AccountNumber
			AND EA.UtilityCode			= @p_UtilityCode
			AND APH.FieldName			= 'LoadProfile'
			ORDER BY APH.EffectiveDate DESC, APH.AccountPropertyHistoryID DESC 
		
			IF @@ROWCOUNT = 0
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,@p_AccountNumber
					,'LoadProfile'
					,SD.Load_Profile
					,ISNULL(CONVERT(DATE,HH.TransactionDate), HH.TransactionDate) AS EffectiveDate 
					,0	
				FROM ISTA.dbo.tbl_867_Header HH (NOLOCK)
				INNER JOIN ISTA.dbo.LDC LD (NOLOCK)
				ON LD.DUNS				= HH.TdspDuns
				INNER JOIN ISTA.dbo.tbl_867_scheduledeterminants SD (NOLOCK)
				ON SD.[867_Key]			= HH.[867_Key]
				WHERE HH.EsiId			= @p_AccountNumber
				AND LD.LDCShortName		= @p_UtilityCode
				AND HH.Direction		= 1
				ORDER BY SD.ScheduleDeterminants_Key DESC
		END

		/* RateClass */
		INSERT INTO @Values 
		SELECT TOP 1 EA.UtilityCode
			,EA.AccountNumber
			,'RateClass'
			,EA.RateClass
			,CASE WHEN (EA.EffectiveDate IS NULL OR EA.EffectiveDate = '19800101') THEN @ProcessDate ELSE EA.EffectiveDate END AS EffectiveDate 
			,0
		FROM lp_transactions..EdiAccount EA (NOLOCK) 
		WHERE EA.AccountNumber		= @p_AccountNumber 
		AND EA.UtilityCode			= @p_UtilityCode
		AND EA.RateClass			NOT LIKE 'COMMERCIAL%'
		AND EA.RateClass			<> ''  
		AND EA.RateClass			IS NOT NULL 
		ORDER BY EA.ID DESC

		IF @@ROWCOUNT = 0
		BEGIN
			INSERT INTO @Values 
			SELECT TOP 1 EA.UtilityCode
				,EA.AccountNumber
				,'RateClass'
				,APH.FieldValue
				,CASE WHEN (EA.EffectiveDate IS NULL OR EA.EffectiveDate = '19800101') THEN @ProcessDate ELSE EA.EffectiveDate END AS EffectiveDate 
				,0
			FROM lp_transactions..EdiAccount EA (NOLOCK) 
			INNER JOIN Libertypower..AccountPropertyHistory APH (NOLOCK)
			ON APH.UtilityID			= EA.UtilityCode
			AND APH.AccountNumber		= EA.AccountNumber
			WHERE EA.AccountNumber		= @p_AccountNumber
			AND EA.UtilityCode			= @p_UtilityCode
			AND APH.FieldName			= 'RateClass'
			ORDER BY APH.EffectiveDate DESC, APH.AccountPropertyHistoryID DESC 
		
			IF @@ROWCOUNT = 0
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,@p_AccountNumber
					,'RateClass'
					,US.RateClass
					,CONVERT(DATE, US.ServicePeriodStart) AS EffectiveDate 
					,0
				FROM ISTA.dbo.Usage US (NOLOCK)
				INNER JOIN ISTA.dbo.LDC LD (NOLOCK)
				ON LD.DUNS = US.TdspDuns
				WHERE US.AccountNumber		= @p_AccountNumber
				AND LD.LDCShortName			= @p_UtilityCode
				ORDER BY US.ServicePeriodStart DESC
		END

		/* Voltage */
		INSERT INTO @Values 
		SELECT TOP 1 EA.UtilityCode
			,EA.AccountNumber
			,'Voltage'
			,EA.Voltage
			,@ProcessDate
			,0
		FROM lp_transactions..EdiAccount EA (NOLOCK) 
		WHERE EA.AccountNumber		= @p_AccountNumber
		AND EA.UtilityCode			= @p_UtilityCode
		AND EA.Voltage				<> '' 
		AND EA.Voltage				IS NOT NULL 
		ORDER BY EA.ID DESC

		/* PBI 135129 BEGIN */
		/* BillGroup */
		INSERT INTO @Values 
		SELECT TOP 1 EA.UtilityCode
			,EA.AccountNumber
			,'BillGroup'
			,EA.BillGroup
			,@ProcessDate
			,0
		FROM lp_transactions..EdiAccount EA (NOLOCK) 
		WHERE EA.AccountNumber		= @p_AccountNumber
		AND EA.UtilityCode			= @p_UtilityCode
		AND EA.BillGroup			<> -1 
		AND EA.BillGroup			IS NOT NULL 
		ORDER BY EA.ID DESC

		-- Scrapper for BillGroup 
		IF @@ROWCOUNT = 0 AND @p_UtilityCode IN ('BGE', 'CMP', 'AMEREN', 'CENHUD', 'COMED', 'CONED', 'PECO', 'RGE', 'NYSEG')
		BEGIN
			IF @p_UtilityCode  = 'BGE'
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,EA.AccountNumber
					,'BillGroup'
					,EA.BillGroup
					,@ProcessDate
					,0
				FROM lp_transactions..BgeAccount EA (NOLOCK) 
				WHERE EA.AccountNumber		= @p_AccountNumber
				AND EA.BillGroup			<> -1 
				AND EA.BillGroup			IS NOT NULL 
				ORDER BY EA.ID DESC
			ELSE IF @p_UtilityCode  = 'CMP'
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,EA.AccountNumber
					,'BillGroup'
					,EA.BillGroup
					,@ProcessDate
					,0
				FROM lp_transactions..CmpAccount EA (NOLOCK) 
				WHERE EA.AccountNumber		= @p_AccountNumber
				AND EA.BillGroup			<> -1 
				AND EA.BillGroup			IS NOT NULL 
				ORDER BY EA.ID DESC
			ELSE IF @p_UtilityCode  = 'AMEREN'
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,EA.AccountNumber
					,'BillGroup'
					,EA.BillGroup
					,@ProcessDate
					,0
				FROM lp_transactions..AmerenAccount EA (NOLOCK) 
				WHERE EA.AccountNumber		= @p_AccountNumber
				AND EA.BillGroup			<> -1 
				AND EA.BillGroup			IS NOT NULL 
				ORDER BY EA.ID DESC
			ELSE IF @p_UtilityCode  = 'CENHUD'
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,EA.AccountNumber
					,'BillGroup'
					,EA.Billcycle
					,@ProcessDate
					,0
				FROM lp_transactions..CenhudAccount EA (NOLOCK) 
				WHERE EA.AccountNumber		= @p_AccountNumber
				AND EA.Billcycle			<> -1 
				AND EA.Billcycle			IS NOT NULL 
				ORDER BY EA.ID DESC
			ELSE IF @p_UtilityCode  = 'COMED'
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,EA.AccountNumber
					,'BillGroup'
					,EA.MeterBillGroupNumber
					,@ProcessDate
					,0
				FROM lp_transactions..ComedAccount EA (NOLOCK) 
				WHERE EA.AccountNumber			= @p_AccountNumber
				AND EA.MeterBillGroupNumber		<> -1 
				AND EA.MeterBillGroupNumber		IS NOT NULL 
				ORDER BY EA.ID DESC
			ELSE IF @p_UtilityCode  = 'CONED'
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,EA.AccountNumber
					,'BillGroup'
					,EA.TripNumber
					,@ProcessDate
					,0
				FROM lp_transactions..ConedAccount EA (NOLOCK) 
				WHERE EA.AccountNumber		= @p_AccountNumber
				AND EA.TripNumber			<> -1 
				AND EA.TripNumber			IS NOT NULL 
				ORDER BY EA.ID DESC
			ELSE IF @p_UtilityCode  = 'PECO'
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,EA.AccountNumber
					,'BillGroup'
					,EA.BillGroup
					,@ProcessDate
					,0
				FROM lp_transactions..PecoAccount EA (NOLOCK) 
				WHERE EA.AccountNumber		= @p_AccountNumber
				AND EA.BillGroup			<> -1 
				AND EA.BillGroup			IS NOT NULL 
				ORDER BY EA.ID DESC
			ELSE IF @p_UtilityCode  = 'RGE'
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,EA.AccountNumber
					,'BillGroup'
					,EA.BillGroup
					,@ProcessDate
					,0
				FROM lp_transactions..RgeAccount EA (NOLOCK) 
				WHERE EA.AccountNumber		= @p_AccountNumber
				AND EA.BillGroup			<> -1 
				AND EA.BillGroup			IS NOT NULL 
				ORDER BY EA.ID DESC
			ELSE IF @p_UtilityCode  = 'NYSEG'
				INSERT INTO @Values 
				SELECT TOP 1 @p_UtilityCode
					,EA.AccountNumber
					,'BillGroup'
					,EA.BillGroup
					,@ProcessDate
					,0
				FROM lp_transactions..NysegAccount EA (NOLOCK) 
				WHERE EA.AccountNumber		= @p_AccountNumber
				AND EA.BillGroup			<> -1 
				AND EA.BillGroup			IS NOT NULL 
				ORDER BY EA.ID DESC
		END

		/* PBI 135129 END */

		/* Zone*/
		INSERT INTO @Values 
		SELECT TOP 1 EA.UtilityCode
			,EA.AccountNumber
			,'Zone'
			,CASE WHEN @FlagIsTexasAccount = 1 THEN LEFT(REPLACE(PP.value,UT.UtilityCode + '-',''), 1) + 'Z' ELSE REPLACE(PP.value,UT.UtilityCode + '-','') END
			,@ProcessDate
			,0
		FROM lp_transactions..EdiAccount EA (NOLOCK) 
		INNER JOIN LibertyPower..Utility UT (NOLOCK) 
		ON UT.UtilityCode			= EA.UtilityCode
		INNER JOIN LibertyPower..Account AA (NOLOCK) 
		ON AA.AccountNumber			= EA.AccountNumber
		AND AA.UtilityID			= UT.ID 
		INNER JOIN LibertyPower..PropertyInternalRef PP  (NOLOCK)
		ON PP.ID					= AA.DeliveryLocationRefID
		WHERE EA.AccountNumber		= @p_AccountNumber
		AND EA.UtilityCode			= @p_UtilityCode
		ORDER BY EA.ID DESC

		IF @@ROWCOUNT = 0
		BEGIN
			INSERT INTO @Values 
			SELECT TOP 1 EA.UtilityCode
				,EA.AccountNumber
				,'Zone'
				,EA.ZoneCode
				,@ProcessDate
				,0
			FROM lp_transactions..EdiAccount EA (NOLOCK) 
			WHERE EA.AccountNumber		= @p_AccountNumber
			AND EA.UtilityCode			= @p_UtilityCode
			AND EA.ZoneCode				<> '' 
			AND EA.ZoneCode				IS NOT NULL 
			AND EA.UtilityCode			NOT IN ('BANGOR')
			ORDER BY EA.ID DESC
		END

		INSERT INTO @Values
		SELECT AA.UtilityCode
			,AA.AccountNumber
			,AA.FieldName
			,BB.AliasValue
			,DATEADD(ss, 1, AA.EffectiveDate)
			,0
		FROM @Values AA
		INNER JOIN Libertypower..DeterminantAlias BB (NOLOCK) 
		ON BB.UtilityCode		= AA.UtilityCode 
		AND BB.FieldName		= AA.FieldName
		AND BB.OriginalValue	= AA.FieldValues
		WHERE BB.DateCreated	<= @ProcessDate 
		AND BB.Active			= 1 
		--AND BB.FieldSource		not like 'Mapping%'

		
		/* Mappings fields */
		INSERT INTO @Values 
		SELECT V.UtilityCode
			,V.AccountNumber
			,R.ResultantFieldName
			,R.ResultantFieldValue
			,V.EffectiveDate
			,0
		FROM Libertypower..DeterminantFieldMaps D (nolock) 
		INNER JOIN @Values V
		ON D.UtilityCode			= V.UtilityCode
		AND D.DeterminantFieldName	= V.FieldName
		AND D.DeterminantValue		= V.FieldValues
		INNER JOIN Libertypower.dbo.DeterminantFieldMapResultants R (nolock)  
		ON R.FieldMapID				= D.ID
		WHERE D.ID					IN (SELECT MAX(T.ID) FROM Libertypower..DeterminantFieldMaps T (nolock) 
										WHERE T.UtilityCode				= D.UtilityCode
										AND T.DeterminantFieldName		= D.DeterminantFieldName
										AND T.DeterminantValue			= D.DeterminantValue)

		IF @FlagIsTexasAccount = 0
		BEGIN 
	
			INSERT INTO @Values 
			SELECT TOP 1 EA.UtilityCode
				,EA.AccountNumber
				,'ICap'
				,CASE WHEN EA.UtilityCode IN ('CMP', 'BANGOR') THEN (EA.ICAP * 1000) ELSE EA.ICAP END
				,CASE WHEN EA.IcapEffectiveDate = '19800101' THEN EA.TimeStampInsert ELSE  EA.IcapEffectiveDate END
				,0
			FROM lp_transactions..EdiAccount EA (NOLOCK) 
			WHERE EA.AccountNumber		= @p_AccountNumber
			AND EA.UtilityCode			= @p_UtilityCode
			AND EA.ICAP					<> -1  
			AND EA.ICAP					IS NOT NULL 
			AND EA.IcapEffectiveDate	IS NOT NULL 
			AND CASE WHEN EA.IcapEffectiveDate = '19800101' THEN EA.TimeStampInsert ELSE  EA.IcapEffectiveDate END	<= @ProcessDate
			ORDER BY EA.ID DESC

			INSERT INTO @Values 
			SELECT TOP 1 EA.UtilityCode
				,EA.AccountNumber
				,'ICap'
				,CASE WHEN EA.UtilityCode IN ('CMP', 'BANGOR') THEN (EA.ICAP * 1000) ELSE EA.ICAP END
				,CASE WHEN EA.IcapEffectiveDate = '19800101' THEN EA.TimeStampInsert ELSE  EA.IcapEffectiveDate END
				,0
			FROM lp_transactions..EdiAccount EA (NOLOCK) 
			WHERE EA.AccountNumber		= @p_AccountNumber
			AND EA.UtilityCode			= @p_UtilityCode
			AND EA.ICAP					<> -1  
			AND EA.ICAP					IS NOT NULL 
			AND EA.IcapEffectiveDate	IS NOT NULL 
			AND CASE WHEN EA.IcapEffectiveDate = '19800101' THEN EA.TimeStampInsert ELSE  EA.IcapEffectiveDate END	> @ProcessDate
			ORDER BY EA.ID DESC
	
			INSERT INTO @Values 
			SELECT TOP 1 UT.UtilityCode
				,SS.EsiId
				,'ICap'
				,CASE WHEN UT.UtilityCode IN ('CMP', 'BANGOR') THEN (CONVERT(FLOAT,SS.CapacityObligation) * 1000) ELSE CONVERT(FLOAT,SS.CapacityObligation) END
				,CONVERT(DATETIME, SS.SpecialReadSwitchDate,101) as  SpecialReadSwitchDate
				,0
			FROM ISTA.dbo.tbl_814_Service SS (NOLOCK) 
			INNER JOIN ISTA.dbo.tbl_814_header HH (NOLOCK) 
			ON HH.[814_key] = SS.[814_key]
			INNER JOIN Libertypower.dbo.Utility UT (NOLOCK) 
			on UT.DunsNumber			= hh.TdspDuns
			LEFT JOIN ISTA.dbo.tbl_814_Service_Status SR WITH (NOLOCK)
			ON SR.Service_Key			= SS.Service_Key
			WHERE SS.EsiId				= @p_AccountNumber
			AND UT.UtilityCode			= @p_UtilityCode
			AND HH.Direction			= 1
			AND HH.ActionCode			IN ('E','C')
			AND SS.CapacityObligation	IS NOT NULL
			AND CONVERT(FLOAT, SS.CapacityObligation) <> -1
			AND CONVERT(DATETIME, SS.SpecialReadSwitchDate,101) <= @ProcessDate
			AND SR.StatusCode			NOT IN ('A13')
			ORDER BY SS.[Service_Key] DESC

			INSERT INTO @Values 
			SELECT TOP 1 UT.UtilityCode
				,SS.EsiId
				,'ICap'
				,CASE WHEN UT.UtilityCode IN ('CMP', 'BANGOR') THEN (CONVERT(FLOAT,SS.CapacityObligation) * 1000) ELSE CONVERT(FLOAT,SS.CapacityObligation) END
				,CONVERT(DATETIME, SS.SpecialReadSwitchDate,101) as  SpecialReadSwitchDate
				,0
			FROM ISTA.dbo.tbl_814_Service SS (NOLOCK) 
			INNER JOIN ISTA.dbo.tbl_814_header HH (NOLOCK) 
			ON HH.[814_key] = SS.[814_key]
			INNER JOIN Libertypower.dbo.Utility UT (NOLOCK) 
			on UT.DunsNumber			= hh.TdspDuns
			LEFT JOIN ISTA.dbo.tbl_814_Service_Status SR WITH (NOLOCK)
			ON SR.Service_Key			= SS.Service_Key
			WHERE SS.EsiId				= @p_AccountNumber
			AND UT.UtilityCode			= @p_UtilityCode
			AND HH.Direction			= 1
			AND HH.ActionCode			IN ('E','C')
			AND SS.CapacityObligation	IS NOT NULL
			AND CONVERT(FLOAT, SS.CapacityObligation) <> -1
			AND CONVERT(DATETIME, SS.SpecialReadSwitchDate,101) > @ProcessDate
			AND SR.StatusCode			NOT IN ('A13')
			ORDER BY SS.[Service_Key] DESC

			INSERT INTO @Values 
			SELECT TOP 1 EA.UtilityCode
				,EA.AccountNumber
				,'TCap'
				,EA.Tcap
				,CASE WHEN EA.TcapEffectiveDate = '19800101' THEN EA.TimeStampInsert ELSE  EA.TcapEffectiveDate END
				,0
			FROM lp_transactions..EdiAccount EA (NOLOCK) 
			WHERE EA.AccountNumber		= @p_AccountNumber
			AND EA.UtilityCode			= @p_UtilityCode
			AND EA.TCAP					<> -1  
			AND EA.TCAP					IS NOT NULL 
			AND EA.TcapEffectiveDate	IS NOT NULL 
			AND CASE WHEN EA.TcapEffectiveDate = '19800101' THEN EA.TimeStampInsert ELSE  EA.TcapEffectiveDate END	<= @ProcessDate
			ORDER BY EA.ID DESC

			INSERT INTO @Values 
			SELECT TOP 1 EA.UtilityCode
				,EA.AccountNumber
				,'TCap'
				,EA.Tcap
				,CASE WHEN EA.TcapEffectiveDate = '19800101' THEN EA.TimeStampInsert ELSE  EA.TcapEffectiveDate END
				,0
			FROM lp_transactions..EdiAccount EA (NOLOCK) 
			WHERE EA.AccountNumber		= @p_AccountNumber
			AND EA.UtilityCode			= @p_UtilityCode
			AND EA.TCAP					<> -1  
			AND EA.TCAP					IS NOT NULL 
			AND EA.TcapEffectiveDate	IS NOT NULL 
			AND CASE WHEN EA.TcapEffectiveDate = '19800101' THEN EA.TimeStampInsert ELSE  EA.TcapEffectiveDate END	> @ProcessDate
			ORDER BY EA.ID DESC
		
		
			INSERT INTO @Values 
			SELECT TOP 1 UT.UtilityCode
				,SS.EsiId
				,'TCap'
				,SS.TransmissionObligation
				,CONVERT(DATETIME, SS.SpecialReadSwitchDate,101) as  SpecialReadSwitchDate
				,0
			FROM ISTA.dbo.tbl_814_Service SS (NOLOCK) 
			INNER JOIN ISTA.dbo.tbl_814_header HH (NOLOCK) 
			ON HH.[814_key] = SS.[814_key]
			INNER JOIN Libertypower.dbo.Utility UT (NOLOCK) 
			on UT.DunsNumber			= hh.TdspDuns
			LEFT JOIN ISTA.dbo.tbl_814_Service_Status SR WITH (NOLOCK)
			ON SR.Service_Key			= SS.Service_Key
			WHERE SS.EsiId				= @p_AccountNumber
			AND UT.UtilityCode			= @p_UtilityCode
			AND HH.Direction			= 1
			AND HH.ActionCode			IN ('E','C')
			AND SS.TransmissionObligation	IS NOT NULL
			AND CONVERT(FLOAT, SS.TransmissionObligation) <> -1
			AND CONVERT(DATETIME, SS.SpecialReadSwitchDate,101) <= @ProcessDate
			AND SR.StatusCode			NOT IN ('A13')
			ORDER BY SS.[Service_Key] DESC

			INSERT INTO @Values 
			SELECT TOP 1 UT.UtilityCode
				,SS.EsiId
				,'TCap'
				,SS.TransmissionObligation
				,CONVERT(DATETIME, SS.SpecialReadSwitchDate,101) as  SpecialReadSwitchDate
				,0
			FROM ISTA.dbo.tbl_814_Service SS (NOLOCK) 
			INNER JOIN ISTA.dbo.tbl_814_header HH (NOLOCK) 
			ON HH.[814_key] = SS.[814_key]
			INNER JOIN Libertypower.dbo.Utility UT (NOLOCK) 
			on UT.DunsNumber			= hh.TdspDuns
			LEFT JOIN ISTA.dbo.tbl_814_Service_Status SR WITH (NOLOCK)
			ON SR.Service_Key			= SS.Service_Key
			WHERE SS.EsiId				= @p_AccountNumber
			AND UT.UtilityCode			= @p_UtilityCode
			AND HH.Direction			= 1
			AND HH.ActionCode			IN ('E','C')
			AND SS.TransmissionObligation	IS NOT NULL
			AND CONVERT(FLOAT, SS.TransmissionObligation) <> -1
			AND CONVERT(DATETIME, SS.SpecialReadSwitchDate,101) > @ProcessDate
			AND SR.StatusCode			NOT IN ('A13')
			ORDER BY SS.[Service_Key] DESC
		END
		ELSE
		BEGIN
		/* Icap 0 if market is TX */
			INSERT INTO @Values 
			SELECT @p_UtilityCode
				,@p_AccountNumber
				,'ICap'
				,0
				,@ProcessDate
				,0
		
			/* Icap 0 if market is TX */
			INSERT INTO @Values 
			SELECT @p_UtilityCode
				,@p_AccountNumber
				,'TCap'
				,0
				,@ProcessDate
				,0
		END
		

		INSERT INTO @CurrentAPH			
		SELECT AP.UtilityID
			,AP.AccountNumber
			,AP.FieldName
			,AP.FieldValue
			,AP.EffectiveDate
		FROM libertypower..AccountPropertyHistory AP (NOLOCK)
		WHERE AP.AccountNumber				= @p_AccountNumber
		AND AP.UtilityID					= @p_UtilityCode
		AND AP.AccountPropertyHistoryID IN (	SELECT TOP 1 APH2.AccountPropertyHistoryID FROM libertypower..AccountPropertyHistory APH2 (NOLOCK)
												WHERE APH2.UtilityID			= AP.UtilityID
												AND APH2.AccountNumber			= AP.AccountNumber
												AND APH2.FieldName				= AP.FieldName
												ORDER BY APH2.EffectiveDate		DESC)

		IF @p_FlagInsert =  1
			BEGIN
				INSERT INTO LibertyPower.dbo.AccountPropertyHistory (UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, ExpirationDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active) 
				SELECT DISTINCT AA.UtilityCode, AA.AccountNumber, AA.FieldName, AA.FieldValues, AA.EffectiveDate, NULL, @Source, @UserName, @ProcessDate, @LockStatus, 1
				FROM  @Values AA 
				WHERE AA.FieldName		NOT IN ('ICap', 'TCap')
				AND AA.EffectiveDate	IS NOT NULL	
				AND AA.Fieldvalues		<> ''						
				AND NOT EXISTS (	SELECT 1 FROM @CurrentAPH BB 
									WHERE BB.UtilityID					= AA.UtilityCode
									AND BB.AccountNumber				= AA.Accountnumber
									AND BB.FieldName					= AA.Fieldname
									AND LTRIM(RTRIM(BB.FieldValue))		= LTRIM(RTRIM(AA.Fieldvalues)))
			
				INSERT INTO LibertyPower.dbo.AccountPropertyHistory (UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, ExpirationDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active) 
				SELECT DISTINCT AA.UtilityCode, AA.AccountNumber, AA.FieldName, AA.FieldValues, AA.EffectiveDate, NULL, @Source, @UserName, @ProcessDate, @LockStatus, 1
				FROM  @Values AA 
				WHERE AA.FieldName		IN('ICap', 'TCap')
				AND AA.EffectiveDate	IS NOT NULL	
				AND AA.Fieldvalues		<> ''						
				AND NOT EXISTS (	SELECT 1 FROM @CurrentAPH BB 
									WHERE BB.UtilityID					= AA.UtilityCode
									AND BB.AccountNumber				= AA.Accountnumber
									AND BB.FieldName					= AA.Fieldname
									AND CONVERT(FLOAT,BB.FieldValue)	= CONVERT(FLOAT,AA.FieldValues))
			SELECT ID =1;
			END
		ELSE
			SELECT DISTINCT AA.UtilityCode, AA.AccountNumber, AA.FieldName, AA.FieldValues, AA.EffectiveDate, NULL, @Source, @UserName, @ProcessDate, @LockStatus, 1
			FROM  @Values AA 
	END
	ELSE
	BEGIN
		SET @StrMessage = 'There are not PR with the Account : ' + LTRIM(RTRIM(@p_AccountNumber)) + ' (' + LTRIM(RTRIM(@p_UtilityCode)) + ').'
		PRINT (@StrMessage)
		SELECT ID =1;
	END
			
    SET NOCOUNT OFF;
END

-- Copyright 02/27/2015 Liberty Power