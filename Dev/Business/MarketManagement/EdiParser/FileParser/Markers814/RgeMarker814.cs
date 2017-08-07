namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for files 814 from Rge utility
	/// </summary>
	public class RgeMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public RgeMarker814()
			: base( "RGE" )
		{
			this.ZoneCell = 2;
		}
	}
}
