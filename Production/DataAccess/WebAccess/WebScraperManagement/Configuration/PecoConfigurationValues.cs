namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Data;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public class PecoConfigurationValues : ConfigurationValues
	{
		private static PecoConfigurationValues instance;

		// ------------------------------------------------------------------------------------
		private static PecoConfigurationValues MapValues( DataSet ds )
		{
			PecoConfigurationValues configurationValues = new PecoConfigurationValues();

			configurationValues.HomePage = GetValue( ds, "3", "HomePage" ) as string;
			configurationValues.StartPage = GetValue( ds, "3", "StartPage" ) as string;
			configurationValues.BillHistoryPage = GetValue( ds, "3", "BillHistoryPage" ) as string;

			return configurationValues;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Default constructor..
		/// </summary>
		static PecoConfigurationValues()
		{
			DataSet pecoValues;

			pecoValues = TransactionsSql.GetConfigurationValues( "PECO" );
			instance = MapValues( pecoValues );
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Read only property that returns an instance of the object..
		/// </summary>
		public static PecoConfigurationValues ValueOf
		{
			get { return instance; }
		}

	}
}
