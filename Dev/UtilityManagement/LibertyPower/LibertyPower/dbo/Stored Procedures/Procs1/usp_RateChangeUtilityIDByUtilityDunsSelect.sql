

/* -----------------------------------------------------------------------------------
   PROCEDURE:    [usp_RateChangeUtilityIDByUtilityDunsSelect]

   AUTHOR:       Christopher Evans 5/5/2010 4:07:33 PM
   ----------------------------------------------------------------------------------- */

CREATE PROCEDURE [dbo].[usp_RateChangeUtilityIDByUtilityDunsSelect]
(
 @AccountNumber varchar(30) ,
 @UtilityDuns varchar(30) )
AS
BEGIN

      SELECT
          a.utility_id
      FROM
          lp_account..account a
      LEFT JOIN LibertyPower..Utility u
      ON  a.utility_id = u.UtilityCode
      WHERE
          a.account_number = @AccountNumber
          AND u.DunsNumber = @UtilityDuns


END



