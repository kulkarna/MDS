USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountDeleteDoNotEnroll]    Script Date: 04/23/2012 15:04:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rafael Vasconcelos
-- Create date: 5/15/2012
-- Description:	Logical delete for accounts marked as "do not enroll"
-- =============================================
CREATE PROCEDURE [dbo].[usp_AccountDeleteDoNotEnroll] 
	@AccountNumber VARCHAR(30) 
AS
BEGIN

	SET NOCOUNT ON
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	UPDATE
	AD
	SET
	AD.EnrollmentTypeID = 1	
	FROM
	LibertyPower..AccountDetail AD	
	LEFT JOIN LibertyPower..Account A ON A.AccountID = AD.AccountID
	WHERE AD.EnrollmentTypeID = 9
	AND A.AccountNumber = @AccountNumber
	
END
