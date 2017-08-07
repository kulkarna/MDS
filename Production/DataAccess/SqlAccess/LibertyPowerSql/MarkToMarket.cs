using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class MarkToMarket
	{

		public static string AccountBackToBack( int AccountID, int ContractID )
		{
			string isBackToBack = "0";
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountIsBackToBack";

					command.Parameters.Add( new SqlParameter( "AccountID", AccountID ) );
					command.Parameters.Add( new SqlParameter( "ContractID", ContractID ) );

					connection.Open();
					object o = command.ExecuteScalar();
					if( o != null )
						isBackToBack = o.ToString();
				}
			}
			return isBackToBack;
		}

		public static string GetMappedZone( int UtilityID, string ZoneText )
		{
			string zone = null;
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ZoneMappingSelect";

					command.Parameters.Add( new SqlParameter( "UtilityID", UtilityID ) );
					command.Parameters.Add( new SqlParameter( "Text", ZoneText ) );

					connection.Open();
					object o = command.ExecuteScalar();
					if( o != null )
						zone = o.ToString();
				}
			}
			return zone;
		}

		/// <summary>
		/// update the default zone for a utility row ID
		/// </summary>
		/// <param name="id">id of the utility</param>
		/// <param name="zoneID">id of the default zone</param>
		/// <returns>number of records updated</returns>
		public static int UpdateZone( int id, int zoneID )
		{
			int iRecords = -1;
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ZoneDefaultUpdate";

					command.Parameters.Add( new SqlParameter( "ID", id ) );
					command.Parameters.Add( new SqlParameter( "ZoneID", zoneID ) );

					connection.Open();
					iRecords = command.ExecuteNonQuery();
				}
			}
			return iRecords;
		}

		public static string GetPricingRequest( string productId, int rateId )
		{
			string pricingRequest = null;
			using( var connection = new SqlConnection( Helper.DCConnectionString ) )
			{
				using( var command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_GetPricingRequest";

					command.Parameters.Add( new SqlParameter( "ProductId", productId ) );
					command.Parameters.Add( new SqlParameter( "RateId", rateId ) );

					connection.Open();
					object o = command.ExecuteScalar();
					if( o != null )
						pricingRequest = o.ToString();
				}
			}
			return pricingRequest;
		}
	}
}
