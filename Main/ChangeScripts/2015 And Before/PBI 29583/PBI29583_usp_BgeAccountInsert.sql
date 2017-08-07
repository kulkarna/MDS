 USE lp_TRANSACTION
GO

/*******************************************************************************  
 * usp_BgeAccountInsert  
 * Inserts a new bge account  
 *  
 * History  
 * 01/27/2014 - adding fields CapPLCPrev, TransPLCPrev, 
				CapPLCEffectiveDt, CapPLCPrevEffectiveDt, TransPLCEffectiveDt, 
				TransPLCPrevEffectiveDt - by Felipe Medeiros
 * 12/09/2010 - returning dataset/latest inserted row (EP)  
 *******************************************************************************  
 * 2010.07.01 - Hamon Vitorino (hvitorino)  
 * Created.  
 *******************************************************************************  
 */  

 
ALTER PROCEDURE [dbo].[usp_BgeAccountInsert]  
 @CustomerName varchar(50) = null,  
 @CustomerSegment varchar(50) = null,  
 @TariffCode int = null,  
 @CapPLC decimal(12,6) = null,  
 @TransPLC decimal(12,6) = null,  
 @CapPLCPrev decimal(12,6) = null,  
 @TransPLCPrev decimal(12,6) = null, 
 @CapPLCEffectiveDt datetime = null,  
 @TransPLCEffectiveDt datetime = null,  
 @CapPLCPrevEffectiveDt datetime = null,  
 @TransPLCPrevEffectiveDt datetime= null,  
 @POLRType varchar(50) = null,  
 @BillGroup int = null,  
 @SpecialBilling varchar(50) = null,  
 @MultipleMeters varchar(5) = null,  
 @AccountNumber varchar(50) = null,  
 @ServiceAddressStreet varchar(50) = null,  
 @ServiceAddressCityName varchar(50) = null,  
 @ServiceAddressStateCode varchar(50) = null,  
 @ServiceAddressZipCode varchar(50) = null,  
 @BillingAddressStreet varchar(50) = null,  
 @BillingAddressCityName varchar(50) = null,  
 @BillingAddressStateCode varchar(50) = null,  
 @BillingAddressZipCode varchar(50) = null,  
 @CreatedBy varchar(50) = null  
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE @ID INT  
/*  
select * from BgeAccount (nolock) --where accountnumber = '9995587453' order by 1 desc  
select * from BgeUsage (nolock) where accountnumber = '9995587453' order by 2, 3, 4  
select * from sys.procedures where name like '%bge%'  
*/  
  
 INSERT INTO BgeAccount (AccountName, CustomerSegment, TariffCode, CapPLC, CapPLCPrev, TransPLC, TransPLCPrev,  CapPLCEffectiveDt, 
	CapPLCPrevEffectiveDt, TransPLCEffectiveDt, TransPLCPrevEffectiveDt, POLRType, BillGroup, SpecialBilling, MultipleMeters, AccountNumber,  
    ServiceAddressStreet, ServiceAddressCityName, ServiceAddressStateCode, ServiceAddressZipCode, BillingAddressStreet, BillingAddressCityName,  
    BillingAddressStateCode, BillingAddressZipCode, Created, CreatedBy)  
 VALUES (@CustomerName, @CustomerSegment, @TariffCode, @CapPLC, @CapPLCPrev, @TransPLC, @TransPLCPrev, @CapPLCEffectiveDt, @CapPLCPrevEffectiveDt, 
	@TransPLCEffectiveDt, @TransPLCPrevEffectiveDt, @POLRType, @BillGroup, @SpecialBilling, @MultipleMeters, @AccountNumber,  
    @ServiceAddressStreet, @ServiceAddressCityName, @ServiceAddressStateCode, @ServiceAddressZipCode, @BillingAddressStreet, @BillingAddressCityName,  
    @BillingAddressStateCode, @BillingAddressZipCode, GETDATE(), @CreatedBy)  
  
 SELECT @Id = SCOPE_IDENTITY()  
  
 SELECT Id, AccountName, CustomerSegment, TariffCode, CapPLC, CapPLCPrev, TransPLC, TransPLCPrev,  CapPLCEffectiveDt, 
	CapPLCPrevEffectiveDt, TransPLCEffectiveDt, TransPLCPrevEffectiveDt, POLRType, BillGroup, SpecialBilling, MultipleMeters, AccountNumber, ServiceAddressStreet,  
	ServiceAddressCityName, ServiceAddressStateCode, ServiceAddressZipCode, BillingAddressStreet, BillingAddressCityName, BillingAddressStateCode, BillingAddressZipCode,  
	Created, CreatedBy, Modified, ModifiedBy  
 FROM BgeAccount (nolock)  
 WHERE ID = @ID  
  
 SET NOCOUNT OFF;  
  
END  
-- Copyright 2010 Liberty Power  
  