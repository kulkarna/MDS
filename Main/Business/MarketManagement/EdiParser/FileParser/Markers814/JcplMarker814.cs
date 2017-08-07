namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for JCPL utility
	/// </summary>
	public class JcplMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public JcplMarker814()
			: base( "JCP&L" )
		{
			this.ZoneCell = 3;
            this.DaysInArrearsCell = 2;
		}
	}
}
