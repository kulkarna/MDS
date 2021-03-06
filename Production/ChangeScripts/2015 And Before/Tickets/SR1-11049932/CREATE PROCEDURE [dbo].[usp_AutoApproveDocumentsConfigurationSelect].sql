USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationSelect]    Script Date: 05/17/2012 11:57:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		José Rafael Vasconcelos Cavalcante
-- Create date: 5/17/2012
-- Description:	Selects "auto approval documents step" configurations for all users
-- =============================================
CREATE PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationSelect]
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @Dummy AS BIT --Necessary to explicity declare a bit variable because Telerik Gridview needs this declaration to bind data correctly.
	SET @Dummy = 0
	
	SELECT 
		U.UserID, 
		U.FirstNAme + ' ' + U.LastName as Name,
		CASE WHEN WAC.AutoApproveDocument IS NULL THEN @Dummy ELSE WAC.AutoApproveDocument END AS AutoApprove
	FROM 
		[LibertyPower]..[User] U 
		JOIN [LibertyPower]..[UserRole] UR ON U.UserID = UR.UserID
		LEFT JOIN [LibertyPower]..[WorkflowAutoComplete] WAC ON U.UserID = WAC.UserID
	WHERE UR.RoleID = 24 --LibertyPowerEmployees
END
