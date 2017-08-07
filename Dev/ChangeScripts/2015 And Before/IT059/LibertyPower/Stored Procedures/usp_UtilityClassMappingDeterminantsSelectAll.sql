USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityClassMappingDeterminantsSelectAll]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityClassMappingDeterminantsSelectAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_UtilityClassMappingDeterminantsSelectAll
 * Gets utility class mapping determinants 
 *
 * History
 *******************************************************************************/

CREATE PROCEDURE [dbo].[usp_UtilityClassMappingDeterminantsSelectAll]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, UtilityID, Driver
    FROM	UtilityClassMappingDeterminants WITH (NOLOCK)


    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
