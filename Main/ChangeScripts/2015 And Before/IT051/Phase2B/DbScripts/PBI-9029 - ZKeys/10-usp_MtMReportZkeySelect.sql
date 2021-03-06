USE [lp_mtm]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMReportZkeySelect]    Script Date: 05/28/2013 11:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************/
 /********************************* usp_MtMReportZkeySelect ************************************/
/**********************************************************************************************/
-- =============================================
-- Author:		
-- Create date: 
-- Description:	Create ZKeys
-- =============================================
-- Modified:	Gail Mangaroo 
-- Modified date: 5/28/2013
-- Description:	Use Iso and Location ID
-- =============================================
-- exec lp_mtm..[usp_MtMReportZkeySelect] 'ERCOT', 'EHHUB'
-- ============================================
ALTER	PROCEDURE	[dbo].[usp_MtMReportZkeySelect]
		@ISO	AS VARCHAR(50),
		@Zone	AS VARCHAR(50)
		
AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT	z.*
	FROM	MtMReportZkey z (nolock)
		JOIN LibertyPower..WholesaleMarket w (NOLOCK) 
			ON w.ID = z.ISOID
		LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
			ON pv.ID = z.ZainetLocationId
	WHERE	w.WholesaleMktId = @ISO
		AND		pv.Value = @Zone

	SET NOCOUNT OFF;
END
