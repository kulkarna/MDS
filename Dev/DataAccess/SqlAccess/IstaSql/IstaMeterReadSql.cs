using System;
using System.Data.SqlClient;
using System.Data;

namespace LibertyPower.DataAccess.SqlAccess.IstaSql
{
    /// <summary>
    /// IstaMeterReadSql
    /// </summary>
	public static class IstaMeterReadSql
	{
		//private const string default_conn = "Data Source=SQLDEV;User ID=sa;Password=N0tr35p@55;Initial Catalog=LibertyPower; Connect Timeout=200; pooling='true'; Max Pool Size=200";

		// ------------------------------------------------------------------------------------
        /// <summary>
        /// Gets the ista meter reads.
        /// </summary>
        /// <param name="account">The account.</param>
        /// <returns></returns>
		public static DataSet GetIstaMeterReads( string account )
		{
			DataSet ds1 = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetIstaMeterReads";
					cmd.Connection = conn;

					cmd.Parameters.Add( new SqlParameter( "accountNumber", account ) );
					cmd.Parameters.Add( new SqlParameter( "beginDate", "" ) );
					cmd.Parameters.Add( new SqlParameter( "endDate", "" ) );
					cmd.Parameters.Add( new SqlParameter( "all", true ) );

					using( SqlDataAdapter da1 = new SqlDataAdapter( cmd ) )
					{
						da1.Fill( ds1 );
					}
				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Gets the ista meter reads.
		/// </summary>
		/// <param name="account">The account.</param>
		/// <param name="utility">The utility.</param>
		/// <param name="from">From.</param>
		/// <param name="to">To.</param>
		/// <returns></returns>
		public static DataSet GetIstaMeterReadsByOffer( string offerID, string utility, DateTime from, DateTime to )
		{
			DataSet ds1 = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetIstaMeterReadsByOffer";
					cmd.Connection = conn;

					cmd.Parameters.Add( new SqlParameter( "OfferID", offerID ) );
					cmd.Parameters.Add( new SqlParameter( "utilityCode", utility ) );
					cmd.Parameters.Add( new SqlParameter( "beginDate", from ) );
					cmd.Parameters.Add( new SqlParameter( "endDate", to ) );

					using( SqlDataAdapter da1 = new SqlDataAdapter( cmd ) )
					{
						da1.Fill( ds1 );
					}
				}
			}

			return ds1;
		}


        /// <summary>
        /// Gets the ista meter reads.
        /// </summary>
        /// <param name="account">The account.</param>
        /// <param name="utility">The utility.</param>
        /// <param name="from">From.</param>
        /// <param name="to">To.</param>
        /// <returns></returns>
		public static DataSet GetIstaMeterReads( string account, string utility, DateTime from, DateTime to )
		{
			DataSet ds1 = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetIstaMeterReads";
                    cmd.CommandTimeout = 120;
					cmd.Connection = conn;

					cmd.Parameters.Add( new SqlParameter( "accountNumber", account ) );
					cmd.Parameters.Add( new SqlParameter( "utilityCode", utility ) );
					cmd.Parameters.Add( new SqlParameter( "beginDate", from ) );
					cmd.Parameters.Add( new SqlParameter( "endDate", to ) );

					using( SqlDataAdapter da1 = new SqlDataAdapter( cmd ) )
					{
						da1.Fill( ds1 );
					}
				}
			}

			return ds1;
		}
	}
}
