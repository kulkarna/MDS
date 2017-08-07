using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEEnergyTradingMarketCurvesSql
    {

        /// <summary>
        /// Selects an EnergyTradingMarketCurves
        /// </summary>
        /// <param name=EnergyTradingMarketCurvesId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectEnergyTradingMarketCurves(Int32 energyTradingMarketCurvesId, String snapshotTradingSymbol, DateTime tradingTimeOpen, DateTime tradingTimeClose, DateTime snapshotTradingDays, String baselineReportSymbol, DateTime baselineReportTradingDay, DateTime baselineReportPricingDay, DateTime baselineReportValidTradeDate, Int32 zoneId, String snapshotReportSymbol, Int32 snapshotTradingHours, Int32 baselineTradingDays)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyTradingMarketCurvesSelect";

                    cmd.Parameters.Add(new SqlParameter("@EnergyTradingMarketCurvesId", energyTradingMarketCurvesId));
                    cmd.Parameters.Add(new SqlParameter("@SnapshotTradingSymbol", snapshotTradingSymbol));
                    cmd.Parameters.Add(new SqlParameter("@TradingTimeOpen", tradingTimeOpen));
                    cmd.Parameters.Add(new SqlParameter("@TradingTimeClose", tradingTimeClose));
                    cmd.Parameters.Add(new SqlParameter("@SnapshotTradingDays", snapshotTradingDays));
                    cmd.Parameters.Add(new SqlParameter("@BaselineReportSymbol", baselineReportSymbol));
                    cmd.Parameters.Add(new SqlParameter("@BaselineReportTradingDay", baselineReportTradingDay));
                    cmd.Parameters.Add(new SqlParameter("@BaselineReportPricingDay", baselineReportPricingDay));
                    cmd.Parameters.Add(new SqlParameter("@BaselineReportValidTradeDate", baselineReportValidTradeDate));
                    cmd.Parameters.Add(new SqlParameter("@ZoneId", zoneId));
                    cmd.Parameters.Add(new SqlParameter("@SnapshotReportSymbol", snapshotReportSymbol));
                    cmd.Parameters.Add(new SqlParameter("@SnapshotTradingHours", snapshotTradingHours));
                    cmd.Parameters.Add(new SqlParameter("@BaselineTradingDays", baselineTradingDays));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts an EnergyTradingMarketCurves
        /// </summary>
        /// <param name=EnergyTradingMarketCurves></param>
        public static int InsertEnergyTradingMarketCurves(String snapshotTradingSymbol, DateTime tradingTimeOpen, DateTime tradingTimeClose, DateTime snapshotTradingDays, String baselineReportSymbol, DateTime baselineReportTradingDay, DateTime baselineReportPricingDay, DateTime baselineReportValidTradeDate, Int32 zoneId, String snapshotReportSymbol, Int32 snapshotTradingHours, Int32 baselineTradingDays)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyTradingMarketCurvesInsert";

                    cmd.Parameters.Add(new SqlParameter("@SnapshotTradingSymbol", snapshotTradingSymbol));
                    cmd.Parameters.Add(new SqlParameter("@TradingTimeOpen", tradingTimeOpen));
                    cmd.Parameters.Add(new SqlParameter("@TradingTimeClose", tradingTimeClose));
                    cmd.Parameters.Add(new SqlParameter("@SnapshotTradingDays", snapshotTradingDays));
                    cmd.Parameters.Add(new SqlParameter("@BaselineReportSymbol", baselineReportSymbol));
                    cmd.Parameters.Add(new SqlParameter("@BaselineReportTradingDay", baselineReportTradingDay));
                    cmd.Parameters.Add(new SqlParameter("@BaselineReportPricingDay", baselineReportPricingDay));
                    cmd.Parameters.Add(new SqlParameter("@BaselineReportValidTradeDate", baselineReportValidTradeDate));
                    cmd.Parameters.Add(new SqlParameter("@ZoneId", zoneId));
                    cmd.Parameters.Add(new SqlParameter("@SnapshotReportSymbol", snapshotReportSymbol));
                    cmd.Parameters.Add(new SqlParameter("@SnapshotTradingHours", snapshotTradingHours));
                    cmd.Parameters.Add(new SqlParameter("@BaselineTradingDays", baselineTradingDays));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

