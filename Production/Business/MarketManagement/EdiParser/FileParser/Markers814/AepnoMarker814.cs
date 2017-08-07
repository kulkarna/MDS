namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for AEPNO utility
	/// </summary>
	public class AepnoMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public AepnoMarker814()
			: base( UtilitiesCodes.CodeOf.Aepno )
		{
			this.AccountNumberCell = 3;
			this.AccountStatusCell = 3;
		}
	}
}
