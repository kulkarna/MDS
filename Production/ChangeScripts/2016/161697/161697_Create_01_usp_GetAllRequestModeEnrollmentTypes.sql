USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllRequestModeEnrollmentTypes]    Script Date: 02/16/2017 09:23:33 ******/
if object_id('usp_GetAllRequestModeEnrollmentTypes') is not null
begin
DROP PROCEDURE [dbo].[usp_GetAllRequestModeEnrollmentTypes]
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllRequestModeEnrollmentTypes]    Script Date: 02/16/2017 09:23:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
-- ====================================================================================================================================================================================
-- Stored Procedure: [usp_GetAllRequestModeEnrollmentTypes]
-- Created: Anjibabu Maddineni 02/09/2017        
-- Description: Selects all Entollment Types 
-- EXEC [usp_GetAllRequestModeEnrollmentTypes]
-- ====================================================================================================================================================================================
*/

CREATE PROCEDURE [dbo].[usp_GetAllRequestModeEnrollmentTypes]
AS
BEGIN

	SELECT DISTINCT 
		SM.Value AS EnrollmentType,
		SM.Value AS Name,
		SM.StringMapId as RequestModeEnrollmentTypeId
	FROM
		--LibertyCrm_MSCRM.dbo.lpc_requestmode RM WITH (NOLOCK)
		LIBERTYCRM_MSCRM.dbo.StringMap SM WITH (NOLOCK) 
		--	ON  RM.lpc_EnrollmentType = SM.AttributeValue 
			WHERE SM.ObjectTypeCode = 10080 
			AND SM.AttributeName = 'lpc_enrollmenttype'

END
GO
