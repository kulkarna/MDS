namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// 814 marker for NECO
	/// </summary>
	public class NecoMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public NecoMarker814()
			: base( UtilitiesCodes.CodeOf.Neco )
		{
			this.AccountStatusCell = 3;
		}
	}
}
