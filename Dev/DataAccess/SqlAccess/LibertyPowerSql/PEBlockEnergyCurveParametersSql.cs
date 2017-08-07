using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{

    public static class PEBlockEnergyCurveParametersSql
    {
	
        /// <summary>
        /// Inserts a BlockEnergyCurveParameters
        /// </summary>
        /// <param name=BlockEnergyCurveParameters></param>
        public static int InsertBlockEnergyCurveParameters(Int32 zoneId, Boolean isPeak, Decimal pricingDay, DateTime validTradeDate)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEBlockEnergyCurveParametersInsert";

                    cmd.Parameters.Add(new SqlParameter("@ZoneId", zoneId));
                    cmd.Parameters.Add(new SqlParameter("@IsPeak", isPeak));
                    cmd.Parameters.Add(new SqlParameter("@PricingDay", pricingDay));
                    cmd.Parameters.Add(new SqlParameter("@ValidTradeDate", validTradeDate));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

