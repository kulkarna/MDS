using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class MarginThresholdSql
    {
        public static DataSet GetMarginThresholds()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_MarginThresholdSelect";

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        public static void InsertMarginThreshold(int UserID, decimal MarginLow, decimal MarginHigh, decimal MarginLimit, DateTime EffectiveDate, DateTime? ExpirationDate)
        {
            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_MarginThresholdInsert";

                    cmd.Parameters.Add(new SqlParameter("@UserID", UserID));
                    cmd.Parameters.Add(new SqlParameter("@MarginLow", MarginLow));
                    cmd.Parameters.Add(new SqlParameter("@MarginHigh", MarginHigh));
                    cmd.Parameters.Add(new SqlParameter("@MarginLimit", MarginLimit));
                    cmd.Parameters.Add(new SqlParameter("@EffectiveDate", EffectiveDate));
                    if (ExpirationDate != null)
                        cmd.Parameters.Add(new SqlParameter("@ExpirationDate", ExpirationDate));

                    cn.Open();

                    cmd.ExecuteNonQuery();
                }
            }
        }

        public static void ExpireActiveMarginThreshold(int ID, int UserID, decimal MarginLow, decimal MarginHigh, DateTime EffectiveDate)
        {
            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_MarginThresholdExpireActive";

                    cmd.Parameters.Add(new SqlParameter("@ID", ID));
                    cmd.Parameters.Add(new SqlParameter("@UserID", UserID));
                    cmd.Parameters.Add(new SqlParameter("@MarginLow", MarginLow));
                    cmd.Parameters.Add(new SqlParameter("@MarginHigh", MarginHigh));
                    cmd.Parameters.Add(new SqlParameter("@EffectiveDate", EffectiveDate));

                    cn.Open();

                    cmd.ExecuteNonQuery();
                }
            }
        }

        public static void UpdateMarginThreshold(int ID, int UserID, decimal MarginLow, decimal MarginHigh, decimal MarginLimit, DateTime EffectiveDate, DateTime? ExpirationDate)
        {
            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_MarginThresholdUpdate";

                    cmd.Parameters.Add(new SqlParameter("@ID", ID));
                    cmd.Parameters.Add(new SqlParameter("@UserID", UserID));
                    cmd.Parameters.Add(new SqlParameter("@MarginLow", MarginLow));
                    cmd.Parameters.Add(new SqlParameter("@MarginHigh", MarginHigh));
                    cmd.Parameters.Add(new SqlParameter("@MarginLimit", MarginLimit));
                    cmd.Parameters.Add(new SqlParameter("@EffectiveDate", EffectiveDate));
                    if (ExpirationDate != null)
                        cmd.Parameters.Add(new SqlParameter("@ExpirationDate", ExpirationDate));


                    cn.Open();

                    cmd.ExecuteNonQuery();
                }
            }
        }

        public static void DeleteMarginThreshold(int ID)
        {
            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_MarginThresholdDelete";

                    cmd.Parameters.Add(new SqlParameter("@ID", ID));

                    cn.Open();

                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
