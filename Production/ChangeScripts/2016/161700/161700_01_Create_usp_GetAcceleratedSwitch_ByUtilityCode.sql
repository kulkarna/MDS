USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAcceleratedSwitch_ByUtilityCode]    Script Date: 02/09/2017 13:28:05 ******/
if OBJECT_ID('usp_GetAcceleratedSwitch_ByUtilityCode') is not null
begin
DROP PROCEDURE [dbo].[usp_GetAcceleratedSwitch_ByUtilityCode]
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAcceleratedSwitch_ByUtilityCode]    Script Date: 02/09/2017 13:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Stored Procedure: usp_GetAcceleratedSwitch_ByUtilityCode
-- Created: Anjibabu Maddineni 02/02/2017        
-- Description: Selects the records from the Utility specified Utility Code
--EXEC [usp_GetAcceleratedSwitch_ByUtilityCode] @UtilityCode = 'CONED'
-- ====================================================================================================================================================================================

CREATE PROC [dbo].[usp_GetAcceleratedSwitch_ByUtilityCode]
	@UtilityCode VARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		UC.lpc_UtilityCode UtilityCode
		, UC.lpc_AcceleratedSwitch AcceleratedSwitch
	FROM
		LibertyCrm_MSCRM.dbo.lpc_utility UC 
	WHERE
		UC.lpc_UtilityCode = @UtilityCode 
	ORDER BY
		UtilityCode

	SET NOCOUNT OFF;

END
GO
