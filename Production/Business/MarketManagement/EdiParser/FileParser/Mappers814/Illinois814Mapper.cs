namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	public class Illinois814Mapper : EdiAccountMap814
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="marker">Marker containing the position of each data in the field</param>
		public Illinois814Mapper( MarkerBase marker )
			: base( marker )
		{
			RemoveFieldMap( "DTM007" );

			AddFieldMap( "DTM152", new DateParser( account => account.EffectiveDate, Marker.EffectiveDateCell ) );
		}
	}
}
