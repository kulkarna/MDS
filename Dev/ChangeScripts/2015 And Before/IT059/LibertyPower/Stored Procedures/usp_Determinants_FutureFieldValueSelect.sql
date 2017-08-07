USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FutureFieldValueSelect]    Script Date: 07/13/2013 11:50:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FutureFieldValueSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FutureFieldValueSelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FutureFieldValueSelect]    Script Date: 07/13/2013 11:50:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_Determinants_FutureFieldValueSelect] 
	@UtilityID varchar( 80 ),
	@AccountNumber varchar( 50 ),
	@FieldName varchar( 30 )
AS
BEGIN
	SET NOCOUNT ON;

	SELECT AccountPropertyHistoryID AS ID ,
		   UtilityID ,
		   AccountNumber ,
		   FieldName ,
		   FieldValue ,
		   CAST(EffectiveDate AS Date) As EffectiveDate ,
		   FieldSource ,
		   CreatedBy AS UserIdentity ,
		   DateCreated ,
		   LockStatus ,
		   Active
	  FROM AccountPropertyHistory WITH (NOLOCK)
	  WHERE UtilityID = @UtilityID
		AND AccountNumber = @AccountNumber
		AND FieldName = @FieldName
		AND CAST(EffectiveDate AS Date) > GetDate()
		AND Active = 1
	  ORDER BY AccountPropertyHistoryID DESC;

	  SET NOCOUNT OFF;
END;

GO


