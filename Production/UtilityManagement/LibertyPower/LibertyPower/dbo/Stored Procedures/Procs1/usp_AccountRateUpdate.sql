

CREATE PROCEDURE [dbo].[usp_AccountRateUpdate]
(
	@UtilityID [varchar](50) ,
	@AccountNumber [varchar](50) ,
	@Rate [decimal](18,10),
	@RateCode [varchar](50) = NULL,
	@ModifiedBy	[varchar] (100)
)
AS
BEGIN

      UPDATE
          lp_account..account
      SET
          
          rate = @Rate,
          rate_code = @RateCode, 
          ModifiedBy = @ModifiedBy,
          Modified = getdate()
 WHERE
          account_number = @AccountNumber
			AND
		  utility_id = @UtilityID
		 
		SELECT utility_id, account_number, rate, rate_code,  Modified, modifiedBy from lp_account..account
        WHERE
			account_number = @AccountNumber
				AND
			utility_id = @UtilityID
         
END

