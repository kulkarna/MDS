namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	public class NyMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public NyMarker814( string utility )
			: base( utility )
		{
			ZoneCell = 2;
		}
	}
}
