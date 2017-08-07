-- =============================================
-- Author:		Rafael Vasconcelos
-- Modified date: 7/3/2012
-- Description:	Changed joins with account_contact, account_address and account_name. They are using the AccountID instead of using address, contact and name ID keys. 				
-- =============================================
-- =============================================
-- Author:		Rafael Vasconcelos
-- Modified date: 6/21/2012
-- Description:	Select comments from account_comments				
-- =============================================
-- =============================================
-- Author:		Rafael Vasconcelos
-- Create date: 5/15/2012
-- Description:	Selects all accounts marked as "do not enroll". 
--				Used for the Gridview in send_do_not_enroll_account.aspx (Enrollment app)
-- =============================================
CREATE PROCEDURE [dbo].[usp_AccountSelectDoNotEnroll] 
AS
BEGIN

	SET NOCOUNT ON
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT
	A.AccountNumber as accountNumber,
	AN.Full_name as accountName,
	U.UtilityCode as utilityCode,
	AC.Phone as phone,
	AA.Address as address,
	AA.State as state,
	AA.City as city,
	AA.Zip as zip,
	A.DateCreated as requestedDate,
	ADT.ExpirationDate as expirationDate,
	ADT.NumberOfDays as expirationDays,
	ACM.comment 
	
	FROM
	LibertyPower..Account A (nolock)
	LEFT JOIN lp_account..account_address AA (nolock) ON A.AccountIDLegacy = AA.account_id
	LEFT JOIN lp_account..account_contact AC (nolock) ON A.AccountIDLegacy = AC.account_id
	LEFT JOIN lp_account..account_name AN (nolock) ON A.AccountIDLegacy = AN.account_id
	LEFT JOIN LibertyPower..Utility U (nolock) ON A.UtilityID = U.ID
	LEFT JOIN LibertyPower..AccountDetail AD (nolock) ON A.AccountID = AD.AccountID
	LEFT JOIN LibertyPower..AccountDateDetails ADT (nolock) ON ADT.AccountID = A.AccountID
	LEFT JOIN lp_account..account_comments ACM (nolock) ON A.AccountIdLegacy = ACM.account_id
	WHERE AD.EnrollmentTypeID = 9
	order by requestedDate desc
	
END
