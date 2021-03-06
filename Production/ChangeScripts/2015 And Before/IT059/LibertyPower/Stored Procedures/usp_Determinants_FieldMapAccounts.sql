USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapAccounts]    Script Date: 08/06/2013 11:11:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldMapAccounts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldMapAccounts]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapAccounts]    Script Date: 08/06/2013 11:11:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Determinants_FieldMapAccounts] 
    @UtilityCode varchar(80),   
    @DriverName varchar(80),
    @DriverValue  varchar(200)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT UtilityID, AccountNumber
		   FROM LibertyPower..AccountPropertyHistory WITH (NOLOCK)
		  WHERE AccountPropertyHistoryID IN(
		   SELECT MAX(AccountPropertyHistoryID) FROM  LibertyPower..AccountPropertyHistory WITH (NOLOCK) 
			  WHERE UtilityID = @UtilityCode
			  AND FieldName = @DriverName
			  AND FieldValue = @DriverValue
			  AND CAST(EffectiveDate AS Date) <= GETDATE()
			  AND Active = 1 
			  GROUP BY UtilityID, AccountNumber, FieldName, FieldValue
			  )

	SET NOCOUNT OFF;
END



GO


