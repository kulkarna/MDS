using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PESnapshotReportMonthMappingSql
    {

        /// <summary>
        /// Selects a SnapshotReportMonthMapping
        /// </summary>
        /// <param name=SnapshotReportMonthMappingId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectSnapshotReportMonthMapping(String symbol, String month, Int32 monthNum)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESnapshotReportMonthMappingSelect";

                    cmd.Parameters.Add(new SqlParameter("@Symbol", symbol));
                    cmd.Parameters.Add(new SqlParameter("@Month", month));
                    cmd.Parameters.Add(new SqlParameter("@MonthNum", monthNum));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a SnapshotReportMonthMapping
        /// </summary>
        /// <param name=SnapshotReportMonthMapping></param>
        public static int InsertSnapshotReportMonthMapping(String month, Int32 monthNum)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESnapshotReportMonthMappingInsert";

                    cmd.Parameters.Add(new SqlParameter("@Month", month));
                    cmd.Parameters.Add(new SqlParameter("@MonthNum", monthNum));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

