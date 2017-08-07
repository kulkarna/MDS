using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using CRMBAL = LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using MarketBAL = LibertyPower.Business.MarketManagement;
using SalesChannelBAL = LibertyPower.Business.CustomerAcquisition.SalesChannel;
using SecurityBAL = LibertyPower.Business.CommonBusiness.SecurityManager;

namespace LibertyPower.Business.CustomerManagement.CRMServices
{
    public interface IContractSubmissionAPI
    {
        // ContractSubmissionResult ValidateContractSubmission( CRMBAL.Contract contract, CRMBAL.Customer customer, SecurityBAL.User user );

        // ContractSubmissionResult SubmitNewContract( CRMBAL.Contract contract, int customerId, int userId );

        ContractSubmissionResult SubmitContract( CRMBAL.Contract contract, CRMBAL.Customer customer, SecurityBAL.User user );

        ContractSubmissionResult SubmitContract( CRMBAL.Contract contract, CRMBAL.Customer customer, SecurityBAL.User user, bool isTest );

        ContractSubmissionResult SubmitContract( CRMBAL.Contract contract, CRMBAL.Customer customer, int userId );

        ContractSubmissionResult SubmitContract( CRMBAL.Contract contract, CRMBAL.Customer customer, int userId, bool isTest );

        ///Bug 7839: 1-64232573 Contract Amendments
        ///Amendment Added on June 17 2013
        ContractSubmissionResult SubmitContractAmmendment( CRMBAL.Contract contract, CRMBAL.Customer customer, string currentContract, int userId );

        ContractSubmissionResult SubmitContractAmendmend(CRMBAL.Contract newcontract, CRMBAL.Customer customer, SecurityBAL.User user, CRMBAL.Contract existingContract);
        
        ContractSubmissionResult SubmitResidentialContract( int userId, string accountNumber, int accountTypeId, int contractTypeId, DateTime contractSignedDate, DateTime contractStartDate, Int64 priceID, double rate, string retailMarketCode, int utilityId, int termsMonths, string customerTitle, string customerFirstName, string customerLastName, string contactEmail, string contactPhoneNumber, string ssnEncrypted, string serviceStreet1, string serviceStreet2, string serviceCity, string serviceState, string serviceZip, string billingStreet1, string billingStreet2, string billingCity, string billingState, string billingZip, string salesChannel, string salesRep, string externalNumber, bool goGreenOption, bool optoutSpecialOffers, int languageId, string pin, string origin );

        Guid SaveContractSupportingFile( string contractNumber, byte[] contractFile, string fileName, int documentTypeId, int userId, int languageId = 0 );

        List<string> SendContractEmails(string contractNumber);

    }
}
