namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for MECO utility
	/// </summary>
	public class MecoMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public MecoMarker814()
			: base( UtilitiesCodes.CodeOf.Meco )
		{
			this.AccountStatusCell = 3;
			this.IcapCell = 2;
			this.TcapCell = 2;
		}
	}
}
