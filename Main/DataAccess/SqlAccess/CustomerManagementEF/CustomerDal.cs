//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;

//namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
//{
//    public static class CustomerDal
//    {

//        public static Customer GetCustomer( int customerId )
//        {
//            Customer c = CommonDal.LPGetNonTrackedEntity<Customer>( d => d.CustomerID == customerId );
//            //if( c.OwnerNameID.HasValue )
//            //{
//            //    c.OwnerName = CommonDal.LPCommonGetNonTrackedEntity<account_name>( f => f.AccountNameID == c.OwnerNameID.Value );
//            //}
//            //c.Name = CommonDal.LPCommonGetNonTrackedEntity<account_name>( f => f.AccountNameID == c.NameID );
//            return c;
//        }

//        //public static CustomerPreference GetCustomerPreference( int customerId )
//        //{
//        //    CustomerPreference c = CommonDal.LPGetNonTrackedEntity<CustomerPreference>( d => d.CustomerID == customerId );
//        //    return c;
//        //}

//        public static bool InsertCustomerPreference( CustomerPreference customerPreference )
//        {
//            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
//            {
//                dal.CustomerPreferences.AddObject( customerPreference );
//                dal.SaveChanges();
//            }
//            return true;
//        }

//        public static bool InsertCustomer( Customer customer )
//        {
//            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
//            {
//                dal.Customers.AddObject( customer );
//                dal.SaveChanges();
//            }
//            return true;
//        }

//        public static Customer UpdateCustomer( Customer c )
//        {
//            c.Modified = DateTime.Now;
//            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
//            {
//                dal.Customers.Attach( c );
//                dal.SaveChanges();
//            }
//            return c;
//        }


//    }
//}
