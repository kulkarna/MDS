namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Utility Code Resolver
	/// </summary>
	public class UtilityCodeResolver
	{
		static UtilityConfigList utilitiesConfigurations;

		/// <summary>
		/// Default constructor
		/// </summary>
		static UtilityCodeResolver()
		{
			utilitiesConfigurations = ConfigurationFactory.GetUtilityConfigurations();
		}

		/// <summary>
		/// Given a duns number, this method returns that same duns number
		/// </summary>
		/// <param name="dunsNumber"></param>
		/// <returns>UtilityCodeResolver instance</returns>
		public static UtilityCodeResolver ForDunsNumber( string dunsNumber )
		{
			return new UtilityCodeResolver( dunsNumber );
		}

		private string dunsNumberId;

		/// <summary>
		/// Constructor..
		/// </summary>
		/// <param name="dunsNumber"></param>
		private UtilityCodeResolver( string dunsNumber )
		{
			this.dunsNumberId = dunsNumber;
		}

		/// <summary>
		/// Given a duns number, it returns a utility code
		/// </summary>
		/// <returns>utility code</returns>
		public string Resolve()
		{
			var config = utilitiesConfigurations.Where( utility => utility.DunsNumber == dunsNumberId ).Single();

			return config.UtilityCode;
		}
	}
}
