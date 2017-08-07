USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_Determinants_AliasSelectAll]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_Determinants_AliasSelectAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_AliasSelectAll
 * Selects all alias by context date
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_AliasSelectAll]
  @ContextDate datetime
AS

BEGIN
	SET NOCOUNT ON;
	
   SELECT ID, UtilityCode, FieldName , OriginalValue, AliasValue, UserIdentity, DateCreated, Active
    FROM DeterminantAlias WITH (NOLOCK)
    WHERE Active = 1 AND DateCreated <= @ContextDate

	SET NOCOUNT OFF;
END

GO
