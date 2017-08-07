


CREATE PROCEDURE [dbo].[usp_Determinants_AccountCurrentPropertiesSelectXml]
	@UtilityCode varchar(80),
	@AccountNumber varchar(50),
	@PropertiesXml XML,
	@ContextDate DATETIME = NULL
AS

	DECLARE @AccountPropertyHistory TABLE (
		AccountPropertyHistoryID BIGINT ,
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
	EXECUTE [dbo].[usp_Determinants_AccountCurrentPropertiesSelect] 
	   @UtilityCode
	  ,@AccountNumber
	  ,@PropertiesXml
	  ,@ContextDate
	  
	  
	SELECT  @UtilityCode AS Utility ,
        @AccountNumber AS AccountNumber ,
        ( SELECT    FieldName AS Name ,
                    FieldValue AS [Value] ,
                    EffectiveDate ,
                    FieldSource AS UpdateSource ,
                    UserIdentity AS UpdateUser ,
                    LockStatus
          FROM      @AccountPropertyHistory
        FOR
          XML PATH('ServiceAccountProperty') ,
              TYPE
        ) Properties
FOR XML PATH('ServiceAccountProperties')


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_Determinants_AccountCurrentPropertiesSelectXml] TO [LIBERTYPOWER\phasselbring]
    AS [dbo];

