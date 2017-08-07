


CREATE PROCEDURE [dbo].[usp_Determinants_AccountCurrentPropertiesSelectByUpDate]
	@FromUpdateDate DATETIME,
	@ToUpdateDate DATETIME
AS

	DECLARE @UpdatedAccounts TABLE (
		UtilityID VARCHAR(80) ,
		AccountNumber VARCHAR(50)
	);
	
	INSERT INTO @UpdatedAccounts
		SELECT  DISTINCT 
				H.UtilityID ,
				H.AccountNumber
		FROM    AccountPropertyHistory H ( NOLOCK ) 
		WHERE 
		(	--modified within specified range
			(H.DateCreated >= @FromUpdateDate AND H.DateCreated < @ToUpdateDate)
			OR 
			--becoming effective within specified range
			(H.EffectiveDate >= @FromUpdateDate AND H.EffectiveDate < @ToUpdateDate)
		)
		AND Active = 1
	
	DECLARE @Properties TABLE (
		FieldName VARCHAR(60)
	);
	
	INSERT INTO @Properties (FieldName)
	SELECT P.FieldName  
	FROM (
		SELECT 'AccountType' AS [FieldName] UNION ALL
		SELECT 'Grid' AS [FieldName] UNION ALL
		SELECT 'Icap' AS [FieldName] UNION ALL
		SELECT 'LbmpZone' AS [FieldName] UNION ALL
		SELECT 'LoadProfile' AS [FieldName] UNION ALL
		SELECT 'LoadShapeId' AS [FieldName] UNION ALL
		SELECT 'LossFactor' AS [FieldName] UNION ALL
		SELECT 'MeterType' AS [FieldName] UNION ALL
		SELECT 'RateClass' AS [FieldName] UNION ALL
		SELECT 'ServiceClass' AS [FieldName] UNION ALL
		SELECT 'TariffCode' AS [FieldName] UNION ALL
		SELECT 'Utility' AS [FieldName] UNION ALL
		SELECT 'Voltage' AS [FieldName] UNION ALL
		SELECT 'Zone' AS [FieldName] UNION ALL
		SELECT 'TCap' AS [FieldName] 
	) P

	DECLARE @AccountPropertyHistory TABLE (
		ID BIGINT ,
		UtilityID VARCHAR(80) ,
		AccountNumber VARCHAR(50) ,
		FieldName VARCHAR(60) ,
		FieldValue VARCHAR(60) ,
		EffectiveDate DATETIME ,
		DateCreated DATETIME ,
		LockStatus VARCHAR(60)
	);
	
	INSERT INTO @AccountPropertyHistory (UtilityID, AccountNumber, FieldName)
		SELECT UA.UtilityID, UA.AccountNumber, P.FieldName FROM @UpdatedAccounts UA CROSS JOIN @Properties P

	UPDATE @AccountPropertyHistory 
	SET 
		ID = HU.AccountPropertyHistoryID,
		FieldValue = HU.LatestFieldValue,
		EffectiveDate = HU.EffectiveDate,
		DateCreated = HU.DateCreated,
		LockStatus = HU.LockStatus
	FROM @AccountPropertyHistory H CROSS APPLY 
	( 
		SELECT TOP 1
			AccountPropertyHistoryID, 
			FieldValue AS LatestFieldValue, 
			EffectiveDate, 
			DateCreated, 
			LockStatus
		FROM      
			AccountPropertyHistory ( NOLOCK )
		WHERE     
			FieldName = H.FieldName 
			AND UtilityID = H.UtilityID 
			AND AccountNumber = H.AccountNumber
		ORDER BY 
			AccountPropertyHistoryID DESC							  
	) HU
	
	UPDATE @AccountPropertyHistory 
	SET 
		ID = HU.AccountPropertyHistoryID,
		FieldValue = HU.LockedFieldValue,
		EffectiveDate = HU.EffectiveDate,
		DateCreated = HU.DateCreated,
		LockStatus = HU.LockStatus
	FROM @AccountPropertyHistory H CROSS APPLY 
	( 
		SELECT TOP 1
			AccountPropertyHistoryID, 
			FieldValue AS LockedFieldValue, 
			EffectiveDate, 
			DateCreated, 
			LockStatus
		FROM      
			AccountPropertyHistory ( NOLOCK )
		WHERE     
			FieldName = H.FieldName 
			AND UtilityID = H.UtilityID 
			AND AccountNumber = H.AccountNumber
			AND LockStatus IN ( 'Locked' )
		ORDER BY  
			AccountPropertyHistoryID DESC							  
	) HU
	WHERE HU.LockedFieldValue IS NOT NULL
	
	SELECT 
		UtilityID,
		AccountNumber,
		FieldName,
		CASE 
			WHEN FieldName = 'metertype' THEN
				CASE 
					WHEN FieldValue = 'IDR' THEN '2'
					ELSE '1'
				END
			ELSE
				FieldValue 
		END FieldValue,
		EffectiveDate,
		DateCreated,
		LockStatus
	FROM @AccountPropertyHistory ORDER BY UtilityID, AccountNumber, FieldName ASC
	RETURN;


