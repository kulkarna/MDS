USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertySelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertySelect]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		fmedeiros
-- Create date: 3/25/2013
-- Description:	List all database's registered properties
-- =============================================
-- exec LibertyPower..[usp_PropertySelect] 2
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertySelect]
	@Id int = null
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		ID,
		Name,
		Inactive,
		DateCreated,
		CreatedBy
	FROM LibertyPower..PropertyName p (NOLOCK) 
	WHERE 1= 1 
		-- and p.Inactive = 'false'
		and ID = ISNULL(@Id, ID)
		
	SET NOCOUNT OFF;
END
GO