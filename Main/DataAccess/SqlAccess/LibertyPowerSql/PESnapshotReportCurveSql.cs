using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PESnapshotReportCurveSql
    {

        /// <summary>
        /// Selects a SnapshotReportCurve
        /// </summary>
        /// <param name=SnapshotReportCurveId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectSnapshotReportCurve(Int32 snapshotReportCurveId, String symbol, Decimal last, Decimal change, Decimal high, Decimal low, Decimal previous, DateTime tradeTime, DateTime tradeDate )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESnapshotReportCurveSelect";

                    cmd.Parameters.Add(new SqlParameter("@SnapshotReportCurveId", snapshotReportCurveId));
                    cmd.Parameters.Add(new SqlParameter("@Symbol", symbol));
                    cmd.Parameters.Add(new SqlParameter("@Last", last));
                    cmd.Parameters.Add(new SqlParameter("@Change", change));
                    cmd.Parameters.Add(new SqlParameter("@High", high));
                    cmd.Parameters.Add(new SqlParameter("@Low", low));
                    cmd.Parameters.Add(new SqlParameter("@Previous", previous));
                    cmd.Parameters.Add(new SqlParameter("@TradeTime", tradeTime));
                    cmd.Parameters.Add(new SqlParameter("@TradeDate", tradeDate));
                     

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a SnapshotReportCurve
        /// </summary>
        /// <param name=SnapshotReportCurve></param>
        public static int InsertSnapshotReportCurve(String symbol, Decimal last, Decimal change, Decimal high, Decimal low, Decimal previous, DateTime tradeTime, DateTime tradeDate )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESnapshotReportCurveInsert";

                    cmd.Parameters.Add(new SqlParameter("@Symbol", symbol));
                    cmd.Parameters.Add(new SqlParameter("@Last", last));
                    cmd.Parameters.Add(new SqlParameter("@Change", change));
                    cmd.Parameters.Add(new SqlParameter("@High", high));
                    cmd.Parameters.Add(new SqlParameter("@Low", low));
                    cmd.Parameters.Add(new SqlParameter("@Previous", previous));
                    cmd.Parameters.Add(new SqlParameter("@TradeTime", tradeTime));
                    cmd.Parameters.Add(new SqlParameter("@TradeDate", tradeDate));
                     
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

