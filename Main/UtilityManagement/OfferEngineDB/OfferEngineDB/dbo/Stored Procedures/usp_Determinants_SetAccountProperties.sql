CREATE PROCEDURE [dbo].[usp_Determinants_SetAccountProperties]
@PropertiesXml AS XML,
@UseInternalTran BIT = 1

AS
SET NOCOUNT ON;

/*

<?xml version="1.0" encoding="utf-16"?>
<ServiceAccountProperties xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Utility>ACE</Utility>
  <AccountNumber>2832615127</AccountNumber>
  <Properties>
    <ServiceAccountProperty>
      <UpdateSource>Crm</UpdateSource>
      <UpdateUser>dsavasteev</UpdateUser>
      <LockStatus>NotLocked</LockStatus>
      <Name>TCap</Name>
      <Value>11.1</Value>
      <EffectiveDate>2013-07-05T16:29:45.8756836-04:00</EffectiveDate>
    </ServiceAccountProperty>
    <ServiceAccountProperty>
      <UpdateSource>Crm</UpdateSource>
      <UpdateUser>dsavasteev</UpdateUser>
      <LockStatus>NotLocked</LockStatus>
      <Name>ICap</Name>
      <Value>22.2</Value>
      <EffectiveDate>2013-07-05T16:29:45.8756836-04:00</EffectiveDate>
    </ServiceAccountProperty>
  </Properties>
</ServiceAccountProperties>

*/

DECLARE 
	@UtilityID AS VARCHAR(80),
	@AccountNumber AS VARCHAR(50);

SELECT 
		 @UtilityID = M.Item.query('./Utility').value('.','VARCHAR(80)')
		,@AccountNumber = M.Item.query('./AccountNumber').value('.','VARCHAR(50)')
FROM @PropertiesXml.nodes('/ServiceAccountProperties') AS M(Item);

DECLARE @Properties AS TABLE
(
      [Count] [INT] IDENTITY(1,1) NOT NULL,
      [UtilityID] VARCHAR(80) NULL ,
      [AccountNumber] VARCHAR(50) NULL ,
      [FieldName] VARCHAR(60) NULL ,
      [FieldValue] VARCHAR(60) NULL ,
      [EffectiveDate] DATETIME NULL ,
      [FieldSource] VARCHAR(60) NULL ,
      [CreatedBy] VARCHAR(256) NULL ,
      [DateCreated] DATETIME NULL ,
      [LockStatus] VARCHAR(60) NULL ,
      [Active] BIT NULL
);

INSERT INTO @Properties
        ( 
          UtilityID ,
          AccountNumber ,
          FieldName ,
          FieldValue ,
          EffectiveDate ,
          FieldSource ,
          CreatedBy ,
          DateCreated ,
          LockStatus ,
          Active
        )
SELECT 
		@UtilityID
		,@AccountNumber
		,M.Item.query('./Name').value('.','VARCHAR(60)')
		,M.Item.query('./Value').value('.','VARCHAR(60)')
		,M.Item.query('./EffectiveDate').value('.','DATETIME')
		,M.Item.query('./UpdateSource').value('.','VARCHAR(60)')
		,M.Item.query('./UpdateUser').value('.','VARCHAR(256)')
		,GETDATE()
		,M.Item.query('./LockStatus').value('.','VARCHAR(60)')
		,1
FROM @PropertiesXml.nodes('/ServiceAccountProperties/Properties/ServiceAccountProperty') AS M(Item);

DECLARE
      @FieldName VARCHAR(60),
      @FieldValue VARCHAR(60),
      @EffectiveDate DATETIME ,
      @FieldSource VARCHAR(60) ,
      @CreatedBy VARCHAR(256) ,
      @DateCreated DATETIME ,
      @LockStatus VARCHAR(60) ,
      @Active BIT,
      @PropCount INT = (SELECT MAX([Count]) FROM @Properties),
      @Row INT = 1;
      
DECLARE @BlockSelectOutput AS TABLE
(
	ID [BIGINT],
	UtilityID VARCHAR(80),
	AccountNumber VARCHAR(50),
	FieldName VARCHAR(60),
	FieldValue VARCHAR(60),
	EffectiveDate DATETIME,
	FieldSource VARCHAR(60),
	UserIdentity VARCHAR(256),
	DateCreated DATETIME,
	LockStatus VARCHAR(60),
	ACTIVE BIT
);


BEGIN TRY
	IF @UseInternalTran = 1 BEGIN TRAN
		WHILE @Row <= @PropCount BEGIN
			SELECT
				@FieldName = FieldName,
				@FieldValue = FieldValue,
				@EffectiveDate = EffectiveDate,
				@FieldSource =  FieldSource,
				@CreatedBy = CreatedBy,
				@DateCreated = DateCreated,
				@LockStatus =  LockStatus,
				@Active = Active
			FROM 
				@Properties WHERE [Count] = @Row;
			
			INSERT INTO @BlockSelectOutput 
			EXEC [dbo].[usp_Determinants_FieldValueInsert]
				@UtilityID = @UtilityID,
				@AccountNumber = @AccountNumber,
				@FieldName = @FieldName,
				@FieldValue = @FieldValue,
				@EffectiveDate = @EffectiveDate,
				@FieldSource = @FieldSource,
				@UserIdentity = @CreatedBy,
				@LockStatus = @LockStatus,
				@DateCreated = @DateCreated,
				@IsActive = @Active,
				@UseInternalTran = 0
		
			SET @Row = @Row + 1;
		END
	
    IF @UseInternalTran = 1 COMMIT TRAN
END TRY
BEGIN CATCH
	IF @UseInternalTran = 1 ROLLBACK TRAN
	DECLARE 
		@ErrorMessage NVARCHAR(4000),
		@ErrorSeverity INT,
		@ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();
           
    RAISERROR (@ErrorMessage,
               @ErrorSeverity,
               @ErrorState );
END CATCH
