namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Map for all utilities from Texas
	/// </summary>
	public class EdiAccountTexasMap814 : EdiAccountMap814
	{
		/// <summary>
		/// Map constructor
		/// </summary>
		/// <param name="marker">Marker containing the position of each data in the field</param>
		public EdiAccountTexasMap814( MarkerBase marker )
			: base( marker )
		{
			RemoveFieldMap( "REF12" );

			AddFieldMap( "REFQ5", new StringParser( account => account.AccountNumber, Marker.AccountNumberCell ) );
		}
	}
}
