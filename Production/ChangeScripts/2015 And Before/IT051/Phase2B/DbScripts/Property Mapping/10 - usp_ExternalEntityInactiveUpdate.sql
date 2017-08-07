USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ExternalEntityInactiveUpdate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_ExternalEntityInactiveUpdate]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/1/2013
-- Description:	inactivate the specified entity 
-- =============================================
-- exec LibertyPower..[usp_ExternalEntityInactiveUpdate] 23 , 0 , 0 
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityInactiveUpdate]
	@Id int 
	, @Inactive bit
	, @ModifiedBy int 
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE LibertyPower..ExternalEntity 
	SET Inactive = @Inactive , Modified = GETDATE() , ModifiedBy = @ModifiedBy
	WHERE id = @Id
		
	SET NOCOUNT OFF;
END
GO