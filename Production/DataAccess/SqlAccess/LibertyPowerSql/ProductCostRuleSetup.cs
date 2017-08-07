using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class ProductCostRuleSetup
	{
		public static DataSet InsertProductCostRuleSetup( int segment, int productType, int market, int utility, int zone, int serviceClass, int maxRelativeStartMonth, int maxTerm, decimal lowCostRate, decimal highCostRate, string insertedBy )
		{
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();

			using(SqlConnection connection = new SqlConnection( connStr ))
			{
				using(SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandText = "usp_ProductCostRateSetupInsert";
					command.CommandType = CommandType.StoredProcedure;

					command.Parameters.Add( new SqlParameter( "segment", segment ) );
					command.Parameters.Add( new SqlParameter( "productType", productType ) );
					command.Parameters.Add( new SqlParameter( "market", market ) );
					command.Parameters.Add( new SqlParameter( "utility", utility ) );
					command.Parameters.Add( new SqlParameter( "zone", zone ) );
					command.Parameters.Add( new SqlParameter( "serviceClass", serviceClass ) );
					command.Parameters.Add( new SqlParameter( "insertedBy", insertedBy ) );
					command.Parameters.Add( new SqlParameter( "maxRelativeStartMonth", maxRelativeStartMonth ) );
					command.Parameters.Add( new SqlParameter( "maxTerm", maxTerm ) );
					command.Parameters.Add( new SqlParameter( "lowCostRate", lowCostRate ) );
					command.Parameters.Add( new SqlParameter( "highCostRate", highCostRate ) );

					using(SqlDataAdapter da = new SqlDataAdapter( command ))
						da.Fill( ds );
				}
			}

			return ds;
		}
	}
}
