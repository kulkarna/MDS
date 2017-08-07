using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class ContactFactory
    {
        #region Contact

        public static Contact GetContact( int contactId )
        {
            DataSet ds = CRMLibertyPowerSql.GetContact( contactId );

            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                Contact contact = new Contact();
                MapDataRowToContact( ds.Tables[0].Rows[0], contact );
                return contact;
            }

            return null;
        }

        public static bool InsertContact( Contact contact, out List<GenericError> errors )
        {
            //int lastLinkNumber = Common.GetHighestLinkId( Enums.LinkIdTableType.contact, contact.Account_Id );
            //contact.ContactLink = ++lastLinkNumber;

            errors = new List<GenericError>();

            if( !contact.IsStructureValidForInsert() )
            {
                throw new InvalidOperationException( "The structure of the Contact Object is not valid" );
            }

            errors = contact.IsValidForInsert();

            if( errors.Count > 0 )
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.InsertContact( contact.FirstName, contact.LastName, contact.Title, contact.Phone, contact.Fax, contact.Email, contact.Birthday, contact.CreatedBy, contact.ModifiedBy );

            MapDataRowToContact( ds.Tables[0].Rows[0], contact );

            return true;
        }

        public static bool UpdateContact( Contact contact, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            if( !contact.IsStructureValidForUpdate() )
            {
                throw new InvalidOperationException( "The structure of the Contact Object is not valid" );
            }

            errors = contact.IsValidForUpdate();

            if( errors.Count > 0 )
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.UpdateContact( contact.ContactId, contact.FirstName, contact.LastName, contact.Title, contact.Phone, contact.Fax, contact.Email, contact.Birthday, contact.ModifiedBy );

            MapDataRowToContact( ds.Tables[0].Rows[0], contact );

            return true;
        }

        private static void MapDataRowToContact( DataRow dataRow, Contact contact )
        {
            if( dataRow["Birthdate"] != DBNull.Value )
                contact.Birthday = dataRow.Field<DateTime>( "Birthdate" );
            contact.ContactId = dataRow.Field<int?>( "contactId" );
            contact.CreatedBy = dataRow.Field<int>( "CreatedBy" );
            contact.DateCreated = dataRow.Field<DateTime>( "DateCreated" );
            contact.Email = dataRow.Field<string>( "Email" );
            contact.Fax = dataRow.Field<string>( "Fax" );
            contact.FirstName = dataRow.Field<string>( "FirstName" );
            contact.LastName = dataRow.Field<string>( "LastName" );
            contact.Modified = dataRow.Field<DateTime>( "Modified" );
            contact.ModifiedBy = dataRow.Field<int>( "ModifiedBy" );
            contact.Phone = dataRow.Field<string>( "Phone" );
            contact.Title = dataRow.Field<string>( "Title" );
        }

        #endregion

        #region Customer Contact

        private static CustomerContact GetCustomerContact( int customerContactId )
        {
            DataSet ds = CRMLibertyPowerSql.GetCustomerContact( customerContactId );

            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                CustomerContact customerContact = new CustomerContact();
                MapDataRowToCustomerContact( ds.Tables[0].Rows[0], customerContact );
                return customerContact;
            }

            return null;
        }

        public static List<CustomerContact> GetCustomerContacts( int customerId )
        {
            List<CustomerContact> recordList = new List<CustomerContact>();

            DataSet ds = CRMLibertyPowerSql.GetCustomerContacts( customerId );

            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    CustomerContact customerContact = new CustomerContact();
                    MapDataRowToCustomerContact( dr, customerContact );

                    recordList.Add( customerContact );
                }
            }

            return recordList;
        }

        public static bool InsertCustomerContact( Contact contact, int customerId, out List<GenericError> errors )
        {
            bool result = false;
            errors = new List<GenericError>();
            using( System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 1 ) ) )
            {

                if( InsertContact( contact, out errors ) )
                {
                    CustomerContact cc = new CustomerContact();
                    cc.ContactId = contact.ContactId;
                    cc.CreatedBy = contact.CreatedBy;
                    cc.CustomerId = customerId;
                    cc.DateCreated = DateTime.Now;
                    cc.Modified = DateTime.Now;
                    cc.ModifiedBy = contact.ModifiedBy;
                    result = InsertCustomerContact( cc, out errors );
                }
                transactionScope.Complete();
            }
            return result;
        }

        private static bool InsertCustomerContact( CustomerContact customerContact, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            #region Validation

            if( !customerContact.IsStructureValidForInsert() )
            {
                throw new InvalidOperationException( "The structure of the Customer Contact Object is not valid for Insert" );
            }

            errors = customerContact.IsValidForInsert();

            if( errors.Count > 0 )
            {
                return false;
            }

            #endregion Validation

            using( System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 1 ) ) )
            {
                // Insert Customer Contact
                DataSet customerContactDataSet = CRMLibertyPowerSql.InsertCustomerContact( customerContact.CustomerId, customerContact.ContactId, customerContact.ModifiedBy, customerContact.CreatedBy );
                MapDataRowToCustomerContact( customerContactDataSet.Tables[0].Rows[0], customerContact );

                transactionScope.Complete();
            }

            return true;
        }

        internal static void MapDataRowToCustomerContact( DataRow dataRow, CustomerContact customerContact )
        {
            customerContact.CustomerContactId = dataRow.Field<int?>( "CustomerContactID" );
            customerContact.CustomerId = dataRow.Field<int?>( "CustomerID" );
            customerContact.ContactId = dataRow.Field<int?>( "ContactID" );
            customerContact.Modified = dataRow.Field<DateTime>( "Modified" );
            customerContact.ModifiedBy = dataRow.Field<int>( "ModifiedBy" );
            customerContact.DateCreated = dataRow.Field<DateTime>( "DateCreated" );
            customerContact.CreatedBy = dataRow.Field<int>( "CreatedBy" );
        }

        #endregion
    }
}
