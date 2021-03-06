USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UtilityBillingTypeSelectByUtilityId]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_UtilityBillingTypeSelectByUtilityId]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =================================================
-- Created By: Gail Mangaroo 
-- Date Created: 12/4/2013
-- =================================================
CREATE	PROCEDURE	[dbo].[usp_UtilityBillingTypeSelectByUtilityId]
		@UtilityId	int
AS

BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	ub.BillingTypeID, b.Type, b.Description
	FROM	UtilityBillingType ub (NOLOCK)
	INNER	JOIN BillingType b (NOLOCK)
	ON		ub.BillingTypeID = b.BillingTypeID
	WHERE	ub.UtilityID  = @UtilityId
	AND		b.Active = 1
	
	SET NOCOUNT OFF;
END
GO

