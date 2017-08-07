namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// Marker for WPP
	/// </summary>
	public class WppMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public WppMarker814()
			: base( UtilitiesCodes.CodeOf.Wpp )
		{
			AccountStatusCell = 3;
		}
	}
}
