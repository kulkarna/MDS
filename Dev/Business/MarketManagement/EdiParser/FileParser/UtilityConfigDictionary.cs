namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// List of utility config objects
	/// </summary>
	public class UtilityConfigList : List<UtilityConfig>
	{
		/// <summary>
		/// Discovers the utility config based on DUNS number
		/// </summary>
		/// <param name="dunsNumber">DUNS number</param>
		/// <returns>Returns the utility config based on DUNS number.</returns>
		public UtilityConfig GetUtilityConfigFromDuns( string dunsNumber )
		{
			if( this.Count.Equals( 0 ) )
				return null;

			foreach( UtilityConfig config in this )
				if( config.DunsNumber.Equals( dunsNumber ) )
					return config;

			return null;
		}
	}
}
