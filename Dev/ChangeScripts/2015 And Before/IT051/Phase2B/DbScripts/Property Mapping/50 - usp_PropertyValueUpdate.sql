USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyValueUpdate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyValueUpdate]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		fmedeiros
-- Create date: 3/23/2013
-- Description:	Insert a new external entity
-- =============================================
-- Modified :   Gail Mangaroo 
--			:	5/2/2013
--			:	Added additional Feilds.
-- ============================================
-- 
-- ============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueUpdate]
	 @id int 
	, @value varchar(100)
	, @internalRefId int
	, @propertyId int 
	, @propertyTypeId int 
	, @inactive bit
	, @modifiedBy int
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE LibertyPower..PropertyValue
	SET Value = @value
		, InternalRefID = @internalRefId
		, PropertyId = @propertyId 
		, PropertyTypeId = @propertyTypeId
		, Inactive = @inactive
		, Modified = GETDATE()
		, ModifiedBy = @modifiedBy
	WHERE ID = @id

	SET NOCOUNT OFF;			
END
GO