using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using LibertyPower.Business.CommonBusiness.CommonEntity;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using lp = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using System.Linq;
namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    /// <summary>
    /// Returns the list of all UtilityPaymentTerms data.
    /// </summary>
    /// <remarks>This is a Factory class used to
    /// retrieve and instantiate UtilityPaymentTerms.</remarks>
    [Serializable]
    public static class UtilityPaymentTermsFactory
    {
        /// <summary>
        /// Gets UtilityPaymentTerms.
        /// </summary>
        /// <returns>The generic ILIST of UtilityPaymentTerms.</returns>
        public static List<UtilityPaymentTerms> GetUtilityPaymentTerms( string utilityCode, int marketID )
        {
            List<UtilityPaymentTerms> upt = null; // the return value

            DataSet ds = UtilityPaymentTermsSql.SelectUtilityPaymentTerms( utilityCode, marketID );
            if( DataSetHelper.HasRow( ds ) )
                upt = new List<UtilityPaymentTerms>();
            {
                foreach( DataRow data in ds.Tables[0].Rows )
                {
                    UtilityPaymentTerms u = new UtilityPaymentTerms();
                    u.marketID = data["MarketId"] == DBNull.Value ? -1 : Convert.ToInt32( data["MarketId"] );
                    u.utilityID = data["UtilityId"] == DBNull.Value ? -1 : Convert.ToInt32( data["UtilityId"] );
                    u.BillTypeID = data["BillingTypeID"] == DBNull.Value ? -1 : Convert.ToInt32( data["BillingTypeID"] );
                    u.AccountTypeID = data["AccountTypeID"] == DBNull.Value ? -1 : Convert.ToInt32( data["AccountTypeID"] );
                    u.ArTerm = data["ARTerms"] == DBNull.Value ? -1 : Convert.ToInt32( data["ARTerms"] );
                    u.rowID = data["ID"] == DBNull.Value ? -1 : Convert.ToInt32( data["ID"] );

                    upt.Add( u );
                }
            }
            return upt;
        }

        public static bool InsertUtilityPaymentTerms( int utilityID, int MarketID, int? BillingTypeID, int AccountTypeID, int ARTerm, out string msg )
        {
            msg = string.Empty;
            bool bSuccess = true;
            try
            {
                UtilityPaymentTermsSql.InsertUtilityPaymentTerms( utilityID, MarketID, BillingTypeID, AccountTypeID, ARTerm );
                msg = "Record Added";
            }
            catch( Exception ex )
            {
                bSuccess = false;
                msg = "Error Inserting record: " + ex.Message;
            }
            return bSuccess;
        }

        public static bool UpdateUtilityPaymentTerms( int rowID, int BillingTypeID, int AccountTypeID, int ARTerm, out string msg )
        {
            msg = string.Empty;
            bool bSuccess = true;
            try
            {
                UtilityPaymentTermsSql.UpdateUtilityPaymentTerms( rowID, BillingTypeID, AccountTypeID, ARTerm );
                msg = "Record Updated";
            }
            catch( Exception ex )
            {
                bSuccess = false;
                msg = "Error updating record: " + ex.Message;
            }
            return bSuccess;
        }

        public static bool DeleteUtilityPaymentTerms( int rowID, out string msg )
        {
            msg = string.Empty;
            bool bSuccess = true;
            try
            {
                UtilityPaymentTermsSql.DeleteUtilityPaymentTerms( rowID );
                msg = "Record Deleted";
            }
            catch( Exception ex )
            {
                bSuccess = false;
                msg = "Error deleting record: " + ex.Message;
            }
            return bSuccess;
        }



        public static int CalculateUtilityPaymentTerms( Utility utility )
        {
            int res = 16;

            List<UtilityPaymentTerms> paymentTerms = GetUtilityPaymentTerms( utility.Code, utility.RetailMarketID );



            return res;
        }
    }
}
