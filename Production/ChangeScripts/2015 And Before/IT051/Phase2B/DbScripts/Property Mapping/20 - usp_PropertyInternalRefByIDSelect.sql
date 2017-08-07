USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyInternalRefByIDSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyInternalRefByIDSelect]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/26/2013
-- Description:	Get Internal Reference
-- =============================================
CREATE PROCEDURE usp_PropertyInternalRefByIDSelect
(@Id int ) 
AS 
BEGIN 
	SET NOCOUNT ON;		
	
	SELECT pir.* 
	FROM LibertyPower..PropertyInternalRef pir (NOLOCK)
	WHERE pir.ID = @Id 
		-- AND Inactive = 0 ???
		
	SET NOCOUNT OFF;				
END 