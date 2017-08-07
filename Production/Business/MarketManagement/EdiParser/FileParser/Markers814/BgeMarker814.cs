namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for BGE utility
	/// </summary>
	public class BgeMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public BgeMarker814()
			: base( UtilitiesCodes.CodeOf.Bge )
		{
			this.MeterNumberCell = 9;
		}
	}
}
