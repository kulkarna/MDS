using System;
using System.Collections.Generic;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using System.Linq;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class CustomerFactory
    {
        public static Customer GetCustomer( int customerId )
        {
            return GetCustomer( customerId, false );
        }

        public static Customer GetCustomer( int customerId, bool loadSubTypes )
        {
            Customer customer = null;
            DataSet ds = CRMLibertyPowerSql.GetCustomer( customerId );

            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                customer = new Customer();
                MapDataRowToCustomer( ds.Tables[0].Rows[0], customer );

                if( loadSubTypes && customer != null )
                {
                    if( customer.AddressId != null )
                    {
                        customer.CustomerAddress = AddressFactory.GetAddress( customer.AddressId.Value );
                    }
                    if( customer.ContactId != null )
                    {
                        customer.Contact = ContactFactory.GetContact( customer.ContactId.Value );
                    }
                    if( customer.CustomerPreferenceId != null )
                    {
                        customer.Preferences = CustomerPreferenceFactory.GetCustomerPreference( customer.CustomerPreferenceId.Value );
                    }
                    customer.Accounts = AccountFactory.GetAccountsByCustomerId( customerId );
                }
            }

            return customer;
        }

        public static List<Customer> GetCustomers()
        {
            return GetCustomers( false );
        }

        public static List<Customer> GetCustomers( bool loadSubTypes )
        {
            List<Customer> recordList = new List<Customer>();

            DataSet ds = CRMLibertyPowerSql.GetCustomers();

            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    Customer customer = new Customer();
                    MapDataRowToCustomer( dr, customer );

                    if( loadSubTypes )
                    {
                        if( customer != null )
                        {
                            customer.CustomerAddress = AddressFactory.GetAddress( customer.AddressId.Value );
                            customer.Contact = ContactFactory.GetContact( customer.ContactId.Value );
                            customer.Preferences = CustomerPreferenceFactory.GetCustomerPreference( customer.CustomerPreferenceId.Value );
                        }
                    }

                    recordList.Add( customer );
                }
            }

            return recordList;
        }

        public static Customer GetTheMostRecentCustomer(Contract objContract)
        {
            int? customerId;
            customerId = GetMostRecentCustomerId(objContract);

            Customer objCustomer = new Customer();
            objCustomer = CustomerFactory.GetCustomer(Convert.ToInt32(customerId), true);

            return objCustomer;
        }

        private static int? GetMostRecentCustomerId(Contract objContract)
        {
            //Check if all the Customerid are the same
            List<AccountContract> AccContr = objContract.AccountContracts;

            var CustomerList = AccContr.GroupBy(res => res.Account.CustomerId)
                                        .Select(res => res.Key).ToList();
            int? customerId;

            //if there are more than one cutomer then get the last modiied Customer
            if (CustomerList.Count > 1)
            {
                var lnCustomerID = AccContr.OrderByDescending(res => res.Modified)
                                                        .Select(res => res.Account.CustomerId).First();
                customerId = lnCustomerID;
            }
            else // Else get the Customer
            {
                customerId = CustomerList.Select(res => res.Value).First();

            }
            return customerId;
        }

        public static bool InsertCustomer( Customer customer, CustomerPreference preferences, Address customerAddress, Contact customerContact, out List<GenericError> errors )
        {
            errors = new List<GenericError>();
            using( System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 1 ) ) )
            {

                CustomerPreferenceFactory.InsertCustomerPreference( preferences, out errors );
                if( errors.Count > 0 )
                    return false;

                customer.CustomerPreferenceId = preferences.CustomerPreferenceId;

                AddressFactory.InsertAddress( customerAddress, out errors );

                if( errors.Count > 0 )
                    return false;

                ContactFactory.InsertContact( customerContact, out errors );
                if( errors.Count > 0 )
                    return false;
                // set values to the customer object:
                customer.AddressId = customerAddress.AddressId;
                customer.ContactId = customerContact.ContactId;

                InsertCustomer( customer, out errors );

                if( errors.Count > 0 )
                {
                    transactionScope.Dispose();
                    return false;
                }
                transactionScope.Complete();
            }

            return true;
        }

        /// <summary>
        /// Inserts new customer that has a new address and a new contact
        /// </summary>
        /// <param name="customer"></param>
        /// <param name="customerAddress"></param>
        /// <param name="customerContact"></param>
        /// <param name="legacyAccountId"></param>
        /// <param name="errors"></param>
        /// <returns></returns>
        public static bool InsertCustomer( Customer customer, Address customerAddress, Contact customerContact, out List<GenericError> errors )
        {
            errors = new List<GenericError>();
            using( System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 1 ) ) )
            {
                AddressFactory.InsertAddress( customerAddress, out errors );
                if( errors.Count > 0 )
                    return false;

                ContactFactory.InsertContact( customerContact, out errors );
                if( errors.Count > 0 )
                    return false;
                // set values to the customer object:
                customer.AddressId = customerAddress.AddressId;
                customer.ContactId = customerContact.ContactId;
                InsertCustomer( customer, out errors );
                if( errors.Count > 0 )
                {
                    transactionScope.Dispose();
                    return false;
                }
                transactionScope.Complete();
            }

            return true;
        }


        /// <summary>
        /// Creates a new customer
        /// </summary>
        /// <param name="customer"></param>
        /// <param name="errors"></param>
        /// <returns></returns>
        public static bool InsertCustomer( Customer customer, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            if( !customer.IsStructureValidForInsert() )
            {
                throw new InvalidOperationException( "The structure of the Customer Object is not valid for Insert" );
            }

            errors = customer.IsValidForInsert();

            if( errors.Count > 0 )
            {
                return false;
            }

            using( System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 1 ) ) )
            {
                if( !string.IsNullOrEmpty( customer.SsnClear ) )
                    customer.SsnEncrypted = LibertyPower.Business.CommonBusiness.CommonEncryption.Crypto.Encrypt( customer.SsnClear );

				//if( !string.IsNullOrEmpty( customer.TaxId ) )
				//    customer.TaxIdEncrypted = LibertyPower.Business.CommonBusiness.CommonEncryption.Crypto.Encrypt( customer.TaxId );

                DataSet customerNameDataSet = CRMLibertyPowerSql.InsertName( customer.CustomerName, customer.CreatedBy, customer.ModifiedBy );
                customer.NameId = Convert.ToInt32( customerNameDataSet.Tables[0].Rows[0]["NameID"] );

                DataSet ownerNameDataSet = CRMLibertyPowerSql.InsertName( customer.OwnerName, customer.CreatedBy, customer.ModifiedBy );
                customer.OwnerNameId = Convert.ToInt32( ownerNameDataSet.Tables[0].Rows[0]["NameID"] );

                DataSet customerDataSet = CRMLibertyPowerSql.InsertCustomer( customer.AddressId, customer.CustomerPreferenceId, customer.BusinessActivityId, customer.BusinessTypeId, customer.ContactId, customer.CreditAgencyId, customer.CreditScoreEncrypted, customer.NameId, customer.Dba, customer.Duns, customer.EmployerId, customer.ExternalNumber, customer.OwnerNameId, string.Empty, customer.SsnEncrypted, customer.TaxId, customer.CreatedBy, customer.ModifiedBy );
                customer.CustomerId = Convert.ToInt32( customerDataSet.Tables[0].Rows[0]["CustomerId"] );

                //TODO: Once the removal of the legacy API, we need to enable this as well as disabling the 2 triggers that create them on the interim
                /**
                CRMLibertyPowerSql.InsertCustomerName( customer.CustomerId, customer.OwnerNameId, customer.CreatedBy, customer.ModifiedBy );
                CRMLibertyPowerSql.InsertCustomerName( customer.CustomerId, customer.NameId, customer.CreatedBy, customer.ModifiedBy );
                CRMLibertyPowerSql.InsertCustomerAddress( customer.CustomerId, customer.AddressId, customer.CreatedBy, customer.ModifiedBy );
                CRMLibertyPowerSql.InsertCustomerContact( customer.CustomerId, customer.ContactId, customer.CreatedBy, customer.ModifiedBy );
                **/
                MapDataRowToCustomer( customerDataSet.Tables[0].Rows[0], customer );

                transactionScope.Complete();
                return true;
            }
        }

        public static bool UpdateCustomer( Customer customer, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            if( !customer.IsStructureValidForUpdate() )
            {
                throw new InvalidOperationException( "The structure of the Customer Object is not valid for Insert" );
            }

            errors = customer.IsValidForUpdate();
            if( errors.Count > 0 )
            {
                return false;
            }

            using( System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 1 ) ) )
            {
                //TODO: Check that the nameid values are set or add new SP to update customer name settings only
                if( customer.NameId.HasValue )
                {
                    CRMLibertyPowerSql.UpdateName( customer.NameId.Value, customer.CustomerName, customer.ModifiedBy );
                }
                else
                {
                    DataSet customerNameDataSet = CRMLibertyPowerSql.InsertName( customer.CustomerName, customer.CreatedBy, customer.ModifiedBy );
                    customer.NameId = Convert.ToInt32( customerNameDataSet.Tables[0].Rows[0]["NameID"] );
                    CRMLibertyPowerSql.InsertCustomerName( customer.CustomerId, customer.NameId, customer.CreatedBy, customer.ModifiedBy );
                }

                if( customer.OwnerNameId.HasValue )
                {
                    CRMLibertyPowerSql.UpdateName( customer.OwnerNameId.Value, customer.OwnerName, customer.ModifiedBy );
                }
                else
                {
                    DataSet ownerNameDataSet = CRMLibertyPowerSql.InsertName( customer.OwnerName, customer.CreatedBy, customer.ModifiedBy );
                    customer.OwnerNameId = Convert.ToInt32( ownerNameDataSet.Tables[0].Rows[0]["NameID"] );
                    CRMLibertyPowerSql.InsertCustomerName( customer.CustomerId, customer.OwnerNameId, customer.CreatedBy, customer.ModifiedBy );
                }

                DataSet customerDataSet = CRMLibertyPowerSql.UpdateCustomer( customer.CustomerId, customer.CustomerPreferenceId, customer.AddressId, customer.BusinessActivityId, customer.BusinessTypeId, customer.ContactId, customer.CreditAgencyId, customer.CreditScoreEncrypted, customer.NameId, customer.Dba, customer.Duns, customer.EmployerId, customer.ExternalNumber, customer.OwnerNameId, customer.SsnClear, customer.SsnEncrypted, customer.TaxIdEncrypted, customer.ModifiedBy );

                transactionScope.Complete();

                MapDataRowToCustomer( customerDataSet.Tables[0].Rows[0], customer );
            }

            return true;
        }

        private static Customer MapDataRowToCustomer( DataRow dataRow, Customer customer )
        {
            customer.CustomerId = dataRow.Field<int?>( "CustomerId" );
            customer.AddressId = dataRow.Field<int?>( "AddressId" );
            customer.CustomerPreferenceId = dataRow.Field<int?>( "CustomerPreferenceId" );
            customer.BusinessActivityId = dataRow.Field<int?>( "BusinessActivityId" );
            customer.BusinessTypeId = dataRow.Field<int?>( "BusinessTypeId" );            
            customer.ContactId = dataRow.Field<int?>( "ContactId" );
            customer.CreatedBy = dataRow.Field<int>( "CreatedBy" );
            customer.CreditAgencyId = dataRow.Field<int?>( "CreditAgencyId" );
            customer.CreditScoreEncrypted = dataRow.Field<string>( "CreditScoreEncrypted" );
            customer.NameId = dataRow.Field<int?>( "NameID" );
            customer.CustomerName = dataRow.Field<string>( "CustomerName" );
            customer.DateCreated = dataRow.Field<DateTime>( "DateCreated" );
            customer.Dba = dataRow.Field<string>( "Dba" );
            customer.Duns = dataRow.Field<string>( "Duns" );
            customer.EmployerId = dataRow.Field<string>( "EmployerId" );
            customer.ExternalNumber = dataRow.Field<string>( "ExternalNumber" );
            customer.Modified = dataRow.Field<DateTime>( "Modified" );
            customer.ModifiedBy = dataRow.Field<int>( "ModifiedBy" );
            customer.OwnerNameId = dataRow.Field<int?>( "OwnerNameID" );
            customer.OwnerName = dataRow.Field<string>( "OwnerName" );
            customer.SsnClear = dataRow.Field<string>( "SsnClear" );
            customer.SsnEncrypted = dataRow.Field<string>( "SsnEncrypted" );
            customer.TaxId = dataRow.Field<string>( "TaxId" );
            customer.TaxIdEncrypted = dataRow.Field<string>( "TaxId" );
            //Added BusinessType and business Activity
            //JUne 26 2013
            customer.BusinessType = dataRow.Field<string>("Type");
            customer.BusinessActivity = dataRow.Field<string>("Activity");


            return customer;
        }
        //   Amendment Added on June 17 2013
        //Bug 7839: 1-64232573 Contract Amendments
        public static bool GetCustomerIdforContractNumber(string contractNo, out List<GenericError> errors,out int? customerId)
        {
            errors = new List<GenericError>();
            customerId = 0;
            DataSet customerDataSet = CRMLibertyPowerSql.GetCustomerIdforContractNumber(contractNo);
            if (customerDataSet != null && customerDataSet.Tables.Count > 0 && customerDataSet.Tables[0].Rows.Count > 0)
            {
               customerId=customerDataSet.Tables[0].Rows[0].Field<int?>( "CustomerId" );
               return true;
            }
            else
            {
                errors.Add(new GenericError() { Code = 0, Message = "Customer does not exist for the existing contract to ammend " });
                return false;
            }
        }


    }
}
