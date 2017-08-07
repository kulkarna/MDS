using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEOfferDetailFileHeaderSql
    {

        /// <summary>
        /// Selects an OfferDetailFileHeader
        /// </summary>
        /// <param name=OfferDetailFileHeaderId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectOfferDetailFileHeader(Int32 offerDetailFileHeaderId, Int32 requestId, Int32 offerId, String customer, String pricingType, String market, Decimal voluntaryRenewable, String voluntaryRenewablesPlanName, Decimal bandwidth, String pricingGroup, DateTime documentTime, DateTime expirationTime, String pricingAnalyst , String salesRep)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOfferDetailFileHeaderSelect";

                    cmd.Parameters.Add(new SqlParameter("@OfferDetailFileHeaderId", offerDetailFileHeaderId));
                    cmd.Parameters.Add(new SqlParameter("@RequestId", requestId));
                    cmd.Parameters.Add(new SqlParameter("@OfferId", offerId));
                    cmd.Parameters.Add(new SqlParameter("@Customer", customer));
                    cmd.Parameters.Add(new SqlParameter("@PricingType", pricingType));
                    cmd.Parameters.Add(new SqlParameter("@Market", market));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewable", voluntaryRenewable));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewablesPlanName", voluntaryRenewablesPlanName));
                    cmd.Parameters.Add(new SqlParameter("@Bandwidth", bandwidth));
                    cmd.Parameters.Add(new SqlParameter("@PricingGroup", pricingGroup));
                    cmd.Parameters.Add(new SqlParameter("@DocumentTime", documentTime));
                    cmd.Parameters.Add(new SqlParameter("@ExpirationTime", expirationTime));
                    cmd.Parameters.Add(new SqlParameter("@PricingAnalyst", pricingAnalyst));
                     
                    cmd.Parameters.Add(new SqlParameter("@SalesRep", salesRep));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts an OfferDetailFileHeader
        /// </summary>
        /// <param name=OfferDetailFileHeader></param>
        public static int InsertOfferDetailFileHeader(Int32 requestId, Int32 offerId, String customer, String pricingType, String market, Decimal voluntaryRenewable, String voluntaryRenewablesPlanName, Decimal bandwidth, String pricingGroup, DateTime documentTime, DateTime expirationTime, String pricingAnalyst , String salesRep)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOfferDetailFileHeaderInsert";

                    cmd.Parameters.Add(new SqlParameter("@RequestId", requestId));
                    cmd.Parameters.Add(new SqlParameter("@OfferId", offerId));
                    cmd.Parameters.Add(new SqlParameter("@Customer", customer));
                    cmd.Parameters.Add(new SqlParameter("@PricingType", pricingType));
                    cmd.Parameters.Add(new SqlParameter("@Market", market));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewable", voluntaryRenewable));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewablesPlanName", voluntaryRenewablesPlanName));
                    cmd.Parameters.Add(new SqlParameter("@Bandwidth", bandwidth));
                    cmd.Parameters.Add(new SqlParameter("@PricingGroup", pricingGroup));
                    cmd.Parameters.Add(new SqlParameter("@DocumentTime", documentTime));
                    cmd.Parameters.Add(new SqlParameter("@ExpirationTime", expirationTime));
                    cmd.Parameters.Add(new SqlParameter("@PricingAnalyst", pricingAnalyst));
                     
                    cmd.Parameters.Add(new SqlParameter("@SalesRep", salesRep));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

