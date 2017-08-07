using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class PELossFactorCurveSql
	{
		/// <summary>
		/// Selects loss factor based on utility, service class, voltage, month, and year.
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="serviceClass">Service class</param>
		/// <param name="voltage">Voltage</param>
		/// <param name="month">Month (integer value)</param>
		/// <param name="year">Year (integer value)</param>
		/// <returns>Returns a dataset containing the loss factor based on utility, service class, voltage, month, and year.</returns>
		public static DataSet SelectLossFactorItemDataCurve( string utilityCode, string serviceClass, string voltage, int month, int year )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PELossFactorSelect";

					cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClass", serviceClass ) );
					cmd.Parameters.Add( new SqlParameter( "@Voltage", voltage ) );
					cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
					cmd.Parameters.Add( new SqlParameter( "@Year", year ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Selects a set of records in PELossFactorItemDataCurve table
		/// </summary>
		/// <param name="lossFactorId">Loss Factor Id</param>
		/// <param name="startDate">Start Date</param>
		/// <param name="endDate">End Date</param>
		/// <returns></returns>
		public static DataSet SelectLossFactorItemDataCurve( string lossFactorId, DateTime beginDate, DateTime endDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PELossFactorSelectRange";

					cmd.Parameters.Add( new SqlParameter( "@lossFactorId", lossFactorId ) );
					cmd.Parameters.Add( new SqlParameter( "@startDate", beginDate ) );
					cmd.Parameters.Add( new SqlParameter( "@endDate", endDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}



	



		/// <summary>
		/// Method to get a Loss Factor Determinant Item
		/// </summary>
		/// <param name="lossFactorId">Loss Factor Id</param>
		/// <returns>DataSet</returns>
		public static DataSet SelectLossFactorItemDeterminantsCurve( String lossFactorId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PELossFactorItemDeterminantsCurveSelect";

					cmd.Parameters.Add( new SqlParameter( "@LossFactorId", lossFactorId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

	}

}


