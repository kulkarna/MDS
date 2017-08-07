USE LibertyPower;

GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
IF EXISTS(SELECT TOP 1 1
            FROM sys.objects WITH (NOLOCK)
            WHERE name = 'usp_QualifierPromoCodeStartEndDateValidation'
              AND type_desc = 'SQL_STORED_PROCEDURE')
    BEGIN
        DROP PROCEDURE usp_QualifierPromoCodeStartEndDateValidation
    END;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_QualifierPromoCodeStartEndDateValidation] 
 * PURPOSE:		To validate if Promo Code is not assigned to another Campaign which has an overlapping effective period
 * HISTORY:		 
 *******************************************************************************
 * 01/02/2013 - Pradeep Katiyar
 * Created.
 * 01/28/2014 - Pradeep Katiyar
 * Updated. Updated for validation check
 *******************************************************************************
 */

CREATE PROCEDURE dbo.usp_QualifierPromoCodeStartEndDateValidation @p_CampaignId int, 
                                                                  @p_PromotionCodeId int, 
                                                                  @p_SignStartDate datetime=NULL, 
                                                                  @p_SignEndDate datetime=NULL
AS
BEGIN
    -- set nocount on and default isolation level
    SET NOCOUNT ON;
    --SET NO_BROWSETABLE OFF
    SELECT DISTINCT qf.CampaignId, 
                    C.Code
      FROM LibertyPower..Qualifier qf WITH (NOLock)
           INNER JOIN LibertyPower..Campaign C WITH (NoLock)
           ON qf.CampaignId = C.CampaignId
      WHERE qf.PromotionCodeId = @p_PromotionCodeId 
		AND  qf.CampaignId<>@p_CampaignId
        AND ((qf.SignStartDate BETWEEN @p_SignStartDate AND @p_SignEndDate)
          OR (qf.SignEndDate BETWEEN @p_SignStartDate AND @p_SignEndDate)
          OR ( @p_SignStartDate BETWEEN qf.SignStartDate AND qf.SignEndDate)
          --AND :modified AND to OR  Jan 28 
         OR (@p_SignEndDate BETWEEN qf.SignStartDate AND qf.SignEndDate));

    SET NOCOUNT OFF;
END

GO

