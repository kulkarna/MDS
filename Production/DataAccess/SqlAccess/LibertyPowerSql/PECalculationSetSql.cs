using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PECalculationSetSql
    {

        /// <summary>
        /// Selects a CalculationSet
        /// </summary>
        /// <param name=CalculationSetId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectCalculationSet(Int32 calculationSetId, DateTime createdDateTime, Int32 user)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PECalculationSetSelect";

                    cmd.Parameters.Add(new SqlParameter("@CalculationSetId", calculationSetId));
                    cmd.Parameters.Add(new SqlParameter("@CreatedDateTime", createdDateTime));
                    cmd.Parameters.Add(new SqlParameter("@User", user));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a CalculationSet
        /// </summary>
        /// <param name=CalculationSet></param>
        public static int InsertCalculationSet(DateTime createdDateTime, Int32 user)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PECalculationSetInsert";

                    cmd.Parameters.Add(new SqlParameter("@CreatedDateTime", createdDateTime));
                    cmd.Parameters.Add(new SqlParameter("@User", user));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

