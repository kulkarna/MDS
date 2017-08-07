using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using CRMBAL = LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using MarketBAL = LibertyPower.Business.MarketManagement;
using SalesChannelBAL = LibertyPower.Business.CustomerAcquisition.SalesChannel;
using SecurityBAL = LibertyPower.Business.CommonBusiness.SecurityManager;
using EFDal = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using System.IO;

namespace LibertyPower.Business.CustomerManagement.CRMServices
{
    public class ContractSubmissionAPI : IContractSubmissionAPI
    {
        #region Contract Submission

        public ContractSubmissionResult SubmitContract(CRMBAL.Contract contract, CRMBAL.Customer customer, SecurityBAL.User user)
        {
            return this.SubmitContract(contract, customer, user, false);
        }

        public ContractSubmissionResult SubmitContract(CRMBAL.Contract contract, CRMBAL.Customer customer, SecurityBAL.User user, bool isTest)
        {
            ContractSubmissionResult contractSubmissionResult = new ContractSubmissionResult();
            List<CRMBAL.GenericError> tempErrors = new List<CRMBAL.GenericError>();
            ContractProcessor contractProcessor = new ContractProcessor(customer, contract, user, isTest);

            if (!contractProcessor.ProcessContract())
            {
                contractSubmissionResult.Errors.AddRange(contractProcessor.CurrentErrors);
                contractSubmissionResult.Message = "Could not process contract";
            }
            else
            {

                contractSubmissionResult.ContractId = contract.ContractId.HasValue ? contract.ContractId.Value : 0;
                contractSubmissionResult.CustomerId = customer.CustomerId.HasValue ? customer.CustomerId.Value : 0;
                contractSubmissionResult.ContractNumber = contract.Number;
                if (isTest)
                    contractSubmissionResult.Message = "Test Mode was enabled, no data was saved to the database but the test completed sucessfully";
                else
                    contractSubmissionResult.Message = "Process completed sucessfully";
            }
            //returns original contract number in case of success or failure.
            contractSubmissionResult.ContractNumber = contract.Number;
            return contractSubmissionResult;
        }

        public ContractSubmissionResult SubmitContract(CRMBAL.Contract contract, CRMBAL.Customer customer, int userId)
        {
            return SubmitContract(contract, customer, userId, false);
        }

        public ContractSubmissionResult SubmitContract(CRMBAL.Contract contract, CRMBAL.Customer customer, int userId, bool isTest)
        {
            ContractSubmissionResult opResult = new ContractSubmissionResult();
            SecurityBAL.User currentUser = null;

            try
            {
                try
                {
                    currentUser = SecurityBAL.UserFactory.GetUser(userId);
                }
                catch
                {
                    // currentUser will be null for cases when the id is not know or when .GetUser throws an exception
                }

                if (currentUser != null)
                {
                    opResult = this.SubmitContract(contract, customer, currentUser, isTest);
                }
                else
                {
                    opResult.Errors.Add(new CRMBAL.GenericError() { Code = 99, Message = "Could Not find UserId" });
                }

                return opResult;
            }
            catch (Exception ex)
            {
                try
                {
                    // In case of any previously unhandled exception try to save the contract to Deal Capture

                    contract.SetDefaultValues();

                    ContractProcessor contractProcessor = new ContractProcessor(customer, contract, currentUser, isTest);
                    contractProcessor.SetClientSubApplicationKey();
                    contractProcessor.CurrentErrors.Add(new GenericError() { Code = 1, Message = ex.Message });
                    contractProcessor.ExecutePostContractSubmissionActions();
                }
                catch
                {
                    // If not possible to save to Deal Capture try to save all the inputs as additional exception data

                    if (ex.Data != null)
                    {
                        ex.Data.Add("contract", TryToSerializeObjectToJson<Contract>(contract) ?? "Unable to serialize contract");
                        ex.Data.Add("customer", TryToSerializeObjectToJson<Customer>(customer) ?? "Unable to serialize customer");
                        ex.Data.Add("userId", userId);
                        ex.Data.Add("isTest", isTest);
                    }
                }

                throw ex;
            }
        }

        public ContractSubmissionResult SubmitResidentialContract(int userId, string accountNumber, int accountTypeId, int contractTypeId, DateTime contractSignedDate, DateTime contractStartDate, Int64 priceId, double rate, string retailMarketCode, int utilityId, int termsMonths, string customerTitle, string customerFirstName, string customerLastName, string contactEmail, string contactPhoneNumber, string ssnEncrypted, string serviceStreet1, string serviceStreet2, string serviceCity, string serviceState, string serviceZip, string billingStreet1, string billingStreet2, string billingCity, string billingState, string billingZip, string salesChannel, string salesRep, string externalNumber, bool goGreenOption, bool optoutSpecialOffers, int languageId, string pin, string origin)
        {
            #region Local Vars
            ContractSubmissionResult opResult = new ContractSubmissionResult();

            SalesChannelBAL.SalesChannel schannel = null;
            MarketBAL.UtilityManagement.RetailMarket cMarket = null;
            SecurityBAL.User currentUser = null;
            MarketBAL.UtilityManagement.Utility utility = null;
            CRMBAL.Enums.ContractType cType;

            #endregion

            opResult = ValidationFactory.ValidateNewResidentialContract(accountNumber, contractSignedDate, contractStartDate, priceId, termsMonths, customerTitle, customerFirstName,
                                                                            customerLastName, contactEmail, contactPhoneNumber, ssnEncrypted, serviceStreet1, serviceStreet2, serviceCity,
                                                                            serviceState, serviceZip, billingStreet1, billingStreet2, billingCity, billingState, billingZip, salesRep);


            // Input Validation:
            if (opResult.HasErrors)
            {
                // cannot continue if inputs are not correct
                return opResult;
            }

            #region Get needed data and validate:

            utility = MarketBAL.UtilityManagement.UtilityFactory.GetUtilityById(utilityId);

            schannel = SalesChannelBAL.SalesChannelFactory.GetSalesChannel(salesChannel.Trim());
            cMarket = MarketBAL.UtilityManagement.MarketFactory.GetRetailMarket(retailMarketCode.Trim());
            currentUser = SecurityBAL.UserFactory.GetUser(userId);

            cType = (CRMBAL.Enums.ContractType)contractTypeId;

            // validate sales channel:
            if (schannel == null)
            {
                opResult.Errors.Add(new CRMBAL.GenericError() { Message = string.Format("Field salesChannel is missing or invalid, submitted value ='{0}'", salesChannel), Code = 1 });
            }
            // validate sales channel:
            if (cMarket == null)
            {
                opResult.Errors.Add(new CRMBAL.GenericError() { Message = string.Format("Field retailMarketCode is missing or invalid, submitted value ='{0}'", retailMarketCode), Code = 1 });
            }

            // validate current user
            if (currentUser == null)
            {
                opResult.Errors.Add(new CRMBAL.GenericError() { Message = string.Format("the user id provided is not in our system, submitted value ='{0}'", userId), Code = 1 });
            }

            // validate utility:
            if (utility == null)
            {
                opResult.Errors.Add(new CRMBAL.GenericError() { Message = string.Format("the utility id provided is not in our system, submitted value ='{0}'", utility), Code = 1 });
            }

            #endregion Get needed data and validate

            if (opResult.HasErrors)
            {
                // cannot continue if inputs are not correct
                return opResult;
            }

            // Data at this point has been validated at some level


            // TODO: These numbers need a better wrapper, transfered the account_id to the account factory level
            // string newAccountIdLegacy = CustomerAcquisition.ProspectManagement.ProspectContractFactory.GetNewAccountId( currentUser.Username );
            // string newContractNumber = CustomerAcquisition.ProspectManagement.ProspectContractFactory.GenerateContractNumber( currentUser.Username );

            #region Legacy Address, Contact, Name table saving

            // Save Address, name and legacy information:
            CRMBAL.Address serviceAddress = new CRMBAL.Address();
            //serviceAddress.Account_Id = newAccountIdLegacy;
            //serviceAddress.AddressLink = 1;
            serviceAddress.City = serviceCity;
            serviceAddress.State = serviceState;
            serviceAddress.Street = serviceStreet1;
            serviceAddress.Suite = serviceStreet2;
            serviceAddress.Zip = serviceZip;

            CRMBAL.Address customerAddress = new CRMBAL.Address();
            //customerAddress.Account_Id = newAccountIdLegacy;
            //customerAddress.AddressLink = 2;
            customerAddress.City = billingCity;
            customerAddress.State = billingState;
            customerAddress.Street = billingStreet1;
            customerAddress.Suite = billingStreet2;
            customerAddress.Zip = billingZip;

            CRMBAL.Address billingAddress = (CRMBAL.Address)customerAddress.Clone();
            //billingAddress.AddressLink = 3;

            CRMBAL.Contact newContact = new CRMBAL.Contact();
            //newContact.Account_Id = newAccountIdLegacy;
            //newContact.ContactLink = 1;
            newContact.Email = contactEmail;
            newContact.FirstName = customerFirstName;
            newContact.LastName = customerLastName;
            newContact.Phone = contactPhoneNumber;
            newContact.Title = customerTitle;

            #endregion Legacy Address, Contact, Name table saving

            // Save contract information
            CRMBAL.Contract newContract = new CRMBAL.Contract();
            newContract.ContractDealType = CRMBAL.Enums.ContractDealType.New;
            newContract.ContractStatus = CRMBAL.Enums.ContractStatus.PENDING;
            newContract.ContractTemplate = CRMBAL.Enums.ContractTemplate.Normal;
            newContract.ContractTypeId = contractTypeId;
            newContract.CreatedBy = userId;
            newContract.DateCreated = DateTime.Now;
            newContract.ExternalNumber = externalNumber;
            newContract.ModifiedBy = userId;
            //newContract.Number = newContractNumber;
            newContract.PricingTypeId = null;
            newContract.ReceiptDate = DateTime.Now;
            newContract.SalesChannel = schannel;
            newContract.SalesChannelId = schannel.ChannelID;
            newContract.SalesManagerId = schannel.ChannelDevelopmentManagerID;
            newContract.SalesRep = salesRep;
            newContract.SignedDate = contractSignedDate;
            newContract.SubmitDate = DateTime.Now;

            //Set the Contract Start Date to the first of the month - End Date to the end of the previous month (+ the term)
            newContract.StartDate = DateTime.Parse(contractStartDate.Month.ToString() + "/01/" + contractStartDate.Year.ToString());
            newContract.EndDate = newContract.StartDate.AddMonths(termsMonths).AddDays(-1);

            // Save CustomerPreference information: 
            CRMBAL.CustomerPreference preferences = new CRMBAL.CustomerPreference();
            preferences.CreatedBy = userId;
            preferences.IsGoGreen = goGreenOption;
            preferences.LanguageId = languageId;
            preferences.OptOutSpecialOffers = optoutSpecialOffers;
            preferences.Pin = pin;
            preferences.CreatedBy = userId;
            preferences.ModifiedBy = userId;

            // Save Customer information: 
            CRMBAL.Customer newCustomer = new CRMBAL.Customer();
            //newCustomer.AddressId = null;
            newCustomer.CustomerAddress = billingAddress;
            newCustomer.Contact = (CRMBAL.Contact)newContact.Clone();
            //newCustomer.Contact.ContactLink++;
            newCustomer.BusinessActivityId = 1;// Business activity = none for residential
            newCustomer.BusinessTypeId = 7; // Business type 7 = residential
            newCustomer.OwnerName = customerFirstName + " " + customerLastName;
            newCustomer.CustomerName = customerFirstName + " " + customerLastName;
            newCustomer.SsnEncrypted = ssnEncrypted;
            newCustomer.ModifiedBy = userId;
            newCustomer.CreatedBy = userId;
            newCustomer.Preferences = preferences;

            // Account Details
            CRMBAL.AccountDetail accDetail = new CRMBAL.AccountDetail();
            accDetail.EnrollmentTypeId = 1;
            accDetail.ModifiedBy = userId;
            accDetail.CreatedBy = userId;

            // Save Account information:
            CRMBAL.Account newAccount = new CRMBAL.Account();
            // newAccount.AccountIdLegacy = newAccountIdLegacy;
            newAccount.AccountNumber = accountNumber;
            newAccount.AccountName = customerFirstName + " " + customerLastName;
            newAccount.AccountTypeId = accountTypeId;
            newAccount.BillingAddress = billingAddress;
            newAccount.BillingContact = newContact;
            newAccount.ServiceAddress = serviceAddress;
            newAccount.BillingType = CRMBAL.Enums.BillingType.RR;
            newAccount.CreatedBy = userId;
            newAccount.ModifiedBy = userId;
            newAccount.Utility = utility;
            newAccount.UtilityId = utility.Identity;
            newAccount.RetailMktId = cMarket.ID;
            newAccount.Origin = origin;
            newAccount.TaxStatus = CRMBAL.Enums.TaxStatus.Full; // FULL
            newAccount.EntityId = utility.CompanyEntityCode;
            newAccount.PorOption = utility.IsPOR;
            newAccount.Details = accDetail;

            //Account Usage 
            CRMBAL.AccountUsage accUsage = new CRMBAL.AccountUsage();
            accUsage.CreatedBy = userId;
            accUsage.ModifiedBy = userId;
            accUsage.UsageRequestStatus = CRMBAL.Enums.UsageReqStatus.Pending;
            accUsage.AnnualUsage = 0; // Set to 0 for residential
            accUsage.EffectiveDate = newContract.StartDate; // this must be the same otherwise it will loose the link on the actual view

            #region Peripheral tables

            //Account contract
            CRMBAL.AccountContract ac = new CRMBAL.AccountContract();
            ac.CreatedBy = userId;
            ac.ModifiedBy = userId;
            ac.RequestedStartDate = newContract.StartDate; // sames as start date by Eric H
            ac.SendEnrollmentDate = ac.RequestedStartDate.Value.AddDays(utility.EnrollmentLeadDays);
            ac.Modified = DateTime.Now;

            CRMBAL.AccountContractRate acr = new CRMBAL.AccountContractRate();
            acr.CreatedBy = userId;
            acr.ModifiedBy = userId;
            acr.LegacyProductId = CRMBAL.ContractFactory.GetProductIdForResidential(utility.Code);// TODO: Need to get this value
            acr.Term = termsMonths;
            acr.PriceId = priceId;
            acr.RateCode = "";
            //acr.RateId = rateId;  removed and replaced with assignment above for priceId
            acr.Rate = rate;
            acr.RateStart = contractStartDate;
            acr.RateEnd = contractStartDate.AddMonths(termsMonths);
            acr.IsContractedRate = true;

            CRMBAL.AccountContractCommission acm = new CRMBAL.AccountContractCommission();
            acm.ModifiedBy = userId;
            acm.CreatedBy = userId;

            CRMBAL.AccountStatus ast = new CRMBAL.AccountStatus();
            ast.Status = "01000";
            ast.SubStatus = "10";
            ast.ModifiedBy = userId;
            ast.CreatedBy = userId;
            ast.Modified = DateTime.Now;

            #endregion

            ac.AccountContractCommission = acm;
            ac.AccountContractRates = new List<CRMBAL.AccountContractRate>();
            ac.AccountContractRates.Add(acr);
            ac.AccountStatus = ast;
            ac.Account = newAccount;
            ac.Contract = newContract;
            newAccount.Details = accDetail;

            newAccount.AccountUsages = new List<CRMBAL.AccountUsage>();
            newAccount.AccountUsages.Add(accUsage);

            newContract.AccountContracts = new List<CRMBAL.AccountContract>();
            newContract.AccountContracts.Add(ac);

            try
            {
                opResult = this.SubmitContract(newContract, newCustomer, currentUser);

            }
            catch (Exception ex)
            {
                opResult.Errors = new List<CRMBAL.GenericError>();
                opResult.Errors.Add(new CRMBAL.GenericError() { Code = 999, Message = "A system error occurred, contract was not submitted. " + ex.Message });
                opResult.SystemErrorException = ex;
            }
            return opResult;
        }

        /// <summary>
        /// Ammends an existing contract with the supplied contract
        /// </summary>
        /// <param name="contract">New Contract</param>
        /// <param name="currentContract">Existing Contract that will be ammended</param>
        /// <param name="userId">Current userId</param>
        /// <returns></returns>
        public ContractSubmissionResult SubmitContractAmmendment(CRMBAL.Contract newcontract, CRMBAL.Customer customer, string currentContract, int userId)
        {
            //Bug 7839: 1-64232573 Contract Amendments
            //Amendment Added on June 17 2013
            ContractSubmissionResult opResult = new ContractSubmissionResult();
            Contract existingContract = CRMBAL.ContractFactory.GetContractByContractNumber(currentContract);
            if (existingContract == null)
            {
                opResult.Errors.Add(new CRMBAL.GenericError() { Code = 0, Message = "Could Not Find the Existing Contract to Amend" });
                return opResult;
            }
            SecurityBAL.User currentUser = SecurityBAL.UserFactory.GetUser(userId);
            if (currentUser != null)
            {
                opResult = this.SubmitContractAmendmend(newcontract, customer, currentUser, existingContract);
            }
            else
            {
                opResult.Errors.Add(new CRMBAL.GenericError() { Code = 99, Message = "Could Not find UserId" });
            }
            return opResult;
        }
        /// <summary>
        /// This method processes the contract ( Validates and Saves)
        /// </summary>
        /// <param name="newContract">New contract to Ammend</param>
        /// <param name="customer"> Current Customer Object</param>
        /// <param name="user">Current user object</param>
        /// <param name="existingContract">Existing Contract to be ammended to</param>
        /// <returns></returns>
        public ContractSubmissionResult SubmitContractAmendmend(CRMBAL.Contract newContract, CRMBAL.Customer customer, SecurityBAL.User user, CRMBAL.Contract existingContract)
        {
            //Bug 7839: 1-64232573 Contract Amendments
            //Amendment Added on June 17 2013
            ContractSubmissionResult contractSubmissionResult = new ContractSubmissionResult();
            List<CRMBAL.GenericError> tempErrors = new List<CRMBAL.GenericError>();
            ContractProcessor contractProcessor = new ContractProcessor(customer, newContract, existingContract, user, false);

            if (!contractProcessor.ProcessContract())
            {
                contractSubmissionResult.Errors.AddRange(contractProcessor.CurrentErrors);
                contractSubmissionResult.Message = "Could not process contract";
            }
            else
            {
                contractSubmissionResult.ContractId = existingContract.ContractId.Value;
                contractSubmissionResult.CustomerId = customer.CustomerId.Value;
                contractSubmissionResult.ContractNumber = existingContract.Number;

            }
            return contractSubmissionResult;
        }

        #endregion

        public Guid SaveContractSupportingFile(string contractNumber, byte[] contractFile, string fileName, int documentTypeId, int userId, int languageId = 0)
        {
            //TODO: clean this up assign proper username
            string username = userId.ToString();
            Guid newDocumentGuid = LibertyPower.Business.CommonBusiness.DocumentManager.DocumentManager.SaveDocument(contractFile, fileName, documentTypeId, contractNumber, username, languageId);

            //Quick Fix for BUG : 53868 Liberty Power Agreement, 11/02/2014 FROM TABLETS- Accpetance email does not have attachments
           // SendElectricAcceptanceEmail(contractNumber, contractFile, fileName);

            SendNaturalGasContractEmail(contractNumber, contractFile, fileName);

            //Save Audio Length of Sales Audio for Incomplete Contract     
            if (TabletIncompleteContractFactory.isIncompleteContract( contractNumber))           
                TabletIncompleteContractFactory.SaveAudioLengthForIncompleteContract(contractNumber);

            if (contractNumber != null && documentTypeId == 1 && languageId > 1)
            {
                Dictionary<int, string> templateVersionInfosDictionary = LibertyPower.Business.CommonBusiness.DocumentManager.DocumentManager.GetTemplateVersions(contractNumber, documentTypeId, languageId);
                if (templateVersionInfosDictionary.Count > 0)
                {
                    CRMBAL.ContractFactory.UpdateAccountLanguagePreference(contractNumber, templateVersionInfosDictionary.First().Key);
                }
            }

            return newDocumentGuid;
        }
        /// <summary>
        /// Sends the Acceptance email with the PDF contract
        /// </summary>
        /// <param name="contractNumber"></param>
        /// <param name="contractFile"></param>
        /// <param name="fileName"></param>
        private static void SendElectricAcceptanceEmail(string contractNumber, byte[] contractFile, string fileName)
        {
            try
            {
                List<CRMBAL.TabletDocument> list = CRMBAL.TabletDocumentFactory.GetTabletDocuments(contractNumber);
                using (EFDal.LibertyPowerEntities entities = new EFDal.LibertyPowerEntities())
                {
                    bool isAccepted = entities.Contracts.Any(item => item.Number == contractNumber);
                    if (isAccepted &&
                        list.Any(item => !item.IsGasFile && item.FileName == fileName && item.DocumentTypeID == 1))
                    {

                        Dictionary<string, Stream> attachments = new Dictionary<string, Stream>();
                        using (Stream st = new MemoryStream(contractFile))
                        {
                            attachments.Add(fileName, st);
                            CRMBAL.Contract contract = ContractFactory.GetContractByContractNumber(contractNumber, true);
                            Customer customer = null;
                            if (contract != null && contract.AccountContracts != null && contract.AccountContracts.Count > 0 &&
                                contract.AccountContracts.First().Account != null &&
                                contract.AccountContracts.First().Account.CustomerId.HasValue &&
                                contract.AccountContracts.First().Account.CustomerId > 0)
                            {
                                customer = CRMBAL.CustomerFactory.GetCustomer(contract.AccountContracts.First().Account.CustomerId.Value, true);
                            }
                            if (customer != null && contract != null && attachments.Count > 0)
                            {
                                ContractSubmissionEmailHelper.SendEmail(contract, customer, attachments, CRMBAL.Enums.EmailType.TabletContractAcceptance, "");
                            }                            
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ContractProcessor.LogError(ex);
            }
        }

        public List<string> SendContractEmails(string contractNunmber)
        {
            List<string> errorsToReturn = new List<string>();
            using (EFDal.LibertyPowerEntities entities = new EFDal.LibertyPowerEntities())
            {
                bool acceptedContract = entities.Contracts.Any(item => item.Number == contractNunmber);
                //Get available files for the contract.

                List<CommonBusiness.DocumentManager.Document> availableDocs
                        = LibertyPower.Business.CommonBusiness.DocumentManager.DocumentManager.GetDocumentsByContractNumber(contractNunmber);


                errorsToReturn = SendTabletEmails(contractNunmber, availableDocs, acceptedContract);

            }
            return errorsToReturn;

        }


        /// <summary>
        ///  Try sending emails in acceptance or rejection don't throw any error , just log it and continue.
        /// </summary>
        /// <param name="contractNumber">Contract Number</param>
        /// <param name="attachments">All the available Attachemnts.</param>
        /// <param name="isAcceptance">Flag to check if its acceptance or rejection scenario.</param>
        /// <returns>Colection of error messages.</returns>
        private static List<string> SendTabletEmails(string contractNumber, List<CommonBusiness.DocumentManager.Document> availableDocs, bool isAcceptance = false)
        {
            List<string> errorsToReturn = new List<string>();
            try
            {
                Dictionary<string, Stream> attachments = new Dictionary<string, Stream>();
               

                if (isAcceptance)
                {
                    attachments = ContractProcessor.LoadEmailAttachments(availableDocs, false);
                    CRMBAL.Contract contract = ContractFactory.GetContractByContractNumber(contractNumber, true);
                    Customer customer = null;
                    if (contract != null && contract.AccountContracts != null && contract.AccountContracts.Count > 0 &&
                        contract.AccountContracts.First().Account != null &&
                        contract.AccountContracts.First().Account.CustomerId.HasValue &&
                        contract.AccountContracts.First().Account.CustomerId > 0)
                    {
                        customer = CRMBAL.CustomerFactory.GetCustomer(contract.AccountContracts.First().Account.CustomerId.Value, true);
                    }
                    if (customer != null && contract != null && attachments.Count > 0)
                    {
                        ContractSubmissionEmailHelper.SendEmail(contract, customer, attachments, CRMBAL.Enums.EmailType.TabletContractAcceptance, "");
                    }
                    else
                    {
                        errorsToReturn.Add("Unable to send acceptance email.");
                    }
                }
                else
                {
                    attachments = ContractProcessor.LoadEmailAttachments(availableDocs, true);
                    //fetch error messages if exists in the RejectedContractMessage Table
                    using (EFDal.LpDealCaptureEntities entities = new EFDal.LpDealCaptureEntities())
                    {
                        EmailClient client = new EmailClient();
                        List<EFDal.RejectedContractMessage> rejectedContractMessage =
                            entities.RejectedContractMessages.Where(item => item.ContractNumber == contractNumber).ToList();
                        if (rejectedContractMessage.Count == 0)
                        {
                            errorsToReturn.Add("Invalid contract number or Contract details are unavailable. Unable to send email.");
                        }
                        else
                        {
                            rejectedContractMessage.ForEach(rejectedDetails =>
                            {
                                List<string> toEmails = new List<string>();
                                CRMBAL.Enums.EmailType emailType = (CRMBAL.Enums.EmailType)rejectedDetails.EmailTypeID;
                                if (emailType == CRMBAL.Enums.EmailType.ECM)
                                { attachments = ContractProcessor.LoadEmailAttachments(availableDocs, true); }
                                else
                                { attachments = ContractProcessor.LoadEmailAttachments(availableDocs, false); }

                                if (!string.IsNullOrEmpty(rejectedDetails.ToEmail))
                                {
                                    if (rejectedDetails.ToEmail.IndexOf(";") != -1)
                                        toEmails = rejectedDetails.ToEmail.Split(new string[] { ";" }, StringSplitOptions.RemoveEmptyEntries).ToList();
                                    else
                                        toEmails.Add(rejectedDetails.ToEmail);
                                }


                                if (ContractSubmissionEmailHelper.SendEmails)
                                {
                                    if (toEmails != null && toEmails.Count > 0)
                                    {
                                        if (!client.SendEmail(toEmails, rejectedDetails.Subject, rejectedDetails.Body, attachments))
                                        {
                                            errorsToReturn.Add("Unable to send rejection email.");
                                        }
                                    }
                                    if (ContractSubmissionEmailHelper.IsCustomerNotificationRequired(emailType))
                                    {
                                        if (!client.SendEmail(rejectedDetails.CustomerEmail, rejectedDetails.Subject, rejectedDetails.Body, attachments))
                                        { errorsToReturn.Add("Unable to send rejection email for Customer."); }
                                    }
                                    if (ContractSubmissionEmailHelper.IsSalesChannelNotificationRequired(emailType))
                                    {
                                        if (!client.SendEmail(rejectedDetails.SalesChannelEmail, rejectedDetails.Subject, rejectedDetails.Body, attachments))
                                        {
                                            errorsToReturn.Add("Unable to send rejection email for SalesChannel.");
                                        }
                                    }
                                }
                                else
                                {
                                    //Send to all test email Ids

                                    if (toEmails != null && toEmails.Count > 0)
                                    {
                                        if (!client.SendEmail(ContractSubmissionEmailHelper.TestCustomerEmail, rejectedDetails.Subject, rejectedDetails.Body, attachments))
                                        {
                                            errorsToReturn.Add("Unable to send rejection email.");
                                        }
                                    }

                                    if (ContractSubmissionEmailHelper.IsCustomerNotificationRequired(emailType))
                                    {
                                        if (!client.SendEmail(ContractSubmissionEmailHelper.TestCustomerEmail, rejectedDetails.Subject, rejectedDetails.Body, attachments))
                                        { errorsToReturn.Add("Unable to send rejection email for Customer."); }
                                    }

                                    if (ContractSubmissionEmailHelper.IsSalesChannelNotificationRequired(emailType))
                                    {
                                        if (!client.SendEmail(ContractSubmissionEmailHelper.TestSalesChannelEmail, rejectedDetails.Subject, rejectedDetails.Body, attachments))
                                        {
                                            errorsToReturn.Add("Unable to send rejection email for SalesChannel.");
                                        }
                                    }
                                }
                            });
                        }
                    }

                }

            }
            catch (Exception ex)
            {
                errorsToReturn.Add(ex.Message);
                ContractProcessor.LogError(ex);

            }
            return errorsToReturn;
        }


        private bool SendNaturalGasContractEmail(string contractNumber, byte[] contractFile, string fileName)
        {
            List<CRMBAL.TabletDocument> list = CRMBAL.TabletDocumentFactory.GetTabletDocuments(contractNumber);
            if (list != null && list.Where(w => w.IsGasFile == true).FirstOrDefault() != null)
            {
                // check if the file is a gas file so that we can send an email
                return ContractSubmissionEmailHelper.SendNaturalGasAttachmentEmail(contractNumber, fileName, contractFile);
            }
            return true;
        }

        /// <summary>
        /// Tries to serialize a given object o of type T to a JSON string.
        /// If it fails, a null reference is returned.
        /// </summary>
        /// <param name="o">The origin object to serialize</param>
        /// <returns>The serialized object into a JSON string or null</returns>
        private string TryToSerializeObjectToJson<T>(object o)
        {
            if (o == null)
                return null;

            try
            {
                //return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(o);

                var stream = new MemoryStream();
                var serializer = new System.Runtime.Serialization.Json.DataContractJsonSerializer(typeof(T));
                serializer.WriteObject(stream, o);
                stream.Position = 0;

                return new StreamReader(stream).ReadToEnd();
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
