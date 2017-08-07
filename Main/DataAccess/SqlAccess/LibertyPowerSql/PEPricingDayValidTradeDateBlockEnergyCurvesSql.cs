using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class PEPricingDayValidTradeDateBlockEnergyCurvesSql
    {


        /// <summary>
        /// Inserts a new Pricing Day Valid Trade Date Block Energy Curves.
        /// </summary>
        /// <param name="validaTradeDate"></param>
        /// <param name="pricingDay"></param>
        /// <returns></returns>
        public static int InsertPricingDayValidTradeDateBlockEnergyCurves( DateTime validateTradeDate, DateTime pricingDay, string curveName )
        {
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPricingDayValidTradeDateBlockEnergyCurvesInsert";

                    cmd.Parameters.Add( new SqlParameter( "@ValidateTradeDate", validateTradeDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@PricingDay", pricingDay ) );
                    cmd.Parameters.Add( new SqlParameter( "@CurveName", curveName ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

		/// <summary>
		/// Gets pricing day valid trade date block energy curves for date range
		/// </summary>
		/// <param name="beginDate">Begin date</param>
		/// <param name="endDate">End date</param>
		/// <returns>Returns a dataset containing the pricing day valid trade date block energy curves for date range</returns>
		public static DataSet SelectPricingDayValidTradeDateBlockEnergyCurves( DateTime beginDate, DateTime endDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEPricingDayValidTradeDateBlockEnergyCurvesSelect";

					cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
					cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

        /// <summary>
        /// Gets the max and min dates based on curve name.
        /// </summary>
        /// <param name="curveName"></param>
        /// <returns></returns>
        public static DataSet SelectPricindDayRange( string curveName)
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPricingDayValidTradeDateBlockEnergyCurvesSelectRange";

                    cmd.Parameters.Add( new SqlParameter( "@CurveName", curveName ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        public static DataSet SelectListPricingDayValidTradeDateBlockEnergyCurves()
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPricingDayValidTradeDateBlockEnergyCurvesSelectList";


                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }
    }
}
