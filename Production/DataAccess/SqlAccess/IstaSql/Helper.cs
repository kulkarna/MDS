using System;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.IstaSql
{
	internal sealed class Helper
	{
		private static string connectionString = ConfigurationManager.ConnectionStrings["Ista"].ConnectionString;

		public static string ConnectionString
		{
			get
			{ return connectionString; }
		}
	}
}
