




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
																							INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
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



