using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using CRMbal = LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using System.Data.Entity;
using LibertyPower.Business.CustomerAcquisition.DailyPricing;
using EFDal = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using LibertyPower.Business.CustomerAcquisition.SalesChannel;

namespace LibertyPower.Business.CustomerManagement.CRMServices
{
    public class ContractSubmissionEmailHelper
    {

        #region Properties
        public static bool SendEmails
        {
            get
            {
                if (ConfigurationManager.AppSettings["SendEmails"] == null)
                {
                    throw new ApplicationException( "Missing configuration setting SendEmails " );
                }
                return Convert.ToBoolean( ConfigurationManager.AppSettings["SendEmails"].ToString() );
            }
        }

        public static List<String> TestCustomerEmail
        {
            get
            {
                if (ConfigurationManager.AppSettings["TestCustomerEmail"] == null)
                {
                    throw new ApplicationException( "Missing configuration setting TestCustomerEmail " );
                }
                return GetEmailsList( ConfigurationManager.AppSettings["TestCustomerEmail"].ToString() );
            }
        }

        public static List<String> TestSalesChannelEmail
        {
            get
            {
                if (ConfigurationManager.AppSettings["TestSalesChannelEmail"] == null)
                {
                    throw new ApplicationException( "Missing configuration setting TestSalesChannelEmail " );
                }
                return GetEmailsList( ConfigurationManager.AppSettings["TestSalesChannelEmail"].ToString() );
            }
        }

        public static List<String> TestECMEmail
        {
            get
            {
                if (ConfigurationManager.AppSettings["TestECMEmail"] == null)
                {
                    throw new ApplicationException( "Missing configuration setting TestECMEmail " );
                }
                return GetEmailsList( ConfigurationManager.AppSettings["TestECMEmail"].ToString() );
            }
        }
        #endregion

        #region Email methods

        internal static List<string> GetEmailsList( string emails )
        {
            List<string> toEmails = new List<string>();
            string[] to;

            to = emails.Split( new char[] { ';' } );

            foreach (string email in to)
            {
                toEmails.Add( email );
            }

            return toEmails;
        }

        public static bool SendEmail( CRMbal.Contract contract, CRMbal.Customer customer, Dictionary<string, Stream> attachments, CRMbal.Enums.EmailType emailType, string message )
        {
            List<string> toEmails = GetEmailRecipients( emailType );
            EFDal.EmailModel email = GetEmailModel( contract, customer, emailType, message );
            SendRequiredEmails( contract, customer, attachments, emailType, toEmails, email );

            return true;
        }

        private static void SendRequiredEmails( CRMbal.Contract contract, CRMbal.Customer customer, Dictionary<string, Stream> attachments, CRMbal.Enums.EmailType emailType, List<string> toEmails, EFDal.EmailModel email )
        {
            EmailClient client = new EmailClient();

            if (SendEmails)
            {
                if (toEmails != null && toEmails.Count > 0)
                    client.SendEmail( toEmails, email.Subject, email.Message, attachments );

                if (IsCustomerNotificationRequired( emailType ))
                    client.SendEmail( customer.Contact.Email, email.Subject, email.Message, attachments );

                if (IsSalesChannelNotificationRequired( emailType ))
                    client.SendEmail( GetSalesChannelEmail( contract ), email.Subject, email.Message, attachments );
            }
            else
            {
                if (IsECMEmailRequired( emailType ))
                    client.SendEmail( TestECMEmail, email.Subject, email.Message, attachments );

                if (IsCustomerNotificationRequired( emailType ))
                    client.SendEmail( TestCustomerEmail, email.Subject, email.Message, attachments );

                if (IsSalesChannelNotificationRequired( emailType ))
                    client.SendEmail( TestSalesChannelEmail, email.Subject, email.Message, attachments );

                if (emailType == CRMbal.Enums.EmailType.GasContract)
                    client.SendEmail( toEmails, email.Subject, email.Message, attachments );

            }
        }

        public static EFDal.EmailModel GetEmailModel( CRMbal.Contract contract, CRMbal.Customer customer, CRMbal.Enums.EmailType emailType, string message )
        {
            int languageId = 1;
            if (customer != null)
                languageId = customer.Preferences.LanguageId;

            EFDal.EmailModel email = PrepareEmail( emailType, languageId );

            if (email == null && languageId != 1)
                email = PrepareEmail( emailType, 1 );

            List<string> accountNumbers = GetAccountNumbers( contract );

            DateTime signedDate = (contract == null ? DateTime.MinValue : contract.SignedDate);
            string ownerName = (customer == null ? "" : customer.OwnerName.Trim());
            string phoneNumber = (customer == null ? "" : customer.Contact.Phone);
            string contractNumber = (contract == null ? "" : contract.Number);

            email.Subject = ReplaceSubjectParameters( contractNumber, signedDate, ownerName, accountNumbers, phoneNumber, email.Subject );

            if (emailType == CRMbal.Enums.EmailType.GasContract)
            {
                email.Message = ReplaceGasMessageParameters( contract, customer, email.Message );
            }
            else
            {
                email.Message = ReplaceMessageParameters( contractNumber, ownerName, message, accountNumbers, contract, customer, email.Message );
            }

            return email;
        }

        /// <summary>
        /// Gets the SalesChannel email of a given contract
        /// </summary>
        /// <param name="contract"></param>
        /// <returns></returns>
        public static string GetSalesChannelEmail( CRMbal.Contract contract )
        {
            string email = "";
            SalesChannel salesChannel = SalesChannelFactory.GetSalesChannel( (int)contract.SalesChannelId );
            if (string.IsNullOrEmpty( salesChannel.ContactEmail ))
            {
                LibertyPower.Business.CommonBusiness.SecurityManager.User cpUser = LibertyPower.Business.CommonBusiness.SecurityManager.UserFactory.GetUserByLogin( salesChannel.ChannelName );

                if (cpUser != null)
                {
                    email = cpUser.Email;
                }
            }
            else
            {
                email = salesChannel.ContactEmail;
            }

            return email;
        }

        /// <summary>
        /// Verify if EmailType is linked to group "Customer"
        /// </summary>
        /// <param name="emailType"></param>
        /// <returns></returns>
        public static bool IsCustomerNotificationRequired( CRMbal.Enums.EmailType emailType )
        {
            using (EFDal.LibertyPowerEntities dal = new EFDal.LibertyPowerEntities())
            {
                var type = dal.EmailTypes.Include( "EmailGroups" ).Where( w => w.EmailTypeID == (int)emailType );
                if (type != null && type.Count() > 0)
                {
                    EFDal.EmailType emailTypeObj = type.First();

                    foreach (EFDal.EmailGroup emailGroup in emailTypeObj.EmailGroups)
                    {
                        if (emailGroup.Description.ToUpper() == "CUSTOMER")
                            return true;
                    }
                }
            }

            return false;
        }

        /// <summary>
        /// Verify if EmailType is linked to group "SalesChannel"
        /// </summary>
        /// <param name="emailType"></param>
        /// <returns></returns>
        public static bool IsSalesChannelNotificationRequired( CRMbal.Enums.EmailType emailType )
        {
            using (EFDal.LibertyPowerEntities dal = new EFDal.LibertyPowerEntities())
            {
                var type = dal.EmailTypes.Include( "EmailGroups" ).Where( w => w.EmailTypeID == (int)emailType );
                if (type != null && type.Count() > 0)
                {
                    EFDal.EmailType emailTypeObj = type.First();

                    foreach (EFDal.EmailGroup emailGroup in emailTypeObj.EmailGroups)
                    {
                        if (emailGroup.Description.ToUpper() == "SALES CHANNEL")
                            return true;
                    }
                }
            }

            return false;
        }

        /// <summary>
        /// Verify if EmailType is linked to group "ECM"
        /// </summary>
        /// <param name="emailType"></param>
        /// <returns></returns>
        private static bool IsECMEmailRequired( CRMbal.Enums.EmailType emailType )
        {
            using (EFDal.LibertyPowerEntities dal = new EFDal.LibertyPowerEntities())
            {
                var type = dal.EmailTypes.Include( "EmailGroups" ).Where( w => w.EmailTypeID == (int)emailType );
                if (type != null && type.Count() > 0)
                {
                    EFDal.EmailType emailTypeObj = type.First();

                    foreach (EFDal.EmailGroup emailGroup in emailTypeObj.EmailGroups)
                    {
                        if (emailGroup.Description.ToUpper() == "ECM")
                            return true;
                    }
                }
            }

            return false;
        }

        public static bool SendEmail( CRMbal.Enums.EmailType emailType, string message )
        {
            return SendEmail( null, null, new Dictionary<string, Stream>(), emailType, message );
        }

        private static List<string> GetAccountNumbers( CRMbal.Contract contract )
        {
            List<string> accountNumbers = new List<string>();
            if (contract != null)
            {
                foreach (CRMbal.AccountContract ac in contract.AccountContracts)
                {
                    accountNumbers.Add( ac.Account.AccountNumber );
                }
            }

            return accountNumbers;
        }

        /// <summary>
        /// Gets the Email record from db based on a given type and language
        /// </summary>
        /// <param name="emailType"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        private static EFDal.EmailModel PrepareEmail( CRMbal.Enums.EmailType emailType, int languageId )
        {
            EFDal.EmailModel email = null;

            using (EFDal.LibertyPowerEntities dal = new EFDal.LibertyPowerEntities())
            {
                var emailObj = dal.EmailModels.Where( w => w.EmailTypeID == (int)emailType && w.LanguageID == languageId && w.IsActive );
                if (emailObj != null && emailObj.Count() > 0)
                {
                    email = emailObj.First();
                }
            }

            return email;
        }

        /// <summary>
        /// Gets the emails linked to the EmailGroup based on the type of the email
        /// </summary>
        /// <param name="emailType"></param>
        /// <returns></returns>
        public static List<string> GetEmailRecipients( CRMbal.Enums.EmailType emailType )
        {
            List<string> emails = new List<string>();

            using (EFDal.LibertyPowerEntities dal = new EFDal.LibertyPowerEntities())
            {
                var type = dal.EmailTypes.Include( "EmailGroups" ).Where( w => w.EmailTypeID == (int)emailType );
                if (type != null && type.Count() > 0)
                {
                    EFDal.EmailType emailTypeObj = type.First();

                    foreach (EFDal.EmailGroup emailGroup in emailTypeObj.EmailGroups)
                    {
                        foreach (EFDal.EmailDistributionList emailDistributionList in emailGroup.EmailDistributionLists)
                        {
                            emails.Add( emailDistributionList.EmailAddress );
                        }
                    }
                }
            }

            return emails;
        }

        /// <summary>
        /// Replaces the email keys on the subject with the contract's values for them
        /// Subject has to match a max lenght of 1024
        /// </summary>
        /// <param name="contractNumber"></param>
        /// <param name="dealDate"></param>
        /// <param name="customerName"></param>
        /// <param name="accountNumbers"></param>
        /// <param name="customerPhoneNumber"></param>
        /// <param name="subject"></param>
        /// <returns></returns>
        private static string ReplaceSubjectParameters( string contractNumber, DateTime dealDate, string customerName, List<string> accountNumbers, string customerPhoneNumber, string subject )
        {
            //replace params
            //@ContractNumber, @Date, @CustomerName, @Accounts, @CustomerPhoneNumber
            subject = subject.Replace( "@Date", dealDate.Date.ToString( "MM/dd/yyyy" ) );
            subject = subject.Replace( "@CustomerPhoneNumber", "Phone# " + customerPhoneNumber );

            int emailSubjectMaxSize = 1024;
            int lenght = emailSubjectMaxSize - (subject.Replace( "@CustomerName", "" ).Length);

            if (accountNumbers.Count() > 0)
                lenght = lenght - (subject.Replace( "@Accounts", "Account# " + accountNumbers[0].ToString() + " (...)" ).Length);
            else
                lenght = lenght - (subject.Replace( "@Accounts", "Account#" ).Length);

            if (customerName.Length > lenght)
                subject = subject.Replace( "@CustomerName", customerName.Substring( 0, lenght - 1 ) );
            else
                subject = subject.Replace( "@CustomerName", customerName );

            string accounts = "";
            foreach (string accountNumber in accountNumbers)
            {
                //consider " (...)" on count, or if it is the last account to be added to the string, just add it
                if ((subject.Length + accountNumber.Length <= (emailSubjectMaxSize - 6)) || accountNumber == accountNumbers[accountNumbers.Count() - 1].ToString())
                {
                    accounts = accounts + (!String.IsNullOrEmpty( accounts ) ? ", " : "") + accountNumber;
                }
                else
                {
                    accounts = accounts + " (...)";
                    break;
                }
            }

            subject = subject.Replace( "@Accounts", "Account# " + accounts );
            subject = subject.Replace( "@ContractNumber", "Contract# " + contractNumber );

            return subject;
        }

        /// <summary>
        /// Replaces the email keys on the message with the contract's values for them
        /// </summary>
        /// <param name="contractNumber"></param>
        /// <param name="customerName"></param>
        /// <param name="message"></param>
        /// <param name="accountNumbers"></param>
        /// <param name="body"></param>
        /// <returns></returns>
        private static string ReplaceMessageParameters( string contractNumber, string customerName, string message, List<string> accountNumbers, CRMbal.Contract contract, CRMbal.Customer customer, string body )
        {
            while (message.Contains( "\r\n" ))
            {
                message = message.Replace( "\r\n", "<br/>" );
            }

            body = body.Replace( "@Message", message );
            body = body.Replace( "@ContractNumber", contractNumber );
            body = body.Replace( "@CustomerName", customerName );

            if (contract != null)
            {
                //oeDomain.Models.OnlineEnrollmentContext db = new oeDomain.Models.OnlineEnrollmentContext();

                body = body.Replace( "@StartDate", contract.StartDate.ToString( "MM/dd/yyyy" ) );
                body = body.Replace( "@SignedDate", contract.SignedDate.ToString( "MM/dd/yyyy" ) );

                if (contract.AccountContracts[0].Account.Utility == null)
                {
                    int utilityId = (int)contract.AccountContracts[0].Account.UtilityId;
                    contract.AccountContracts[0].Account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( utilityId );
                }

                body = body.Replace( "@Utility", contract.AccountContracts[0].Account.Utility.Code );

                CrossProductPriceSalesChannel price = contract.AccountContracts[0].AccountContractRates[0].Price;
                if (price == null)
                {
                    long LPPriceID = (long)contract.AccountContracts[0].AccountContractRates[0].PriceId;
                    price = DailyPricingFactory.GetPrice( LPPriceID );
                }

                body = body.Replace( "@AccountType", contract.AccountContracts[0].Account.AccountType.ToString() );

                string product = contract.AccountContracts[0].AccountContractRates[0].LegacyProductId;
                if (String.IsNullOrEmpty( product ))
                {
                    product = price != null && price.ProductBrand != null ? price.ProductBrand.Name : "";
                }

                body = body.Replace( "@Product", product );
                body = body.Replace( "@Term", contract.AccountContracts[0].AccountContractRates[0].Term.ToString() );

                body = body.Replace("@PriceTier", price != null && price.PriceTier != null ? price.PriceTier.Description : "");

                string billingAddress = (customer == null ? "" : MountAddress( customer.CustomerAddress ));
                body = body.Replace( "@BillingAddress", billingAddress );

                string contact = (customer == null ? "" : MountCustomerContact( customer.Contact ));
                body = body.Replace( "@Contact", contact );

                if (customer != null && contract.AccountContracts[0].Account.AccountType == CRMbal.Enums.AccountType.RES)
                {
                    body = body.Replace( "@SSN", (String.IsNullOrEmpty( customer.SsnClear ) ? "-" : customer.SsnClear) );
                }
                else
                    body = body.Replace( "@SSN", "-" );

                //per account
                string accountDetails = "";
                foreach (CRMbal.AccountContract accountContract in contract.AccountContracts)
                {
                    string accountNumber = accountContract.Account.AccountNumber;
                    string serviceAddress = (customer == null ? "" : MountAddress( accountContract.Account.ServiceAddress ));

                    double? rate = accountContract.AccountContractRates[0].Rate;
                    int? rateId = accountContract.AccountContractRates[0].RateId;
                    long priceId = (long)accountContract.AccountContractRates[0].PriceId;

                    CrossProductPriceSalesChannel accountPrice = accountContract.AccountContractRates[0].Price;
                    if (accountPrice == null)
                    {
                        accountPrice = DailyPricingFactory.GetPrice( priceId );
                    }

                    string zone = accountContract.Account.Zone;
                    if (String.IsNullOrEmpty( zone ))
                    {
                        zone = accountPrice.Zone.ZoneCode;
                    }

                    string serviceClass = accountContract.Account.ServiceRateClass;
                    if (String.IsNullOrEmpty( serviceClass ))
                    {
                        serviceClass = accountPrice != null ? accountPrice.ServiceClassCode : "";
                        if (String.IsNullOrEmpty( serviceClass ))
                        {
                            if (accountPrice != null && accountPrice.ServiceClass != null)
                                serviceClass = (accountPrice.ServiceClass.Identity == -1 ? "Default" : "-");
                            else
                                serviceClass = "";
                        }
                    }

                    accountDetails += "<table>" +
                                        "<tr><td><i>Account #:</i></td><td>" + accountNumber + "</td></tr>" +
                                        "<tr><td><i>Zone:</i></td><td>" + zone + "</td></tr>" +
                                        "<tr><td><i>Service Class:</i></td><td>" + serviceClass + "</td></tr>" +
                                        "<tr><td><i>Rate:</i></td><td>" + rate + "</td></tr>" +
                                        "<tr><td><i>Price Id:</i></td><td>" + priceId + "</td></tr>" +
                                        "<tr><td valign=\"top\"><i>Address:</i></td><td>" + serviceAddress + "</td></tr>" +
                                      "</table><br/><br/>";

                }

                body = body.Replace( "@AccountDetails", accountDetails );
            }

            string accounts = "";
            foreach (string accountNumber in accountNumbers)
            {
                accounts = accounts + (!String.IsNullOrEmpty( accounts ) ? ", " : "") + accountNumber;
            }

            body = body.Replace( "@Accounts", accounts );

            return body;
        }

        private static string ReplaceGasMessageParameters( CRMbal.Contract contract, CRMbal.Customer customer, string body )
        {
            if (customer != null)
            {
                #region Customer Info

                string name = !String.IsNullOrEmpty( customer.Contact.FirstName ) ? customer.Contact.FirstName.Trim() + " " : String.Empty;
                name += !String.IsNullOrEmpty( customer.Contact.LastName ) ? customer.Contact.LastName.Trim() : String.Empty;

                body = body.Replace( "@Name", name );
                body = body.Replace( "@AccountType", contract.AccountContracts[0].Account.AccountType != null ? contract.AccountContracts[0].Account.AccountType.ToString() : String.Empty );
                body = body.Replace( "@Phone", !String.IsNullOrEmpty( customer.Contact.Phone ) ? customer.Contact.Phone.Trim() : String.Empty );
                body = body.Replace( "@Email", !String.IsNullOrEmpty( customer.Contact.Email ) ? customer.Contact.Email.Trim() : String.Empty );

                if (contract.AccountContracts[0].Account.AccountType == CRMbal.Enums.AccountType.RES)
                {
                    body = body.Replace( "@SSN", !String.IsNullOrEmpty( customer.SsnClear ) ? customer.SsnClear : String.Empty );
                }
                else
                {
                    body = body.Replace( "@SSN", String.Empty );
                }

                body = body.Replace("@Dob", customer.Contact.Birthday != null && customer.Contact.Birthday != DateTime.MinValue && customer.Contact.Birthday != new DateTime(1900, 1, 1) ? customer.Contact.Birthday.ToString("MM/dd/yyyy") : String.Empty);
                body = body.Replace( "@Address1", !String.IsNullOrEmpty( customer.CustomerAddress.Street ) ? customer.CustomerAddress.Street.Trim() : String.Empty );
                body = body.Replace( "@Address2", !String.IsNullOrEmpty( customer.CustomerAddress.Suite ) ? customer.CustomerAddress.Suite.Trim() : String.Empty );
                body = body.Replace( "@City", !String.IsNullOrEmpty( customer.CustomerAddress.City ) ? customer.CustomerAddress.City.Trim() : String.Empty );
                body = body.Replace( "@Zip", !String.IsNullOrEmpty( customer.CustomerAddress.Zip ) ? customer.CustomerAddress.Zip.Trim() : String.Empty );
                body = body.Replace( "@State", !String.IsNullOrEmpty( customer.CustomerAddress.State ) ? customer.CustomerAddress.State.Trim() : String.Empty );

                #endregion
            }

            if (contract != null)
            {
                #region Accounts Info

                body = body.Replace( "@NumberOfAccounts", contract.AccountContracts.Count.ToString() );

                if (contract.AccountContracts.Count > 0)
                {
                    // Get the template for each account
                    int markerIndex = body.IndexOf( "@AccountTableMarker" );
                    string accountTemplate = body.Substring( markerIndex );
                    accountTemplate = accountTemplate.Replace( "@AccountTableMarker", String.Empty );

                    // Now remove the template from the body and add each account to the end
                    body = body.Remove( markerIndex );
                    string accounts = String.Empty;
                    foreach (var accountContract in contract.AccountContracts)
                    {
                        var account = accountContract.Account;
                        if (account != null)
                        {
                            string currentTemplate = String.Copy( accountTemplate );

                            currentTemplate = currentTemplate.Replace( "@Market", !String.IsNullOrEmpty( account.Utility.RetailMarketCode ) ? account.Utility.RetailMarketCode : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@Utility", !String.IsNullOrEmpty( account.Utility.Code ) ? account.Utility.Code : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@AccountNumber", !String.IsNullOrEmpty( account.AccountNumber ) ? account.AccountNumber : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@ServiceAddress1", !String.IsNullOrEmpty( account.ServiceAddress.Street ) ? account.ServiceAddress.Street : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@ServiceAddress2", !String.IsNullOrEmpty( account.ServiceAddress.Suite ) ? account.ServiceAddress.Suite : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@ServiceCity", !String.IsNullOrEmpty( account.ServiceAddress.City ) ? account.ServiceAddress.City : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@ServiceZip", !String.IsNullOrEmpty( account.ServiceAddress.Zip ) ? account.ServiceAddress.Zip : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@ServiceState", !String.IsNullOrEmpty( account.ServiceAddress.State ) ? account.ServiceAddress.State : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@BillingAddress1", !String.IsNullOrEmpty( account.BillingAddress.Street ) ? account.BillingAddress.Street : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@BillingAddress2", !String.IsNullOrEmpty( account.BillingAddress.Suite ) ? account.BillingAddress.Suite : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@BillingCity", !String.IsNullOrEmpty( account.BillingAddress.City ) ? account.BillingAddress.City : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@BillingZip", !String.IsNullOrEmpty( account.BillingAddress.Zip ) ? account.BillingAddress.Zip : String.Empty );
                            currentTemplate = currentTemplate.Replace( "@BillingState", !String.IsNullOrEmpty( account.BillingAddress.State ) ? account.BillingAddress.State : String.Empty );

                            accounts += currentTemplate;
                        }
                    }
                    body = body.Replace( "@AccountSection", accounts );

                }

                #endregion

                #region Contract Info

                body = body.Replace( "@ContractNumber", !String.IsNullOrEmpty( contract.Number ) ? contract.Number : String.Empty );
                body = body.Replace( "@SalesChannel", (contract.SalesChannel != null && !String.IsNullOrEmpty( contract.SalesChannel.ChannelName )) ? contract.SalesChannel.ChannelName : String.Empty );
                body = body.Replace( "@SalesRep", !String.IsNullOrEmpty( contract.SalesRep ) ? contract.SalesRep : String.Empty );
                body = body.Replace( "@SignedDate", contract.SignedDate != null ? contract.SignedDate.ToString( "MM/dd/yyyy" ) : String.Empty );
                body = body.Replace( "@RequestedDate", contract.StartDate != null ? contract.StartDate.ToString( "MM/dd/yyyy" ) : String.Empty );

                CRMBusinessObjects.AccountContractRate acr = null;
                if (contract.AccountContracts != null &&
                    contract.AccountContracts.Count > 0 &&
                    contract.AccountContracts[0].AccountContractRates != null &&
                    contract.AccountContracts[0].AccountContractRates.Count > 0)
                {
                    acr = contract.AccountContracts[0].AccountContractRates[0];
                }

                body = body.Replace( "@Product", (acr != null && acr.Price != null) ? acr.Price.ProductBrand.Name : String.Empty );
                body = body.Replace( "@Term", (acr != null && acr.Term.HasValue) ? acr.Term.ToString() : String.Empty );
                body = body.Replace( "@Rate", (acr != null && acr.Rate.HasValue) ? acr.Rate.ToString() : String.Empty );

                #endregion
            }

            return body;
        }

        private static string MountCustomerContact( CRMbal.Contact customerContact )
        {
            string contact = "";

            if (!String.IsNullOrEmpty( customerContact.FirstName ))
                contact += customerContact.FirstName.Trim() + " ";

            if (!String.IsNullOrEmpty( customerContact.LastName ))
                contact += customerContact.LastName.Trim();

            if (!String.IsNullOrEmpty( customerContact.Title ))
                contact += ", " + customerContact.Title.Trim();

            if (!String.IsNullOrEmpty( customerContact.Email ))
                contact += "<br/>" + customerContact.Email.Trim();

            if (!String.IsNullOrEmpty( customerContact.Phone ))
                contact += "<br/>Phone: " + customerContact.Phone.Trim();

            if (!String.IsNullOrEmpty( customerContact.Fax ))
                contact += "<br/>Fax: " + customerContact.Fax.Trim();

            return contact;
        }

        private static string MountAddress( CRMbal.Address customerAddress )
        {
            string address = "";

            if (!String.IsNullOrEmpty( customerAddress.Suite ))
                address += customerAddress.Suite.Trim() + " ";

            if (!String.IsNullOrEmpty( customerAddress.Street ))
                address += customerAddress.Street.Trim();

            if (!String.IsNullOrEmpty( customerAddress.City ))
                address += "<br/>" + customerAddress.City.Trim() + " ";

            if (!String.IsNullOrEmpty( customerAddress.State ))
                address += customerAddress.State.Trim() + " ";

            if (!String.IsNullOrEmpty( customerAddress.Zip ))
                address += " (" + customerAddress.Zip.Trim() + ")";

            return address;
        }

        public static bool SendNaturalGasAttachmentEmail( string contractNumber, string fileName, byte[] contractFile )
        {
            bool success = true;
            // Send email to the gas emailbox:
            EmailClient emailClient = new EmailClient();
            List<string> recipients = GetEmailRecipients( CRMbal.Enums.EmailType.GasContract );
            Dictionary<string, Stream> attachments = new Dictionary<string, Stream>();
            // Prepare the Email:
            string subject = string.Format( "{0} - Documentation+++", contractNumber );
            string body = string.Format( "This is an attachment for the following contract number: {0}", contractNumber );
            // Prepare the attachments:
            try
            {
                Stream st = new MemoryStream( contractFile );
                attachments.Add( fileName, st );
                emailClient.SendEmail( recipients, subject, body, attachments );
            }
            catch
            {
                //TODO: Create a log of something gone wrong!
                success = false;
            }
            return success;
        }

        public static bool SendTroubleshootingAssetsAttachmentEmail(string deviceId, string applicationVersionNumber, string channelName, int agentId, string agentName, string accountNumber, Dictionary<string, string> files)
        {
            bool success = false, successSubmissionFailure = false;

            try
            {
                // Prepare the email

                EmailClient emailClient = new EmailClient();
                List<string> recipients = GetEmailRecipients(CRMbal.Enums.EmailType.Troubleshooting);

                string subject = string.Format("Troubleshooting asset(s) for device id {0}", deviceId);
                string subjectSubmissionFailure = string.Format("Submission Failure(s) for device id {0}", deviceId);

                string accountNumberStr = accountNumber != null ? "Account #: " + accountNumber + "<br/><br/>" : "";

                string body = string.Format(@"Please find attached the troubleshooting asset(s) for agent {0} (id: {1}) using tablet with device id {2}, installed with application {3}, in channel {4}.<br/><br/>" + accountNumberStr + "Thank you,<br/>", agentName, agentId, deviceId, applicationVersionNumber, channelName);

                string submissionFailureSuffix = "_submissionfailure";

                // Prepare the attachments and submissionFailureAttachments

                Dictionary<string, Stream> attachments = new Dictionary<string, Stream>();
                Dictionary<string, Stream> attachmentSubmissionFailures = new Dictionary<string, Stream>();

                if (files != null)
                    foreach (var file in files)
                        try 
                        {
                            byte[] fileBytes = Convert.FromBase64String(file.Value);
                            Stream st = new MemoryStream(fileBytes);

                            if (file.Key.ToLower().Contains(submissionFailureSuffix))
                                attachmentSubmissionFailures.Add(file.Key, st);
                            else
                                attachments.Add(file.Key, st);
                        }
                        catch (Exception ex)
                        {
                            ContractProcessor.LogError(ex);
                        }

                // Send the email with subject submission failures or send all troubleshooting assests

                if (attachmentSubmissionFailures.Count() > 0)
                    successSubmissionFailure = emailClient.SendEmail(recipients, subjectSubmissionFailure, body, attachmentSubmissionFailures);
                else
                    successSubmissionFailure = true;

                if (attachments.Count() > 0)
                    success = emailClient.SendEmail(recipients, subject, body, attachments);
                else
                    success = true;
            } 
            catch (Exception ex)
            {
                ContractProcessor.LogError(ex);
                success = false;
            }

            return success && successSubmissionFailure;
        }

        #endregion

    }
}