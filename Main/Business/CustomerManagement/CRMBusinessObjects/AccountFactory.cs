using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LegacyAccountManagement = LibertyPower.Business.CustomerManagement.AccountManagement;
using DALEntity = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using SecurityBAL = LibertyPower.Business.CommonBusiness.SecurityManager;
using UtilityBAL = LibertyPower.Business.MarketManagement.UtilityManagement;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.AccountSql;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class AccountFactory
    {
        #region Account

        public static Account GetAccount( int accountId )
        {
            Account account = null;
            DataSet ds = CRMLibertyPowerSql.GetAccount( accountId );

            if (LibertyPower.Business.CommonBusiness.CommonHelper.DataSetHelper.HasRow( ds ))
            {
                account = new Account();
                MapDataRowToAccount( ds.Tables[0].Rows[0], account );
                var meters = new List<LegacyAccountManagement.AccountMeters>();

                //TEMPORARILY REMOVED TO STABILIZE BUILD	--PLEASE UNCOMMENT
                //meters = AccountManagement.AccountMetersFactory.GetAccountMeters( account.AccountNumber );
                foreach (var item in meters)
                {
                    account.MeterNumbers.Add( item.Meter_Number );
                }
            }
            return account;
        }

        public static Account GetAccountWithContracts( int accountId )
        {
            Account account = GetAccount( accountId );
            if (account == null)
                return null;



            return account;
        }

        public static Account GetAccount( string accountNumber, int utilityId )
        {
            Account account = null;
            DataSet ds = CRMLibertyPowerSql.GetAccount( accountNumber, utilityId );
            if (LibertyPower.Business.CommonBusiness.CommonHelper.DataSetHelper.HasRow( ds ))
            {
                account = new Account();
                MapDataRowToAccount( ds.Tables[0].Rows[0], account );
                var meters = new List<LegacyAccountManagement.AccountMeters>();

                //TEMPORARILY REMOVED TO STABILIZE BUILD	--PLEASE UNCOMMENT
                //meters = AccountMetersFactory.GetAccountMeters( account.AccountNumber );
                foreach (var item in meters)
                {
                    account.MeterNumbers.Add( item.Meter_Number );
                }
            }
            return account;
        }

        public static List<Account> GetAccountsByCustomerId( int customerId )
        {
            List<Account> accounts = new List<Account>();
            DataSet ds = CRMLibertyPowerSql.GetAccountsByCustomerId( customerId );

            if (LibertyPower.Business.CommonBusiness.CommonHelper.DataSetHelper.HasRow( ds ))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Account account = new Account();
                    MapDataRowToAccount( ds.Tables[0].Rows[0], account );
                    accounts.Add( account );
                }
            }

            return accounts;
        }

      

        //IT 148-new
        /// <summary>
        /// Insert Service address, Billing address, contact and Account Name
        /// </summary>
        /// <remarks>Before calling this method call InsertAccount to save Account and AccountDetails</remarks>
        /// <param name="account">Account</param>        
        /// <param name="serviceAddress">service Address</param>
        /// <param name="billingAddress">Billing address</param>
        /// <param name="contact">contact</param>
        /// <param name="errors">errors</param>
        /// <returns>true if successful</returns>
        public static bool InsertAccountCustomerInformation(Account account,  Address serviceAddress, Address billingAddress, Contact contact, out List<GenericError> errors)
        {
            errors = new List<GenericError>();
            using (System.Transactions.TransactionScope transaction = new System.Transactions.TransactionScope(System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions(2)))
            {
                AddressFactory.InsertAddress(serviceAddress, out errors);
                if (errors.Count > 0)
                    return false;

                AddressFactory.InsertAddress(billingAddress, out errors);
                if (errors.Count > 0)
                    return false;

                ContactFactory.InsertContact(contact, out errors);
                if (errors.Count > 0)
                    return false;

                // set values to the customer object:
                account.ServiceAddressId = serviceAddress.AddressId;
                account.BillingAddressId = billingAddress.AddressId;
                account.BillingContactId = contact.ContactId;

                // Insert Name

                DataSet accountNameDataSet = CRMLibertyPowerSql.InsertName(account.AccountName, account.CreatedBy, account.ModifiedBy);
                account.AccountNameId = Convert.ToInt32(accountNameDataSet.Tables[0].Rows[0]["NameID"]);

                if (account.CustomerId.HasValue)
                {
                    
                    CRMLibertyPowerSql.InsertCustomerName(account.CustomerId.Value, account.AccountNameId.Value, account.CreatedBy, account.ModifiedBy);
                    CRMLibertyPowerSql.InsertCustomerAddress(account.CustomerId.Value, account.BillingAddressId.Value, account.CreatedBy, account.ModifiedBy);
                    CRMLibertyPowerSql.InsertCustomerAddress(account.CustomerId.Value, account.ServiceAddressId.Value, account.CreatedBy, account.ModifiedBy);
                    CRMLibertyPowerSql.InsertCustomerContact(account.CustomerId.Value, account.BillingContactId.Value, account.CreatedBy, account.ModifiedBy);
                }
                
                //InsertAccount(account, out errors);
                //if (errors.Count > 0)
                //    return false;
                //details.AccountId = account.AccountId;
                //AccountFactory.InsertAccountDetail(details, out errors);

                if (errors.Count > 0)
                {
                    transaction.Dispose();
                    return false;
                }
                transaction.Complete();
            }
            return true;
        }

        //IT 148 -New
        /// <summary>
        /// Insert Account and Account details
        /// </summary>
        /// <remarks>Before calling this method call InsertAccountCustomerInformation</remarks>
        /// <param name="account">Account</param>
        /// <param name="details">Account Details</param>
        /// <param name="errors">errors</param>
        /// <returns>true if successful</returns>
        public static bool InsertAccount(Account account, AccountDetail details, out List<GenericError> errors)
        {
            using (System.Transactions.TransactionScope transaction = new System.Transactions.TransactionScope(System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions(2)))
            {
                //Insert Account
                InsertAccount(account, out errors);
               
                if (errors.Count > 0)
                    return false;

                details.AccountId = account.AccountId;


                //Insert Account Details
                InsertAccountDetail(details, out errors);

                if (errors.Count > 0)
                {
                    transaction.Dispose();
                    return false;
                }
                transaction.Complete();
            }
            return true;
        }


        //IT 148- updated
        /// <summary>
        /// Insert Account and Account Deatails
        /// </summary>
        /// <param name="account">Accout</param>
        /// <param name="errors">Errors</param>
        /// <returns>true if successful</returns>
        public static bool InsertAccount( Account account, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            if (!account.IsStructureValidForInsert())
            {
                throw new InvalidOperationException( "The structure of the Account Object is not valid" );
            }

            errors = account.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }

            using (System.Transactions.TransactionScope transaction = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 2 ) ))
            {
                if (string.IsNullOrEmpty( account.AccountIdLegacy ))
                {
                    // Automatically generate account legacy ID - parameter not used
                    account.AccountIdLegacy = CustomerAcquisition.ProspectManagement.ProspectContractFactory.GetNewAccountId( "" );
                }

                if (account.Utility == null)
                {
                    account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( account.UtilityId.Value );
                }

                if (string.IsNullOrEmpty( account.EntityId ))
                {
                    if (account.Utility == null)
                    {
                        account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( account.UtilityId.Value );
                    }
                    account.EntityId = account.Utility.CompanyEntityCode;
                }

                if (!account.PorOption.HasValue)
                {
                    if (account.Utility == null)
                    {
                        account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( account.UtilityId.Value );
                    }
                    account.PorOption = account.Utility.IsPOR;
                }

                //TODO: review this logic to see if it makes sense to do it in the IsValid function
                // if billing type is not set, default to utility default
                if ((account.BillingType == Enums.BillingType.NotSet || !account.IsBillingTypeAllowedInUtility()) || (account.Origin != null && account.Origin == "GENIE")) // || account.BillingType.ToString().ToLower() != account.Utility.BillingType.ToLower())
                {
                    if (account.Utility == null)
                    {
                        if (account.UtilityId.HasValue)
                        {
                            account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById(account.UtilityId.Value);
                            account.BillingType = (Enums.BillingType)Enum.Parse(typeof(Enums.BillingType), account.Utility.BillingType.ToUpper());
                        }
                        else
                        {
                            account.BillingType = Enums.BillingType.NotSet;
                        }
                    }
                    else
                    {
                        if (account.Utility.BillingType != null)
                        {
                            account.BillingType = (Enums.BillingType)Enum.Parse(typeof(Enums.BillingType), account.Utility.BillingType.ToUpper());
                        }
                        else
                {
                            account.BillingType = Enums.BillingType.NotSet;
                        }
                    }
                }

                /* IT 148 - moved to  method InsertAccountCustomerInformation
                // Insert Name
                // int lastLinkNumber = Common.GetHighestLinkId( Enums.LinkIdTableType.name, account.AccountIdLegacy );
                DataSet accountNameDataSet = CRMLibertyPowerSql.InsertName( account.AccountName, account.CreatedBy, account.ModifiedBy );
                account.AccountNameId = Convert.ToInt32( accountNameDataSet.Tables[0].Rows[0]["NameID"] );
                //TODO: Review this, consider wheter the customerid is required field because the address/name/contact etc is bound to customer
                if (account.CustomerId.HasValue)
                {
                    CRMLibertyPowerSql.InsertCustomerName( account.CustomerId.Value, account.AccountNameId.Value, account.CreatedBy, account.ModifiedBy );
                    CRMLibertyPowerSql.InsertCustomerAddress( account.CustomerId.Value, account.BillingAddressId.Value, account.CreatedBy, account.ModifiedBy );
                    CRMLibertyPowerSql.InsertCustomerAddress( account.CustomerId.Value, account.ServiceAddressId.Value, account.CreatedBy, account.ModifiedBy );
                    CRMLibertyPowerSql.InsertCustomerContact( account.CustomerId.Value, account.BillingContactId.Value, account.CreatedBy, account.ModifiedBy );
                }
                 * */

                // Insert Account
                DataSet accountDataSet = CRMLibertyPowerSql.InsertAccount( account.AccountIdLegacy, account.AccountNumber, account.AccountTypeId, account.CurrentContractId, account.CurrentRenewalContractId, account.CustomerId, account.CustomerIdLegacy, account.EntityId, account.RetailMktId, account.UtilityId, account.AccountNameId, account.BillingAddressId, account.BillingContactId, account.ServiceAddressId, account.Origin, account.TaxStatusId, account.PorOption, account.BillingTypeId, account.Zone, account.ServiceRateClass, account.StratumVariable, account.BillingGroup, account.Icap, account.Tcap, account.LoadProfile, account.LossCode, account.MeterTypeId, account.ModifiedBy, account.CreatedBy , account.DeliveryLocationRefID , account.LoadProfileRefID , account.ServiceClassRefID );
                MapDataRowToAccount( accountDataSet.Tables[0].Rows[0], account );

                // Insert Account Meters
                //TEMPORARILY REMOVED TO STABILIZE BUILD	--PLEASE UNCOMMENT
                //		LibertyPower.Business.CustomerManagement.AccountManagement.AccountMetersFactory.InsertAccountMeters( account.AccountIdLegacy, account.MeterNumbers );

                transaction.Complete();
            }

            return true;
        }


        //IT 148: Need to be revisited for Phase 2
        /// <summary>
        /// Update/Insert Service address, Billing address, contact and Account Name
        /// </summary>
        /// <remarks> Before calling this method Call UpdateAccount to save Account and AccountDetails</remarks>
        /// <param name="account">Account</param>        
        /// <param name="serviceAddress">service Address</param>
        /// <param name="billingAddress">Billing address</param>
        /// <param name="contact">contact</param>
        /// <param name="errors">errors</param>
        /// <returns>true if successful</returns>
        public static bool UpdateAccountCustomerInformation(Account account, Address serviceAddress, Address billingAddress, Contact contact, out List<GenericError> errors)
        {
            if (!account.IsStructureValidForUpdate())
            {
                throw new InvalidOperationException("The structure of the Account Object is not valid for Insert");
            }

            // map the values if they are not mapped
            if (account.BillingAddress == null)
                account.BillingAddress = billingAddress;

            if (account.ServiceAddress == null)
                account.ServiceAddress = serviceAddress;

            if (account.BillingContact == null)
                account.BillingContact = contact;
            

            //// if billing type is not set, default to utility default
            if ((account.BillingType == Enums.BillingType.NotSet || !account.IsBillingTypeAllowedInUtility()) || (account.Origin != null && account.Origin == "GENIE")) // || account.BillingType.ToString().ToLower() != account.Utility.BillingType.ToLower())
            {
                if (account.Utility == null)
                {
                    if (account.UtilityId.HasValue)
                    {
                    account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById(account.UtilityId.Value);
                    account.BillingType = (Enums.BillingType)Enum.Parse(typeof(Enums.BillingType), account.Utility.BillingType.ToUpper());
                }
                else
                {
                        account.BillingType = Enums.BillingType.NotSet;
                    }
                }
                else
                {
                    if (account.Utility.BillingType != null)
                    {
                    account.BillingType = (Enums.BillingType)Enum.Parse(typeof(Enums.BillingType), account.Utility.BillingType.ToUpper());
                }
                    else
                    {
                        account.BillingType = Enums.BillingType.NotSet;
            }
                }
            }

            errors = account.IsValidForUpdate();
            if (errors.Count > 0)
                return false;
            

            using (System.Transactions.TransactionScope transaction = new System.Transactions.TransactionScope(System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions(2)))
            {
                AddressFactory.InsertAddress(serviceAddress, out errors);
                if (errors.Count > 0)
                    return false;

                AddressFactory.InsertAddress(billingAddress, out errors);
                if (errors.Count > 0)
                    return false;

                ContactFactory.InsertContact(contact, out errors);
                if (errors.Count > 0)
                    return false;

                // set values to the customer object:
                account.ServiceAddressId = serviceAddress.AddressId;
                account.BillingAddressId = billingAddress.AddressId;
                account.BillingContactId = contact.ContactId;

                CRMLibertyPowerSql.UpdateName( account.AccountNameId.Value, account.AccountName, account.ModifiedBy );
                CRMLibertyPowerSql.InsertCustomerAddress(account.CustomerId, account.ServiceAddressId, account.CreatedBy, account.ModifiedBy);
                CRMLibertyPowerSql.InsertCustomerAddress(account.CustomerId, account.BillingAddressId, account.CreatedBy, account.ModifiedBy);
                CRMLibertyPowerSql.InsertCustomerContact(account.CustomerId, account.BillingContactId, account.CreatedBy, account.ModifiedBy);


                //UpdateAccount(account, out errors);
                //detail.AccountId = account.AccountId;
                //AccountDetail detailOld = AccountFactory.GetAccountDetailByAccountID((int)detail.AccountId);
                //if (detailOld != null)
                //{
                //    detail.AccountDetailId = detailOld.AccountDetailId;
                //    detail.OriginalTaxDesignation = (detail.OriginalTaxDesignation == null ? detailOld.OriginalTaxDesignation : detail.OriginalTaxDesignation);
                //    AccountFactory.UpdateAccountDetail(detail, out errors);
                //}
                //else
                //{
                //    AccountFactory.InsertAccountDetail(detail, out errors);
                //}

             

                if (errors.Count > 0)
                {
                    transaction.Dispose();
                    return false;
                }
                transaction.Complete();
            }
            return true;
        }


     
        /// <summary>
        /// Update Account and Account Details
        /// </summary>
        /// <param name="account"></param>
        /// <remarks> Before calling this method Call UpdateAccountCustomerInformation </remarks>
        /// <param name="detail"></param>
        /// <param name="errors"></param>
        /// <returns></returns>
        public static bool UpdateAccount(Account account, AccountDetail detail, out List<GenericError> errors)
        {
            using (System.Transactions.TransactionScope transaction = new System.Transactions.TransactionScope(System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions(2)))
            {

                //Update Account
                UpdateAccount(account, out errors);


                detail.AccountId = account.AccountId;

                //update Account Details
                AccountDetail detailOld = AccountFactory.GetAccountDetailByAccountID((int)detail.AccountId);
                if (detailOld != null)
                {
                    detail.AccountDetailId = detailOld.AccountDetailId;
                    detail.OriginalTaxDesignation = (detail.OriginalTaxDesignation == null ? detailOld.OriginalTaxDesignation : detail.OriginalTaxDesignation);
                    AccountFactory.UpdateAccountDetail(detail, out errors);
                }
                else
                {
                    AccountFactory.InsertAccountDetail(detail, out errors);
                }
                
                if (errors.Count > 0)
                {
                    transaction.Dispose();
                    return false;
                }
                transaction.Complete();
            }
            return true;
        }


        //used by AccountData.cs in MArketManagement
        /// <summary>
        /// Update Account
        /// </summary>
        /// <param name="account"></param>
        /// <param name="errors"></param>
        /// <returns></returns>
        public static bool UpdateAccount(Account account, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            //Set any missing values, this should not be called that much, but is here to counter the problem with do not enroll
            if (string.IsNullOrEmpty( account.EntityId ))
            {
                if (account.Utility == null)
                {
                    account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( account.UtilityId.Value );
                }
                account.EntityId = account.Utility.CompanyEntityCode;
            }

            if (!account.PorOption.HasValue)
            {
                if (account.Utility == null)
                {
                    account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( account.UtilityId.Value );
                }
                account.PorOption = account.Utility.IsPOR;
            }

            if (!account.IsStructureValidForUpdate())
            {
                throw new InvalidOperationException( "The structure of the Account Object is not valid for Insert" );
            }

            errors = account.IsValidForUpdate();
            if (errors.Count > 0)
            {
                return false;
            }

            using (System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 1 ) ))
            {
                CRMLibertyPowerSql.UpdateName( account.AccountNameId.Value, account.AccountName, account.ModifiedBy );
                DataSet accountDataSet = CRMLibertyPowerSql.UpdateAccount( account.AccountId, account.AccountIdLegacy, account.AccountNumber, account.AccountTypeId, account.CurrentContractId, account.CurrentRenewalContractId, account.CustomerId, account.CustomerIdLegacy, account.EntityId, account.RetailMktId, account.UtilityId, account.AccountNameId, account.BillingAddressId, account.BillingContactId, account.ServiceAddressId, account.Origin, account.TaxStatusId, account.PorOption, account.BillingTypeId, account.Zone, account.ServiceRateClass, account.StratumVariable, account.BillingGroup, account.Icap, account.Tcap, account.LoadProfile, account.LossCode, account.MeterTypeId, account.ModifiedBy, account.DeliveryLocationRefID, account.LoadProfileRefID, account.ServiceClassRefID );
                transactionScope.Complete();
                MapDataRowToAccount( accountDataSet.Tables[0].Rows[0], account );
            }
            return true;
        }

        private static void MapDataRowToAccount( DataRow dataRow, Account account )
        {
            account.AccountId = dataRow.Field<int?>( "AccountID" );
            account.AccountIdLegacy = dataRow.Field<string>( "AccountIdLegacy" );
            account.AccountNumber = dataRow.Field<string>( "AccountNumber" );
            account.AccountTypeId = dataRow.Field<int?>( "AccountTypeID" );
            account.CustomerId = dataRow.Field<int?>( "CustomerID" );
            account.CustomerIdLegacy = dataRow.Field<string>( "CustomerIdLegacy" );
            account.EntityId = dataRow.Field<string>( "EntityID" );
            account.RetailMktId = dataRow.Field<int?>( "RetailMktID" );
            account.UtilityId = dataRow.Field<int?>( "UtilityID" );
            account.AccountNameId = dataRow.Field<int?>( "AccountNameID" );
            account.AccountName = dataRow.Field<string>( "AccountName" );
            account.BillingAddressId = dataRow.Field<int?>( "BillingAddressID" );
            account.BillingContactId = dataRow.Field<int?>( "BillingContactID" );
            account.ServiceAddressId = dataRow.Field<int?>( "ServiceAddressID" );
            account.Origin = dataRow.Field<string>( "Origin" );
            account.TaxStatusId = dataRow.Field<int?>( "TaxStatusID" );
            account.PorOption = dataRow.Field<bool?>( "PorOption" );
            account.BillingTypeId = dataRow.Field<int?>( "BillingTypeID" );
            account.Zone = dataRow.Field<string>( "Zone" );
            account.ServiceRateClass = dataRow.Field<string>( "ServiceRateClass" );
            account.StratumVariable = dataRow.Field<string>( "StratumVariable" );
            account.BillingGroup = dataRow.Field<string>( "BillingGroup" );
            account.Icap = dataRow.Field<string>( "Icap" );
            account.Tcap = dataRow.Field<string>( "Tcap" );
            account.LoadProfile = dataRow.Field<string>( "LoadProfile" );
            account.LossCode = dataRow.Field<string>( "LossCode" );
            account.MeterTypeId = dataRow.Field<int?>( "MeterTypeID" );
			account.DeliveryLocationRefID = dataRow.Field<int?>( "DeliveryLocationRefID" );
			account.LoadProfileRefID = dataRow.Field<int?>( "LoadProfileRefID" );
			account.ServiceClassRefID = dataRow.Field<int?>( "ServiceClassRefID" );
            account.CurrentContractId = dataRow.Field<int?>( "CurrentContractID" );
            account.CurrentRenewalContractId = dataRow.Field<int?>( "CurrentRenewalContractID" );
            account.Modified = dataRow.Field<DateTime>( "Modified" );
            account.DateCreated = dataRow.Field<DateTime>( "DateCreated" );

            if (dataRow["ModifiedBy"] != DBNull.Value)
            {
                account.ModifiedBy = dataRow.Field<int>( "ModifiedBy" );
            }
            else
            {
                account.ModifiedBy = SecurityBAL.User.SystemUserID;
            }

            if (dataRow["CreatedBy"] != DBNull.Value)
            {
                account.CreatedBy = dataRow.Field<int>( "CreatedBy" );
            }
            else
            {
                account.CreatedBy = SecurityBAL.User.SystemUserID;
            }

        }

        #endregion

        #region Account Detail

        public static AccountDetail GetAccountDetail( int accountDetailId )
        {
            AccountDetail accountDetail = null;
            DataSet ds = CRMLibertyPowerSql.GetAccountDetail( accountDetailId );

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                accountDetail = new AccountDetail();
                MapDataRowToAccountDetail( ds.Tables[0].Rows[0], accountDetail );
            }

            return accountDetail;
        }

        public static AccountDetail GetAccountDetailByAccountID( int accountId )
        {
            AccountDetail accountDetail = null;
            DataSet ds = CRMLibertyPowerSql.GetAccountDetailByAccountId( accountId );

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                accountDetail = new AccountDetail();
                MapDataRowToAccountDetail( ds.Tables[0].Rows[0], accountDetail );
            }

            return accountDetail;
        }

        public static bool InsertAccountDetail( AccountDetail accountDetail, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            if (!accountDetail.IsStructureValidForInsert())
            {
                throw new InvalidOperationException( "The structure of the AccountDetail Object is not valid" );
            }

            errors = accountDetail.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }

            using (System.Transactions.TransactionScope transaction = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 2 ) ))
            {
                // Insert AccountDetail
                DataSet accountDetailDataSet = CRMLibertyPowerSql.InsertAccountDetail( accountDetail.AccountId, accountDetail.EnrollmentTypeId, accountDetail.OriginalTaxDesignation, accountDetail.ModifiedBy, accountDetail.CreatedBy );

                transaction.Complete();

                MapDataRowToAccountDetail( accountDetailDataSet.Tables[0].Rows[0], accountDetail );
            }

            return true;
        }

        public static bool UpdateAccountDetail( AccountDetail accountDetail, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            if (!accountDetail.IsStructureValidForUpdate())
            {
                throw new InvalidOperationException( "The structure of the AccountDetail Object is not valid for Insert" );
            }

            errors = accountDetail.IsValidForUpdate();
            if (errors.Count > 0)
            {
                return false;
            }

            using (System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 1 ) ))
            {
                DataSet accountDetailDataSet = CRMLibertyPowerSql.UpdateAccountDetail( accountDetail.AccountDetailId, accountDetail.AccountId, accountDetail.EnrollmentTypeId, accountDetail.OriginalTaxDesignation, accountDetail.ModifiedBy );

                transactionScope.Complete();

                MapDataRowToAccountDetail( accountDetailDataSet.Tables[0].Rows[0], accountDetail );
            }

            return true;
        }

        private static void MapDataRowToAccountDetail( DataRow dataRow, AccountDetail accountDetail )
        {
            accountDetail.AccountDetailId = dataRow.Field<int>( "AccountDetailID" );
            accountDetail.AccountId = dataRow.Field<int>( "AccountID" );
            accountDetail.EnrollmentTypeId = dataRow.Field<int?>( "EnrollmentTypeID" );
            accountDetail.OriginalTaxDesignation = dataRow.Field<int?>( "OriginalTaxDesignation" );
            accountDetail.Modified = dataRow.Field<DateTime>( "Modified" );
            accountDetail.ModifiedBy = dataRow.Field<int>( "ModifiedBy" );
            accountDetail.DateCreated = dataRow.Field<DateTime>( "DateCreated" );
            accountDetail.CreatedBy = dataRow.Field<int>( "CreatedBy" );
        }

        #endregion

        #region Account Usage

        public static AccountUsage GetAccountUsage( int accountUsageId )
        {
            DataSet ds = CRMLibertyPowerSql.GetAccountUsage( accountUsageId );

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                AccountUsage accountUsage = new AccountUsage();
                MapDataRowToAccountUsage( ds.Tables[0].Rows[0], accountUsage );
                return accountUsage;
            }

            return null;
        }

        public static AccountUsage GetAccountUsageByAccountIdAndEffectiveDate( int accountId, DateTime effectiveDate )
        {
            AccountUsage accountUsage = null;
            using (DALEntity.LibertyPowerEntities dal = new DALEntity.LibertyPowerEntities())
            {
                var au = dal.AccountUsages.FirstOrDefault( f => f.AccountID == accountId && f.EffectiveDate == effectiveDate );
                if (au != null)
                {
                    accountUsage = new AccountUsage();
                    accountUsage.AccountId = au.AccountID;
                    accountUsage.AccountUsageId = au.AccountUsageID;
                    accountUsage.AnnualUsage = au.AnnualUsage;
                    accountUsage.CreatedBy = au.CreatedBy;
                    accountUsage.DateCreated = au.DateCreated;
                    accountUsage.EffectiveDate = au.EffectiveDate;
                    accountUsage.Modified = au.Modified;
                    accountUsage.ModifiedBy = au.ModifiedBy;
                    accountUsage.UsageReqStatusId = au.UsageReqStatusID;
                }
            }
            return accountUsage;
        }

        public static bool InsertAccountUsage( AccountUsage accountUsage, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            if (!accountUsage.IsStructureValidForInsert())
            {
                throw new InvalidOperationException( "The structure of the AccountUsage Object is not valid" );
            }

            errors = accountUsage.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.InsertAccountUsage( accountUsage.AccountId, accountUsage.AnnualUsage, accountUsage.UsageReqStatusId, accountUsage.EffectiveDate, accountUsage.ModifiedBy, accountUsage.CreatedBy );

            MapDataRowToAccountUsage( ds.Tables[0].Rows[0], accountUsage );

            return true;
        }

        public static bool UpdateAccountUsage( AccountUsage accountUsage, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            if (!accountUsage.IsStructureValidForUpdate())
            {
                throw new InvalidOperationException( "The structure of the AccountUsage Object is not valid" );
            }

            errors = accountUsage.IsValidForUpdate();

            if (errors.Count > 0)
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.UpdateAccountUsage( accountUsage.AccountUsageId, accountUsage.AccountId, accountUsage.AnnualUsage, accountUsage.UsageReqStatusId, accountUsage.EffectiveDate, accountUsage.ModifiedBy );

            MapDataRowToAccountUsage( ds.Tables[0].Rows[0], accountUsage );

            return true;
        }

        private static void MapDataRowToAccountUsage( DataRow dataRow, AccountUsage accountUsage )
        {
            accountUsage.AccountUsageId = dataRow.Field<int?>( "AccountUsageID" );
            accountUsage.AccountId = dataRow.Field<int?>( "AccountID" );
            accountUsage.AnnualUsage = dataRow.Field<int?>( "AnnualUsage" );
            accountUsage.UsageReqStatusId = dataRow.Field<int>( "UsageReqStatusID" );
            accountUsage.EffectiveDate = dataRow.Field<DateTime>( "EffectiveDate" );
            accountUsage.CreatedBy = dataRow.Field<int>( "CreatedBy" );
            accountUsage.DateCreated = dataRow.Field<DateTime>( "DateCreated" );
            accountUsage.Modified = dataRow.Field<DateTime>( "Modified" );
            accountUsage.ModifiedBy = dataRow.Field<int>( "ModifiedBy" );
        }

        #endregion

        #region Account Info

        public static bool UpdateAccountInfo( AccountInfo accountInfo, out List<GenericError> errors )
        {
            errors = new List<GenericError>();
            if (!accountInfo.IsStructureValidForUpdate())
            {
                throw new InvalidOperationException( "The structure of the AccountInfo Object is not valid" );
            }
            errors = accountInfo.IsValidForUpdate();
            if (errors.Count > 0)
            {
                return false;
            }
            DALEntity.account_info ai = MapBalToDalAccountInfo( accountInfo );
            DALEntity.CommonDal.UpdateAccountInfo( ai );
            accountInfo = MapDalToBalAccountInfo( ai );
            return true;
        }

        public static bool InsertAccountInfo( AccountInfo accountInfo, out List<GenericError> errors )
        {
            errors = new List<GenericError>();
            if (!accountInfo.IsStructureValidForInsert())
            {
                throw new InvalidOperationException( "The structure of the AccountInfo Object is not valid" );
            }
            errors = accountInfo.IsValidForInsert();
            if (errors.Count > 0)
            {
                return false;
            }
            DALEntity.account_info ai = MapBalToDalAccountInfo( accountInfo );
            DALEntity.CommonDal.InsertAccountInfo( ai );
            return true;
        }

        public static AccountInfo GetAccountInfo( string legacyAccountId )
        {
            AccountInfo accountInfo = null;
            DALEntity.account_info ai = null;
            using (DALEntity.Lp_AccountEntities dal = new DALEntity.Lp_AccountEntities())
            {
                ai = dal.account_info.FirstOrDefault( f => f.account_id == legacyAccountId );
            }

            if (ai != null)
            {
                accountInfo = MapDalToBalAccountInfo( ai );
            }
            return accountInfo;
        }

        public static AccountInfo GetAccountInfo( int accountId )
        {
            DALEntity.account_info ai = DALEntity.CommonDal.GetAccountInfo( accountId );
            AccountInfo accountInfo = MapDalToBalAccountInfo( ai );
            return accountInfo;
        }

        private static AccountInfo MapDalToBalAccountInfo( DALEntity.account_info efObject )
        {
            AccountInfo accountInfo = new AccountInfo();
            accountInfo.BillingAccount = efObject.BillingAccount;
            accountInfo.DateCreated = efObject.Created;
            accountInfo.LegacyAccountId = efObject.account_id;
            accountInfo.MeterDataMgmtAgent = efObject.MeterDataMgmtAgent;
            accountInfo.MeterInstaller = efObject.MeterInstaller;
            accountInfo.MeterOwner = efObject.MeterOwner;
            accountInfo.MeterReader = efObject.MeterReader;
            accountInfo.MeterServiceProvider = efObject.MeterServiceProvider;
            accountInfo.NameKey = efObject.name_key;
            accountInfo.SchedulingCoordinator = efObject.SchedulingCoordinator;
            accountInfo.UtilityCode = efObject.utility_id;
            accountInfo.CreatedBy = efObject.CreatedBy;
            return accountInfo;
        }

        private static DALEntity.account_info MapBalToDalAccountInfo( AccountInfo balObject )
        {
            DALEntity.account_info accountInfo = new DALEntity.account_info();
            accountInfo.BillingAccount = balObject.BillingAccount;
            accountInfo.Created = balObject.DateCreated;
            accountInfo.account_id = balObject.LegacyAccountId;
            accountInfo.MeterDataMgmtAgent = balObject.MeterDataMgmtAgent;
            accountInfo.MeterInstaller = balObject.MeterInstaller;
            accountInfo.MeterOwner = balObject.MeterOwner;
            accountInfo.MeterReader = balObject.MeterReader;
            accountInfo.MeterServiceProvider = balObject.MeterServiceProvider;
            accountInfo.name_key = balObject.NameKey;
            accountInfo.SchedulingCoordinator = balObject.SchedulingCoordinator;
            accountInfo.utility_id = balObject.UtilityCode;
            accountInfo.CreatedBy = balObject.CreatedBy;
            return accountInfo;
        }

        #endregion Account Info

        #region Account Summary

        /// <summary>
        /// Get all accounts summary in the scope of a given zip codes list.
        /// Summary for an account is represented by the fields of the AccountSummary BO class.
        /// </summary>
        /// <param name="zipCodes">Set of zip codes to retrive accounts summary</param>
        /// <returns>Accounts summary list collected for set of zip codes</returns>
        public static List<AccountSummary> GetAccountsSummary(List<string> zipCodes)
        {
            if (zipCodes == null || zipCodes.Count == 0)
                throw new ArgumentNullException("ZipCodes list cannot be null or empty.");

            DataSet ds = CRMLibertyPowerSql.GetAccountsSummary(zipCodes);

            if (!LibertyPower.Business.CommonBusiness.CommonHelper.DataSetHelper.HasRow(ds))
                return null;

            List<AccountSummary> result = new List<AccountSummary>();
            DataTable table = ds.Tables[0];

            foreach (DataRow row in table.Rows)
                result.Add(MapDataRowToAccountSummary(row));

            return result;
        }

        /// <summary>
        /// Get all accounts status. A status is represented by an ID as follow:
        ///     1 Not An Existing Liberty Power Customer   
        ///     2 Existing Liberty Power Customer Contract expires (end date) is > 30 days 
        ///     3 Existing Liberty Power Customer - Eligible for Renewal Contract is expired (date has passed) 
        ///     4 Pending Enrollment
        /// </summary>
        /// <param name="zipCodes">Set of zip codes to retrive accounts summary</param>
        /// <returns>Accounts status summary list collected for set of zip codes</returns>
        public static List<AccountStatusSummary> GetAccountsStatus(List<string> zipCodes, int? Channelid = 0)
        {
            if (zipCodes == null || zipCodes.Count == 0)
                throw new ArgumentNullException("ZipCodes list cannot be null or empty.");

            DataSet ds = CRMLibertyPowerSql.GetAccountsSummary(zipCodes, Channelid);

            if (!LibertyPower.Business.CommonBusiness.CommonHelper.DataSetHelper.HasRow(ds))
                return null;

            // Get summary rows (AccountNumber, AccountStatus, ContractEndDate, ProductCode, UtilityID, SalesChannel, IsDefault, AccountLatestServiceEndDate, IsFlex)

            List<AccountSummary> accountSummaryRows = new List<AccountSummary>();
            DataTable table = ds.Tables[0];

            foreach (DataRow row in table.Rows)
                accountSummaryRows.Add(MapDataRowToAccountSummary(row));

            // Compute smaller response (AccountNumber, UtilityID, StatusID)

            List<AccountStatusSummary> result = new List<AccountStatusSummary>();

            foreach (AccountSummary accountSummary in accountSummaryRows) {
                int statusId = GetStatusId(accountSummary);

                if (statusId > 2) // StatusID 3 was removed from requirements but we keep it as a gap in IDs sequence for historic tablet IDs compatibility reason
                    statusId++;

                result.Add(new AccountStatusSummary() {
                    AccountNumber = accountSummary.AccountNumber,
                    UtilityID = accountSummary.UtilityID,
                    StatusID = statusId,
                    ContractNumber = accountSummary.ContractNumber,
                    ContractEndDate = accountSummary.ContractEndDate,
                    Channel = accountSummary.Channel,
                    EnrollmentStatus = accountSummary.EnrollmentStatus,
                    EnrollmentSubStatus = accountSummary.EnrollmentSubStatus,
                    DeEnrollmentDate = accountSummary.AccountLatestServiceEndDate,
                    UtilityCode = accountSummary.UtilityCode
                });
            }

            // Return

            return result;
        }

        /// <summary>
        /// Computes a Status ID for the given account.
        /// 
        /// Each Status ID represents an account status as follow:
        ///     1 Not An Existing Liberty Power Customer   
        ///     2 Existing Liberty Power Customer Contract expires (end date) is > 30 days 
        ///     3 Existing Liberty Power Customer - Eligible for Renewal Contract is expired (date has passed) 
        ///     4 Pending Enrollment
        /// </summary>
        /// <param name="account"></param>
        /// <returns></returns>
        public static int GetStatusId(AccountSummary account)
        {
            if (String.Equals(account.AccountStatus, "Rejected", StringComparison.OrdinalIgnoreCase))
                return 1;
            
            if (String.Equals(account.AccountStatus, "Pending", StringComparison.OrdinalIgnoreCase))
                return 4;

            if (String.Equals(account.AccountStatus, "Approved", StringComparison.OrdinalIgnoreCase))                                       // Message 1/2/3/4
            {
                DateTime today = DateTime.Now;

                if (account.AccountLatestServiceEndDate <= today)
                    return 1;

                if (account.AccountLatestServiceEndDate > today || account.AccountLatestServiceEndDate == null)                             // Message 2/3
                {
                    DateTime todayAndOneMonth = today.AddMonths(1);

                    if (account.ContractEndDate <= todayAndOneMonth)
                        return 3;
                    
                    if (account.ContractEndDate > todayAndOneMonth && account.IsFlex)
                        return 3;
                    
                    if (account.ContractEndDate > todayAndOneMonth)
                        return 2;
                }
            }

            return 1; // If we are not able to identify a message it should be 1, Let the orders API handle it, when the contract gets submitted
        }

        private static AccountSummary MapDataRowToAccountSummary(DataRow row)
        {
            AccountSummary accountSummary = new AccountSummary();
            accountSummary.AccountNumber = row.Field<string>("AccountNumber");
            accountSummary.AccountStatus = row.Field<string>("AccountStatus");
            accountSummary.ContractEndDate = row.Field<DateTime?>("ContractEndDate");
            accountSummary.ProductCode = row.Field<string>("ProductCode");
            accountSummary.UtilityID = row.Field<int>("UtilityID");
            accountSummary.SalesChannelName = row.Field<string>("SalesChannel");
            accountSummary.DefaultVariable = row["IsDefault"] != null && row["IsDefault"] != DBNull.Value ? row.Field<byte>("IsDefault") == 1 : false;
            accountSummary.AccountLatestServiceEndDate = row.Field<DateTime?>("AccountLatestServiceEndDate");
            accountSummary.IsFlex = row.Field<byte?>("IsFlex") == null || row.Field<byte?>("IsFlex") == 1;
            accountSummary.ContractNumber = row.Field<string>("ContractNumber");
            accountSummary.Channel = row.Field<int>("Channel");
            accountSummary.EnrollmentStatus = row.Field<string>("EnrollmentStatus");
            accountSummary.EnrollmentSubStatus = row.Field<string>("EnrollmentSubStatus");
            accountSummary.UtilityCode = row.Field<string>("UtilityCode");
            
            return accountSummary;
        }

        #endregion

        #region Validation

        /// <summary>
        /// Checks if the account number + utility exists in the system
        /// </summary>
        /// <param name="accountNumber">The account number to check</param>
        /// <param name="utilityId">The Utility Key Id of the utility for this account</param>
        /// <returns>True if the account already exists, false otherwise</returns>
        public static bool IsAccountNumberInTheSystem( string accountNumber, int utilityId )
        {
            return DALEntity.AccountDal.IsAccountNumberInTheSystem( accountNumber, utilityId );
        }

        public static bool IsAccountInContract(string accountNumber, int utilityId)
        {
            return DALEntity.AccountDal.IsAccountInContract(accountNumber, utilityId);
        }

        public static bool IsAccountActive( string accountNumber, int utilityId )
        {
            return DALEntity.AccountDal.IsAccountActive( accountNumber, utilityId );
        }

        public static bool IsAccountCurrentlyInRenewalUnderDifferentContract( string accountNumber, int utilityId  )
        {
            DataSet ds = CRMLibertyPowerSql.IsAccountCurrentlyInRenewalUnderDifferentContract(accountNumber, utilityId);

            return (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0);

        }

        public static bool IsRolloverRenewalActive(string legacyAccountId)
        {
            return DALEntity.AccountDal.IsRolloverRenewalActive(legacyAccountId);
        }

        public static bool IsAccountInDoNotEnrollList( string accountNumber )
        {
            return AccountSqlLP.CheckIfAccountIsDoNotEnroll( accountNumber );
        }

        #endregion Validation

        public static int GetAccountPaymentTerms( int utilityId, int accountId )
        {
            UtilityBAL.Utility u = UtilityBAL.UtilityFactory.GetUtilityById( utilityId );
            Account a = GetAccount( accountId );
            return GetAccountPaymentTerms( u, a );
        }

        //24311  Fix Payment Term Logic in Deal Capture (Contract API ) Oct 31 2013
        //Account Payment Terms modified on Oct 31 2013
        //This method was always defaulting the value of 16, eventhough we find out the Accountpayment Terms.
        public static int GetAccountPaymentTerms(UtilityBAL.Utility utility, Account account)
        {
            //changing the default to 0, as it is inserting 16 as the default for all the accounts
            //Modified on October 31 2013
            int res = 0;
            // preconditions:
            if (utility == null || account == null || string.IsNullOrEmpty(account.AccountIdLegacy))
                throw new ArgumentNullException("Account object is invalid or account legacy id is not set.");

            DALEntity.LibertyPowerEntities dal = new DALEntity.LibertyPowerEntities();

            // Find most specific rule first:

            var utilityPaymentTerms = dal.UtilityPaymentTerms.Where(
                w =>
                    w.UtilityId == utility.Identity &&
                    w.AccountTypeID.HasValue && w.AccountTypeID.Value == account.AccountTypeId.Value &&
                    w.BillingTypeID.HasValue && w.BillingTypeID.Value == account.BillingTypeId.Value
                );

            // if this doesnt work then ignore accounttype
            if (utilityPaymentTerms == null || utilityPaymentTerms.Count() == 0)
            {
                utilityPaymentTerms = dal.UtilityPaymentTerms.Where(
                    w => w.UtilityId == utility.Identity &&
                         w.BillingTypeID.HasValue && w.BillingTypeID.Value == account.BillingTypeId.Value
                         && w.AccountTypeID == null);

            }

            // if not then remove billing type
            if (utilityPaymentTerms == null || utilityPaymentTerms.Count() == 0)
            {
                utilityPaymentTerms = dal.UtilityPaymentTerms.Where(w => w.UtilityId == utility.Identity
                    && w.AccountTypeID == null
                && w.BillingTypeID == null);
            }

            // if not then market only
            if (utilityPaymentTerms == null || utilityPaymentTerms.Count() == 0)
            {
                utilityPaymentTerms = dal.UtilityPaymentTerms.Where(w => w.UtilityId == 0 && w.MarketId == account.RetailMktId);
            }

            // TODO: Review this logic is failing
            if (utilityPaymentTerms != null && utilityPaymentTerms.Count() > 0)
            {
                res = utilityPaymentTerms.First().ARTerms;
            }

            return res;
        }

        /// <summary>
        /// New  code  added for PBI- 81211
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilityCode"></param>
        /// <param name="insertFlag"></param>
        /// <returns></returns>
        public static bool AccountPropertyHistoryWatchdogInsert(string accountNumber, string utilityCode, int insertFlag)
        {
            try
            {
                DataSet dataSet = CRMLibertyPowerSql.AccountPropertyHistoryWatchdogInsert(accountNumber, utilityCode, insertFlag);
                return dataSet != null;
            }
            catch (Exception exc)
            {
                throw;
            }
        }

        public static bool AccountUpdateLoadProfileRefIdModifiedFromEdiAccountLoadProfile(string accountNumber)
        {
            try
            {
                DataSet dataSet = CRMLibertyPowerSql.AccountUpdateLoadProfileRefIdModifiedFromEdiAccountLoadProfile(accountNumber);
                return dataSet != null;
            }
            catch (Exception exc)
            {
                throw;
            }
        }

        public static bool AccountUpdateLoadProfileRefIdModifiedFromConedAccountLoadProfile(string accountNumber)
        {
            try
            {
                DataSet dataSet = CRMLibertyPowerSql.AccountUpdateLoadProfileRefIdModifiedFromConedAccountLoadProfile(accountNumber);
                return dataSet != null;
            }
            catch (Exception exc)
            {
                throw;
    }
}

        public static bool AccountUpdateProfileForUiaccounts(string accountNumber)
        {
            try
            {
                DataSet dataSet = CRMLibertyPowerSql.AccountUpdateProfileForUiaccounts(accountNumber);
                return dataSet != null;
            }
            catch (Exception exc)
            {
                throw;
            }
        }

        public static bool AccountUpdateScraper(string accountNumber)
        {
            try
            {
                DataSet dataSet = CRMLibertyPowerSql.AccountUpdateScraper(accountNumber);
                return dataSet != null;
            }
            catch (Exception exc)
            {
                throw;
            }
        }

        public static bool AccountUpdateDeliveryLocationRefId(string accountNumber)
        {
            try
            {
                DataSet dataSet = CRMLibertyPowerSql.AccountUpdateDeliveryLocationRefId(accountNumber);
                return dataSet != null;
            }
            catch (Exception exc)
            {
                throw;
            }
        }

        public static bool AccountUpdateProfileRefId(string accountNumber)
        {
            try
            {
                DataSet dataSet = CRMLibertyPowerSql.AccountUpdateProfileRefId(accountNumber);
                return dataSet != null;
            }
            catch (Exception exc)
            {
                throw;
            }
        }

        public static bool AccountUpdateOneZoneUtilities(string accountNumber)
        {
            try
            {
                DataSet dataSet = CRMLibertyPowerSql.AccountUpdateOneZoneUtilities(accountNumber);
                return dataSet != null;
            }
            catch (Exception exc)
            {
                throw;
            }
        }
        /// <summary>
        /// Created to be able to call the function ufn_GetAccountStatus
        /// </summary>
        /// <param name="AccLegacyId"></param>
        /// <returns></returns>
        /// Created by: Andre Damasceno / PBI: 111143
        [System.Data.Objects.DataClasses.EdmFunction("LibertypowerModel.Store", "ufn_GetAccountStatus")]
        private static string ufn_GetAccountStatus(string AccLegacyId)
        {
           throw new NotSupportedException("ufn_GetAccountStatus not supported");
        }

        /// <summary>
        /// Created to be able to call the function ufn_GetAccountSubStatus
        /// </summary>
        /// <param name="AccLegacyId"></param>
        /// <returns></returns>
        /// Created by: Andre Damasceno / PBI: 111143
        [System.Data.Objects.DataClasses.EdmFunction("LibertypowerModel.Store", "ufn_GetAccountSubStatus")]
        private static String ufn_GetAccountSubStatus(string AccLegacyId)
        {
            throw new NotSupportedException("ufn_GetAccountSubStatus not supported");
        }

        /// <summary>
        /// Created to get the EnrollmentSatus and EnrollmentSubStatus using the respective functions
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="contractNumber"></param>
        /// <param name="EnrollmentStatus"></param>
        /// <param name="EnrollmentSubStatus"></param>
        /// Created by: Andre Damasceno / PBI: 111143
        public static void GetAccountStatus(string accountNumber, out string UtilityId, out string ContractNumber, out string EnrollmentStatus, out string EnrollmentSubStatus)
        {
            UtilityId = String.Empty;
            ContractNumber = String.Empty;
            EnrollmentStatus = String.Empty;
            EnrollmentSubStatus = String.Empty;

            using (DALEntity.LibertyPowerEntities context = new DALEntity.LibertyPowerEntities())
            {
                var acc = (from s in context.Accounts
                           where s.AccountNumber == accountNumber
                           select new
                           {
                               cn = context.Contracts.FirstOrDefault(w => w.ContractID == s.CurrentContractID).Number,
                               utilityId = s.UtilityID,
                               //accNumber = s.AccountNumber,
                               status = ufn_GetAccountStatus(s.AccountIdLegacy),
                               subStatus = ufn_GetAccountSubStatus(s.AccountIdLegacy),

                           }).ToList();
                if (acc.Count > 0)
                {
                    ContractNumber = acc[0].cn;
                    UtilityId = acc[0].utilityId.ToString();
                    EnrollmentStatus = acc[0].status;
                    EnrollmentSubStatus = acc[0].subStatus;
                }
            }
        }

        /// <summary>
        /// Created to receive a list of accounts, instead of just one, and return a dataSet with the list information
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <returns></returns>
        /// Created by: Andre Damasceno / PBI: 111143
        public static DataSet GetAccountStatus(List<string> accountNumber)
        {
            var utilityId = String.Empty;
            var contractN = String.Empty;
            var enrollmentStatus = String.Empty;
            var enrollmentSubStatus = String.Empty;
            var hasErrors = "YES";

            DataSet dt = new DataSet();
            dt.Tables.Add();
            dt.Tables[0].Columns.Add("ContractNumber");
            dt.Tables[0].Columns.Add("AccountNumber");
            dt.Tables[0].Columns.Add("UtilityId");
            dt.Tables[0].Columns.Add("EnrollmentStatus");
            dt.Tables[0].Columns.Add("EnrollmentSubStatus");
            dt.Tables[0].Columns.Add("HasErrors");

            for (int i = 0; i < accountNumber.Count; i++)
            {

                GetAccountStatus(accountNumber[i], out utilityId, out contractN, out enrollmentStatus, out enrollmentSubStatus);

                if (contractN != String.Empty && enrollmentStatus != String.Empty && enrollmentSubStatus != String.Empty && utilityId != String.Empty)
                {
                    hasErrors = "NO";
                }
                else
                {
                    hasErrors = "YES";
                }

                dt.Tables[0].Rows.Add(contractN, accountNumber[i], utilityId, enrollmentStatus, enrollmentSubStatus, hasErrors);
            }

            return dt;
        }
    }

}
