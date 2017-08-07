USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]    Script Date: 10/14/2013 17:02:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_AccountCurrentPropertiesSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]    Script Date: 10/14/2013 17:02:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]
	@UtilityCode varchar(80),
	@AccountNumber varchar(50),
	@PropertiesXml XML,
	@ContextDate DATETIME = NULL
AS

	DECLARE @Properties TABLE (
		FieldName VARCHAR(60)
	);
	
	IF @ContextDate IS NULL
		SET @ContextDate = GETDATE()
    
	INSERT INTO @Properties (FieldName)
	SELECT M.Item.query('.').value('.','VARCHAR(60)')
	FROM @PropertiesXml.nodes('/Properties/Name') AS M(Item);
		
	DECLARE @AccountPropertyHistory TABLE (
		ID BIGINT ,
		UtilityID VARCHAR(80) ,
		AccountNumber VARCHAR(50) ,
		FieldName VARCHAR(60) ,
		FieldValue VARCHAR(60) ,
		EffectiveDate DATETIME ,
		FieldSource VARCHAR(60) ,
		UserIdentity VARCHAR(256) ,
		DateCreated DATETIME ,
		LockStatus VARCHAR(60) ,
		Active BIT
	);
	
	INSERT INTO @AccountPropertyHistory
		SELECT  H.AccountPropertyHistoryID ,
				H.UtilityID ,
				H.AccountNumber ,
				H.FieldName ,
				H.FieldValue ,
				CAST(H.EffectiveDate AS Date) AS EffectiveDate ,
				H.FieldSource ,
				H.CreatedBy ,
				H.DateCreated ,
				H.LockStatus ,
				H.Active
		FROM    AccountPropertyHistory H ( NOLOCK ) INNER JOIN @Properties P ON H.FieldName = P.FieldName
		WHERE   UtilityID = @UtilityCode
				AND AccountNumber = @AccountNumber
				AND CAST(H.EffectiveDate AS Date) <= @ContextDate
				AND Active = 1
				
	SELECT  
				HO.ID,
				@UtilityCode AS UtilityID,
				@AccountNumber AS AccountNumber,
				P.FieldName,
				HO.FieldValue,
				CAST(HO.EffectiveDate AS Date) AS EffectiveDate ,
				HO.FieldSource,
				HO.UserIdentity,
				HO.DateCreated,
				HO.LockStatus,
				HO.Active
	  FROM      @Properties P
				CROSS APPLY ( SELECT TOP 1
										Locked.*
							  FROM      @AccountPropertyHistory Locked
							  WHERE     Locked.FieldName = P.FieldName
										AND LockStatus IN ( 'Locked' )
							  ORDER BY  Locked.ID DESC
							  UNION
							  SELECT TOP 1
										Unknown.*
							  FROM      @AccountPropertyHistory Unknown
							  WHERE     Unknown.FieldName = P.FieldName
										AND Unknown.LockStatus NOT IN ( 'Locked' )
										AND NOT EXISTS (	SELECT 1 
															FROM  @AccountPropertyHistory LH 
															WHERE LH.FieldName = Unknown.FieldName AND LH.LockStatus IN ( 'Locked' ))
							  ORDER BY  Unknown.ID DESC
							) HO

GO


