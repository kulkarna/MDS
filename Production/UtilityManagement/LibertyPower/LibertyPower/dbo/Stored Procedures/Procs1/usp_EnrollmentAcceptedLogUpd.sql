
-- =============================================
-- Created: Isabelle Tamanini 3/22/2012
-- Updates the RateUpdateSentToISTA flag of an account
-- SD24065
-- =============================================

CREATE PROCEDURE [dbo].[usp_EnrollmentAcceptedLogUpd]
	@AccountID INT,
	@RateUpdateSentToIsta bit = 1
AS
BEGIN

	UPDATE Libertypower.dbo.EnrollmentAcceptedLog
	SET RateUpdateSentToIsta = @RateUpdateSentToIsta
	WHERE AccountID = @AccountID 
	
END
