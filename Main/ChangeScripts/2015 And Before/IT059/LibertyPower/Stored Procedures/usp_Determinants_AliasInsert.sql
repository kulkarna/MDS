USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_Determinants_AliasInsert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_Determinants_AliasInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_AliasInsert
 * Inserts alias values
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_AliasInsert]
	
    @UtilityCode varchar(50),
    @FieldName varchar(60),
    @OriginalValue varchar(60),
    @AliasValue varchar(60),
    @UserIdentity varchar(256)

AS

BEGIN

	SET NOCOUNT ON;

    INSERT INTO DeterminantAlias (    UtilityCode, FieldName , OriginalValue, AliasValue, UserIdentity)
    VALUES(@UtilityCode,  @FieldName,  @OriginalValue,  @AliasValue,  @UserIdentity )			

    IF SCOPE_IDENTITY() IS NOT NULL
    BEGIN
	   SELECT ID, UtilityCode, FieldName , OriginalValue, AliasValue, UserIdentity, DateCreated, Active
	   FROM DeterminantAlias WITH (NOLOCK)
	   WHERE ID = SCOPE_IDENTITY()
    END

	SET NOCOUNT OFF;

END

GO
