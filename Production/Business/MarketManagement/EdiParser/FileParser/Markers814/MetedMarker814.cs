namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for METED
	/// </summary>
	public class MetedMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public MetedMarker814()
			: base( UtilitiesCodes.CodeOf.Meted )
		{
			this.AccountStatusCell = 3;
		}
	}
}
