USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyValueInsert]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyValueInsert]
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
-- exec 
-- ============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueInsert]
	@value varchar(100)
	, @internalRefId int
	, @propertyId int 
	, @propertyTypeId int 
	, @inactive bit
	, @createdBy int
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO LibertyPower..PropertyValue
	(Value, InternalRefID, propertyId, propertyTypeId, Inactive, DateCreated, CreatedBy)
	VALUES
	(@value, @internalRefId,@propertyId,@propertyTypeId , @inactive,  GETDATE(), @createdBy)
        
    SELECT SCOPE_IDENTITY();
    
	SET NOCOUNT OFF;		    
END
GO