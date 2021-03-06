USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_UtilityCompany_DoesUtilityCodeBelongToIso]    Script Date: 01/13/2017 12:21:14 ******/
DROP PROCEDURE [dbo].[usp_UtilityCompany_DoesUtilityCodeBelongToIso]
GO
/****** Object:  StoredProcedure [dbo].[usp_UtilityCompany_DoesUtilityCodeBelongToIso]    Script Date: 01/13/2017 12:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXEC [usp_UtilityCompany_DoesUtilityCodeBelongToIso] 'PJM', 'ACE'
*/

CREATE PROCEDURE [dbo].[usp_UtilityCompany_DoesUtilityCodeBelongToIso]
	@IsoName NVARCHAR(50),
	@UtilityCode NVARCHAR(50)
AS
BEGIN

	SELECT 
		CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
	FROM 
		LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) 
		INNER JOIN LibertyCrm_MSCRM.dbo.lpc_iso I WITH (NOLOCK)
			ON uc.lpc_iso = I.lpc_isoId
	WHERE
		I.lpc_name = @IsoName
		AND UC.lpc_UtilityCode = @UtilityCode

END
GO
