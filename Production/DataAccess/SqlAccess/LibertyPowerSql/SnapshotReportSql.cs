namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
using System.Data;
using System.Data.SqlClient;

	/// <summary>
	/// Class to retrieve a snapshot report of the Energy Trading Market Curve
	/// </summary>
	public static class SnapshotReportSql
	{
		/// <summary>
		/// Method to retrieve the Snapshot Report given a range of date and symbol
		/// </summary>
		/// <param name="initialDate">Initial Date</param>
		/// <param name="endDate">End Date</param>
		/// <param name="symbol">Symbol (eg.QNG, NG)</param>
		/// <returns>DataSet</returns>
		public static DataSet SnapshotReportSelectRange ( DateTime initialDate, DateTime endDate, string symbol)
		{
			DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEEnergyTradingMarketCurvesReportsSelectRange";

				}
			}
			return ds;

		}
	}
}
