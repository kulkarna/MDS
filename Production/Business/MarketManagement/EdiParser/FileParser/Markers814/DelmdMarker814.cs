namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for DELMD utility
	/// </summary>
	public class DelmdMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public DelmdMarker814()
			: base( UtilitiesCodes.CodeOf.Delmd )
		{
			this.TcapCell = 2;
			this.IcapCell = 2;
		}
	}
}
