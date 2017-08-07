USE		lp_risk

GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		get the risk load shapes														*
 *	Modified:																					*
 ********************************************************************************************** */
 
CREATE	PROCEDURE usp_RiskLoadShapesGetSTRMs
	(	@ServiceClass as INT,
		@Stratum as FLOAT
	)

AS

BEGIN

	SELECT	DISTINCT 
			strm_start, strm_end
	FROM	risk_load_shapes
	WHERE	service_class = @ServiceClass
	AND		@Stratum between strm_start and strm_end

END
