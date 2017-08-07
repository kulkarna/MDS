namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Map for BGE
	/// </summary>
	public class Bge814Mapper : EdiAccountMap814
	{
		/// <summary>
		/// BGE map constructor
		/// </summary>
		/// <param name="maker">Marker containing the position of each data in the field</param>
		public Bge814Mapper( MarkerBase maker )
			: base( maker )
		{
			RemoveFieldMap( "REFMG" );

			AddFieldMap( "NM1", new StringParser( account => account.MeterNumber, maker.MeterNumberCell ) );
		}
	}
}
