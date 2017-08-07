namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Linq;
	using System.Data;

	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public class IDRPecoConfigurationValues : ConfigurationValues
	{
		/// <summary>
		/// user name needed to log in to the site
		/// </summary>
		public new static string Username
		{
			get;
			private set;
		}

		/// <summary>
		/// password needed to log in to the site
		/// </summary>
		public new static string Password
		{
			get;
			private set;
		}

		/// <summary>
		/// Path where the list is located
		/// </summary>
		public static string IDRList
		{
			get;
			private set;
		}

		/// <summary>
		/// get the properties values from the database 
		/// </summary>
		public static void MapToOject()
		{
			DataSet pecoValues;

			pecoValues = TransactionsSql.GetConfigurationValues( "IDR_PECO" );

			Username = GetValue( pecoValues, "1", null ) as string;
			Password = GetValue( pecoValues, "2", null ) as string;
			IDRList = GetValue( pecoValues, "3", "IDR List" ) as string;

		}
	}
}
