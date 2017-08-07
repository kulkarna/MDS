namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql
{
	using System;
	using System.Configuration;

	/// <summary>
	/// Class that retrieves the connection string from config file.
	/// </summary>
	internal sealed class Helper
	{
		public static string ConnectionString
		{
			get{ return ConfigurationManager.ConnectionStrings["Transactions"].ConnectionString; }
		}
	}
}
