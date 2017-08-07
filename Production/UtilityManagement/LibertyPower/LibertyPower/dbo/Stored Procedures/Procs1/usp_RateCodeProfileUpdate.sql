

CREATE PROCEDURE [dbo].[usp_RateCodeProfileUpdate]
       @UtilityID nvarchar(50) ,
       @ServiceClass nvarchar(50) ,
       @Zone nvarchar(50) ,
       @MeterType nvarchar(50) ,
       @RateCodeFormat int ,                      --lp_common..rate_code_format                                                            
       @RateCodeFields int ,						--lp_common..rate_code_fields
       @RateCodePreference int ,						--libertypower..RateCodePreferenceBySlice
       @UserID int
AS
BEGIN TRANSACTION

IF NOT EXISTS ( SELECT
                    RateCodePreference rc
                FROM
                    libertypower..RateCodePreferenceBySlice rc
                WHERE
                    rc.Utility = @UtilityID
                    AND rc.ServiceClass = @ServiceClass
                    AND rc.Zone = @Zone
                    AND rc.MeterType = @MeterType )
   BEGIN

         INSERT INTO
             LibertyPower..RateCodePreferenceBySlice
             (
               Utility , ServiceClass , Zone , MeterType , RateCodePreference , CreatedBy , ModifiedBy )
         VALUES
             (
               @UtilityID , @ServiceClass , @Zone , @MeterType , @RateCodePreference , @UserID , @UserID )

   END
ELSE
   BEGIN

         UPDATE
             LibertyPower..RateCodePreferenceBySlice
         SET
             RateCodePreference = @RateCodePreference ,
             ModifiedBy = @UserID ,
             DateModified = GETDATE()
         WHERE
             Utility = @UtilityID
             AND ServiceClass = @ServiceClass
             AND Zone = @Zone
             AND MeterType = @MeterType

   END

UPDATE LibertyPower..Utility 
SET 
	RateCodeFormat = @RateCodeFormat, 
	RateCodeFields = @RateCodeFields
WHERE
	UtilityCode = @UtilityID
	

IF @@ERROR = 0
   COMMIT
ELSE
   ROLLBACK

SELECT
    c.utility_id , rc.ServiceClass , rc.Zone , rc.MeterType , c.rate_code_fields , c.rate_code_format , rc.RateCodePreference
FROM
    lp_common..common_utility c
LEFT JOIN libertypower..RateCodePreferenceBySlice rc
ON  c.utility_id = rc.Utility
WHERE
    c.utility_id = @UtilityID
    AND rc.ServiceClass = @ServiceClass
    AND rc.Zone = @Zone
    AND rc.MeterType = @MeterType
 
-- Copyright 2009 Liberty Power





GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeProfileUpdate';

