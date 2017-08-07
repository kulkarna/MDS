USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueHistorySelect]    Script Date: 07/13/2013 11:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldValueHistorySelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueHistorySelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueHistorySelect]    Script Date: 07/13/2013 11:49:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueHistorySelect] @UtilityID varchar( 80 ) ,
                                                             @AccountNumber varchar( 50 ) ,
                                                             @FieldName varchar( 60 ) = 'ALL' ,
                                                             @ContextDate datetime
AS
BEGIN
	SET NOCOUNT ON;

    IF @FieldName = 'ALL'
        BEGIN
            SELECT LH.AccountPropertyHistoryID AS ID,
                   UtilityID ,
                   AccountNumber ,
                   FieldName ,
                   FieldValue ,
                   CAST(EffectiveDate AS Date) AS EffectiveDate,
                   FieldSource ,
                   LH.CreatedBy AS UserIdentity ,
                   LH.DateCreated ,
                   LH.LockStatus ,
                   Active
              FROM AccountPropertyHistory PH WITH (NOLOCK)
              INNER JOIN AccountPropertyLockHistory LH WITH (NOLOCK) ON PH.AccountPropertyHistoryID = LH.AccountPropertyHistoryID
              WHERE UtilityID = @UtilityID
                AND AccountNumber = @AccountNumber
                AND  CAST(EffectiveDate AS Date) <= @ContextDate
                AND Active = 1
              ORDER BY LH.DateCreated DESC , FieldName;
        END;
    ELSE
        BEGIN
            SELECT LH.AccountPropertyHistoryID AS ID,
                   UtilityID ,
                   AccountNumber ,
                   FieldName ,
                   FieldValue ,
                    CAST(EffectiveDate AS Date) AS EffectiveDate,
                   FieldSource ,
                   LH.CreatedBy AS UserIdentity ,
                   LH.DateCreated ,
                   LH.LockStatus ,
                   Active
              FROM AccountPropertyHistory PH WITH (NOLOCK)
              INNER JOIN AccountPropertyLockHistory LH WITH (NOLOCK) ON PH.AccountPropertyHistoryID = LH.AccountPropertyHistoryID
              WHERE UtilityID = @UtilityID
                AND AccountNumber = @AccountNumber
                AND FieldName = @FieldName
                AND  CAST(EffectiveDate AS Date) <= @ContextDate
                AND Active = 1
                ORDER BY LH.DateCreated DESC;
        END;

		SET NOCOUNT OFF;
END;




GO


