namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for PENELEC
	/// </summary>
	public class PenelecMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public PenelecMarker814()
			: base( UtilitiesCodes.CodeOf.Penelec )
		{
			this.AccountStatusCell = 3;
		}
	}
}
