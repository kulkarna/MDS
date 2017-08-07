USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_aggregated_icap_tcap_losses_by_offer_sel]    Script Date: 07/13/2013 14:03:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/17/2008
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[usp_aggregated_icap_tcap_losses_by_offer_sel]

@p_offer_id			varchar(50)

AS

-- 7/23/2008 - omitted per SD Ticket # 5174
-- no usage
--IF EXISTS (	SELECT	NULL
--			FROM	OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) on a.id = b.oe_account_id
--			WHERE	b.offer_id = @p_offer_id AND ANNUAL_USAGE = 0 )
--	BEGIN
--		SELECT		offer_id, utility, zone, SUM(ICAP) as ICAP, SUM(TCAP) AS TCAP, 0 AS Losses 
--		FROM		(	SELECT	ac.utility, ac.zone, ac.voltage, ac.ICAP, ac.TCAP, ac.Losses, ac.annual_usage, sap.offer_id 
--						FROM	oe_account ac WITH (NOLOCK) INNER JOIN (	SELECT	oa.ACCOUNT_NUMBER, oa.offer_id 
--																			FROM	oe_offer_accounts oa WITH (NOLOCK) INNER JOIN
--																					OE_PRICING_REQUEST_OFFER pra WITH (NOLOCK) ON oa.offer_id = pra.offer_id) 
--					sap ON ac.ACCOUNT_NUMBER = sap.ACCOUNT_NUMBER) sep
--		WHERE		offer_id = @p_offer_id
--		GROUP BY	offer_id, utility, zone
--	END
--ELSE
--	BEGIN
		SELECT		offer_id, utility, zone, SUM(CASE WHEN ICAP = -1 THEN -1 ELSE ICAP END) as ICAP, SUM(TCAP) AS TCAP, SUM(ISNULL(Losses, 0) * Annual_Usage) / SUM(Annual_Usage) AS Losses 
		FROM		(	SELECT	ac.ACCOUNT_NUMBER, ac.utility, ac.zone, ac.voltage, ac.ICAP, ac.TCAP, ac.Losses, ac.annual_usage, sap.offer_id 
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












GO

