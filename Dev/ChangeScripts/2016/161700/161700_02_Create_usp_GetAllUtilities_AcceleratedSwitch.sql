USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllUtilities_AcceleratedSwitch]    Script Date: 02/09/2017 13:34:48 ******/
if OBJECT_ID('usp_GetAllUtilities_AcceleratedSwitch') is not null
begin
DROP PROCEDURE [dbo].[usp_GetAllUtilities_AcceleratedSwitch]
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllUtilities_AcceleratedSwitch]    Script Date: 02/09/2017 13:34:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================

-- Stored Procedure: usp_GetAllUtilities_AcceleratedSwitch

-- Created: Anjibabu Maddineni 02/02/2017        

-- Description: Selects the records from the Utility for accelerated Switch

--EXEC [usp_GetAllUtilities_AcceleratedSwitch] 

-- ====================================================================================================================================================================================



CREATE PROC [dbo].[usp_GetAllUtilities_AcceleratedSwitch]

AS

BEGIN



	SET NOCOUNT ON;



	SELECT 

		UC.lpc_UtilityCode UtilityCode

		, UC.lpc_AcceleratedSwitch AcceleratedSwitch

		, UC.lpc_utility_id UtilityIdInt

		, UC.lpc_utilityId UtilityCompanyId

	FROM

		LibertyCrm_MSCRM.dbo.lpc_utility UC 

	ORDER BY

		UtilityCode



	SET NOCOUNT OFF;



END
GO
