using System;
using System.Linq;
using System.Collections.Generic;
using System.Configuration;
using System.Threading.Tasks;
using AM = LibertyPower.Business.CustomerManagement.AccountManagement;
using LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using AccountFactory = LibertyPower.Business.CustomerManagement.CRMBusinessObjects.AccountFactory;
using AccountInfo = LibertyPower.Business.CustomerManagement.CRMBusinessObjects.AccountInfo;
using BillingType = LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums.BillingType;
using ContractFactory = LibertyPower.Business.CustomerManagement.CRMBusinessObjects.ContractFactory;
using CRMBAL = LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using MarketBAL = LibertyPower.Business.MarketManagement;
using PricingBal = LibertyPower.Business.CustomerAcquisition.DailyPricing;
using ProductBal = LibertyPower.Business.CustomerAcquisition.ProductManagement;
using SecurityBAL = LibertyPower.Business.CommonBusiness.SecurityManager;
using EFDal = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using LibertyPower.Business.CustomerAcquisition.DailyPricing;
using System.IO;
using DocumentBal = LibertyPower.Business.CommonBusiness.DocumentManager;
using System.Data.Common;
using System.Text;


namespace LibertyPower.Business.CustomerManagement.CRMServices
{
    internal class ContractProcessor
    {
        #region Fields

        private CRMBAL.Customer customer;
        private CRMBAL.Contract contract;
        private CRMBAL.Contract existingContract;
        private SecurityBAL.User user;
        private ContractValidator validator = null;
        private List<CRMBAL.GenericError> _errors = new List<GenericError>();
        private bool isTest = false;// determines whether we need to persist data, can be used for testing

        #endregion

        #region Properties

        public List<CRMBAL.GenericError> CurrentErrors
        {
            get
            {
                List<CRMBAL.GenericError> ret = this.validator.CurrentErrors;
                ret.AddRange( _errors );
                return ret;
            }
        }

        public bool WasContractRejected
        {
            get
            {
                return CurrentErrors.Count() != 0;
            }
        }

        public bool IsGasContract
        {
            get
            {
                for (int i = 0; i < contract.AccountContracts.Count; i++)
                {
                    for (int j = 0; j < contract.AccountContracts[i].AccountContractRates.Count; j++)
                    {
                        var acr = contract.AccountContracts[i].AccountContractRates[j];
                        if (acr.Price != null &&
                            acr.Price.ProductBrand != null &&
                            acr.Price.ProductBrand.IsGas.HasValue &&
                            acr.Price.ProductBrand.IsGas.Value == true)
                        {
                            return true;
                        }
                    }
                }

                return false;
            }
        }

        #endregion

        #region Constructors

        private ContractProcessor()
        {
        }

        public ContractProcessor( CRMBAL.Customer customer, CRMBAL.Contract contract, SecurityBAL.User enrollmentSpecialist, bool isTest )
            : this()
        {
            this.customer = customer;
            this.contract = contract;
            this.user = enrollmentSpecialist;
            this.isTest = isTest;
            this.validator = new ContractValidator( this.customer, this.contract, this.user );
        }

        public ContractProcessor( CRMBAL.Customer customer, CRMBAL.Contract contract, SecurityBAL.User enrollmentSpecialist )
            : this( customer, contract, enrollmentSpecialist, false )
        {
            this.customer = customer;
            this.contract = contract;
            this.user = enrollmentSpecialist;

            this.validator = new ContractValidator( this.customer, this.contract, this.user );
        }
        //Added for Amendment
        public ContractProcessor( CRMBAL.Customer customer, CRMBAL.Contract contract, CRMBAL.Contract existingContract, SecurityBAL.User enrollmentSpecialist, bool isTest )
            : this()
        {
            this.customer = customer;
            this.contract = contract;
            this.existingContract = existingContract;
            this.user = enrollmentSpecialist;
            this.isTest = isTest;
            this.validator = new ContractValidator( this.customer, this.contract, this.existingContract, this.user );
        }

        #endregion

        #region Event Handlers

        #endregion

        #region Methods (if you're lost, look here first)

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool ProcessContract()
        {
            //=============================================================================
            // Electric contract processing undergoes 4 steps, eventually gas will have its 
            // own steps, however step 1 is performed regardless of the type of 
            // product, therefore this step it is executed first below
            //=============================================================================

            // ===========================================================================
            // 1 -Validate that the submission package has acceptable data
            // ===========================================================================
            if (!this.ValidateContractSubmissionData())
                return false;

            // Now proceed according to the product we are processing
            if (!IsGasContract)
                return ProcessElectricContract();
            else
                return ProcessGasContract();
        }

        private bool ProcessElectricContract()
        {
            // ===========================================================================
            // 2- Check actual business rules with the valid data
            // ===========================================================================
            bool passedBusinessRules = false;
            passedBusinessRules = this.ValidateContractSubmissionBusinessRules();

            // ===========================================================================
            // 3 - Save any data that we need for logging or data for tracking purposes such as file meta data
            // ===========================================================================

            this.SaveContractSubmissionMeta();

            // ===========================================================================
            // 4 - AFTER THIS LINE WE CAN ACCEPT THE CONTRACT and save the data in the main system
            // ===========================================================================
            // Save Contract Information          
            bool hasSavedContractInformationSucessfully = false;
            if (passedBusinessRules)
            {
                hasSavedContractInformationSucessfully = this.SaveContractInformation();		// true if Contract Accepted
            }

            // ===========================================================================
            // 5 - Performs final actions after the submission is complete, for example, send email notifications
            // ===========================================================================

            this.ExecutePostContractSubmissionActions();

            return hasSavedContractInformationSucessfully;
        }

        #region Gas Methods

        private bool ProcessGasContract()
        {
            // ===========================================================================
            // 3 - Save any data that we need for logging or data for tracking purposes such as file meta data
            // ===========================================================================
            SaveContractSubmissionMeta();
            SaveDocuments();
            SendContractToGasMailbox();
            return true;
        }

        private void SaveDocuments()
        {
            if (contract.Documents != null)
            {
                foreach (LibertyPower.Business.CommonBusiness.DocumentManager.Document doc in contract.Documents)
                {
                    string ContractNumber;
                    //   Amendment Added on June 17 2013
                    //Bug 7839: 1-64232573 Contract Amendments
                    if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Amendment)
                    {
                        ContractNumber = existingContract.Number;
                    }
                    else
                    {
                        ContractNumber = contract.Number;
                    }
                    LibertyPower.Business.CommonBusiness.DocumentManager.DocumentManager.SaveDocument( doc.FileBytes, doc.Name, doc.DocumentTypeId, ContractNumber, user.Username );
                }
            }
        }

        private void SendContractToGasMailbox()
        {
            if (contract.IsTabletContract)
            {
                // we need information about the sales channel populated for the email
                PopulateSalesChannel();

                // Attachments are loaded as well
                ContractSubmissionEmailHelper.SendEmail( contract, customer, LoadEmailAttachments( contract.Documents, true ), CRMBAL.Enums.EmailType.GasContract, null );
            }
        }

        private void PopulateSalesChannel()
        {
            if (contract.SalesChannelId.HasValue && contract.SalesChannelId > 0 && contract.SalesChannel == null)
            {
                contract.SalesChannel = CustomerAcquisition.SalesChannel.SalesChannelFactory.GetSalesChannel(contract.SalesChannelId.Value);
            }
        }

        #endregion

        #region PostContractSubmissionActions
        /// <summary>
        /// Processes the required steps after the contract submission process ends, regardless if the contract was 
        /// successfully submitted or not
        /// </summary>
        public bool ExecutePostContractSubmissionActions()
        {
            //insert the information in the DealCapture Database only for 3.0 avoid 2.9
            if (this.contract.IsTabletContract && WasContractRejected &&
                (this.contract.ClientSubmitApplicationKeyId.HasValue && 
                this.contract.ClientSubmitApplicationKeyId != 7))
            {
               
                this.SaveDetailsToDealCapture();
                SaveRejectedContractMessageDetails();
            }
           
            this.SendEmailsForTabletContract();
            return true;
        }

        /// <summary>
        /// Sends email notifications based on the contract submission results for tablet contracts
        /// </summary>
        /// <returns></returns>
        private bool SendEmailsForTabletContract()
        {
            if (!this.contract.IsTabletContract)
            {
                //only tablet contracts have this functionality
                return true;
            }

            if (!WasContractRejected)
            {
                //Moved to ContractSubmissionAPI to send emails.
                //BUG - 53868 -Liberty Power Agreement, 11/02/2014 FROM TABLETS- Accpetance email does not have attachments
                //this.SendTabletContractAcceptanceNotification();
                //Only allow Contacts from Genie service to send emails.
                //Remove below when all tablets are in 3.0
                if (this.contract.ClientSubmitApplicationKeyId.HasValue && this.contract.ClientSubmitApplicationKeyId == 7)
                {
                    //the code will get here only for contracts submitted through OnlineDataSync Service.
                    this.SendTabletContractAcceptanceNotification();
                }

            }
            else
            {
                //Should be commented once tablet changes are in production for 54592
                //Currently this is helping to send rejection letters for 2.9. For 
                //3.0 rejection letters are send without attachment
                //When we deploy the tablet code add a if condition to allow only for 2.9. Remove completely once all tablets are in 3.0
                if (this.contract.ClientSubmitApplicationKeyId.HasValue && this.contract.ClientSubmitApplicationKeyId == 7)
                {
                this.SendTabletRejectionNotification();
				}
            }

            return true;
        }


        /// <summary>
        /// Saves the RejectedContract Messages to RejectedContractMessage table in Deal capture.
        /// </summary>
        private void SaveRejectedContractMessageDetails()
        {
            string errorMessages = string.Empty;

            List<GenericError> currentError = CurrentErrors;

            CurrentErrors.Select(item => item.Message).ToList().ForEach(item =>
            {
                errorMessages += item + "\r\n";
            });

            List<CRMBAL.Enums.EmailType> allowedEmailTypes =
                new List<CRMBAL.Enums.EmailType>() { CRMBAL.Enums.EmailType.TabletContractException, CRMBAL.Enums.EmailType.ECM };

            List<string> toEmails = new List<string>();
            EFDal.EmailModel emailModel = null;
            //List<string> toEmails = ContractSubmissionEmailHelper.GetEmailRecipients(CRMBAL.Enums.EmailType.TabletContractException);
            //List<string> toEmailsECM = ContractSubmissionEmailHelper.GetEmailRecipients(CRMBAL.Enums.EmailType.ECM);
            using (EFDal.LpDealCaptureEntities entities = new EFDal.LpDealCaptureEntities())
            {
                allowedEmailTypes.ForEach(allowedType =>
                {

                    try
                    {
                        toEmails = ContractSubmissionEmailHelper.GetEmailRecipients(allowedType);
                        emailModel = ContractSubmissionEmailHelper.GetEmailModel(contract, customer,
                            allowedType,(allowedType == CRMBAL.Enums.EmailType.ECM ? errorMessages : string.Empty));

                        if (!entities.RejectedContractMessages.Any(item => item.ContractNumber == contract.Number
                            && item.EmailTypeID == (int)allowedType))
                        {
                            entities.RejectedContractMessages.AddObject(new EFDal.RejectedContractMessage()
                            {
                                ContractNumber = contract.Number,
                                ErrorMessage = errorMessages,
                                EmailTypeID = (int)allowedType,
                                Body = emailModel.Message,
                                ToEmail = String.Join(";", toEmails.ToArray()),
                                CustomerEmail = customer.Contact.Email,
                                SalesChannelEmail = ContractSubmissionEmailHelper.GetSalesChannelEmail(contract),
                                Subject = emailModel.Subject,
                                CreatedBy = user.UserID,
                                CreatedDate = DateTime.Now
                            });
                        }

                        entities.SaveChanges();

                    }
                    catch (Exception ex)
                    {
                        if (ex.Data != null)
                        {
                            ex.Data.Add("contract", TryToSerializeObjectToJson<Contract>(contract) ?? "Unable to serialize contract");
                            ex.Data.Add("customer", TryToSerializeObjectToJson<Customer>(customer) ?? "Unable to serialize customer");
                        }

                        LogError(ex);
                    }
                });
            }

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

        /// <summary>
        /// When a tablet deal gets rejected we want to capture all the information in the LP_Dealcapture database.
        /// </summary>
        private void SaveDetailsToDealCapture()
        {
            try
            {
                using (LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.LpDealCaptureEntities lpDealCapture = new EFDal.LpDealCaptureEntities())
                {
                    lpDealCapture.Connection.Open();

                    bool existingContract = lpDealCapture.deal_contract.Any(item => item.contract_nbr == contract.Number);

                    if (!existingContract && !string.IsNullOrEmpty(contract.Number)
                          && contract.AccountContracts != null && contract.AccountContracts.Count > 0
                          && this.contract.AccountContracts.FirstOrDefault() != null
                          && this.contract.AccountContracts.FirstOrDefault().AccountContractRates != null
                          && this.contract.AccountContracts.FirstOrDefault().AccountContractRates.FirstOrDefault() != null)
                    {
                        using (DbTransaction transaction = lpDealCapture.Connection.BeginTransaction())
                        {
                            try
                            {
                                CRMBAL.Account account = this.contract.AccountContracts.First().Account;
                                CRMBAL.AccountContractRate acr = this.contract.AccountContracts.First().AccountContractRates.FirstOrDefault();

                                /* Create Deal_Name entry.
                                 * Create Deal_contract entry so that atleast we have a way to open it from Deal Capture(DC).
                                 */
                                string salesChannelRole = null;
                                if (contract.SalesChannelId.HasValue && contract.SalesChannelId > 0 && contract.SalesChannel == null)
                                {
                                    contract.SalesChannel = Business.CustomerAcquisition.SalesChannel.SalesChannelFactory.GetSalesChannel(contract.SalesChannelId.Value);

                                    salesChannelRole = string.Format("Sales Channel/{0}", contract.SalesChannel.ChannelName);
                                }
                                contract.AccountContracts.ForEach(ac =>
                                {
                                    ac.Account.Customer = customer;
                                    ac.Account.CustomerId = customer.CustomerId;
                                    if (ac.Account.Customer.BusinessTypeId.HasValue && ac.Account.Customer.BusinessTypeId.Value > 0)
                                    {

                                        ac.Account.Customer.BusinessType = CRMBusinessObjects.CRMBaseFactory.GetBusinessTypes().
                                            Where(item => item.BusinessTypeID == ac.Account.Customer.BusinessTypeId.Value).FirstOrDefault().Type;
                                    }
                                    if (ac.Account.Customer.BusinessActivityId.HasValue && ac.Account.Customer.BusinessActivityId.Value > 0)
                                    {
                                        ac.Account.Customer.BusinessActivity = CRMBusinessObjects.CRMBaseFactory.GetBusinessActivities().
                                            Where(item => item.BusinessActivityID == ac.Account.Customer.BusinessActivityId.Value).FirstOrDefault().Activity;
                                    }
                                });

                                int nameLink = 1;
                                int contactLink = 1;
                                int addressLink = 1;

                                EFDal.deal_contract contractToAdd = CreateDealContract(account, acr);
                                contractToAdd.sales_channel_role = string.IsNullOrEmpty(salesChannelRole) ? string.Empty : salesChannelRole;

                                lpDealCapture.deal_name.AddObject(CreateDealName(nameLink));
                                lpDealCapture.deal_contract.AddObject(contractToAdd);

                                lpDealCapture.SaveChanges();

                                lpDealCapture.deal_contact.AddObject(CreateDealContact(customer, contactLink));
                                lpDealCapture.deal_address.AddObject(CreateDealAddress(account, addressLink));


                                contract.AccountContracts.ForEach(ac =>
                                {
                                    if (ac.Account != null)
                                    {
                                        int accountServiceAddressLink = ++addressLink;
                                        int accountBillingAddressLink = ++addressLink;
                                        int accountCustomercontactLink = ++contactLink;
                                        //Account Name
                                        lpDealCapture.deal_name.AddObject(CreateDealName(++nameLink));
                                        //Account Contact
                                        lpDealCapture.deal_contact.AddObject(CreateDealContact(ac.Account.Customer, accountCustomercontactLink));
                                        //Account Address Service
                                        lpDealCapture.deal_address.AddObject(CreateDealAddress(ac.Account, accountServiceAddressLink));
                                        //Account Address billing
                                        lpDealCapture.deal_address.AddObject(CreateDealAddress(ac.Account, accountBillingAddressLink, true));
                                        //Insert Deal_contract_account
                                        EFDal.deal_contract_account contractAccountToAdd = CreateDealAccount(lpDealCapture, nameLink, 1,
                                            1, 1, ac, accountServiceAddressLink, accountBillingAddressLink);
                                        contractAccountToAdd.sales_channel_role = string.IsNullOrEmpty(salesChannelRole) ? string.Empty : salesChannelRole;
                                        lpDealCapture.deal_contract_account.AddObject(contractAccountToAdd);

                                    }
                                });

                                lpDealCapture.SaveChanges();

                                if (contract != null && contract.PromotionCodes != null && contract.PromotionCodes.Count > 0)
                                {
                                    var contractId = lpDealCapture.deal_contract.First(item => item.contract_nbr == contract.Number).ID;

                                    using (EFDal.LibertyPowerEntities lp = new EFDal.LibertyPowerEntities())
                                    {
                                        contract.PromotionCodes.ForEach(code =>
                                        {
                                            if (!string.IsNullOrWhiteSpace(code))
                                            {
                                                var promotionCode = lp.PromotionCodes.FirstOrDefault(item => item.Code == code);

                                                if (promotionCode != null)
                                                {
                                                    lpDealCapture.ContractPromotionCodes
                                                        .AddObject(CreateDealPromoCode(contractId, null, promotionCode.PromotionCodeId));
                                                }
                                            }
                                        });
                                    }

                                    lpDealCapture.SaveChanges();
                                }

                                transaction.Commit();
                            }

                            catch (Exception ex)
                            {
                                //Just log the error 
                                LogError(ex);
                                transaction.Rollback();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                //Just log the error 
                LogError(ex);
            }

        }

        private EFDal.ContractPromotionCode CreateDealPromoCode(int contractId, int? accountId, int promotionCodeId)
        {
            EFDal.ContractPromotionCode result = new EFDal.ContractPromotionCode();

            //result.ContractPromotionCodeId = Identity;
            result.ContractId = contractId;
            result.AccountId = accountId;
            result.PromotionCodeId = promotionCodeId;

            return result;
        }

        private EFDal.deal_contract_account CreateDealAccount( LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.LpDealCaptureEntities lpDealCapture
                    , int nameLink, int contactLink, int addressLink, int nameLinkOwner,
                    AccountContract ac, int accountServiceAddressLink, int accountBillingAddressLink )
        {
            EFDal.deal_contract_account accountToInsert = new EFDal.deal_contract_account();
            string acctID = lpDealCapture.usp_get_key( user.Username,
                "ACCOUNT ID", new System.Data.Objects.ObjectParameter( "p_unickey", "" ), "Y" ).ToList().FirstOrDefault();
            accountToInsert.account_id = string.IsNullOrEmpty( acctID ) ? string.Empty : acctID;
            accountToInsert.account_name_link = nameLink;
            accountToInsert.account_number = string.IsNullOrEmpty( ac.Account.AccountNumber ) ? string.Empty : ac.Account.AccountNumber;
            accountToInsert.account_type = ac.Account.AccountTypeId;
            accountToInsert.additional_id_nbr = string.IsNullOrEmpty( ac.Account.Customer.TaxId ) ? string.Empty : ac.Account.Customer.TaxId;
            accountToInsert.additional_id_nbr_type = string.Empty;
            accountToInsert.billing_address_link = accountBillingAddressLink;
            accountToInsert.billing_contact_link = contactLink;
            accountToInsert.business_activity = string.IsNullOrEmpty( ac.Account.Customer.BusinessActivity ) ? string.Empty : ac.Account.Customer.BusinessActivity;
            accountToInsert.business_type = string.IsNullOrEmpty( ac.Account.Customer.BusinessType ) ? string.Empty : ac.Account.Customer.BusinessType;
            accountToInsert.chgstamp = 0;
            accountToInsert.contract_eff_start_date = contract.StartDate != new DateTime() && contract.StartDate != null ? contract.StartDate : DateTime.Now;
            accountToInsert.contract_nbr = contract.Number;
            accountToInsert.contract_type = contract.ContractType.ToString();
            accountToInsert.CreditScoreEncrypted = string.IsNullOrEmpty( ac.Account.Customer.CreditScoreEncrypted ) ? string.Empty : ac.Account.Customer.CreditScoreEncrypted;
            accountToInsert.customer_address_link = addressLink;
            accountToInsert.customer_code = string.Empty;
            accountToInsert.customer_contact_link = contactLink;
            accountToInsert.customer_group = string.Empty;
            accountToInsert.customer_name_link = nameLink;
            accountToInsert.date_created = DateTime.Now;
            accountToInsert.date_deal = DateTime.Now;
            accountToInsert.date_end = DateTime.Now.AddDays( -1 );
            accountToInsert.date_submit = contract.SubmitDate != null && contract.SubmitDate != new DateTime() ? contract.SubmitDate : DateTime.Now;
            accountToInsert.deal_type = string.Empty;
            accountToInsert.enrollment_type = 1;
            accountToInsert.evergreen_commission_end = null;
            accountToInsert.evergreen_commission_rate = null;
            accountToInsert.evergreen_option_id = null;
            accountToInsert.grace_period = 365;
            accountToInsert.HeatIndexSourceID = 0;
            accountToInsert.HeatRate = 0;
            accountToInsert.initial_pymt_option_id = null;
            accountToInsert.IsForSave = true;
            accountToInsert.origin = string.IsNullOrEmpty( ac.Account.Origin ) ? string.Empty : ac.Account.Origin;
            accountToInsert.owner_name_link = nameLinkOwner;
            accountToInsert.PriceID = ac.AccountContractRates.FirstOrDefault().PriceId;
            accountToInsert.product_id = string.IsNullOrEmpty( ac.AccountContractRates.FirstOrDefault().LegacyProductId ) ? string.Empty : ac.AccountContractRates.FirstOrDefault().LegacyProductId;
            accountToInsert.rate = ac.AccountContractRates.FirstOrDefault().Rate.HasValue ? ac.AccountContractRates.FirstOrDefault().Rate.Value : 0;
            accountToInsert.rate_id = ac.AccountContractRates.FirstOrDefault().RateId.HasValue ? ac.AccountContractRates.FirstOrDefault().RateId.Value : 0;
            accountToInsert.RatesString = null;
            accountToInsert.requested_flow_start_date = contract.StartDate;
            accountToInsert.residual_commission_end = null;
            accountToInsert.residual_option_id = null;
            accountToInsert.retail_mkt_id = ac.Account.Utility == null || string.IsNullOrEmpty(ac.Account.Utility.RetailMarketCode) ? string.Empty : ac.Account.Utility.RetailMarketCode;
            accountToInsert.sales_channel_role = string.Empty;
            accountToInsert.sales_rep = string.IsNullOrEmpty( contract.SalesRep ) ? string.Empty : contract.SalesRep;
            accountToInsert.service_address_link = accountServiceAddressLink;
            accountToInsert.SSNClear = ac.Account.Customer.SsnClear;
            accountToInsert.SSNEncrypted = ac.Account.Customer.SsnEncrypted;
            accountToInsert.status = ac.AccountStatus == null || string.IsNullOrEmpty(ac.AccountStatus.Status) ? string.Empty : ac.AccountStatus.Status;
            accountToInsert.TaxStatus = null;
            accountToInsert.term_months = ac.AccountContractRates == null || ac.AccountContractRates.FirstOrDefault().Term.HasValue ? ac.AccountContractRates.FirstOrDefault().Term.Value : 0;
            accountToInsert.username = user.Username;
            accountToInsert.utility_id = ac.Account.Utility == null || string.IsNullOrEmpty(ac.Account.Utility.Code) ? string.Empty : ac.Account.Utility.Code;
            accountToInsert.zone = string.Empty;
            return accountToInsert;
        }

        private EFDal.deal_contract CreateDealContract( CRMBAL.Account account, CRMBAL.AccountContractRate acr )
        {
            EFDal.deal_contract contractToInsert = new EFDal.deal_contract();

            contractToInsert.ClientSubmitApplicationKeyId = contract.ClientSubmitApplicationKeyId;
            contractToInsert.contract_nbr = this.contract.Number;
            contractToInsert.contract_type = this.contract.ContractType.ToString();
            contractToInsert.status = "DRAFT";
            contractToInsert.retail_mkt_id = account.Utility == null || string.IsNullOrEmpty(account.Utility.RetailMarketCode) ? string.Empty : account.Utility.RetailMarketCode;//IL
            contractToInsert.utility_id = account.Utility == null || string.IsNullOrEmpty(account.Utility.Code) ? string.Empty : account.Utility.Code;//COMED                             
            contractToInsert.account_type = account.AccountTypeId;  //2
            contractToInsert.product_id = string.IsNullOrEmpty( acr.LegacyProductId ) ? string.Empty : acr.LegacyProductId;//COMED_IP_RES        
            contractToInsert.rate_id = acr.RateId.HasValue ? acr.RateId.Value : 0;//236981930
            contractToInsert.rate = acr.Rate.HasValue ? acr.Rate.Value : 0;//0.06668
            contractToInsert.customer_name_link = 1;//1
            contractToInsert.customer_address_link = 1;//1
            contractToInsert.customer_contact_link = 1;//1
            contractToInsert.billing_address_link = 1;//1
            contractToInsert.billing_contact_link = 1;//1
            contractToInsert.owner_name_link = 1;//1
            contractToInsert.service_address_link = 1;//1
            contractToInsert.business_type = account.Customer == null || string.IsNullOrEmpty(account.Customer.BusinessType) ? string.Empty : account.Customer.BusinessType;//RESIDENTIAL
            contractToInsert.business_activity = account.Customer == null || string.IsNullOrEmpty(account.Customer.BusinessActivity) ? "None" : account.Customer.BusinessActivity;//None
            contractToInsert.additional_id_nbr_type = "NONE";//NONE
            contractToInsert.additional_id_nbr = string.Empty;//
            contractToInsert.contract_eff_start_date = this.contract.StartDate != null && this.contract.StartDate != new DateTime() ? contract.StartDate : DateTime.Now;//need to check
            contractToInsert.enrollment_type = 1;//1
            contractToInsert.term_months = acr.Term.HasValue ? acr.Term.Value : 0;//12
            contractToInsert.date_end = this.contract.EndDate != null && this.contract.EndDate != new DateTime() ? this.contract.EndDate : contractToInsert.contract_eff_start_date.AddMonths( contractToInsert.term_months );
            contractToInsert.date_deal = this.contract.SignedDate != null && this.contract.SignedDate != new DateTime() ? this.contract.SignedDate : DateTime.Now;
            contractToInsert.date_created = DateTime.Now;
            contractToInsert.date_submit = this.contract.SubmitDate;
            contractToInsert.sales_channel_role = contract.SalesChannel != null ? contract.SalesChannel.ChannelDescription : string.Empty;//Sales Channel/LPC;
            contractToInsert.username = user.Username;//libertypower\jdiesta                                                                                
            contractToInsert.sales_rep = string.IsNullOrEmpty( contract.SalesRep ) ? string.Empty : contract.SalesRep;//JAHQUIERA BLUNT
            contractToInsert.origin = string.IsNullOrEmpty( account.Origin ) ? string.Empty : account.Origin;//ONLINE
            contractToInsert.grace_period = 365;//0
            contractToInsert.chgstamp = 0;//0
            contractToInsert.contract_rate_type = null;//
            contractToInsert.requested_flow_start_date = contract.StartDate;//
            contractToInsert.deal_type = contract.ContractDealType != null ? contract.ContractDealType.ToString() : string.Empty;//
            contractToInsert.customer_code = null;//
            contractToInsert.customer_group = null;//
            contractToInsert.SSNClear = account.Customer.SsnClear;
            contractToInsert.SSNEncrypted = account.Customer.SsnEncrypted;
            contractToInsert.CreditScoreEncrypted = account.Customer.CreditScoreEncrypted;
            contractToInsert.HeatIndexSourceID = 0;
            contractToInsert.HeatRate = (decimal?)0.00;
            contractToInsert.evergreen_option_id = 0;
            contractToInsert.evergreen_commission_end = null;
            contractToInsert.residual_option_id = 0;
            contractToInsert.residual_commission_end = null;
            contractToInsert.initial_pymt_option_id = 0;
            contractToInsert.sales_manager = contract.SalesManager != null ? contract.SalesManager.DisplayName : string.Empty;
            contractToInsert.evergreen_commission_rate = null;
            contractToInsert.TaxStatus = 0;
            contractToInsert.PriceID = acr.PriceId;
            contractToInsert.PriceTier = acr.Price == null || acr.Price.PriceTier == null ? null : (int?) acr.Price.PriceTier.PriceTierID;
            contractToInsert.RatesString = null;
            //contractToInsert.ID //identity
            contractToInsert.CurrentNumber = null;
            contractToInsert.CurrentContAcc = null;
            return contractToInsert;
        }
        private EFDal.deal_address CreateDealAddress( CRMBAL.Account account, int addressLink, bool isBilling = false )
        {
            Address addressToUse = isBilling ? ((account.BillingAddress != null) ? account.BillingAddress : account.ServiceAddress)
                                   : account.ServiceAddress;

            //Save Details to Contact Address
            EFDal.deal_address addressToInsert = new EFDal.deal_address();
            addressToInsert.address = string.IsNullOrEmpty( addressToUse.Street ) ? string.Empty : addressToUse.Street;
            addressToInsert.address_link = addressLink;
            addressToInsert.chgstamp = 0;
            addressToInsert.city = string.IsNullOrEmpty( addressToUse.City ) ? string.Empty : addressToUse.City;
            addressToInsert.contract_nbr = contract.Number;
            addressToInsert.county = string.IsNullOrEmpty( addressToUse.County ) ? string.Empty : addressToUse.County;
            addressToInsert.county_fips = String.IsNullOrEmpty( addressToUse.CountyFips ) ? string.Empty : addressToUse.CountyFips;
            addressToInsert.state = string.IsNullOrEmpty( addressToUse.State ) ? string.Empty : addressToUse.State;
            addressToInsert.state_fips = String.IsNullOrEmpty( addressToUse.StateFips ) ? string.Empty : addressToUse.StateFips;
            addressToInsert.suite = String.IsNullOrEmpty( addressToUse.Suite ) ? string.Empty : addressToUse.Suite;
            addressToInsert.zip = String.IsNullOrEmpty( addressToUse.Zip ) ? string.Empty : addressToUse.Zip;
            return addressToInsert;
        }

        private EFDal.deal_contact CreateDealContact( Customer customer, int contactLink = 1 )
        {
            EFDal.deal_contact contactToInsert = new EFDal.deal_contact();
            contactToInsert.birthday = customer.Contact.Birthday.ToString( "mm/dd" );
            contactToInsert.chgstamp = 0;
            contactToInsert.contact_link = contactLink;
            contactToInsert.contract_nbr = contract.Number;
            contactToInsert.email = string.IsNullOrEmpty( customer.Contact.Email ) ? string.Empty : customer.Contact.Email;
            contactToInsert.fax = string.IsNullOrEmpty( customer.Contact.Fax ) ? string.Empty : customer.Contact.Fax;
            contactToInsert.first_name = string.IsNullOrEmpty( customer.Contact.FirstName ) ? string.Empty : customer.Contact.FirstName;
            contactToInsert.last_name = string.IsNullOrEmpty( customer.Contact.LastName ) ? string.Empty : customer.Contact.LastName;
            contactToInsert.phone = string.IsNullOrEmpty( customer.Contact.Phone ) ? string.Empty : customer.Contact.Phone;
            contactToInsert.title = string.IsNullOrEmpty( customer.Contact.Title ) ? string.Empty : customer.Contact.Title;
            return contactToInsert;
        }

        private EFDal.deal_name CreateDealName( int nameLink = 1 )
        {
            //Save Customer  Deal_Name
            EFDal.deal_name dealNameToInsert = new EFDal.deal_name();
            dealNameToInsert.chgstamp = 0;
            dealNameToInsert.contract_nbr = contract.Number;
            dealNameToInsert.full_name = (contract != null &&
                contract.AccountContracts.FirstOrDefault() != null &&
                contract.AccountContracts.FirstOrDefault().Account != null &&
                contract.AccountContracts.FirstOrDefault().Account.Customer != null) ?
                contract.AccountContracts.FirstOrDefault().Account.Customer.CustomerName : contract.Number;
            dealNameToInsert.name_link = nameLink;
            return dealNameToInsert;
        }

        /// <summary>
        /// Send success submission notification emails according to the links between EmailType and EmailGroup tables
        /// </summary>
        private void SendTabletContractAcceptanceNotification()
        {
            Dictionary<string, Stream> attachments = LoadEmailAttachments( this.contract.Documents, false );

            ContractSubmissionEmailHelper.SendEmail( this.contract, this.customer, attachments, CRMBAL.Enums.EmailType.TabletContractAcceptance, "" );
        }

        /// <summary>
        /// Sends failure submission email to ECM with errors for analysis and to other emails according to the
        /// links between EmailType and EmailGroup tables
        /// Should be commented once tablet changes are in production for 53868
        /// </summary>
        private void SendTabletRejectionNotification()
        {
            Dictionary<string, Stream> attachments = LoadEmailAttachments( this.contract.Documents, false );
            Dictionary<string, Stream> attachmentsECM = LoadEmailAttachments( this.contract.Documents, true );

            string errors = "";

            CurrentErrors.Select(item=>item.Message).ToList().ForEach(item=>{
            errors += item + "\r\n";
            });

            ContractSubmissionEmailHelper.SendEmail( this.contract, this.customer, attachments, CRMBAL.Enums.EmailType.TabletContractException, "" );
            ContractSubmissionEmailHelper.SendEmail( this.contract, this.customer, attachmentsECM, CRMBAL.Enums.EmailType.ECM, errors );
        }

        /// <summary>
        /// Converts a list of documents to a stream dictionary to be sent on the email
        /// </summary>
        /// <param name="documents"></param>
        /// <returns></returns>
        public static Dictionary<string, Stream> LoadEmailAttachments( List<DocumentBal.Document> documents, bool includeAudioFiles )
        {
            Dictionary<string, Stream> attachments = new Dictionary<string, Stream>();

            if (documents != null)
            {
                foreach (DocumentBal.Document document in documents)
                {
                    if (document.DocumentTypeId != 60 || includeAudioFiles)
                    {
                        MemoryStream stream = new MemoryStream();
                        stream.Write( document.FileBytes, 0, document.FileBytes.Length );
                        attachments.Add( document.Name, stream );
                    }
                }
            }

            return attachments;
        }

        #endregion

        /// <summary>
        /// This routine can be used to save datathat is useful or needed for every contract submission regardless of whether the contract submission
        /// was sucessful or not
        /// </summary>
        /// <returns></returns>
        private bool SaveContractSubmissionMeta()
        {
            if (!this.SaveTabletDocumentsMeta())
                return false;
            return true;
        }

        private bool SaveTabletDocumentsMeta()
        {
            if (!this.contract.IsTabletContract)
            {
                //functionality available only for tablet contracts
                return true;
            }

            if (this.contract.TabletDocuments == null || this.contract.TabletDocuments.Count == 0)
            {
                // nothing to save here
                return true;
            }
            // Proceed with saving the information
            using (System.Transactions.TransactionScope transaction = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBAL.CRMBaseFactory.GetStandardTransactionOptions( 1 ) ))
            {
                try
                {
                    for (int i = 0; i < this.contract.TabletDocuments.Count; i++)
                    {
                        List<GenericError> errors = null;
                        // If the file is a gas product, we need to flag it:
                        if (this.IsGasContract)
                            this.contract.TabletDocuments[i].IsGasFile = true;
                        else
                            this.contract.TabletDocuments[i].IsGasFile = false;
                        // End Gas File Changes

                        if (!CRMBAL.TabletDocumentFactory.InsertTabletDocument( this.contract.TabletDocuments[i], out errors ))
                        {
                            this._errors.AddRange( errors );
                        }
                    }
                    // Throw away data changes if this is a test submission
                    if (!this.isTest && this._errors.Count == 0)
                        transaction.Complete();
                    else
                        transaction.Dispose();

                }
                catch (Exception ex)
                {
                    LogError( ex );
                    transaction.Dispose();
                    _errors.Add( new CRMBAL.GenericError() { Code = 1, Message = ex.Message } );
                    _errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "One or more error(s) occurred, contract was not submitted" } );
                }
            }
            return this._errors.Count == 0;
        }

        /// <summary>
        /// Validate a contract submission package, it will setup default values for the fields that can be extracted from other values 
        /// </summary>
        /// <returns></returns>
        private bool ValidateContractSubmissionData()
        {
            //validate class level basic object structure
            if (!this.validator.IsClassStructureValid())
            {
                return false;
            }
            //if base objects are valid, we can now set some default values
            this.SetMissingContractSubmissionValues();
            //validate that certain Id's are set, like utility id and so forth
            if (!this.validator.AreContractSubmissionRequiredFieldsValid())
            {
                return false;
            }
            return true;
        }


        /// <summary>
        ///  Method to cancel existing Rollover Contracts for the Accounts being renewed.
        /// </summary>
        private void CancelAssociatedRolloverRenewals()
        {
            if (this.CurrentErrors.Count > 0)
                return;

            for (int i = 0; i < contract.AccountContracts.Count; i++)
            {
                string accountId = contract.AccountContracts[i].Account.AccountIdLegacy;
                string contractNumber = contract.Number;

                //check if IsRolloverRenewalActive
                if (AccountFactory.IsRolloverRenewalActive(accountId))
                { 
                    //cancel the rollover renewal
                    string comment = "Rollover renewal Cancelled for the Account" + contract.AccountContracts[i].Account.AccountNumber + "to allow renewal Contract " + contractNumber + ".";
                    LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccountFactory.CancelRenewalAccount(accountId,comment,user.Username);
                }
            }
        }


        /// <summary>
        /// This function  expects that all the required fields are properly set so that the validator can assume some null checks and some 
        /// higher level classes have been populated from given values.
        /// </summary>
        /// <returns></returns>
        private bool ValidateContractSubmissionBusinessRules()
        {
            if (!this.validator.AreContractSubmissionBusinessRulesValid())
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// Set values that are not set and be careful with things that ARE set
        /// </summary>
        private void SetMissingContractSubmissionValues()
        {
            // cannot perform this action if there are errors
            if (this.CurrentErrors.Count > 0)
                return;

            // when doing renewal we preferences are not required to be submitted with the object
            if (customer.Preferences != null)
            {
                customer.Preferences.CreatedBy = customer.Preferences.CreatedBy == 0 ? user.UserID : customer.Preferences.CreatedBy;
                customer.Preferences.ModifiedBy = customer.Preferences.ModifiedBy == 0 ? user.UserID : customer.Preferences.ModifiedBy;
            }

            customer.CustomerAddress.CreatedBy = customer.CustomerAddress.CreatedBy == 0 ? user.UserID : customer.CustomerAddress.CreatedBy;
            customer.CustomerAddress.ModifiedBy = customer.CustomerAddress.ModifiedBy == 0 ? user.UserID : customer.CustomerAddress.ModifiedBy;

            customer.Contact.CreatedBy = customer.Contact.CreatedBy == 0 ? user.UserID : customer.Contact.CreatedBy;
            customer.Contact.ModifiedBy = customer.Contact.ModifiedBy == 0 ? user.UserID : customer.Contact.ModifiedBy;

            //Contract Default Id's
            //REMOVED since there is a function call in constructor             contract.SetDefaultValues();// sets any default values that arent set yet and could be infered
            contract.SetDefaultValues();
            contract.CreatedBy = contract.CreatedBy == 0 ? user.UserID : contract.CreatedBy;
            contract.ModifiedBy = contract.ModifiedBy == 0 ? user.UserID : contract.CreatedBy;

            //Customer Default Id's
            customer.CreatedBy = customer.CreatedBy == 0 ? user.UserID : customer.CreatedBy;
            customer.ModifiedBy = customer.ModifiedBy == 0 ? user.UserID : customer.ModifiedBy;

            //Added to set the Client Application type and the Client Application Key
            //1/16/2014- 28366
            SetClientSubApplicationKey();

            for (int i = 0; i < contract.AccountContracts.Count; i++)
            {
                // See if the contract needs linking:
                if (!contract.AccountContracts[i].ContractId.HasValue && contract.AccountContracts[i].Contract == null)
                {
                    contract.AccountContracts[i].Contract = contract;
                }

                #region Set Default Account Status
                // Set Default Account Status
                if (contract.AccountContracts[i].AccountStatus == null)
                {
                    CRMBAL.AccountStatus ast = new CRMBAL.AccountStatus();
                    ast.Status = "01000";
                    ast.SubStatus = "10";
                    contract.AccountContracts[i].AccountStatus = ast;
                }
                #endregion

                #region Set Default Account Details
                // we have account, check other dependencies:
                if (contract.AccountContracts[i].Account.Details == null)
                {
                    CRMBAL.AccountDetail ad = new CRMBAL.AccountDetail();
                    contract.AccountContracts[i].Account.Details = ad;
                }
                #endregion

                #region Set Created By and Modified By fields in all objects

                contract.AccountContracts[i].CreatedBy = contract.AccountContracts[i].CreatedBy == 0 ? user.UserID : contract.AccountContracts[i].CreatedBy;
                contract.AccountContracts[i].ModifiedBy = contract.AccountContracts[i].ModifiedBy == 0 ? user.UserID : contract.AccountContracts[i].ModifiedBy;

                contract.AccountContracts[i].AccountStatus.CreatedBy = contract.AccountContracts[i].AccountStatus.CreatedBy == 0 ? user.UserID : contract.AccountContracts[i].AccountStatus.CreatedBy;
                contract.AccountContracts[i].AccountStatus.ModifiedBy = contract.AccountContracts[i].AccountStatus.ModifiedBy == 0 ? user.UserID : contract.AccountContracts[i].AccountStatus.ModifiedBy;

                contract.AccountContracts[i].Account.CreatedBy = contract.AccountContracts[i].Account.CreatedBy == 0 ? user.UserID : contract.AccountContracts[i].Account.CreatedBy;
                contract.AccountContracts[i].Account.ModifiedBy = contract.AccountContracts[i].Account.ModifiedBy == 0 ? user.UserID : contract.AccountContracts[i].Account.ModifiedBy;

                contract.AccountContracts[i].Account.Details.CreatedBy = contract.AccountContracts[i].Account.Details.CreatedBy == 0 ? user.UserID : contract.AccountContracts[i].Account.Details.CreatedBy;
                contract.AccountContracts[i].Account.Details.ModifiedBy = contract.AccountContracts[i].Account.Details.ModifiedBy == 0 ? user.UserID : contract.AccountContracts[i].Account.Details.ModifiedBy;

                contract.AccountContracts[i].Account.BillingContact.CreatedBy = contract.AccountContracts[i].Account.BillingContact.CreatedBy == 0 ? user.UserID : contract.AccountContracts[i].Account.BillingContact.CreatedBy;
                contract.AccountContracts[i].Account.BillingContact.ModifiedBy = contract.AccountContracts[i].Account.BillingContact.ModifiedBy == 0 ? user.UserID : contract.AccountContracts[i].Account.BillingContact.ModifiedBy;

                contract.AccountContracts[i].Account.ServiceAddress.CreatedBy = contract.AccountContracts[i].Account.ServiceAddress.CreatedBy == 0 ? user.UserID : contract.AccountContracts[i].Account.ServiceAddress.CreatedBy;
                contract.AccountContracts[i].Account.ServiceAddress.ModifiedBy = contract.AccountContracts[i].Account.ServiceAddress.ModifiedBy == 0 ? user.UserID : contract.AccountContracts[i].Account.ServiceAddress.ModifiedBy;

                contract.AccountContracts[i].Account.BillingAddress.CreatedBy = contract.AccountContracts[i].Account.BillingAddress.CreatedBy == 0 ? user.UserID : contract.AccountContracts[i].Account.BillingAddress.CreatedBy;
                contract.AccountContracts[i].Account.BillingAddress.ModifiedBy = contract.AccountContracts[i].Account.BillingAddress.ModifiedBy == 0 ? user.UserID : contract.AccountContracts[i].Account.BillingAddress.ModifiedBy;

                if (contract.AccountContracts[i].AccountContractCommission != null)
                {
                    contract.AccountContracts[i].AccountContractCommission.CreatedBy = contract.AccountContracts[i].AccountContractCommission.CreatedBy == 0 ? user.UserID : contract.AccountContracts[i].AccountContractCommission.CreatedBy;
                    contract.AccountContracts[i].AccountContractCommission.ModifiedBy = contract.AccountContracts[i].AccountContractCommission.ModifiedBy == 0 ? user.UserID : contract.AccountContracts[i].AccountContractCommission.ModifiedBy;
                }

                if (contract.AccountContracts[i].AccountContractRates != null)
                {
                    // 
                    for (int j = 0; j < contract.AccountContracts[i].AccountContractRates.Count; j++)
                    {
                        contract.AccountContracts[i].AccountContractRates[j].CreatedBy = contract.AccountContracts[i].AccountContractRates[j].CreatedBy == 0 ? user.UserID : contract.AccountContracts[i].AccountContractRates[j].CreatedBy;
                        contract.AccountContracts[i].AccountContractRates[j].ModifiedBy = contract.AccountContracts[i].AccountContractRates[j].ModifiedBy == 0 ? user.UserID : contract.AccountContracts[i].AccountContractRates[j].ModifiedBy;
                    }
                }

                #endregion

                #region Set Default Account Usages (if not provided)
                if (contract.AccountContracts[i].Account.AccountUsages == null || contract.AccountContracts[i].Account.AccountUsages.Count == 0)
                {
                    contract.AccountContracts[i].Account.AccountUsages = new List<CRMBAL.AccountUsage>();
                    CRMBAL.AccountUsage au = new CRMBAL.AccountUsage();
                    au.CreatedBy = user.UserID;
                    au.ModifiedBy = user.UserID;
                    au.EffectiveDate = contract.StartDate;
                    au.UsageRequestStatus = CRMBAL.Enums.UsageReqStatus.Pending;
                    contract.AccountContracts[i].Account.AccountUsages.Add( au );
                }
                #endregion

                #region Set Utility and Market objects

                if (contract.AccountContracts[i].Account.Utility == null && contract.AccountContracts[i].Account.UtilityId.HasValue)
                {
                    contract.AccountContracts[i].Account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( contract.AccountContracts[i].Account.UtilityId.Value );
                }

                if (contract.AccountContracts[i].Account.RetailMarket == null && contract.AccountContracts[i].Account.RetailMktId.HasValue)
                {
                    contract.AccountContracts[i].Account.RetailMarket = MarketManagement.UtilityManagement.MarketFactory.GetMarket( contract.AccountContracts[i].Account.RetailMktId.Value );
                }

                #endregion

                #region Set/Verify AccountLegacyId

                // Set accountid legacy even if is submitted with some id value we ignore this
                if (!string.IsNullOrWhiteSpace( contract.AccountContracts[i].Account.AccountNumber ) && contract.AccountContracts[i].Account.UtilityId.HasValue)
                {
                    using (EFDal.LibertyPowerEntities dal = new EFDal.LibertyPowerEntities())
                    {
                        string a = contract.AccountContracts[i].Account.AccountNumber;
                        int uid = contract.AccountContracts[i].Account.Utility.Identity;
                        var currAccount = dal.Accounts.Where( f => f.AccountNumber == a && f.UtilityID == uid ).FirstOrDefault();
                        if (currAccount != null)
                        {
                            // existing/returning customer assign current legacy id:
                            contract.AccountContracts[i].Account.AccountIdLegacy = currAccount.AccountIdLegacy;
                        }
                        else if (string.IsNullOrWhiteSpace( contract.AccountContracts[i].Account.AccountIdLegacy ))
                        {
                            // Automatically generate account legacy ID since  itwasnt provided - parameter not used
                            contract.AccountContracts[i].Account.AccountIdLegacy = CustomerAcquisition.ProspectManagement.ProspectContractFactory.GetNewAccountId( "" );
                        }
                    }
                }

                #endregion Set/Verify AccountLegacyId

                #region Set/Verify AccountZone
                //for the accounts that belongs to a ONE zone Utility, assign that zone to the account.
                if (string.IsNullOrEmpty( contract.AccountContracts[i].Account.Zone ))
                {
                    string oneZone;
                    if (MarketManagement.UtilityManagement.ZoneFactory.OneZoneUtility(
                        contract.AccountContracts[i].Account.Utility.Code, out oneZone ))
                    {
                        contract.AccountContracts[i].Account.Zone = oneZone;
                    }
                }
                //assign the DeliveryLocationRefID of the Zone to the account
                if (!string.IsNullOrEmpty( contract.AccountContracts[i].Account.Zone ))
                {
                    int utilityId = (contract.AccountContracts[i].Account.UtilityId == null ? 0 : int.Parse( contract.AccountContracts[i].Account.UtilityId.ToString() ));
                    contract.AccountContracts[i].Account.DeliveryLocationRefID = CommonBusiness.CommonEntity.PropertyFactory.GetLocationPropertId( contract.AccountContracts[i].Account.Zone, utilityId, contract.AccountContracts[i].Account.Utility.Code );
                }
                #endregion

                if (contract.AccountContracts[i].Account.AccountInfo != null)
                {
                    // populate missing required fields:
                    contract.AccountContracts[i].Account.AccountInfo.LegacyAccountId = contract.AccountContracts[i].Account.AccountIdLegacy;
                    contract.AccountContracts[i].Account.AccountInfo.UtilityCode = contract.AccountContracts[i].Account.Utility.Code;
                }

                //// Global Default Billing Type setting, this will be checked again in the GetExtraObjects when we handle pricing
                //if (contract.AccountContracts[i].Account.BillingType == BillingType.NotSet)
                //{
                //    contract.AccountContracts[i].Account.BillingType = BillingType.RR;
                //    // See if this is a custom deal to set this:
                //}

                //Sets the billing type of the account to the utility default
                if (contract.AccountContracts[i].Account.BillingType == BillingType.NotSet)
                {
                    switch (contract.AccountContracts[i].Account.Utility.BillingType)
                    {
                        case "BR":
                            contract.AccountContracts[i].Account.BillingType = BillingType.BR;
                            break;
                        case "DUAL":
                            contract.AccountContracts[i].Account.BillingType = BillingType.DUAL;
                            break;
                        case "RR":
                            contract.AccountContracts[i].Account.BillingType = BillingType.RR;
                            break;
                        case "SC":
                            contract.AccountContracts[i].Account.BillingType = BillingType.SC;
                            break;
                    }
                }

                //// TODO: Set default values for account object if this is a renewal 
                //if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Renewal)
                //{
                //	if (!AccountManagement.CompanyAccountFactory.IsAddOnAccount( contract.AccountContracts[i].Account.AccountNumber, contract.AccountContracts[i].Account.Utility.Code ))
                //	{
                //		CrossProductPriceSalesChannel cppsc = DailyPricingFactory.GetPrice( (long)contract.AccountContracts[i].AccountContractRates[0].PriceId );
                //		if (cppsc.ProductBrand.IsMultiTerm)
                //		{
                //			long priceId = (long)contract.AccountContracts[i].AccountContractRates[0].PriceId;
                //			int j = 0;
                //			MultiTermList multiTermList = DailyPricingFactory.SubTermsSelect( priceId );

                //			foreach (LibertyPower.Business.CustomerAcquisition.DailyPricing.MultiTerm multiTerm in multiTermList)
                //			{
                //				DateTime startDate = contract.AccountContracts[i].Account.GetCycleReadDate( multiTerm.StartDate );
                //				contract.AccountContracts[i].AccountContractRates[j].RateStart = startDate;
                //				DateTime endDate = contract.AccountContracts[i].Account.GetCycleReadDate( multiTerm.StartDate.AddMonths( multiTerm.Term ) );
                //				contract.AccountContracts[i].AccountContractRates[j].RateEnd = endDate.AddDays( -1 );

                //				contract.AccountContracts[i].AccountContractRates[j].IsCustomEnd = true;
                //				j++;
                //			}
                //		}
                //		else
                //		{
                //			DateTime startDate = contract.AccountContracts[i].Account.GetCycleReadDate( contract.StartDate );
                //			contract.AccountContracts[i].AccountContractRates[0].RateStart = startDate;
                //			DateTime endDate = startDate.AddMonths( (int)contract.AccountContracts[i].AccountContractRates[0].Term ).AddDays( -1 );
                //			contract.AccountContracts[i].AccountContractRates[0].RateEnd = endDate;
                //		}
                //	}
                //}

                AdjustRateStartDate(contract.AccountContracts[i]);

                //If the account record does not exist in the system, we need to set the origin based on the contract's ClientApplicationKey
                if (!AccountFactory.IsAccountNumberInTheSystem( contract.AccountContracts[i].Account.AccountNumber, (int)contract.AccountContracts[i].Account.UtilityId )
                        && contract.HasValidClientApplicationType)
                    contract.AccountContracts[i].Account.SetOriginBasedOnContractApplicationType( contract.ClientApplicationType );
            }

            GetExtraObjects();
        }

        /// <summary>
        /// Method that adjusts the contract start date based on:
        /// - the current contract end date for renewals when account is on contract, or
        /// - the meter read date available for the contract to start (either renewal or new deal).
        /// </summary>
        /// <param name="ac">AccountContract object</param>
        private void AdjustRateStartDate(AccountContract ac)
        {
            CrossProductPriceSalesChannel cppsc = DailyPricingFactory.GetPrice((long)ac.AccountContractRates[0].PriceId);
            DateTime priceStartDate = DateTime.MinValue;
                if (cppsc.ProductBrand.IsMultiTerm)
                {
                long priceId = (long)ac.AccountContractRates[0].PriceId;
                MultiTermList multiTermList = DailyPricingFactory.SubTermsSelect(priceId);
                priceStartDate = multiTermList.First().StartDate;
            }
            else
                priceStartDate = cppsc.StartDate;

            DateTime startDate = DateTime.MinValue;


            //If the account is currently active in the system (renewal), we need to know if it is still on contract. 
            //In this case, if the end date happens to be the same of the price start, se assume startdate = contractEndDate + 1 day. Otherwise, we will go with the price start calculation (which will be validated later).
            //If it is not a renewal, and it is a texas non-standard enrollment, we will get the start date based on the requested start date.
            if (AccountFactory.IsAccountNumberInTheSystem(ac.Account.AccountNumber, (int)ac.Account.UtilityId) && AccountFactory.IsAccountActive(ac.Account.AccountNumber, (int)ac.Account.UtilityId))
            {
                AM.CompanyAccount account = AM.CompanyAccountFactory.GetCompanyAccount(ac.Account.AccountNumber, ac.Account.Utility.Code);
                if (!account.IsExpired && account.ContractEndDate.Month == priceStartDate.Month && account.ContractEndDate.Year == priceStartDate.Year)
                    startDate = account.ContractEndDate.AddDays(1);
            }
            else if (ac.Account.RetailMarket.Code == "TX" && ac.Account.Details.EnrollmentType != CRMBAL.Enums.EnrollmentType.Standard)
            {
                startDate = GetNonStandardTexasStartDate(ac, priceStartDate);
            }

            //Here we adjust the end dates and the AccountContractRate objects start/end dates if the product is multiterm.
            //We will only calculate the very first start date for multiterm contracts, or the start date for non-multi-term if the startDate is null: 
            // if we couldn't determine the startDate for this contract based on the conditions above, we will go by the meter read date for the price start.
            if (cppsc.ProductBrand.IsMultiTerm)
            {
                long priceId = (long)ac.AccountContractRates[0].PriceId;
                MultiTermList multiTermList = DailyPricingFactory.SubTermsSelect(priceId);
                    int j = 0;

                    foreach (LibertyPower.Business.CustomerAcquisition.DailyPricing.MultiTerm multiTerm in multiTermList)
                    {
                    //We do not want to adjust the very first rate start in this case, only if the startDate is null
                    if (j != 0 || (j == 0 && startDate == DateTime.MinValue))
                        startDate = GetStartDateforACR(multiTerm.StartDate, ac);

                    ac.AccountContractRates[j].RateStart = startDate;
                    DateTime endDate = GetStartDateforACR(multiTerm.StartDate.AddMonths(multiTerm.Term), ac);
                    ac.AccountContractRates[j].RateEnd = endDate.AddDays(-1);
                    ac.AccountContractRates[j].IsCustomEnd = true;
                        j++;
                    }
                }
                else
                {
                if (startDate == DateTime.MinValue)
                    startDate = GetStartDateforACR(cppsc.StartDate, ac);

                ac.AccountContractRates[0].RateStart = startDate;
                DateTime endDate = startDate.AddMonths((int)ac.AccountContractRates[0].Term).AddDays(-1);
                ac.AccountContractRates[0].RateEnd = endDate;
            }
            
                }

        /// <summary>
        /// Returns the required start date for Texas contracts with enrollment type other then Standard
        /// </summary>
        /// <param name="ac">AccountContract object</param>
        /// <param name="priceStartDate">The contract price start date</param>
        /// <returns>Start date for the deal</returns>
        private DateTime GetNonStandardTexasStartDate(AccountContract ac, DateTime priceStartDate)
        {
            DateTime startDate = DateTime.MinValue;

            if (ac.RequestedStartDate != null && ac.RequestedStartDate != DateTime.MinValue)
                startDate = (DateTime)ac.RequestedStartDate;
            else
                startDate = priceStartDate;

            return startDate;
            }

        private DateTime GetStartDateforACR( DateTime PriceStartDate, CRMBusinessObjects.AccountContract ac )
        {
            if (!AccountFactory.IsAccountNumberInTheSystem(ac.Account.AccountNumber, ac.Account.UtilityId.Value)
                    || !AccountFactory.IsAccountActive(ac.Account.AccountNumber, ac.Account.UtilityId.Value))
            {
                return new DateTime(PriceStartDate.Year, PriceStartDate.Month, 1);
            }
            else
            {
                return GettheMeterReadStartDateforACR(PriceStartDate, ac.Account);
            }
        }

        private DateTime GettheMeterReadStartDateforACR( DateTime PriceStartDate, CRMBusinessObjects.Account Account )
        {
            DateTime meterReadDate = System.DateTime.MinValue;
            //1. Get the Meter Read Start date for the given Pricing Date
            // If there is no billing group,or date is not there, then we cannot find the  meter read dates
            //2. So going by the flow start date.date
            //3. if there is no flow start date then go by price start date
            AM.MeterReadCalendarFactory MR = new AM.MeterReadCalendarFactory();
            
            meterReadDate = MR.GetTheReadStartDateforaGivenStartMonth(Account.Utility.Code, Account.AccountNumber, PriceStartDate);

            if (meterReadDate == DateTime.MinValue)
            {
                //get the flowStartDate. date 
                meterReadDate = Account.GetFlowStartDate_NEW( PriceStartDate );
                //If its a brand new account the flowStart date will be Datetime.MIn Value so set the price date
                if (meterReadDate == DateTime.MinValue)
                    meterReadDate = PriceStartDate;
            }
            return meterReadDate;
        }


        /// <summary>
        /// Gets additional information for the deal such as price, its mainly a wrapper function
        /// </summary>
        public void GetExtraObjects()
        {
            for (int i = 0; i < contract.AccountContracts.Count; i++)
            {
                for (int j = 0; j < contract.AccountContracts[i].AccountContractRates.Count; j++)
                {
                    // Set price object, the price id gets checked later soo we dont care if we are just getting additional values for this object
                    if (contract.AccountContracts[i].AccountContractRates[j].Price == null && contract.AccountContracts[i].AccountContractRates[j].PriceId.HasValue)
                    {
                        int isFlexible = 0;
                        AccountContractRate acr = contract.AccountContracts[i].AccountContractRates[j];
                        acr.Price = PricingBal.CrossProductPriceFactory.GetSalesChannelPrice( acr.PriceId.Value );
                        //TODO: Verify this for multi-term
                        //commented toggle
                        //acr.MultiTerm = PricingBal.CrossProductPriceFactory.GetProductCrossPriceMultiTermByProductCrossPriceMultiID( acr.ProductCrossPriceMultiID );

                        //TOO: Standardize the way we get legacy id here and in the ACR factory, might need both but they should get the info from the same place
                        if (string.IsNullOrEmpty( acr.LegacyProductId ))
                        {
                            if (acr.Price.ProductBrand.IsFlexible)
                            {
                                isFlexible = 1;
                            }
                            int legacyAccountTypeID = PricingBal.DailyPricingFactory.ConvertAccountTypeID( acr.Price.Segment.Identity, "LEGACY" );
                            acr.LegacyProductId = ProductBal.ProductFactory.GetProductID( acr.Price.ProductBrand.ProductBrandID, acr.Price.Utility.Code, legacyAccountTypeID, isFlexible );
                        }
                        if (!acr.RateId.HasValue || acr.RateId == 0)
                        {
                            acr.RateId = ProductBal.ProductRateFactory.GetNewRateID();
                        }

                        // for custom pricing we need to ensure we set the billing type:
                        if (acr.Price.ProductBrand.IsCustom)
                        {
                            // get the value for billing type
                            using (EFDal.LpDealCaptureEntities dal = new EFDal.LpDealCaptureEntities())
                            {
                                var dcDetail = dal.deal_pricing_detail.FirstOrDefault( f => f.PriceID == acr.PriceId.Value );

                                if (dcDetail != null && dcDetail.BillingTypeId.HasValue)
                                    contract.AccountContracts[i].Account.BillingTypeId = dcDetail.BillingTypeId.Value;
                            }
                        }

                    }
                }
            }
        }


        /// <summary>
        /// Sets the Client Application type and the Application Key Id from the Guid Key submitted by the client application
        /// If the key is provided, we will get the details from Libertypower entity and assign the values to the contract object to be used later for saving to the [ContractClientSubApplication]
        /// </summary>
        public void SetClientSubApplicationKey()
        {
            if (contract.ClientSubmitApplicationKey.HasValue)
            {
                using (EFDal.LibertyPowerEntities dal = new EFDal.LibertyPowerEntities())
                {
                    var ApplicationKeyDetails = dal.ClientSubmitApplicationKeys.FirstOrDefault( f => f.ApplicationKey == contract.ClientSubmitApplicationKey.Value );

                    if (ApplicationKeyDetails != null)
                    {
                        contract.ClientSubmitApplicationKeyId = ApplicationKeyDetails.ClientSubApplicationKeyId;
                        contract.ClientSubmitApplicationKeyDetails = ApplicationKeyDetails;
                    }
                }
            }

        }


        /// <summary>
        /// We save all contract information here, either rewnewal or new deals, it assumes that all 
        /// validation was performed and this function should NOT have any validation nor business logic
        ///if the Contract DealType is Amendment then we save the current Account information to the existing old contractId
        /// </summary>
        /// <returns></returns>
        private bool SaveContractInformation()
        {
            List<CRMBAL.GenericError> tempErrors = new List<CRMBAL.GenericError>();
            //  Amendment Added on June 17 2013
            //Bug 7839: 1-64232573 Contract Amendments
            int contractIdforAmendment = 0;
            if (this.contract.ContractDealType == CRMBAL.Enums.ContractDealType.Amendment)
            {
                contractIdforAmendment = existingContract.ContractId.Value;
            }
            if (this.CurrentErrors.Count > 0)
                return false;

            //Updated the transaction timeout to 30 minutes 
            //BUG 54715 -T-Mobile Submission  FSD 1/2015 
            using (System.Transactions.TransactionScope transaction = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBAL.CRMBaseFactory.GetStandardTransactionOptions(30) ))
            {
                
                try
                {
                    //Cancel existing Rollover Contracts for the Accounts being renewed.
                    this.CancelAssociatedRolloverRenewals(); 

                    #region Insert the records

                    //Insert Customer Information
                    if (!this.SaveCustomerInformation( out tempErrors ))
                    {
                        _errors.AddRange( tempErrors );
                        throw new ContractSubmissionException();
                    }

                    // Insert Contractfor only new and renewal
                    if (this.contract.ContractDealType == CRMBAL.Enums.ContractDealType.New || this.contract.ContractDealType == CRMBAL.Enums.ContractDealType.Renewal || this.contract.ContractDealType == CRMBAL.Enums.ContractDealType.RolloverRenewal)
                    {
                        if (!ContractFactory.InsertContract( contract, out tempErrors ))
                        {
                            _errors.AddRange( tempErrors );
                            throw new ContractSubmissionException();
                        }
                    }
                    //For Amendment type we need to save all the accounts and the other related info to the old Contractid 
                    //Bug 7839: 1-64232573 Contract Amendments
                    //Amendment Added on June 17 2013
                    foreach (AccountContract accountContract in contract.AccountContracts)
                    {

                        accountContract.Account.CustomerId = customer.CustomerId;

                        if (!this.SaveAccount( accountContract, out tempErrors ))
                        {
                            _errors.AddRange( tempErrors );
                            throw new ContractSubmissionException();
                        }

                        accountContract.AccountId = accountContract.Account.AccountId;
                        if (this.contract.ContractDealType == CRMBAL.Enums.ContractDealType.Amendment)
                        {
                            accountContract.ContractId = contractIdforAmendment;
                        }
                        else
                        {
                            accountContract.ContractId = contract.ContractId;
                        }

                        accountContract.Account.AccountUsages[0].AccountId = accountContract.Account.AccountId;

                        // Insert usage info - should have one usage only:
                        // if( !CRMBAL.AccountFactory.InsertAccountUsage( accountContract.Account.AccountUsages[0], out tempErrors ) )
                        if (!this.SaveAccountUsage( accountContract.Account.AccountUsages[0], out tempErrors ))
                        {
                            _errors.AddRange( tempErrors );
                            throw new ContractSubmissionException();
                        }

                        SetEnrollmentDate( accountContract, contract );

                        // Method to adjust contract rate for New jersey --RAJU
                        AdjustNJContractRate( accountContract );


                        if (!ContractFactory.InsertAccountContract( accountContract, out tempErrors ))
                        {
                            _errors.AddRange( tempErrors );
                            throw new ContractSubmissionException();
                        }

                        AccountManagement.ContractFactory.InsertAccountStatusHistory( user.Username, accountContract.Account.AccountIdLegacy, accountContract.AccountStatus.Status, accountContract.AccountStatus.SubStatus, contract.SubmitDate, "DEAL CAPTURE", accountContract.Account.Utility.Code );

                        if (!this.SaveAccountInfo( accountContract, out tempErrors ))
                        {
                            _errors.AddRange( tempErrors );
                            throw new ContractSubmissionException();
                        }

                        //Save the Contract Qualifier
                        //Sept 25 2013

                        if (!this.SaveContractQualifier( accountContract, out tempErrors ))
                        {
                            _errors.AddRange( tempErrors );
                            throw new ContractSubmissionException();
                        }


                    }

                    // Save documents					
                    if (contract.Documents != null)
                    {
                        foreach (LibertyPower.Business.CommonBusiness.DocumentManager.Document doc in contract.Documents)
                        {
                            string ContractNumber;
                            //   Amendment Added on June 17 2013
                            //Bug 7839: 1-64232573 Contract Amendments
                            if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Amendment)
                            {
                                ContractNumber = existingContract.Number;
                            }
                            else
                            {
                                ContractNumber = contract.Number;
                            }
                            LibertyPower.Business.CommonBusiness.DocumentManager.DocumentManager.SaveDocument( doc.FileBytes, doc.Name, doc.DocumentTypeId, ContractNumber, user.Username );

                        }
                    }

                    // Save contract template
                    if (contract.ContractTemplateVersionId.HasValue && contract.ContractTemplateVersionId > 0)
                    {
                        string ContractNumber;
                        //   Amendment Added on June 17 2013
                        //Bug 7839: 1-64232573 Contract Amendments
                        if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Amendment)
                        {
                            ContractNumber = existingContract.Number;
                        }
                        else
                        {
                            ContractNumber = contract.Number;
                        }

                        CRMBAL.ContractFactory.UpdateContractVersion( ContractNumber, contract.ContractTemplateVersionId.Value );
                        CRMBAL.ContractFactory.UpdateAccountLanguagePreference( ContractNumber, contract.ContractTemplateVersionId.Value );
                    }

                    #endregion

                    #region Additional Steps

                    #region Process Deal Submission Event

                    try
                    {
                        foreach (var ac in contract.AccountContracts)
                        {
                            AM.AccountEventType eventType = AccountManagement.AccountEventType.DealSubmission;
                            if( this.contract.ContractDealType == CRMBAL.Enums.ContractDealType.Renewal )
                                eventType = AccountManagement.AccountEventType.RenewalSubmission;
                            else if ( this.contract.ContractDealType == CRMBAL.Enums.ContractDealType.Conversion )
                                eventType = AccountManagement.AccountEventType.ContractConversion;
                            else if (this.contract.ContractDealType == CRMBAL.Enums.ContractDealType.RolloverRenewal)
                                eventType = AccountManagement.AccountEventType.Rollover;
                            AccountManagement.AccountEventProcessor.ProcessEvent( eventType, ac.Account.AccountNumber, ac.Account.Utility.Code );
                        }
                        // AccountManagement.AccountEventProcessor.ProcessEvent( AccountManagement.AccountEventType.DealSubmission, contract.AccountContracts[0].Account.AccountNumber, contract.AccountContracts[0].Account.Utility.Code );
                    }
                    catch (Exception ex)
                    {
                        LogError( ex );
                        transaction.Dispose();
                        _errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Error while trying to call AccountManagement.AccountEventProcessor.ProcessEvent" } );
                        _errors.Add( new CRMBAL.GenericError() { Code = 1, Message = ex.Message } );
                    }

                    #endregion

                    #region Submit Historical Usage Request

                    if (!(contract.ContractDealType == CRMBAL.Enums.ContractDealType.RolloverRenewal))
                    {
                    //TODO: We need to spawn a new process here and remove the try catch
                    //try
                    //{
                    if (IsGetUsageEnabled())
                    {
                        //CancellationTokenSource tokenSource = new CancellationTokenSource();
                        //var watch = Stopwatch.StartNew();
                            Task tAcquire = Task.Factory.StartNew(() => GetUsage(contract.AccountContracts[0].Account)/*, tokenSource.Token */);
                        //tokenSource.Cancel();

                    }
                    //}
                    //catch { }
                    }
                    else
                    {
                         LogError( new Exception("Skipping Usage check for Rollover Contracts"));
                    }

                    #endregion

                    #region Run MtM process
                    try
                    {
                        //Per Cathy if this fails is ok
                        RunMtM();
                    }
                    catch { }
                    #endregion Run MtM process

                    #region Process the Account Payment Term

                    this.ProcessPaymentTerm();

                    #endregion Process the Account Payment Term

                    #region UPdate the rate submit index when the process is successfull
                    //Added on JUne 20 2013 
                    //BUg 13630 1-143915081 - Verizon FSD 6/2013 Update the rate submitted for Custom price to true only when the it is successfully processed when send to LP

                    this.UpdateCustomRateSubmitIndex();

                    #endregion
                    #endregion

                    // Throw away data changes if this is a test submission
                    if (!this.isTest)
                        transaction.Complete();
                    else
                        transaction.Dispose();

                }
                catch (Exception ex)
                {
                    LogError( ex );
                    transaction.Dispose();
                    _errors.Add( new CRMBAL.GenericError() { Code = 1, Message = ex.Message } );
                    //if( ex.InnerException != null )
                    //{
                    //    _errors.Add( new CRMBAL.GenericError() { Code = 1, Message = ex.InnerException.Message } );
                    //}
                    //_errors.Add( new CRMBAL.GenericError() { Code = 1, Message = ex.StackTrace } );
                    _errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "One or more error(s) occurred, contract was not submitted" } );
                }
            }

            return _errors.Count == 0;
        }

        #region Helper Methods

        private bool SaveCustomerInformation( out List<CRMBAL.GenericError> tempErrors )
        {
            tempErrors = new List<CRMBAL.GenericError>();

            switch (contract.ContractDealType)
            {
                case CRMBAL.Enums.ContractDealType.New:
                    CustomerFactory.InsertCustomer( customer, customer.Preferences, customer.CustomerAddress, customer.Contact, out tempErrors );
                    _errors.AddRange( tempErrors );
                    break;
                case CRMBAL.Enums.ContractDealType.Renewal:
                case CRMBAL.Enums.ContractDealType.RolloverRenewal:
                    //if (customer.Preferences != null)
                    //{
                    //    CustomerPreferenceFactory.UpdateCustomerPreference( customer.Preferences, out tempErrors );
                    //    _errors.AddRange( tempErrors );
                    //}

                    //AddressFactory.InsertCustomerAddress( customer.CustomerAddress, customer.CustomerId.Value, out tempErrors );
                    //_errors.AddRange( tempErrors );
                    //customer.AddressId = customer.CustomerAddress.AddressId;
                    //ContactFactory.InsertCustomerContact( customer.Contact, customer.CustomerId.Value, out tempErrors );
                    //_errors.AddRange( tempErrors );
                    //customer.ContactId = customer.Contact.ContactId;
                    // Jaime: Had to remove this because of merge collision, need to review.
                    // CustomerFactory.UpdateCustomer( customer, out tempErrors );
                    // _errors.AddRange( tempErrors );
                    //PBI 11924 -- Customer will be inserted so that accounts that belong to the current contract and are not in the renewal
                    // won't have the customer updated.
                    CustomerFactory.InsertCustomer( customer, customer.Preferences, customer.CustomerAddress, customer.Contact, out tempErrors );
                    _errors.AddRange( tempErrors );
                    break;
                //   Amendment Added on June 17 2013
                //Bug 7839: 1-64232573 Contract Amendments
                case CRMBAL.Enums.ContractDealType.Amendment:
                    int? customerId;
                    CustomerFactory.GetCustomerIdforContractNumber( existingContract.Number, out tempErrors, out customerId );
                    _errors.AddRange( tempErrors );
                    customer.CustomerId = customerId;
                    break;
                default:
                    throw new NotImplementedException( "Conversion New deal type not implemented" );
            }
            return _errors.Count == 0;
        }

        //Bug 7839: 1-64232573 Contract Amendments
        //Amendment Added on June 17 2013
        //ExistingContractIdForAmendment optional parameter is added
        private bool SaveAccount( AccountContract accountContract, out List<CRMBAL.GenericError> tempErrors )
        {
            tempErrors = new List<CRMBAL.GenericError>();

            if (!AccountFactory.IsAccountNumberInTheSystem( accountContract.Account.AccountNumber, accountContract.Account.UtilityId.Value ))
            {
                SetAccountIdLegacy( accountContract );
                if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Renewal)
                {
                    // if renewal and account is new then is an add on account
                    accountContract.Account.CurrentContractId = contract.ContractId;
                    accountContract.Account.CurrentRenewalContractId = contract.ContractId;
                }
                else if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.New)
                {
                    accountContract.Account.CurrentContractId = contract.ContractId;
                }
                //For Amendment
                //   Amendment Added on June 17 2013
                //Bug 7839: 1-64232573 Contract Amendments
                else if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Amendment)
                {
                    //if the current Contract is Ammendment and the existing contract is Renewal 
                    //then set both the Current Contract and the CurrentRenewal Contract to the existing Contract ID
                    if (existingContract.ContractDealType == CRMBAL.Enums.ContractDealType.Renewal)
                    {
                        // if renewal and account is new then is an add on account
                        accountContract.Account.CurrentContractId = existingContract.ContractId;
                        accountContract.Account.CurrentRenewalContractId = existingContract.ContractId;
                    }
                    //if the current Contract is Ammendment and the existing contract is New 
                    //then set  the Current Contract  to the existing Contract ID
                    else if (existingContract.ContractDealType == CRMBAL.Enums.ContractDealType.New)
                    {
                        accountContract.Account.CurrentContractId = existingContract.ContractId;
                    }

                }

                // Insert Account
                AccountFactory.InsertAccount( accountContract.Account, accountContract.Account.Details, accountContract.Account.ServiceAddress, accountContract.Account.BillingAddress, accountContract.Account.BillingContact, out tempErrors );
                _errors.AddRange( tempErrors );
            }
            else // Account is in the system fill up the accountid and the accountidlegacy
            {
                SetAccountUpdateableValues( accountContract );
                //this needs to be after the previous statement since the previous statement sets the old renewal id from the current record
                if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Renewal || contract.ContractDealType == CRMBAL.Enums.ContractDealType.RolloverRenewal)
                {
                    //if account is in the system and is a renewal, this is the normal renewal path, so just set the renewalid
                    accountContract.Account.CurrentRenewalContractId = contract.ContractId;
                    //Added to fix Origin=CustomDealUpload related issues
                    //(Records isnerted through Custom DealUPload had CurrentContractId as Null)  Jan 3 2014
                    if (accountContract.Account.CurrentContractId == null)
                        accountContract.Account.CurrentContractId = contract.ContractId;

                }
                else if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.New)
                {
                    // account is in the system but is a new deal then the customer must have been inactive
                    accountContract.Account.CurrentContractId = contract.ContractId;
                }
                //For Amendment
                //   Amendment Added on June 17 2013
                //Bug 7839: 1-64232573 Contract Amendments
                else if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Amendment)
                {
                    //if the current Contract is Ammendment and the existing contract is Renewal 
                    //then set both the Current Contract and the CurrentRenewal Contract to the existing Contract ID
                    if (existingContract.ContractDealType == CRMBAL.Enums.ContractDealType.Renewal)
                    {
                        // if renewal and account is new then is an add on account
                        accountContract.Account.CurrentRenewalContractId = existingContract.ContractId;
                        //Added to fix Origin=CustomDealUpload related issues
                        //(Records isnerted through Custom DealUPload had CurrentContractId as Null)  Jan 3 2014
                        if (accountContract.Account.CurrentContractId == null)
                            accountContract.Account.CurrentContractId = existingContract.ContractId;
                    }
                    //if the current Contract is Ammendment and the existing contract is New 
                    //then set  the Current Contract  to the existing Contract ID
                    else if (existingContract.ContractDealType == CRMBAL.Enums.ContractDealType.New)
                    {
                        accountContract.Account.CurrentContractId = existingContract.ContractId;
                    }

                }

                // need to insert billing address, etc
                AccountFactory.UpdateAccount( accountContract.Account, accountContract.Account.Details, accountContract.Account.ServiceAddress, accountContract.Account.BillingAddress, accountContract.Account.BillingContact, out tempErrors );
                _errors.AddRange( tempErrors );
            }
            return _errors.Count == 0;
        }

        private bool SaveAccountInfo( AccountContract accountContract, out List<CRMBAL.GenericError> tempErrors )
        {
            tempErrors = new List<CRMBAL.GenericError>();
            // create the account_info if !Exist
            AccountInfo currentAI = CRMBAL.AccountFactory.GetAccountInfo( accountContract.Account.AccountIdLegacy );
            if (currentAI != null)
            {
                // update the values if set
                if (accountContract.Account.AccountInfo != null)
                {
                    if (!string.IsNullOrEmpty( accountContract.Account.AccountInfo.BillingAccount ))
                        currentAI.BillingAccount = accountContract.Account.AccountInfo.BillingAccount;
                    currentAI.CreatedBy = user.Username;
                    currentAI.DateCreated = DateTime.Now;
                    if (!string.IsNullOrEmpty( accountContract.Account.AccountInfo.MeterDataMgmtAgent ))
                        currentAI.MeterDataMgmtAgent = accountContract.Account.AccountInfo.MeterDataMgmtAgent;
                    if (!string.IsNullOrEmpty( accountContract.Account.AccountInfo.MeterInstaller ))
                        currentAI.MeterInstaller = accountContract.Account.AccountInfo.MeterInstaller;
                    if (!string.IsNullOrEmpty( accountContract.Account.AccountInfo.MeterOwner ))
                        currentAI.MeterOwner = accountContract.Account.AccountInfo.MeterOwner;
                    if (!string.IsNullOrEmpty( accountContract.Account.AccountInfo.MeterReader ))
                        currentAI.MeterReader = accountContract.Account.AccountInfo.MeterReader;
                    if (!string.IsNullOrEmpty( accountContract.Account.AccountInfo.MeterServiceProvider ))
                        currentAI.MeterServiceProvider = accountContract.Account.AccountInfo.MeterServiceProvider;
                    if (!string.IsNullOrEmpty( accountContract.Account.AccountInfo.NameKey ))
                        currentAI.NameKey = accountContract.Account.AccountInfo.NameKey;
                    if (!string.IsNullOrEmpty( accountContract.Account.AccountInfo.SchedulingCoordinator ))
                        currentAI.SchedulingCoordinator = accountContract.Account.AccountInfo.SchedulingCoordinator;
                    currentAI.UtilityCode = accountContract.Account.Utility.Code;
                    CRMBAL.AccountFactory.UpdateAccountInfo( currentAI, out tempErrors );
                }
            }
            else
            {
                //insert the account info record if provided
                if (accountContract.Account.AccountInfo == null)
                {
                    accountContract.Account.AccountInfo = new AccountInfo();
                    accountContract.Account.AccountInfo.LegacyAccountId = accountContract.Account.AccountIdLegacy;
                    accountContract.Account.AccountInfo.UtilityCode = accountContract.Account.Utility.Code;
                    accountContract.Account.AccountInfo.CreatedBy = user.Username;
                    accountContract.Account.AccountInfo.DateCreated = DateTime.Now;
                }
                CRMBAL.AccountFactory.InsertAccountInfo( accountContract.Account.AccountInfo, out tempErrors );
            }
            return _errors.Count == 0;
        }

        private void SetAccountIdLegacy( AccountContract accountContract )
        {
            if (string.IsNullOrEmpty( accountContract.Account.AccountIdLegacy ))
            {
                // Automatically generate account legacy ID - parameter not used
                accountContract.Account.AccountIdLegacy = CustomerAcquisition.ProspectManagement.ProspectContractFactory.GetNewAccountId( "" );
            }
        }

        /// <summary>
        /// This functions has to prevents fields from being overwritten, 
        /// some fields are not exposed to the outside and therefore might have invalid values
        /// </summary>
        /// <param name="accountContract"></param>
        private void SetAccountUpdateableValues( AccountContract accountContract )
        {
            Account tmpAccount = AccountFactory.GetAccount( accountContract.Account.AccountNumber, accountContract.Account.UtilityId.Value );

            #region Cleanup Al's crappy "do not enroll" mess:

            if (tmpAccount.Zone == null)
                tmpAccount.Zone = "";

            if (tmpAccount.Tcap == null)
                tmpAccount.Tcap = "";

            if (tmpAccount.Icap == null)
                tmpAccount.Icap = "";

            if (tmpAccount.ServiceRateClass == null)
                tmpAccount.ServiceRateClass = "";

            if (tmpAccount.LoadProfile == null)
                tmpAccount.LoadProfile = "";

            if (tmpAccount.ServiceRateClass == null)
                tmpAccount.ServiceRateClass = "";

            if (tmpAccount.LossCode == null)
                tmpAccount.LossCode = "";

            if (tmpAccount.StratumVariable == null)
                tmpAccount.StratumVariable = "";

            if (!tmpAccount.AccountTypeId.HasValue)
                tmpAccount.AccountType = accountContract.Account.AccountType;

            if (tmpAccount.BillingGroup == null)
                tmpAccount.BillingGroup = "";

            if (tmpAccount.Origin == null)
            {
                tmpAccount.Origin = "ONLINE";
            }
            else if (!string.IsNullOrWhiteSpace( tmpAccount.Origin ))
            {
                // Maintain the original Origin field if it was there before
                accountContract.Account.Origin = tmpAccount.Origin;
            }
            #endregion

            accountContract.Account.AccountId = tmpAccount.AccountId;
            accountContract.Account.AccountIdLegacy = tmpAccount.AccountIdLegacy;
            accountContract.Account.AccountNameId = tmpAccount.AccountNameId;

            accountContract.Account.EntityId = tmpAccount.EntityId;

            if (!accountContract.Account.TaxStatusId.HasValue)
                accountContract.Account.TaxStatusId = tmpAccount.TaxStatusId;

            accountContract.Account.CurrentContractId = tmpAccount.CurrentContractId;
            accountContract.Account.CurrentRenewalContractId = tmpAccount.CurrentRenewalContractId;

            /**
             * PBI 68087
             * Andre Damasceno - 04/22/2015
             * Added test in DeliveryLocationRefID and Zone = "0", try to prevent this method resets the account values
             */
            if (accountContract.Account.DeliveryLocationRefID.HasValue)
                accountContract.Account.DeliveryLocationRefID = tmpAccount.DeliveryLocationRefID;

            if (string.IsNullOrEmpty(accountContract.Account.Zone) || accountContract.Account.Zone == "0")
                accountContract.Account.Zone = tmpAccount.Zone;

            if (string.IsNullOrEmpty( accountContract.Account.Tcap ))
                accountContract.Account.Tcap = tmpAccount.Tcap;

            if (string.IsNullOrEmpty( accountContract.Account.Icap ))
                accountContract.Account.Icap = tmpAccount.Icap;

            if (string.IsNullOrEmpty( accountContract.Account.ServiceRateClass ))
                accountContract.Account.ServiceRateClass = tmpAccount.ServiceRateClass;

            if (!accountContract.Account.AccountTypeId.HasValue)
                accountContract.Account.AccountTypeId = tmpAccount.AccountTypeId;

            if (string.IsNullOrEmpty( accountContract.Account.LoadProfile ))
                accountContract.Account.LoadProfile = tmpAccount.LoadProfile;


            if (string.IsNullOrEmpty( accountContract.Account.LossCode ))
                accountContract.Account.LossCode = tmpAccount.LossCode;

            if (string.IsNullOrEmpty( accountContract.Account.StratumVariable ))
            {
                if (!string.IsNullOrEmpty( tmpAccount.StratumVariable ))
                    accountContract.Account.StratumVariable = tmpAccount.StratumVariable;
                else
                    accountContract.Account.StratumVariable = ""; // If this is null in the database it will generate an error therefore we set it to blank
            }

            if (string.IsNullOrEmpty( accountContract.Account.BillingGroup ))
                accountContract.Account.BillingGroup = tmpAccount.BillingGroup;

            accountContract.Account.PorOption = tmpAccount.PorOption;
            accountContract.Account.ModifiedBy = user.UserID;
            accountContract.Account.CreatedBy = tmpAccount.CreatedBy;

            if (AccountFactory.IsAccountActive(accountContract.Account.AccountNumber, accountContract.Account.UtilityId.Value))
            accountContract.Account.BillingType = tmpAccount.BillingType;
            else
                accountContract.Account.BillingType = LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums.BillingType.NotSet;

        }

        private void SetEnrollmentDate( AccountContract ac, CRMBAL.Contract newContract )
        {
            if (ac.Account.Utility == null)
                ac.Account.Utility = MarketBAL.UtilityManagement.UtilityFactory.GetUtilityById( ac.Account.UtilityId.Value );

            int enrollmentLeadDays = ac.Account.Utility.EnrollmentLeadDays;

            DateTime enrDate;
            // if texas 
            if (ac.Account.RetailMktId == 1 && ac.RequestedStartDate.HasValue && ac.RequestedStartDate.Value > DateTime.MinValue)
            {
                enrDate = ac.RequestedStartDate.Value;
            }
            else
            {
                enrDate = newContract.StartDate;
            }

            //the SendEnrollmentDate should be equal the "Request Start Date"/"Contract Start Date" minus the enrollmentLeadDays. "Request Start date" is the first of the month of the request start date. 
            //If the SendEnrollmentDate falls on a a weekend, it shoud be modified to reflect the Friday just before
            enrDate = DateTime.Parse( enrDate.Month.ToString() + "/01/" + enrDate.Year.ToString() );
            enrDate = enrDate.AddDays( -enrollmentLeadDays );
            if (enrDate.DayOfWeek == DayOfWeek.Saturday)
                enrDate = enrDate.AddDays( -1 );
            else if (enrDate.DayOfWeek == DayOfWeek.Sunday)
                enrDate = enrDate.AddDays( -2 );
            ac.SendEnrollmentDate = enrDate;
        }

        private bool SaveAccountUsage( AccountUsage accountUsage, out List<CRMBAL.GenericError> tempErrors )
        {
            tempErrors = new List<CRMBAL.GenericError>();
            AccountUsage tmpAu = CRMBusinessObjects.AccountFactory.GetAccountUsageByAccountIdAndEffectiveDate( accountUsage.AccountId.Value, accountUsage.EffectiveDate );
            if (tmpAu == null)
            {
                // there is not a record for this specific time period, no need to create
                CRMBAL.AccountFactory.InsertAccountUsage( accountUsage, out tempErrors );
            }
            //TODO: Implement the update to at least have some record of the update 
            return _errors.Count == 0;
        }

        /// <summary>
        /// Run the MtM process once the contract has been successfully submitted.
        /// the configuration for the MtM service is present in the web.config of the cRMService. if anyone needs to run this code without using the CRMWebservice, the configuration
        /// of the endpoints for MtM service should be copied over to the web.config of whatever UI will be calling this code
        /// if the MtM flag is not present, an exception will be returned, which is ok bcos then the developer will fix the issue as we should always be aware and know if we need to run MtM or not
        /// </summary>
        private void RunMtM()
        {
            bool runMtM = ConfigurationManager.AppSettings["RunMtM"] == null ? false : ConfigurationManager.AppSettings["RunMtM"].Equals( "1" );
            if (runMtM)
            {
				var mtmClient = new MarkToMarketServiceReference.MarkToMarketServiceClient( ConfigurationManager.AppSettings["MarkToMarketSvcEndPt"] );
                mtmClient.CheckProductAndRunForecasting( contract.AccountContracts[0].Account.Origin, contract.Number, contract.AccountContracts[0].AccountContractRates[0].PriceId.Value );
            }
        }

        private void GetUsage( Account account )
        {
            try
            {
                if (account.Utility.HU_RequestType.Trim() == "EDI")
                    // LibertyPower.DataAccess.WebServiceAccess.IstaWebService.UsageService.SubmitHistoricalUsageRequest( account.AccountNumber, user.Username, "Enrollment", account.Utility.Code );
                    AccountManagement.CompanyAccountFactory.RequestAccountUsage( account.AccountNumber, user.Username, "ENROLLMENT", account.Utility.Code );
                else //if( account.Utility.IsScrapable )
                {
					AccountManagement.AcquireUsage acquireUsage = new AccountManagement.AcquireUsage( account.Utility, account.AccountNumber, "ENROLLMENT" );
                    string temp = acquireUsage.ProcessName;
                    acquireUsage.Run( contract.Number, account.AccountIdLegacy, user.Username );
                }
            }
            catch (Exception ex)
            {
                LogError( ex );
            }
        }

        private bool IsGetUsageEnabled()
        {
            bool IsEnabled = false;
            if (ConfigurationManager.AppSettings["ServerType"] == null)
            {
                IsEnabled = false;
            }
            else
            {
                IsEnabled = ConfigurationManager.AppSettings["ServerType"].Equals( "Production", StringComparison.OrdinalIgnoreCase );

            }
            return IsEnabled;
            //return ConfigurationManager.AppSettings["ServerType"] == null
            //                               ? false
            //                               : ConfigurationManager.AppSettings["ServerType"].Equals( "Production", StringComparison.OrdinalIgnoreCase );
        }

        public static void LogError( Exception ex )
        {
            try
            {
                string logName = "OrdersAPI";
                string additionalDataStr = TryToSerializeExceptionDataDictionaryToString(ex);
                string errorToDisplayInLog = logName + System.Environment.NewLine + "Error Message: " + ex.Message + System.Environment.NewLine + "Stack Trace:" + ex.StackTrace + (!string.IsNullOrWhiteSpace(additionalDataStr) ? Environment.NewLine + "Additional Data: " + additionalDataStr : null);

                if (!System.Diagnostics.EventLog.SourceExists( logName ))
                {
                    System.Diagnostics.EventLog.CreateEventSource( logName, logName );
                }

                System.Diagnostics.EventLog.WriteEntry( logName, errorToDisplayInLog, System.Diagnostics.EventLogEntryType.Error );
            }
            catch (Exception)
            {
            }
        }

        /// <summary>
        /// Tries to serialize the exception additional Data dictionary into a string.
        /// </summary>
        /// <param name="ex">The exception with the additional data to serialize</param>
        /// <returns>The generated string</returns>
        private static string TryToSerializeExceptionDataDictionaryToString(Exception ex)
        {
            try
            {
                StringBuilder result = new StringBuilder("");

                if (ex.Data != null && ex.Data.Count > 0)
                    foreach (var key in ex.Data.Keys)
                        result.Append(key.ToString()).Append(": ").Append(ex.Data[key.ToString()].ToString()).Append(", ");

                return result.ToString().TrimEnd().TrimEnd(',');
            } catch
            {
                return null;
            }
        }

        /// <summary>
        /// Processes payment term for the entire contract
        /// </summary>
        private void ProcessPaymentTerm()
        {
            foreach (var ac in this.contract.AccountContracts)
            {
                using (EFDal.Lp_AccountEntities dal = new EFDal.Lp_AccountEntities())
                {
                    // see if we got some account_id legacy:
                    if (dal.AccountPaymentTerms.FirstOrDefault( f => f.accountId == ac.Account.AccountIdLegacy ) == null)
                    {
                        // If the record doesnt exist then we need to provide it
                        EFDal.AccountPaymentTerm pt = new EFDal.AccountPaymentTerm();
                        pt.accountId = ac.Account.AccountIdLegacy;
                        //    //24311  Fix Payment Term Logic in Deal Capture (Contract API ) Oct 31 2013
                        //Due to a bug that is defaulting all the Account Payment terms to 16, we are commenting this code and inserting a value of 0
                        //The Account payment term is used for overriding the default values, This can be done through Enrollment Application
                        pt.paymentTerm = 0;
                        // pt.paymentTerm = AccountFactory.GetAccountPaymentTerms(ac.Account.Utility, ac.Account);
                        pt.dateCreated = DateTime.Now;
                        dal.AccountPaymentTerms.AddObject( pt );
                        dal.SaveChanges();
                    }
                }


            }
        }

        /// <summary>
        /// For New jersey the contract rate needs to be adjusted SR#1-178962126
        /// </summary>
        /// <param name="accountContract"></param>
        private void AdjustNJContractRate( AccountContract accountContract )
        {
            if (accountContract.Account.RetailMarket.Code == "NJ")
            {
                LibertyPower.Business.MarketManagement.UtilityManagement.RetailMarketSalesTax salesTax = LibertyPower.Business.MarketManagement.UtilityManagement.MarketFactory.GetMarketSalesTax( accountContract.Account.RetailMarket, contract.SignedDate );
                foreach (var subTermRate in accountContract.AccountContractRates)
                {
                    // For variable products do not remove sales tax from contract rate
                    if (salesTax != null && subTermRate.Price.ProductType.Identity != 2)
                    {
                        //modified the tax calculations  pbi:24305 October 31 2013
                        subTermRate.Rate = Math.Round( Convert.ToDouble( subTermRate.Rate / (1 + salesTax.SalesTax) ), 5 );
                        //subTermRate.Rate = Math.Round(Convert.ToDouble(subTermRate.Rate * (1 - salesTax.SalesTax)), 5);
                    }
                    else
                    {
                        // Not rounding the values which are not adjusted
                        subTermRate.Rate = Convert.ToDouble( subTermRate.Rate );
                    }

                }

            }
        }


        /// <summary>
        /// Update rate submit Index for a custom fixed price to true  when the contract is send to Liberty Power
        /// </summary>
        private void UpdateCustomRateSubmitIndex()
        //Added on JUne 20 2013 
        //BUg 13630 1-143915081 - Verizon FSD 6/2013 Update the rate submitted to true only when the it is successfully processed when send to LP
        {
            using (EFDal.LpDealCaptureEntities dal = new EFDal.LpDealCaptureEntities())
            {
                if (this.contract.AccountContracts[0].AccountContractRates[0].Price.ProductBrand.IsCustom)
                {
                    var priceData = dal.deal_contract.Join( dal.deal_pricing_detail, a => a.PriceID, b => b.PriceID, ( a, b ) => new { deal_pricingdetail = b, deal_contract = a } ).Where( a => a.deal_contract.contract_nbr == this.contract.Number ).FirstOrDefault();
                    if (priceData != null)
                    {
                        priceData.deal_pricingdetail.rate_submit_ind = true;
                        dal.SaveChanges();
                    }
                }
            }


        }

        #endregion Helper Methods

        #endregion

        #region " Contract Qualifier Save"
        //Sept 26 2013 PBI 20710
        private bool SaveContractQualifier( AccountContract accountContract, out List<CRMBAL.GenericError> tempErrors )
        {
            tempErrors = new List<CRMBAL.GenericError>();

            //Check if there are valid Qualifiers

            List<string> promotionCodes = this.contract.PromotionCodes;
            if (promotionCodes != null)
            {

                foreach (string PromotionCode in this.contract.PromotionCodes)
                {
                    List<CRMBAL.Qualifier> qualifierlist = new List<CRMBAL.Qualifier>();
                    qualifierlist = this.validator.GetTheQualifiersforGivenpromoCodeandDeterminents( PromotionCode, accountContract );
                    if (qualifierlist != null)
                    {
                        //Insert to ContractQualifier
                        foreach (CRMBAL.Qualifier qualifier in qualifierlist)
                        {
                            ContractQualifier contractQualifier = new ContractQualifier();
                            if (accountContract.ContractId.HasValue)
                            {
                                contractQualifier.ContractId = int.Parse( accountContract.ContractId.ToString() );
                                contractQualifier.AccountId = int.Parse( accountContract.AccountId.ToString() );
                                contractQualifier.QualifierId = qualifier.QualifierId;
                                contractQualifier.CreatedBy = accountContract.CreatedBy;
                                contractQualifier.CreatedDate = System.DateTime.Now;
                                contractQualifier.ModifiedBy = accountContract.CreatedBy;
                                contractQualifier.ModifiedDate = System.DateTime.Now;
                                contractQualifier.PromotionStatus = CRMBAL.Enums.PromotionStatus.Pending;
                                ContractQualifierFactory.InsertContractQualifier( contractQualifier, out tempErrors );
                                return _errors.Count == 0;
                            }


                        }


                    }
                }

            }
            return _errors.Count == 0;

        }


        #endregion



    }
}
