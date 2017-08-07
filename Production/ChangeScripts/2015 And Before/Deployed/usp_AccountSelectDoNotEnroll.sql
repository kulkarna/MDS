USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountSelectDoNotEnroll]    Script Date: 04/23/2012 15:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	ADT.NumberOfDays as expirationDays
	
	FROM
	LibertyPower..Account A 
	LEFT JOIN lp_account..account_address AA (nolock) ON A.BillingAddressID = AA.AccountAddressID
	LEFT JOIN lp_account..account_contact AC (nolock) ON A.BillingContactID = AC.AccountContactID
	LEFT JOIN lp_account..account_name AN (nolock) ON A.AccountNameID = AN.AccountNameID
	LEFT JOIN LibertyPower..Utility U (nolock) ON A.UtilityID = U.ID
	LEFT JOIN LibertyPower..AccountDetail AD (nolock) ON A.AccountID = AD.AccountID
	LEFT JOIN LibertyPower..AccountDateDetails ADT (nolock) ON ADT.AccountID = A.AccountID
	WHERE AD.EnrollmentTypeID = 9
	order by requestedDate desc
	
END
