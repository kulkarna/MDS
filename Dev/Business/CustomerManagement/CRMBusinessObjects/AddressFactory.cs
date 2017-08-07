using System;
using System.Collections.Generic;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class AddressFactory
    {
        #region Address

        public static Address GetAddress( int addressId )
        {
            DataSet ds = CRMLibertyPowerSql.GetAddress( addressId );

            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                Address address = new Address();
                MapDataRowToAddress( ds.Tables[0].Rows[0], address );
                return address;
            }

            return null;
        }

        public static List<Address> GetAddressByCustomerId( int customerId )
        {
            List<Address> addresses = new List<Address>();
            DataSet ds = CRMLibertyPowerSql.GetAddressByCustomerId( customerId );

            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                foreach( var row in ds.Tables[0].Rows )
                {
                    Address address = new Address();
                    MapDataRowToAddress( ds.Tables[0].Rows[0], address );
                    addresses.Add( address );
                }
            }
            return addresses;
        }

        //private static bool InsertAddress( Address address )
        //{
        //    List<GenericError> errors = null;
        //    return InsertAddress( address, out errors );
        //}

        /// <summary>
        /// Insert an address reocrds, must be used with care since the CustomerAddress table has dependencies here
        /// </summary>
        /// <param name="address"></param>
        /// <param name="errors"></param>
        /// <returns></returns>
        public static bool InsertAddress( Address address, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            if( !address.IsStructureValidForInsert() )
            {
                throw new InvalidOperationException( "The structure of the Address Object is not valid" );
            }

            errors = address.IsValidForInsert();

            if( errors.Count > 0 )
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.InsertAddress( address.Street, address.Suite, address.City, address.State, address.StateFips, address.Zip, address.County, address.CountyFips, address.CreatedBy, address.ModifiedBy );

            MapDataRowToAddress( ds.Tables[0].Rows[0], address );

            return true;
        }

        public static bool UpdateAddress( Address address )
        {
            List<GenericError> errors = null;
            return UpdateAddress( address, out errors );
        }

        public static bool UpdateAddress( Address address, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            if( !address.IsStructureValidForUpdate() )
            {
                throw new InvalidOperationException( "The structure of the Address Object is not valid" );
            }

            errors = address.IsValidForUpdate();

            if( errors.Count > 0 )
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.UpdateAddress( address.AddressId.Value, address.Street, address.Suite, address.City, address.State, address.StateFips, address.Zip, address.County, address.CountyFips, address.ModifiedBy );

            MapDataRowToAddress( ds.Tables[0].Rows[0], address );

            return true;
        }

        private static void MapDataRowToAddress( DataRow dataRow, Address address )
        {
            address.AddressId = dataRow.Field<int?>( "AddressId" );
            address.City = dataRow.Field<string>( "City" );
            address.County = dataRow.Field<string>( "County" );
            address.CountyFips = dataRow.Field<string>( "CountyFips" );
            address.CreatedBy = dataRow.Field<int>( "CreatedBy" );
            address.DateCreated = dataRow.Field<DateTime>( "DateCreated" );
            address.Modified = dataRow.Field<DateTime>( "Modified" );
            address.ModifiedBy = dataRow.Field<int>( "ModifiedBy" );
            address.State = dataRow.Field<string>( "State" );
            address.StateFips = dataRow.Field<string>( "StateFips" );
            address.Street = dataRow.Field<string>( "Address1" );
            address.Suite = dataRow.Field<string>( "Address2" );
            address.Zip = dataRow.Field<string>( "Zip" );
        }

        #endregion

        #region Customer Address

        private static CustomerAddress GetCustomerAddress( int customerAddressId )
        {
            DataSet ds = CRMLibertyPowerSql.GetCustomerAddress( customerAddressId );

            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                CustomerAddress customerAddress = new CustomerAddress();
                MapDataRowToCustomerAddress( ds.Tables[0].Rows[0], customerAddress );
                return customerAddress;
            }

            return null;
        }

        private static List<CustomerAddress> GetCustomerAddresses( int customerId )
        {
            List<CustomerAddress> recordList = new List<CustomerAddress>();

            DataSet ds = CRMLibertyPowerSql.GetCustomerAddresses( customerId );

            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    CustomerAddress customerAddress = new CustomerAddress();
                    MapDataRowToCustomerAddress( dr, customerAddress );

                    recordList.Add( customerAddress );
                }
            }

            return recordList;
        }

        public static bool InsertCustomerAddress( Address address, int customerId, out List<GenericError> errors )
        {
            bool result = false;
            errors = new List<GenericError>();
            using( System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 1 ) ) )
            {

                if( InsertAddress( address, out errors ) )
                {
                    CustomerAddress ca = new CustomerAddress();
                    ca.AddressId = address.AddressId;
                    ca.CreatedBy = address.CreatedBy;
                    ca.ModifiedBy = address.ModifiedBy;
                    ca.Modified = DateTime.Now;
                    ca.CustomerId = customerId;
                    result = InsertCustomerAddress( ca, out errors );
                }
                transactionScope.Complete();
            }
            return result;
        }

        private static bool InsertCustomerAddress( CustomerAddress customerAddress, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            #region Validation

            if( !customerAddress.IsStructureValidForInsert() )
            {
                throw new InvalidOperationException( "The structure of the Customer Address Object is not valid for Insert" );
            }

            errors = customerAddress.IsValidForInsert();

            if( errors.Count > 0 )
            {
                return false;
            }

            #endregion Validation

            using( System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope( System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions( 1 ) ) )
            {
                // Insert Customer Address
                DataSet customerAddressDataSet = CRMLibertyPowerSql.InsertCustomerAddress( customerAddress.CustomerId, customerAddress.AddressId, customerAddress.ModifiedBy, customerAddress.CreatedBy );
                MapDataRowToCustomerAddress( customerAddressDataSet.Tables[0].Rows[0], customerAddress );

                transactionScope.Complete();
            }

            return true;
        }

        internal static void MapDataRowToCustomerAddress( DataRow dataRow, CustomerAddress customerAddress )
        {
            customerAddress.CustomerAddressId = dataRow.Field<int?>( "CustomerAddressID" );
            customerAddress.CustomerId = dataRow.Field<int?>( "CustomerID" );
            customerAddress.AddressId = dataRow.Field<int?>( "AddressID" );
            customerAddress.Modified = dataRow.Field<DateTime>( "Modified" );
            customerAddress.ModifiedBy = dataRow.Field<int>( "ModifiedBy" );
            customerAddress.DateCreated = dataRow.Field<DateTime>( "DateCreated" );
            customerAddress.CreatedBy = dataRow.Field<int>( "CreatedBy" );
        }

        #endregion
    }
}
