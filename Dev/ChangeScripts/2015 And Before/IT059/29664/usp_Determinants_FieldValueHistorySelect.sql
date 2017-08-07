USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueHistorySelect]    Script Date: 01/02/2014 21:33:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldValueHistorySelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueHistorySelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueHistorySelect]    Script Date: 01/02/2014 21:33:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_GetConsolidatedUsage
 * retrieves usage from the consolidated usage table
 *
 * History
 *
 *******************************************************************************
 * Created - Chris Evans (date unknown)
  
 *******************************************************************************
 * Modifed - Jikku Joseph John
 1/14/2014
  Purpose - Added new nullable parameters PriceRequestID and OfferID and made existing parameters @UtilityID and @AccountNumber nullable
 */

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueHistorySelect] @UtilityID varchar( 80 ) =null,
                                                             @AccountNumber varchar( 50 ) =null,
                                                             @FieldName varchar( 60 ) = 'ALL' ,
                                                             @ContextDate datetime,
                                                             @PriceRequestID varchar(50) =null,
                                                             @OfferID varchar(50) =null
AS
BEGIN
	SET NOCOUNT ON;

    IF @FieldName = 'ALL'
        BEGIN
			IF @OfferID IS NOT NULL
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
				INNER JOIN OfferEngineDB..OE_ACCOUNT  OA (NOLOCK) ON OA.UTILITY = PH.UtilityID AND OA.ACCOUNT_NUMBER = PH.AccountNumber
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS OOA WITH (NOLOCK) ON OOA.OE_ACCOUNT_ID=OA.ID
				WHERE OOA.OFFER_ID = @OfferID
				AND  CAST(EffectiveDate AS Date) <= @ContextDate
				AND Active = 1
			ELSE IF @PriceRequestID IS NOT NULL
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
				INNER JOIN OfferEngineDB..OE_ACCOUNT  OA (NOLOCK) ON OA.UTILITY = PH.UtilityID AND OA.ACCOUNT_NUMBER = PH.AccountNumber
				INNER JOIN OfferEngineDB..OE_PRICING_REQUEST_ACCOUNTS OPRA (NOLOCK) ON OPRA.OE_ACCOUNT_ID=OA.ID
				WHERE OPRA.PRICING_REQUEST_ID = @PriceRequestID
				AND  CAST(EffectiveDate AS Date) <= @ContextDate
				AND Active = 1
			ELSE
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
			
        END
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


