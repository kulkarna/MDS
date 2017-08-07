use lp_transactions
Go


ALTER TABLE lp_transactions..NysegAccount
  Add BillGroup varchar(50)
  
  GO
  
ALTER TABLE lp_transactions..RgeAccount
  Add BillGroup varchar(50)
  
  
  GO  
/*******************************************************************************  
 * usp_NysegAccountInsert  
 * Insert a new Nyseg account  
 *  
 * History  
 * 06/15/2010 - moved meter number from usage to account (EP)  
 * 12/08/2010 - returning dataset/latest inserted row  
 * 9/7/2011 - Rick Deigsler - added Icap 
 * 07/16/2015 - Vikas Sharma - added BillGroup 
 *******************************************************************************  
 * 06/14/2010 - Eduardo Patino  
 * Created.  
 *******************************************************************************  
 */  
  
ALTER PROCEDURE [dbo].[usp_NysegAccountInsert]  
 @AccountNumber   varchar(50),  
 @CustomerName    varchar(250) = null,  
 @CurrentRateCategory varchar(50)  = null,  
 @FutureRateCategory  varchar(50)  = null,  
 @RevenueClass   varchar(50)  = null,  
 @LoadShapeID   varchar(50)  = null,  
 @Grid     varchar(50)  = null,  
 @TaxJurisdiction  varchar(50)  = null,  
 @TaxDistrict   varchar(50)  = null,  
 @MailingStreet   varchar(100) = null,  
 @MailingCity     varchar(100) = null,  
 @MailingZipCode    varchar(50)  = null,  
 @MailingStateCode       varchar(20)  = null,  
 @ServiceStreet   varchar(100) = null,  
 @ServiceCity     varchar(100) = null,  
 @ServiceZipCode    varchar(50)  = null,  
 @ServiceStateCode  varchar(20)  = null,  
 @MeterNumber   varchar(50)  = null,  
 @createdBy    varchar(30),  
 @Icap     decimal(12,6),
 @BillGroup varchar(50)  
AS  
BEGIN  
/*  
 SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.  
 select * from sys.procedures where name like '%nyseg%'  
*/  
 SET NOCOUNT ON;  
 DECLARE @Id BIGINT  
  
    -- Insert statements for procedure here  
 INSERT INTO NysegAccount  
     (AccountNumber,  
   CustomerName,  
   MeterNumber,  
   CurrentRateCategory,  
   FutureRateCategory,  
   RevenueClass,  
   [Profile],  
   Grid,  
   TaxJurisdiction,  
   TaxDistrict,  
   MailingStreet,  
   MailingCity,  
   MailingZipCode,  
   MailingStateCode,  
   ServiceStreet,  
   ServiceCity,  
   ServiceZipCode,  
   ServiceStateCode,  
   CreatedBy,  
   Icap,
   BillGroup)  
     VALUES  
     (@AccountNumber,  
   @CustomerName,  
   @MeterNumber,  
   @CurrentRateCategory,  
   @FutureRateCategory,  
   @RevenueClass,  
   @LoadShapeID,  
   @Grid,  
   @TaxJurisdiction,  
   @TaxDistrict,  
   @MailingStreet,  
   @MailingCity,  
   @MailingZipCode,  
   @MailingStateCode,  
   @ServiceStreet,  
   @ServiceCity,  
   @ServiceZipCode,  
   @ServiceStateCode,  
   @createdBy,  
   @Icap,
   @BillGroup);  
  
 SELECT @Id = SCOPE_IDENTITY()  
  
 SELECT ID, AccountNumber, CustomerName, MeterNumber, CurrentRateCategory, FutureRateCategory, RevenueClass,   
   [Profile], Grid, TaxJurisdiction, TaxDistrict, MailingStreet, MailingCity, MailingZipCode,   
   MailingStateCode, ServiceStreet, ServiceCity, ServiceZipCode, ServiceStateCode, CreatedBy, Icap,BillGroup  
 FROM NysegAccount (nolock)  
 WHERE ID = @Id  
  
 SET NOCOUNT OFF;  
END  
  
  GO
  
  
/*******************************************************************************
 * usp_RgeAccountInsert
 * Insert a new Rge account
 *
 * History
 * 06/15/2010 - moved meter number from usage to account (EP)
 * 12/08/2010 - returning dataset/latest inserted row (EP)
 * 9/7/2011 - Rick Deigsler - added Icap
 * 07/16/2015 - Vikas Sharma	-  Added BillGroup Type varchar(50)
 *******************************************************************************
 * 06/09/2010 - Hamon Vitorino
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_RgeAccountInsert]
	@AccountNumber			varchar(50)  = null,
	@CustomerName 			varchar(250) = null,
	@CurrentRateCategory	varchar(50)  = null,
	@FutureRateCategory		varchar(50)  = null,
	@RevenueClass			varchar(50)  = null,
	@LoadShapeID			varchar(50)  = null,
	@Grid					varchar(50)  = null,
	@TaxJurisdiction		varchar(50)  = null,
	@TaxDistrict			varchar(50)  = null,
	@MailingStreet			varchar(100) = null,
	@MailingCity  			varchar(100) = null,
	@MailingZipCode  		varchar(50)  = null,
	@MailingStateCode       varchar(20)  = null,
	@ServiceStreet			varchar(100) = null,
	@ServiceCity  			varchar(100) = null,
	@ServiceZipCode  		varchar(50)  = null,
	@ServiceStateCode		varchar(20)  = null,
	@MeterNumber			varchar(50)  = null,
	@createdBy				varchar(30),
	@Icap					decimal(12,6),
	@BillGroup              varchar(50)  =null
AS
BEGIN
/*
select * from RgeAccount (nolock) --where accountnumber = 'R01000052224573' order by 1 desc
select * from RgeUsage (nolock) where accountnumber = 'R01000052224573' order by 2, 3, 4
select * from sys.procedures where name like '%rge%'
*/
	SET NOCOUNT ON;
	DECLARE	@Id BIGINT

    -- Insert statements for procedure here
	INSERT INTO RgeAccount
			([AccountNumber]
			,[CustomerName]
			,MeterNumber
			,[CurrentRateCategory]
			,[FutureRateCategory]
			,[RevenueClass]
			,[Profile]
			,[Grid]
			,[TaxJurisdiction]
			,[TaxDistrict]
			,[MailingStreet]
			,[MailingCity]
			,[MailingZipCode]
			,[MailingStateCode]
			,[ServiceStreet]
			,[ServiceCity]
			,[ServiceZipCode]
			,[ServiceStateCode]
			,[CreatedBy]
			,Icap
			,BillGroup)
	VALUES
			(@AccountNumber
			,@CustomerName
			,@MeterNumber
			,@CurrentRateCategory
			,@FutureRateCategory
			,@RevenueClass
			,@LoadShapeID
			,@Grid
			,@TaxJurisdiction
			,@TaxDistrict
			,@MailingStreet
			,@MailingCity
			,@MailingZipCode
			,@MailingStateCode
			,@ServiceStreet
			,@ServiceCity
			,@ServiceZipCode
			,@ServiceStateCode
			,@createdBy
			,@Icap
			,@BillGroup);

	SELECT	@Id	= SCOPE_IDENTITY()

	SELECT	Id, AccountNumber, CustomerName, MeterNumber, CurrentRateCategory, FutureRateCategory, RevenueClass, 
			[Profile], Grid, TaxJurisdiction, TaxDistrict, MailingStreet, MailingCity, MailingZipCode, 
			MailingStateCode, ServiceStreet, ServiceCity, ServiceZipCode, ServiceStateCode, Created, CreatedBy, Icap,BillGroup
	FROM	RgeAccount (nolock)
	WHERE	Id = @Id

	SET NOCOUNT OFF;
END

GO
  
/*******************************************************************************  
 * usp_NysegAccountGet  
 * Selects a Nyseg account  
 *  
 * History  
 * 4/25/2013: Get the latest account information by ID and not by Date Created  
 *******************************************************************************  
 * ? - ?  
 * Created.  
 * Modified by: Cathy Ghazal
 *07/16/2015 - Vikas Sharma Modify for Bill Group  
 *******************************************************************************  
 */  
  
ALTER PROCEDURE [dbo].[usp_NysegAccountGet]  
(@accountNumber as varchar(50))  
  
AS  
  
BEGIN  
 SET NOCOUNT ON;  
   
 DECLARE @ID as INT  
  
 --The NysegAccount table can hold more than one record per account/utility.   
 --We need to select the last one that was updated/inserted  
 SELECT @ID = MAX(ID)  
 FROM NysegAccount (NOLOCK)  
 WHERE AccountNumber = @accountNumber  
  
 SELECT ID, AccountNumber, Profile, Icap, Grid, CurrentRateCategory,BillGroup  
 FROM NysegAccount (NOLOCK)  
 WHERE AccountNumber = @accountNumber  
 AND  ID = @ID  
  
 SET NOCOUNT OFF;  
END  
  
  GO
    
/*******************************************************************************  
 * usp_RgeAccountGet  
 * Selects a Rge account  
 *  
 * History  
 * 5/14/2013: Get the latest account information by ID and not by Date Created  
 *******************************************************************************  
 * Created by: Cathy Ghazal  
 *******************************************************************************  
 */  
  
ALTER PROCEDURE [dbo].[usp_RgeAccountGet]  
(@accountNumber as varchar(50))  
  
AS  
  
BEGIN  
  
 SET NOCOUNT ON;  
  
 DECLARE @ID as INT  
  
 --The RgeAccount table can hold more than one record per account/utility.   
 --We need to select the last one that was updated/inserted  
 SELECT @ID = MAX(ID)  
 FROM RgeAccount (NOLOCK)  
 WHERE AccountNumber = @accountNumber  
  
 SELECT ID, AccountNumber,Profile, Icap, Grid, CurrentRateCategory,BillGroup  
 FROM RgeAccount (NOLOCK)  
 WHERE AccountNumber = @accountNumber  
 AND  ID = @ID  
  
 SET NOCOUNT OFF;  
END  
  
  
