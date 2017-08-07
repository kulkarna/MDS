﻿create PROC [dbo].[spGenie_PrepImport] AS

begin

INSERT INTO [lp_deal_capture].[dbo].[T_GenieImport]
           ([ContractID]
           ,[MarketCode]
           ,[UtilityCode]
           ,[BusinessType]
           ,[PartnerName]
           ,[LoginID]
           ,[AgentName]
           ,[AccountTypeID]
           ,[ProductSelection]
           ,[CustomerName]
           ,[DBA]
           ,[DUNS]
           ,[TaxExempt]
           ,[CertificateAtached]
           ,[TaxID]
           ,[ContactFirstName]
           ,[ContactLastName]
           ,[ContactTitle]
           ,[ContactPhone]
           ,[ContactFax]
           ,[ContactEmail]
           ,[ContractSignDate]
           ,[ContractCreatedDate]
           ,[GPSLat]
           ,[GPSLong]
           ,[LanguageID]
           ,[EmailPreference]
           ,[NumberOfAccounts]
           ,[ServiceAccountID]
           ,[ServiceAccountNumber]
           ,[ServiceAccountName]
           ,[EstimatedUsage]
           ,[FlowStartMonth]
           ,[ContractTerm]
           ,[RateID]
           ,[TransferRate]
           ,[PartnerMarkup]
           ,[ServiceAddress1]
           ,[ServiceAddress2]
           ,[ServiceCity]
           ,[ServiceState]
           ,[ServiceZip]
           ,[BillingSameAsService]
           ,[BillingAccountNumber]
           ,[BillingAddress1]
           ,[BillingAddress2]
           ,[BillingCity]
           ,[BillingState]
           ,[BillingZip]
           ,[UtilityNameKey]
           ,[FlowStartDate]
           ,[FlowEndDate]
           ,[ZoneCode]
           ,[ContractNBR]
           ,[AccountID]
           ,[DealCaptureStatus]
           ,[DealCaptureErrorCode]
           ,[AgreementVersion]
           ,[AttachmentVersion]
           ,[TermsAndConditionsVersion]
           ,[ModDate])
    
    SELECT [ContractID]
      ,[MarketCode]
      ,[UtilityCode]
      ,[BusinessType]
      ,[PartnerName]
      ,[LoginID]
      ,[AgentName]
      ,[AccountTypeID]
      ,[ProductSelection]
      ,[CustomerName]
      ,[DBA]
      ,[DUNS]
      ,[TaxExempt]
      ,[CertificateAtached]
      ,[TaxID]
      ,[ContactFirstName]
      ,[ContactLastName]
      ,[ContactTitle]
      ,[ContactPhone]
      ,[ContactFax]
      ,[ContactEmail]
      ,[ContractSignDate]
      ,[ContractCreatedDate]
      ,[GPSLat]
      ,[GPSLong]
      ,[LanguageID]
      ,[EmailPreference]
      ,[NumberOfAccounts]
      ,[ServiceAccountID]
      ,[ServiceAccountNumber]
      ,[ServiceAccountName]
      ,[EstimatedUsage]
      ,[FlowStartMonth]
      ,[ContractTerm]
      ,[RateID]
      ,[TransferRate]
      ,[PartnerMarkup]
      ,[ServiceAddress1]
      ,[ServiceAddress2]
      ,[ServiceCity]
      ,[ServiceState]
      ,[ServiceZip]
      ,[BillingSameAsService]
      ,[BillingAccountNumber]
      ,[BillingAddress1]
      ,[BillingAddress2]
      ,[BillingCity]
      ,[BillingState]
      ,[BillingZip]
      ,[UtilityNameKey]
      ,[FlowStartDate]
      ,[FlowEndDate]
      ,[ZoneCode]
      ,[ContractNBR]
      ,[AccountID]
      ,[DealCaptureStatus]
      ,[DealCaptureErrorCode]
      ,[AgreementVersion]
      ,[AttachmentVersion]
      ,[TermsAndConditionsVersion]
      , GETDATE()
  FROM [lp_deal_capture].[dbo].[ST_GenieImport]
  
  DELETE FROM [ST_GenieImport]
  
END