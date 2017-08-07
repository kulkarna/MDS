namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	public class NY814Mapper : EdiAccountMap814
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="marker">Marker containing the position of each data in the field</param>
		public NY814Mapper( MarkerBase marker )
			: base( marker )
		{
            RemoveFieldMap("AMTKC");
            RemoveFieldMap("AMTKZ");

            AddFieldMap("AMTKZ", new DecimalParser(account => account.Icap, Marker.IcapCell));
            AddFieldMap("DTMAB2", new DateParser(account => account.IcapEffectiveDate, Marker.IcapEffectiveDateCell));
            AddFieldMap("AMT8B", new DecimalParser(account => account.FutureIcap, Marker.IcapCell));
            AddFieldMap("DTMAB4", new DateParser(account => account.FutureIcapEffectiveDate, Marker.IcapEffectiveDateCell));
            AddFieldMap("AMTKC", new DecimalParser(account => account.Tcap, Marker.TcapCell));
		}
	}
}
