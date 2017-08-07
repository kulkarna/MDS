USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_Determinants_FutureFieldValueHistorySelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_Determinants_FutureFieldValueHistorySelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_FutureFieldValueHistorySelect
 * Gets history for a field
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_FutureFieldValueHistorySelect] @UtilityID varchar( 80 ) ,
                                                             @AccountNumber varchar( 50 ) ,
                                                             @FieldName varchar( 30 ) 
AS
BEGIN		
		SET NOCOUNT ON;

            SELECT ID ,
                   UtilityID ,
                   AccountNumber ,
                   FieldName ,
                   FieldValue ,
                   CAST(EffectiveDate AS Date) As EffectiveDate,
                   FieldSource ,
                   UserIdentity ,
                   DateCreated ,
                   LockStatus ,
                   Active
              FROM DeterminantHistory WITH (NOLOCK)
              WHERE UtilityID = @UtilityID
                AND AccountNumber = @AccountNumber
                AND FieldName = @FieldName
                AND CAST(EffectiveDate AS Date) > GetDate()
                AND Active = 1
              ORDER BY ID DESC;

		SET NOCOUNT OFF;
END;


GO
