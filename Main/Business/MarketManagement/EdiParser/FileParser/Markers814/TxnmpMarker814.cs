namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for TXNMP utility
	/// </summary>
	public class TxnmpMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public TxnmpMarker814()
			: base( UtilitiesCodes.CodeOf.Txnmp )
		{
			this.AccountNumberCell = 3;
			this.AccountStatusCell = 3;
		}
	}
}
