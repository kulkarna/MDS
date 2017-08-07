using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEOfferDocumentHeaderSql
    {

        /// <summary>
        /// Selects an OfferDocumentHeader
        /// </summary>
        /// <param name=OfferDocumentHeaderId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectOfferDocumentHeader(Int32 offerDocumentHeaderId, Int32 requestId, Int32 offerId, String customer, String pricingType, String salesRep, String market, Decimal voluntaryRenewable, String voluntaryRenewablesPlanName, Decimal bandwidth, String pricingGroup, DateTime expirationTime )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOfferDocumentHeaderSelect";

                    cmd.Parameters.Add(new SqlParameter("@OfferDocumentHeaderId", offerDocumentHeaderId));
                    cmd.Parameters.Add(new SqlParameter("@RequestId", requestId));
                    cmd.Parameters.Add(new SqlParameter("@OfferId", offerId));
                    cmd.Parameters.Add(new SqlParameter("@Customer", customer));
                    cmd.Parameters.Add(new SqlParameter("@PricingType", pricingType));
                    cmd.Parameters.Add(new SqlParameter("@SalesRep", salesRep));
                    cmd.Parameters.Add(new SqlParameter("@Market", market));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewable", voluntaryRenewable));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewablesPlanName", voluntaryRenewablesPlanName));
                    cmd.Parameters.Add(new SqlParameter("@Bandwidth", bandwidth));
                    cmd.Parameters.Add(new SqlParameter("@PricingGroup", pricingGroup));
                    cmd.Parameters.Add(new SqlParameter("@ExpirationTime", expirationTime));
                     

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts an OfferDocumentHeader
        /// </summary>
        /// <param name=OfferDocumentHeader></param>
        public static int InsertOfferDocumentHeader(Int32 requestId, Int32 offerId, String customer, String pricingType, String salesRep, String market, Decimal voluntaryRenewable, String voluntaryRenewablesPlanName, Decimal bandwidth, String pricingGroup, DateTime expirationTime )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOfferDocumentHeaderInsert";

                    cmd.Parameters.Add(new SqlParameter("@RequestId", requestId));
                    cmd.Parameters.Add(new SqlParameter("@OfferId", offerId));
                    cmd.Parameters.Add(new SqlParameter("@Customer", customer));
                    cmd.Parameters.Add(new SqlParameter("@PricingType", pricingType));
                    cmd.Parameters.Add(new SqlParameter("@SalesRep", salesRep));
                    cmd.Parameters.Add(new SqlParameter("@Market", market));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewable", voluntaryRenewable));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewablesPlanName", voluntaryRenewablesPlanName));
                    cmd.Parameters.Add(new SqlParameter("@Bandwidth", bandwidth));
                    cmd.Parameters.Add(new SqlParameter("@PricingGroup", pricingGroup));
                    cmd.Parameters.Add(new SqlParameter("@ExpirationTime", expirationTime));
                     
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

