USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapsSelect]    Script Date: 05/01/2013 17:01:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldMapsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldMapsSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapsSelect]    Script Date: 05/01/2013 17:01:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_FieldMapsSelect
 * Gets mapping for a date
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_FieldMapsSelect] @ContextDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;

	CREATE TABLE #Max (ID INT PRIMARY KEY)
	
	INSERT INTO #max
		SELECT MAX( da.ID )  
		FROM DeterminantFieldMaps da WITH ( NOLOCK )  
		WHERE da.DateCreated <= @ContextDate  AND (da.ExpirationDate IS NULL OR da.ExpirationDate > @ContextDate)
		GROUP BY da.UtilityCode ,  
		da.DeterminantFieldName ,  
		da.DeterminantValue 
	
	
	SELECT d.ID ,  
	d.UtilityCode ,  
	d.DeterminantFieldName ,  
	d.DeterminantValue ,  
	d.MappingRuleType ,  
	d.CreatedBy ,  
	r.ResultantFieldName ,  
	r.ResultantFieldValue
	FROM #Max t
	JOIN DeterminantFieldMaps d (nolock) ON d.ID = t.ID
	LEFT JOIN  DeterminantFieldMapResultants r (nolock) ON d.ID = r.FieldMapID  
	ORDER BY d.ID , d.UtilityCode , d.DeterminantFieldName , d.DeterminantValue;  

	SET NOCOUNT OFF;

END;



GO


