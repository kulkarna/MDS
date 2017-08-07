

CREATE PROCEDURE [dbo].[PriceFlexInsert]

AS

DECLARE @Month INT
SET @Month = 0
WHILE (@Month <= 12)
BEGIN
	INSERT INTO LibertyPower..Price
	SELECT	sc.ChannelID,
			cg.ChannelGroupID,
			CASE WHEN c.ChannelTypeID = 4 THEN 1 ELSE c.ChannelTypeID END,
			0,
			2,
			7,
			18,
			2,
			z.zone_id,
			src.service_rate_class_id,
			CAST(lp_enrollment.dbo.ufn_date_format(DATEADD(MONTH,@Month,GETDATE()),'<YYYY>-<MM>-01 00:00:00') AS DATETIME),
			12,
			rv.BillingRate,
			CAST(lp_enrollment.dbo.ufn_date_format(GETDATE(),'<YYYY>-<MM>-<DD> 00:00:00') AS DATETIME),
			CAST(lp_enrollment.dbo.ufn_date_format(GETDATE(),'<YYYY>-<MM>-<DD> 23:59:59') AS DATETIME),
			0,
			GETDATE(),
			0,
			4,
			0.0000000000,
			NULL
	FROM ISTA.dbo.RateVariable rv WITH (NOLOCK)
		LEFT JOIN ISTA.dbo.UsageClass uc WITH (NOLOCK) ON rv.UsageClassID = uc.UsageClassID
		LEFT JOIN ISTA.dbo.LBMP LBMP WITH (NOLOCK) ON rv.LBMPID = LBMP.LBMPID
		LEFT JOIN ISTA.dbo.LBMPLDC LBMPLDC WITH (NOLOCK) ON LBMP.LBMPID = LBMPLDC.LBMPId
		LEFT JOIN ISTA.dbo.LDC LDC WITH (NOLOCK) ON LBMPLDC.LDCId = LDC.LDCId
		JOIN lp_common..zone z WITH (NOLOCK) ON LBMP.LBMPID = z.ista_mapping
		JOIN lp_common..service_rate_class src WITH (NOLOCK) ON src.ista_mapping = uc.UsageClassID OR uc.UsageClassID = 4 -- 4 means ALL
		,Libertypower..SalesChannel sc
		INNER JOIN Libertypower..SalesChannelChannelGroup cg WITH (NOLOCK) ON sc.ChannelID = cg.ChannelID
			AND cg.EffectiveDate <= GETDATE()	
			AND Coalesce(cg.ExpirationDate, cast('1/1/9999' as DateTime)) > GETDATE()
		INNER JOIN libertypower..ChannelGroup c WITH (NOLOCK) ON cg.ChannelGroupID	= c.ChannelGroupID	
	WHERE LDC.LDCID = 13
		AND rv.EffectiveDate = lp_enrollment.dbo.ufn_date_format(getdate(),'<YYYY>-<MM>-<DD>')
		AND RateVariableTypeId = 2
		AND z.utility_id = 'CONED'
		AND src.service_rate_class_id IN (1,2,23)
		AND sc.Inactive = 0
	
	SET @Month = @Month + 1
END
