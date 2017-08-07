using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEClosingBusinessDayReportCurveSql
    {

        /// <summary>
        /// Selects a ClosingBusinessDayReportCurve
        /// </summary>
        /// <param name=ClosingBusinessDayReportCurveId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectClosingBusinessDayReportCurve(Int32 closingBusinessDayReportCurveId, String symbol, Decimal last, Decimal change, Decimal high, Decimal low, Decimal previous, DateTime tradeTime, DateTime tradeData )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEClosingBusinessDayReportCurveSelect";

                    cmd.Parameters.Add(new SqlParameter("@ClosingBusinessDayReportCurveId", closingBusinessDayReportCurveId));
                    cmd.Parameters.Add(new SqlParameter("@Symbol", symbol));
                    cmd.Parameters.Add(new SqlParameter("@Last", last));
                    cmd.Parameters.Add(new SqlParameter("@Change", change));
                    cmd.Parameters.Add(new SqlParameter("@High", high));
                    cmd.Parameters.Add(new SqlParameter("@Low", low));
                    cmd.Parameters.Add(new SqlParameter("@Previous", previous));
                    cmd.Parameters.Add(new SqlParameter("@TradeTime", tradeTime));
                    cmd.Parameters.Add(new SqlParameter("@TradeData", tradeData));
                     

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a ClosingBusinessDayReportCurve
        /// </summary>
        /// <param name=ClosingBusinessDayReportCurve></param>
        public static int InsertClosingBusinessDayReportCurve(String symbol, Decimal last, Decimal change, Decimal high, Decimal low, Decimal previous, DateTime tradeTime, DateTime tradeData )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEClosingBusinessDayReportCurveInsert";

                    cmd.Parameters.Add(new SqlParameter("@Symbol", symbol));
                    cmd.Parameters.Add(new SqlParameter("@Last", last));
                    cmd.Parameters.Add(new SqlParameter("@Change", change));
                    cmd.Parameters.Add(new SqlParameter("@High", high));
                    cmd.Parameters.Add(new SqlParameter("@Low", low));
                    cmd.Parameters.Add(new SqlParameter("@Previous", previous));
                    cmd.Parameters.Add(new SqlParameter("@TradeTime", tradeTime));
                    cmd.Parameters.Add(new SqlParameter("@TradeData", tradeData));
                     
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

