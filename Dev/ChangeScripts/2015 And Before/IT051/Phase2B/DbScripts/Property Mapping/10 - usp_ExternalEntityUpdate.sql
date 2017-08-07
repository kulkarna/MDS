USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ExternalEntityUpdate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_ExternalEntityUpdate]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/1/2013
-- Description:	Updates an external entity record
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityUpdate]
	@ID int 
	,@EntityKey int 
	,@EntityType int 
	,@showAs int
	,@inactive bit
	,@modifiedBy int
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE LibertyPower..ExternalEntity 
		SET EntityKey = @EntityKey
			, EntityTypeID =@EntityType
			, Inactive = @inactive
			, Modified = GETDATE() 
			, ModifiedBy = @modifiedBy
			, ShowAs = @showAs
	WHERE ID = @ID     
	
	SET NOCOUNT OFF;		
END
GO 