namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for O and R utility
	/// </summary>
	public class ORMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public ORMarker814()
			: base( "O&R" )
		{
			this.ZoneCell = 2;
			this.UtilityIdentifierCell = 2;										// leslie - bug 2840 10/25/2010
		}
	}
}
