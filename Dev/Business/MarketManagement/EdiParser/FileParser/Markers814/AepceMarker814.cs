namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for AEPCE utility
	/// </summary>
	public class AepceMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public AepceMarker814()
			: base( UtilitiesCodes.CodeOf.Aepce )
		{
			this.AccountNumberCell = 3;
			this.AccountStatusCell = 3;
		}
	}
}
