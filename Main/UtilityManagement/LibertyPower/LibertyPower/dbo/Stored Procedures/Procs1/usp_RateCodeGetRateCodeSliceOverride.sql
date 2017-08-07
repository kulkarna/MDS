


/*******************************************************************************
 * [usp_RateCodeGetRateCodeSliceOverride]
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeGetRateCodeSliceOverride]
AS
SELECT DISTINCT
    Utility ,
    ServiceClass ,
    Zone ,
    MeterType ,
    RateCodePreference as [Slice Rate Code Preference]
   FROM  RateCodePreferenceBySlice
ORDER BY
    Utility ,
    ServiceClass ,
    Zone ,
    MeterType



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeGetRateCodeSliceOverride';

