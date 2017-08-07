-- =============================================
-- Author:		Rafael Vasconcelos
-- Create date: 5/15/2012
-- Description:	Check if an account is marked as "do not enroll". 
--				Used in the deal_capture_contract_express.aspx (Deal Capture app)
-- =============================================
CREATE PROCEDURE [dbo].[usp_CheckIfAccountIsDoNotEnroll]
	(@AccountNumber		VARCHAR(30))
AS
BEGIN
	SET NOCOUNT ON
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	--DOING EVERYTHING THE FAST WAY
	DECLARE @EnrollmentTypeID	AS INT
	DECLARE @Result				AS BIT
	
	SET		@Result				= 0
	
	SELECT @EnrollmentTypeID = AD.EnrollmentTypeID FROM LibertyPower..Account (NOLOCK) A
	JOIN LibertyPower..AccountDetail AD (NOLOCK) ON A.AccountID = AD.AccountID
	WHERE A.AccountNumber = @AccountNumber
	
	IF(@EnrollmentTypeID = 9)
	BEGIN
		SET @Result = 1		
	END
	
	SELECT @Result
END
