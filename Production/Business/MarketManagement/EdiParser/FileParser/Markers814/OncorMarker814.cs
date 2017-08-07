namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for ONCOR utility
	/// </summary>
	public class OncorMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public OncorMarker814()
			: base( UtilitiesCodes.CodeOf.Oncor )
		{
			this.AccountNumberCell = 3;
			this.AccountStatusCell = 3;
		}
	}
}
