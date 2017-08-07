namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Map for CL-and-P
	/// </summary>
	public class Clp814Mapper : EdiAccountMap814
	{
		/// <summary>
		/// Map constructor
		/// </summary>
		/// <param name="marker">Marker containing the position of each data in the field</param>
		public Clp814Mapper( MarkerBase marker )
			: base( marker )
		{
			RemoveFieldMap( "REF12" );

			AddFieldMap( "REFMG", new StringParser( account => account.AccountNumber, Marker.AccountNumberCell ) );
		}
	}
}
