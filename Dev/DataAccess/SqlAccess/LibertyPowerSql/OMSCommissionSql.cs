using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;



namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class OMSCommissionSql
    {
        public static DataSet CommissionInsert(string requestID, int offerID, decimal commission, Int64 priceID)
        {
           DataSet  ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_OMSCommissionInsert";

                    cmd.Parameters.Add(new SqlParameter("@RequestID", requestID));
                    cmd.Parameters.Add(new SqlParameter("@OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("@Commission", commission));
                    cmd.Parameters.Add(new SqlParameter("@PriceID", priceID));


                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        public static DataSet CommissionUpdate(string requestID, int offerID, decimal commission, Int64 priceID)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_OMSCommissionUpdate";

                    cmd.Parameters.Add(new SqlParameter("@RequestID", requestID));
                    cmd.Parameters.Add(new SqlParameter("@OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("@Commission", commission));
                    cmd.Parameters.Add(new SqlParameter("@PriceID", priceID));


                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        public static DataSet CommissionGet(string requestID, int offerID, Int64 priceID)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_OMSCommissionGet";

                    cmd.Parameters.Add(new SqlParameter("@RequestID", requestID));
                    cmd.Parameters.Add(new SqlParameter("@OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("@PriceID", priceID));
                    


                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        public static DataSet CommissionGetByRequestID(string RequestID)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_OMSCommissionGetByRequestID";

                    cmd.Parameters.Add(new SqlParameter("@RequestID", RequestID));
                    

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
    }
}
