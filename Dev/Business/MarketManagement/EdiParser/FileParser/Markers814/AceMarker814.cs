namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for Ace utility
	/// </summary>
	public class AceMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public AceMarker814()
			: base( UtilitiesCodes.CodeOf.Ace )
		{
			this.AccountStatusCell = 3;
			this.ContactInfoCell = 1;
            this.DaysInArrearsCell = 2;
		}
	}
}
