namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for CTPEN utility
	/// </summary>
	public class CtpenMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public CtpenMarker814()
			: base( UtilitiesCodes.CodeOf.Ctpen )
		{
			this.AccountNumberCell = 3;
			this.AccountStatusCell = 3;
		}
	}
}
