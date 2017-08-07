namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for NySeg utility
	/// </summary>
	public class NysegMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public NysegMarker814()
			: base( "NYSEG" )
		{
			this.ZoneCell = 2;
		}
	}
}
