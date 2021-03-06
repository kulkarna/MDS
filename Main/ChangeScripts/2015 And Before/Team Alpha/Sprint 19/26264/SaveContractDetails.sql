USE [Genie]
GO
/****** Object:  StoredProcedure [dbo].[SaveContractDetails_JFORERO]    Script Date: 11/27/2013 16:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		????
-- Create date: ????
-- Description:	Saves a new contract
-- 2012-12-28 Carlos Lima - Removed block for INSERT INTO [GENIE].[dbo].[WSLog] ([XMLData]) VALUES (@ContractXML)
-- =============================================
/*

exec [SaveContractDetails] @ContractXML = '<LibertyPower><Contract PartnerID="556" AgentID="783" ContractTypeID="1" MarketID="8" UtilityID="50" BusinessTypeID="7" AccountTypeID="2" BrandID="25" ProductSelection="PENELEC_G2_RES      " CustomerName="hhuj bhjjk" DBA="" EstimatedAnnualUsage="0" Duns="" TaxExempt="0" CertificateAtached="0" TemplateTypeID="1" ContactFirstName="hhuj" ContactLastName="bhjjk" ContactTitle="" ContactPhone="8568882222" ContactFax="" ContactEmail="customercareadmin@libertypowercorp.com" ContractSignDate="11/20/2013 01:26 PM" ContractCreatedDate="11/20/2013 01:25 PM" GPSLat="26.20412826538086" GPSLong="-80.16866302490234" LanguageID="1" EmailPreference="1" NumberOfAccounts="1" SSN="" TaxID="" IDType="SSN" EstimatedTaxRate="0.0" PromoCode="" EmailAddress="" AgreementVersion="MMPA-ESAG-LG-0813" AttachmentVersion="" TermsAndConditionsVersion="MMPA-FRTC-RES-LG-0813" AgreementDocID="0" AttachmentADocID="0" TermsAndConditionsDocID="0"><ServiceAccountDetail ServiceAccountNumber="54665766766777766666" MeterTypeID="1" UtilityID="50" ServiceClassID="401" ZoneID="40" EstimatedUsage="0" FlowStartMonth="10/1/2013" ContractTerm="12" RateID="256553064" TransferRate="0.08996" PartnerMarkup="0.0" ServiceAddress1="655 hhh" ServiceAddress2="" ServiceCity="ALLENSVILLE" ServiceState="PA" ServiceZip="17002" BillingSameAsService="true" BillingAccountNumber="" BillingAddress1="655 hhh" BillingAddress2="" BillingCity="ALLENSVILLE" BillingState="PA" BillingZip="17002" UtilityNameKey="" FlowStartDate="10/1/2013" FlowEndDate="10/1/2014" ServiceAccountName="" /><CTAdditionalFields NameKey="1245" BillingAccountNumber="34455556556" /></Contract></LibertyPower>'


exec [SaveContractDetails] @ContractXML = '<LibertyPower><Contract PartnerID="556" AgentID="783" ContractTypeID="1" MarketID="8" UtilityID="50" BusinessTypeID="7" AccountTypeID="2" BrandID="25" ProductSelection="PENELEC_G2_RES      " CustomerName="hhuj bhjjk" DBA="" EstimatedAnnualUsage="0" Duns="" TaxExempt="0" CertificateAtached="0" TemplateTypeID="1" ContactFirstName="hhuj" ContactLastName="bhjjk" ContactTitle="" ContactPhone="8568882222" ContactFax="" ContactEmail="customercareadmin@libertypowercorp.com" ContractSignDate="11/20/2013 01:26 PM" ContractCreatedDate="11/20/2013 01:25 PM" GPSLat="26.20412826538086" GPSLong="-80.16866302490234" LanguageID="1" EmailPreference="1" NumberOfAccounts="1" SSN="" TaxID="" IDType="SSN" EstimatedTaxRate="0.0" PromoCode="" EmailAddress="" AgreementVersion="MMPA-ESAG-LG-0813" AttachmentVersion="" TermsAndConditionsVersion="MMPA-FRTC-RES-LG-0813" AgreementDocID="0" AttachmentADocID="0" TermsAndConditionsDocID="0"><ServiceAccountDetail ServiceAccountNumber="54665766766777766666" MeterTypeID="1" UtilityID="50" ServiceClassID="401" ZoneID="40" EstimatedUsage="0" FlowStartMonth="10/1/2013" ContractTerm="12" RateID="256553064" TransferRate="0.08996" PartnerMarkup="0.0" ServiceAddress1="655 hhh" ServiceAddress2="" ServiceCity="ALLENSVILLE" ServiceState="PA" ServiceZip="17002" BillingSameAsService="true" BillingAccountNumber="" BillingAddress1="655 hhh" BillingAddress2="" BillingCity="ALLENSVILLE" BillingState="PA" BillingZip="17002" UtilityNameKey="" FlowStartDate="10/1/2013" FlowEndDate="10/1/2014" ServiceAccountName="" /></Contract></LibertyPower>'

*/
ALTER PROCEDURE [dbo].[SaveContractDetails] (@ContractXML varchar(max)) AS                          
SET NOCOUNT OFF                  
BEGIN                
   
   Begin try                
   
	  BEGIN TRANSACTION              
                
      DECLARE @idoc int                
      --Create an internal representation of the XML document.                
      EXEC sp_xml_preparedocument @idoc OUTPUT, @ContractXML                
      -- Execute a SELECT statement that uses the OPENXML rowset provider.                
      DECLARE @MaxContractID integer                    
      DECLARE @NameKey varchar(50);             
	  DECLARE @BillingAccountNumber varchar(50);
   
           
      IF EXISTS (Select 1 from T_contract)                
        SELECT @MaxContractID =MAX(isnull(ContractID,0))+1 from T_contract                    
      else                
        set @MaxContractID=1                 
                
      INSERT INTO T_contract (ContractID,PartnerID,AgentID,ContractTypeID, MarketID, UtilityID,                    
      BusinessTypeID, AccountTypeID,BrandID, ProductSelection, CustomerName,                    
      DBA, EstimatedAnnualUsage, Duns, TaxExempt, CertificateAtached,                    
      TaxExemptDocID, ContactFirstName, ContactLastName,ContactTitle,                    
      ContactPhone, ContactFax, ContactEmail,ContractSignDate,ContractCreatedDate,  
      GPSLat,GPSLong,LanguageID,EmailPreference,NumberOfAccounts,TaxID,SSN,EstimatedTaxRate,PromoCode,
      EmailAddress,AgreementVersion,AttachmentVersion,TermsAndConditionsVersion,AgreementDocID,AttachmentADocID,
      TermsAndConditionsDocID,Field01)                
      SELECT  @MaxContractID as ContractID,PartnerID,AgentID,ContractTypeID, MarketID, UtilityID,                    
      BusinessTypeID, AccountTypeID, BrandID, ProductSelection, CustomerName,                    
      DBA, EstimatedAnnualUsage, Duns, TaxExempt, CertificateAtached,                    
      TaxExemptDocID, ContactFirstName, ContactLastName,ContactTitle,                    
      ContactPhone, ContactFax, ContactEmail,CONVERT( datetime, ContractSignDate, 101) as ContractSignDate,  
      CONVERT( datetime, ContractCreatedDate, 101) as ContractCreatedDate,GPSLat,GPSLong,LanguageID,EmailPreference,  
      NumberOfAccounts,TaxID,SSN,EstimatedTaxRate, PromoCode, EmailAddress,AgreementVersion,AttachmentVersion,
      TermsAndConditionsVersion,AgreementDocID,AttachmentADocID,TermsAndConditionsDocID,IDType                
      FROM       OPENXML (@idoc, '/LibertyPower/Contract',1)                
         WITH (PartnerID  int,                
            AgentID int,                
            ContractTypeID int,                
            MarketID int,                
            UtilityID int,                
            BusinessTypeID int,                
            AccountTypeID int,                
            BrandID int,                
            ProductSelection varchar(50),                
            CustomerName varchar(100),                
            DBA varchar(100),                
            EstimatedAnnualUsage int,                
            Duns varchar(50),                
            TaxExempt bit,                
            CertificateAtached bit,                
            TaxExemptDocID int,                
            ContactFirstName varchar(50),                
            ContactLastName varchar(50),                
            ContactTitle varchar(20),                
            ContactPhone varchar(20),                
            ContactFax varchar(20),                
            ContactEmail nvarchar(512),                
            ContractSignDate datetime,                
            ContractCreatedDate datetime,                
            GPSLat float,                
            GPSLong float,                
            LanguageID int,                
            EmailPreference int,                
            NumberOfAccounts int,            
            TaxID varchar(50),        
            SSN varchar(MAX),        
            EstimatedTaxRate decimal(12,5),  
            PromoCode varchar(250),
            EmailAddress varchar(100),
			AgreementVersion varchar(50),
			AttachmentVersion varchar(50),
			TermsAndConditionsVersion  varchar(50),
			AgreementDocID int,
			AttachmentADocID int,
			TermsAndConditionsDocID int,
			IDType varchar(50))                
			
			
			
      INSERT INTO t_contractServiceAccount (ContractID, ServiceAccountNumber, MeterTypeID,                  
      UtilityID,ServiceClassID, ZoneID,EstimatedUsage, FlowStartMonth, ContractTerm,                  
      RateID, TransferRate, PartnerMarkup, ServiceAddress1, ServiceAddress2,                  
      ServiceCity,ServiceState, ServiceZip, BillingSameAsService, BillingAccountNumber,BillingAddress1,                  
      BillingAddress2, BillingCity, BillingState,BillingZip,                  
      UtilityNameKey, FlowStartDate, FlowEndDate,ServiceAccountName)          
      SELECT @MaxContractID, ServiceAccountNumber, MeterTypeID,                  
      UtilityID, ServiceClassID, ZoneID,EstimatedUsage, FlowStartMonth, ContractTerm,               
      RateID, TransferRate, PartnerMarkup, ServiceAddress1, ServiceAddress2,                  
      ServiceCity,ServiceState, ServiceZip, BillingSameAsService, BillingAccountNumber,BillingAddress1,                  
      BillingAddress2, BillingCity, BillingState,BillingZip,                  
      UtilityNameKey, CONVERT( datetime, FlowStartDate, 101) as FlowStartDate,     
      CONVERT( datetime, FlowEndDate, 101) as FlowEndDate, ServiceAccountName                
      FROM       OPENXML (@idoc, '/LibertyPower/Contract/ServiceAccountDetail',1)                
         WITH (ContractID  int,                
            ServiceAccountNumber varchar(36),                
            MeterTypeID int,                
            UtilityID int,                
			ServiceClassID int,                
            ZoneID int,                
            EstimatedUsage int,                
            FlowStartMonth date,                
            ContractTerm int,                
			RateID int,                
            TransferRate decimal(12,5),                
            PartnerMarkup decimal(12,5),                
            ServiceAddress1 varchar(50),                
            ServiceAddress2 varchar(50),                
            ServiceCity varchar(30),                
            ServiceState char(2),                
            ServiceZip char(10),                
            BillingSameAsService bit,                
            BillingAccountNumber varchar(20),                
            BillingAddress1 varchar(50),                
            BillingAddress2 varchar(50),                
            BillingCity varchar(30),                
            BillingState char(2),                
            BillingZip char(10),                
            UtilityNameKey varchar(20),                
            FlowStartDate datetime,                
            FlowEndDate datetime,            
            ServiceAccountName varchar(50)                               
            )  
            
           
            
     SELECT 
			@NameKey = NameKey ,                
            @BillingAccountNumber = BillingAccountNumber       
      FROM       OPENXML (@idoc, '/LibertyPower/Contract/CTAdditionalFields',1)                
         WITH (ContractID  int,                
            NameKey varchar(50),                
            BillingAccountNumber varchar(50)
            )  
            
   
   -- SELECT @MaxContractID as ContractID, 
   -- @NameKey as NameKey ,                
   --         @BillingAccountNumber as BillingAccountNumber;
   
   
   UPDATE Genie.dbo.T_ContractServiceAccount       
   SET UtilityNameKey = @NameKey, BillingAccountNumber = @BillingAccountNumber
   WHERE ContractID = @MaxContractID
                          
                          
                          
   PRINT 'CALL INSIDE COMMIT'                         
   
   COMMIT Transaction                   
   
   select @MaxContractID as ContractID                        
   
   
   
   END TRY                
   BEGIN CATCH                
		PRINT 'CALL INSIDE ROLLBACK'                
		ROLLBACK Transaction                
		DECLARE @ErrorMessage NVARCHAR(4000);          
		DECLARE @ErrorSeverity INT;          
		DECLARE @ErrorState INT;          
          
		SELECT           
			@ErrorMessage = ERROR_MESSAGE(),          
			@ErrorSeverity = ERROR_SEVERITY(),          
			@ErrorState = ERROR_STATE();          
	          
		-- Use RAISERROR inside the CATCH block to return error          
		-- information about the original error that caused          
		-- execution to jump to the CATCH block.          
		RAISERROR (@ErrorMessage, -- Message text.          
				   @ErrorSeverity, -- Severity.          
				   @ErrorState -- State.          
				   );          
	          
	   select 0 as ContractID                 
   END CATCH
   SET NOCOUNT OFF
   
                    
END


