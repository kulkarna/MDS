using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
   [Serializable]
	public static class PENewSupplyQuoteRequestHeaderSql
   {

       /// <summary>
       /// Selects a NewSupplyQuoteRequestHeader
       /// </summary>
       /// <param name=NewSupplyQuoteRequestHeaderId></param>
       /// <returns>A dataset with all attributes</returns>
       public static DataSet SelectNewSupplyQuoteRequestHeader(Int32 newSupplyQuoteRequestHeaderId, String opportunity, Int32 offerId, String requestor, DateTime requestTime, DateTime pricingRequestDueTime, DateTime quoteDueTime  )       {
           DataSet ds = new DataSet();
           using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
       	{
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "usp_PENewSupplyQuoteRequestHeaderSelect";

                cmd.Parameters.Add(new SqlParameter("@NewSupplyQuoteRequestHeaderId", newSupplyQuoteRequestHeaderId));
                cmd.Parameters.Add(new SqlParameter("@Opportunity", opportunity));
                cmd.Parameters.Add(new SqlParameter("@OfferId", offerId));
                cmd.Parameters.Add(new SqlParameter("@Requestor", requestor));
                cmd.Parameters.Add(new SqlParameter("@RequestTime", requestTime));
                cmd.Parameters.Add(new SqlParameter("@PricingRequestDueTime", pricingRequestDueTime));
                cmd.Parameters.Add(new SqlParameter("@QuoteDueTime", quoteDueTime));
                 

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(ds);
                }
            }
       }
       return ds;
   }
       /// <summary>
       /// Inserts a NewSupplyQuoteRequestHeader
       /// </summary>
       /// <param name=NewSupplyQuoteRequestHeader></param>
       public static int InsertNewSupplyQuoteRequestHeader(String opportunity, Int32 offerId, String requestor, DateTime requestTime, DateTime pricingRequestDueTime, DateTime quoteDueTime )
       {
           DataSet ds = new DataSet();
           using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
           {
               using (SqlCommand cmd = new SqlCommand())
               {
                   cmd.Connection = conn;
                   cmd.CommandType = CommandType.StoredProcedure;
                   cmd.CommandText = "usp_PENewSupplyQuoteRequestHeaderInsert";

                   cmd.Parameters.Add(new SqlParameter("@Opportunity", opportunity));
                   cmd.Parameters.Add(new SqlParameter("@OfferId", offerId));
                   cmd.Parameters.Add(new SqlParameter("@Requestor", requestor));
                   cmd.Parameters.Add(new SqlParameter("@RequestTime", requestTime));
                   cmd.Parameters.Add(new SqlParameter("@PricingRequestDueTime", pricingRequestDueTime));
                   cmd.Parameters.Add(new SqlParameter("@QuoteDueTime", quoteDueTime));
                    
                   conn.Open();
                   return Convert.ToInt32( cmd.ExecuteScalar() );

               }
           }
       }
   }
}

