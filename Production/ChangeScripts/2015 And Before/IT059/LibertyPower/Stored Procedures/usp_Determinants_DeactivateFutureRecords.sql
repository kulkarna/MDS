USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_Determinants_DeactivateFutureRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_Determinants_DeactivateFutureRecords]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_DeactivateFutureRecords
 * Deactivates future determinant records
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_Determinants_DeactivateFutureRecords]  @UtilityID varchar( 80 ) ,
                                                      @AccountNumber varchar( 50 ) ,
                                                      @FieldName varchar( 60 )
									
                                                      
AS
BEGIN
    SET NOCOUNT ON;

   UPDATE DeterminantHistory
   SET Active = 0
   WHERE UtilityID = @UtilityID
			 AND AccountNumber = @AccountNumber
			 AND FieldName = @FieldName
			 AND EffectiveDate > getdate()
   
   SET NOCOUNT OFF;
END;
GO
