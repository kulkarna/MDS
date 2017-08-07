using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEAddersSql
    {

        /// <summary>
        /// Selects an Adders
        /// </summary>
        /// <param name=AddersId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectAdders(Int32 addersId, Decimal defaultMarkup, Decimal commission)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEAddersSelect";

                    cmd.Parameters.Add(new SqlParameter("@AddersId", addersId));
                    cmd.Parameters.Add(new SqlParameter("@DefaultMarkup", defaultMarkup));
                    cmd.Parameters.Add(new SqlParameter("@Commission", commission));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts an Adders
        /// </summary>
        /// <param name=Adders></param>
        public static int InsertAdders(Decimal defaultMarkup, Decimal commission)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEAddersInsert";

                    cmd.Parameters.Add(new SqlParameter("@DefaultMarkup", defaultMarkup));
                    cmd.Parameters.Add(new SqlParameter("@Commission", commission));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

